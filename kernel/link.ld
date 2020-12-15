/* vim: tabstop=4 shiftwidth=4 noexpandtab
 * Kernel linker script for x86
 */
OUTPUT_FORMAT(pei-i386)
ENTRY(_start)

SECTIONS
{
	. = 0x100000;
	phys = .;

	.text phys : AT(phys)
	{
		code = .; _code = .;
		*(.mulboot)
		*(.text)
		. = ALIGN(4096);
	}

	.data : AT(phys + (data - code))
	{
		data = .; _data = .;
		*(.data)
		PROVIDE(_kernel_symbols_start = .);
		*(.symbols)
		PROVIDE(_kernel_symbols_end = .);
		. = ALIGN(4096);
	}

	.rdata  : AT(phys + (rdata - code))
	{
		rdata = .;
		*(.rdata)
		. = ALIGN(4096);
	}

	.bss  : AT(phys + (bss - code))
	{
		bss = .; _bss = .;
		*(COMMON)
		*(.bss)
		*(.stack)
		. = ALIGN(4096);
	}

	end = .; _end = .;

	/DISCARD/ :
	{
		*(.comment)
		*(.eh_frame)
		*(.note.gnu.build-id)
	}
}
