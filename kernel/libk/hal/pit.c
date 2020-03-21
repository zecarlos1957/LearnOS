#include <kernel/hal/cpu/idt.h>
#include <kernel/hal/pit.h>
#include <kernel/hal/irq.h>
#include <kernel/io/ports.h>

#include <kernel/hal/pic.h>
#include <stdio.h>
//-----------------------------------------------
//	Controller Registers
//-----------------------------------------------

#define		I86_PIT_REG_COUNTER0		0x40
#define		I86_PIT_REG_COUNTER1		0x41
#define		I86_PIT_REG_COUNTER2		0x42
#define		I86_PIT_REG_COMMAND			0x43

//! Global Tick count
static volatile uint32_t _pit_ticks = 0;

//!	pit timer interrupt handler
int pit_irq(int irqnum)
{
     printf("MIMMO");
	_pit_ticks++;

	irq_done(irqnum);
    return 0;
}

uint32_t pit_get_tick_count()
{
	return _pit_ticks;
}

void pit_send_command(uint8_t cmd)
{
	outportb(I86_PIT_REG_COMMAND, cmd);
}

void pit_send_data(uint16_t data, uint8_t counter)
{
	uint8_t	port = (counter == I86_PIT_OCW_COUNTER_0) ? I86_PIT_REG_COUNTER0 :
		((counter == I86_PIT_OCW_COUNTER_1) ? I86_PIT_REG_COUNTER1 : I86_PIT_REG_COUNTER2);
	outportb(port, (uint8_t)data);
}

uint8_t pit_read_data(uint16_t counter)
{
	uint8_t	port = (counter == I86_PIT_OCW_COUNTER_0) ? I86_PIT_REG_COUNTER0 :
		((counter == I86_PIT_OCW_COUNTER_1) ? I86_PIT_REG_COUNTER1 : I86_PIT_REG_COUNTER2);
	return inportb(port);
}

void pit_start_counter(uint32_t freq, uint8_t counter, uint8_t mode)
{
	if (freq == 0)
		return;

	uint16_t divisor = (uint16_t)(1193181 / (uint16_t)freq);

    //! send operational command
	uint8_t ocw = 0;
	ocw = (ocw & ~I86_PIT_OCW_MASK_MODE) | mode;
	ocw = (ocw & ~I86_PIT_OCW_MASK_RL) | I86_PIT_OCW_RL_DATA;
	ocw = (ocw & ~I86_PIT_OCW_MASK_COUNTER) | counter;
	pit_send_command(ocw);

	//! set frequency rate
	pit_send_data(divisor & 0xff, 0);
	pit_send_data((divisor >> 8) & 0xff, 0);

	//! reset tick count
	_pit_ticks = 0;
}

void pit_initialize()
{
	irq_set_hook(2, pit_irq);
}