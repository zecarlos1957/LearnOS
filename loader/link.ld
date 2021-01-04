/* vim: tabstop=4 shiftwidth=4 noexpandtab
 * Kernel linker script for x86
 */
OUTPUT_FORMAT("pei-i386")
 ENTRY(start)  
phys = 0xF800;

SECTIONS
{
	. = 0xF800;

	.text BLOCK(1) : ALIGN(1) 
	{
		code = .; _code = .;
		*(.text)
	}

	.data BLOCK(1) : ALIGN(1)
	{
		data = .; _data = .;
		*(.data)
	}

	.rdata BLOCK(1) : ALIGN(1)
	{
		rdata = .; _rdata = .;
		*(.rdata)
	}

	.bss BLOCK(1) : ALIGN(1)
	{
		bss = .; _bss = .;
		
		PROVIDE(__bss_start = .);
		bss = .;
		*(.bss)
		*(.stack)
		PROVIDE(__bss_end = .);
	}

	end = .; _end = .;

}
