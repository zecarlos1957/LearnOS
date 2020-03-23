OUTPUT_FORMAT("pei-i386")
ENTRY(start)
SECTIONS
{
    . = 0x100000;
    .text   : ALIGN(4096) 
    {
        code = .; 
        *(.text)
    }
    
    .rodata : ALIGN(4096) 
    {
        rodata = .;  
        *(.rodata)
    }

    .data : ALIGN(4096) 
    {
        data = .;  
        *(.data)

    }

    .bss : ALIGN(4096) 
    {
        bss = .;  
        *(.bss)
        *(.stack)
    }

    PROVIDE(kernel_end = .); PROVIDE(_kernel_end = .); 

}