/*
 * Copyright 2014, NICTA
 *
 * This software may be distributed and modified according to the terms of
 * the GNU General Public License version 2. Note that NO WARRANTY is provided.
 * See "LICENSE_GPLv2.txt" for details.
 *
 * @TAG(NICTA_GPL)
 */

ENTRY(_start)

PECOFF_FILE_ALIGNMENT = 0x200;

#ifdef EFI
#define PECOFF_EDATA_PADDING    \
    .pecoff_edata_padding : { BYTE(0); . = ALIGN(PECOFF_FILE_ALIGNMENT); }
#else
#define PECOFF_EDATA_PADDING
#endif

SECTIONS
{
    .text :
    {
        *(.text.start)
        *(.text)
    }

    .rodata :
    {
        *(.rodata)
        *(.rodata.*)
        . = ALIGN(16);
        _archive_start = .;
        *(.archive_ar)
        _archive_end = .;
    }

    .data :
    {
        *(.data)
    }

    PECOFF_EDATA_PADDING
    _edata = .;

    .bss :
    {
        *(.bss)

        _bootstack_bottom = .;
        . = . + 4K;
        . = ALIGN(16K);
        _bootstack_top = .;
    }

    _end = .;
}
