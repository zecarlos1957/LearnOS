OUTPUT_FORMAT("pei-i386")
ENTRY(__main)
__image_base__ = 0x20000000;
__section_alignment__ = 4096;
SECTIONS
{
	. = SIZEOF_HEADERS;
	. = ALIGN(__section_alignment__);

	.text  __image_base__ + ( __section_alignment__ < 0x1000 ? . : __section_alignment__ ) :
	{
		code = .;
		*(.init)
		*(.text)
	___CTOR_LIST__ = .; __CTOR_LIST__ = . ;
			LONG (-1);*(.ctors); *(.ctor); *(SORT(.ctors.*));  LONG (0);
	 ___DTOR_LIST__ = .; __DTOR_LIST__ = . ;
			LONG (-1); *(.dtors); *(.dtor); *(SORT(.dtors.*));  LONG (0);
		*(.fini)
	}

	.data  BLOCK(__section_alignment__) :
	{
		data = .;
		*(.data)
	}

	.rdata  BLOCK(__section_alignment__) :
	{
		rdata = .;
		*(.rdata)
	}

	.eframe  BLOCK(__section_alignment__) :
	{
		eframe = .;
		*(.eframe)
	}

	.pdata  BLOCK(__section_alignment__) :
	{
		pdata = .;
		*(.pdata)
	}

	.bss  BLOCK(__section_alignment__) :
	{
		__bss_start__ = . ;
		*(.bss)
		*(COMMON)
		__bss_end__ = . ;
	}

	.edata  BLOCK(__section_alignment__) :
	{
		*(.edata)
	}

	/DISCARD/ :
	{
		*(.comment)
		*(.drectve)
		*(.note.gnu.build-id)
	}

	.idata  BLOCK(__section_alignment__) : ALIGN(4096)
	{
		idata = .;
		*(.idata)
	}

	.CRT BLOCK(__section_alignment__) : 
	{
		___crt_xc_start__ = .;
		*(.CRT)
		 ___crt_xc_end__ = . ;
	}

	.tls BLOCK(__section_alignment__) : 
	{
		___tls_start__ = . ;
		*(.tls)
		___tls_end__ = . ;
	}

	.reloc BLOCK(__section_alignment__) :
	{
		*(.reloc)
	}

	.stab BLOCK(__section_alignment__) (NOLOAD) :
	{
		*(.stab)
	}

		.stabstr BLOCK(__section_alignment__) (NOLOAD) :
	{
		*(.stabstr)
	}

}
