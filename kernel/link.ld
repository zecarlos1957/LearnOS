/* vim: tabstop=4 shiftwidth=4 noexpandtab
 * Kernel linker script for x86
 */
OUTPUT_FORMAT(pei-i386)
ENTRY(_start)

SECTIONS
{
	. = 0x100000;
	phys = .;

	.text  BLOCK(4096) : ALIGN(4096)
	{
		code = .; _code = .;
		*(.mulboot)
		*(.text)
	}

	.rdata BLOCK(4096) : ALIGN(4096)
	{
		*(.rdata)
	}

	.data BLOCK(8192) : ALIGN(4096)
	{
		data = .; _data = .;
		*(.data)
		*(.symbols)
		PROVIDE(_kernel_symbols_start = .);
		PROVIDE(_kernel_symbols_end = .);
	}

	.bss BLOCK(4096) : ALIGN(4096)
	{
		bss = .; _bss = .;
		*(COMMON)
		*(.bss)
		*(.stack)
	}

	end = .; _end = .;

	/DISCARD/ :
	{
		*(.comment)
		*(.eh_frame)
		*(.note.gnu.build-id)
	}
}
