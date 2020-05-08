/* vim: tabstop=4 shiftwidth=4 noexpandtab
 * Kernel linker script for x86
 */
OUTPUT_FORMAT("pei-i386")
 ENTRY(start)  
phys = 0x7c00;

SECTIONS
{
	. = 0x7c00;

	.text BLOCK(1) : ALIGN(1) 
	{
		code = .;
		*(.text)
	}

	.rodata BLOCK(1) : ALIGN(1)
	{
		*(.rodata)
		*(.rdata)
	}

	.data BLOCK(1) : ALIGN(1)
	{
		data = .;
		*(.data)
	}

	.bss BLOCK(1) : ALIGN(1)
	{
		PROVIDE(__bss_start = .);
		bss = .;
		*(COMMON)
		*(.bss)
		*(.stack)
		PROVIDE(__bss_end = .);
	}

	end = .;

	/DISCARD/ :
	{
		*(.comment)
		*(.eh_frame)
		*(.note.gnu.build-id)
	}
}
