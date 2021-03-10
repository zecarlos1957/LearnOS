/* vim: tabstop=4 shiftwidth=4 noexpandtab
 * 
 */
ENTRY(__main)

SECTIONS
{
	. = 0x20000000;
	phys = .;

	.text BLOCK(4K) : ALIGN(4K)
	{
		code = .;
		*(.init)
		*(.text)
		*(.fini)
	}

	.rdata BLOCK(4K) : ALIGN(4K)
	{
		*(.rdata)
	}

	.data BLOCK(4K) : ALIGN(4K)
	{
		*(.data)
	}

	.bss BLOCK(4K) : ALIGN(4K)
	{
		*(COMMON)
		*(.bss)
	}

	.eh_frame BLOCK(4K) : ALIGN(4K)
	{
		*(.eh_frame)
	}

	end = .;

	/DISCARD/ :
	{
		*(.comment)
		*(.note.gnu.build-id)
	}
}
