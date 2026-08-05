#include "../include/vga.h"

volatile unsigned short* vga = (unsigned short*)0xB8000;

int cursor = 0;


void vga_clear()
{
    for(int i = 0; i < 2000; i++)
    {
        vga[i] = 0x0F20;
    }

    cursor = 0;
}


void vga_putchar(char c)
{
    vga[cursor] = (0x0F << 8) | c;

    cursor++;
}


void vga_print(char* str)
{
    while(*str)
    {
        vga_putchar(*str);
        str++;
    }
}
