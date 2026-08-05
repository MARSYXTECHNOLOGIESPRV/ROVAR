#include "include/vga.h"


void kernel_main()
{
    vga_clear();

    vga_print("ROVAR Kernel Loaded!");
    vga_print("\n");
    vga_print("32-bit Protected Mode");
    
    while(1)
    {
        asm volatile("hlt");
    }
}
