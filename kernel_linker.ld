OUTPUT_FORMAT("pei-i386")
ENTRY(start)
SECTIONS
{

    .text 0x100000 :
    {
        code = .; 
        *(.text)
        . = ALIGN(4096);
    }
    
    .rodata :
    {
        rodata = .;  
        *(.rodata)
        . = ALIGN(4096);
    }

    .data :
    {
        data = .;  
        *(.data)
        . = ALIGN(4096);
    }

    .bss :
    {
        bss = .;  
        *(.bss)
        . = ALIGN(4096);
    }

    PROVIDE(kernel_end = .); PROVIDE(_kernel_end = .); 

}