#include <kernel/io/ports.h>
#include <kernel/io/ps2.h>
#include <kernel/hal/irq.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <stddef.h>

#include <kernel/io/keyboard.h>

#define KB_LISTENER_FUNC_LIST_SIZE 16   // TODO: Once we have dynamic memory
                                        // allocation, remove this limit.
#define PS2_POLL_BUFFER_SIZE 16

static kb_listener_func s_listener_func_list[KB_LISTENER_FUNC_LIST_SIZE];

static const uint8_t s_keymap[128] = {
    #include "keymap-en-US"
};

struct ps2_kb_packet
{
    uint8_t status;
    uint8_t data;
};

struct kb_device
{
    bool shift_pressed;
    bool ctrl_pressed;
    bool alt_pressed;
};

static struct kb_key convert_packet(const struct kb_device* device, const struct ps2_kb_packet* packet)
{
    struct kb_key key = { 0 };

    key.raw = packet->data;
    key.scancode = key.raw & 0x7f;
    key.keycode = s_keymap[key.scancode];
    key.event = (key.raw & 0x80) ? KB_RELEASE : KB_PRESS;

    if (device->shift_pressed)
        key.modifiers |= KB_MOD_SHIFT;

    if (device->ctrl_pressed)
        key.modifiers |= KB_MOD_CTRL;

    if (device->alt_pressed)
        key.modifiers |= KB_MOD_ALT;

    return key;
}

static int poll_ps2(struct ps2_kb_packet *buffer, int buffer_size)
{
    struct ps2_kb_packet *packet;
    uint8_t ps2_status;
    int i = 0;

    while (true)
    {
        if (i > buffer_size)
        {
            printf("kb: ps2 poll packet buffer full (%d packets)\n", buffer_size);
            FLUSH_INPUT_BUFFER();
            return -1;
        }

        ps2_status = inportb(PS2_PORT_STATUS);
        portwait();

        if (ps2_status & PS2_STATUS_OUTPUT_BUFFER_FULL)
        {
            packet = buffer + i;
            packet->status = ps2_status;
            packet->data = inportb(PS2_PORT_DATA);
            portwait();

            ++i;
        } else
            break;
    }

    return i;
}

static int call_listeners(const struct kb_key *key)
{
    for (int i = 0; i < KB_LISTENER_FUNC_LIST_SIZE; ++i)
        if (s_listener_func_list[i])
            s_listener_func_list[i](key);

    return 0;
}

int kb_irq_hook(int irqnum)
{
    static struct kb_device device = { 0 };
    struct ps2_kb_packet buffer[PS2_POLL_BUFFER_SIZE];
    int num_received = poll_ps2(buffer, PS2_POLL_BUFFER_SIZE);
    struct kb_key key;

    for (int i = 0; i < num_received; i++)
    {
        key = convert_packet(&device, buffer + i);

        if (key.keycode >= 250)
        {
            switch (key.keycode & ~1)
            {
                case KB_KEY_LSHIFT:
                    device.shift_pressed = (key.event == KB_PRESS);
                    break;
                case KB_KEY_LCTRL:
                    device.ctrl_pressed = (key.event == KB_PRESS);
                    break;
                case KB_KEY_LALT:
                    device.alt_pressed = (key.event == KB_PRESS);
                    break;
            }
        }

        call_listeners(&key);
    }

    irq_done(irqnum);
    return 0;
}

int kb_init(void)
{
    memset(s_listener_func_list, 0, sizeof(s_listener_func_list));

    if (irq_set_hook(1, kb_irq_hook))
    {
        printf("kb: failed to hook irq\n");
        return 1;
    }

    ps2_set_enabled(1, 1);

    kb_set_typematic_config(0x0b, 2);

    return 0;
}

int kb_set_typematic_config(int repeat_rate, int typematic_delay)
{
    struct ps2_kb_typematic_byte tb = { 0, 0 };

    if ((repeat_rate < 0) || (repeat_rate > 0x1f))
        return 1;

    if ((typematic_delay < 0) || (typematic_delay > 3))
        return 1;

    tb.repeat_rate = repeat_rate;
    tb.typematic_delay = typematic_delay;

    WAIT_FOR_OUTPUT_BUFFER();
    FLUSH_INPUT_BUFFER();

    outportb(PS2_PORT_CMD, PS2_KB_CMD_SET_TYPEMATIC_CONFIG);
    portwait();

    outportb(PS2_PORT_DATA, *((uint8_t *) &tb));
    portwait();

    if (inportb(PS2_PORT_DATA) != PS2_DEV_RESP_OK)
        return 1;

    printf("kb: set repeat rate to %d, typematic delay to %d\n", repeat_rate, typematic_delay);

    return 0;
}

int kb_add_listener(kb_listener_func func)
{
    if (!func)
        return 1;

    for (int i = 0; i < KB_LISTENER_FUNC_LIST_SIZE; i++)
        if (!s_listener_func_list[i])
        {
            s_listener_func_list[i] = func;
            return 0;
        }

    printf("kb: cannot add listener at %d, limit of %d reached\n", (int)func, KB_LISTENER_FUNC_LIST_SIZE);

    return 1;
}

int kb_remove_listener(kb_listener_func func)
{
    if (!func)
        return 1;

    for (int i = 0; i < KB_LISTENER_FUNC_LIST_SIZE; i++)
        if (s_listener_func_list[i] == func)
        {
            s_listener_func_list[i] = NULL;
            return 0;
        }

    return 1;
}
