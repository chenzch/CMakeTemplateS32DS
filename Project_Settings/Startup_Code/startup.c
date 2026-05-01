/*==================================================================================================
*   Project              : RTD AUTOSAR 4.9
*   Platform             : CORTEXM
*   Peripheral           :
*   Dependencies         : none
*
*   Autosar Version      : 4.9.0
*   Autosar Revision     : ASR_REL_4_9_REV_0000
*   Autosar Conf.Variant :
*   SW Version           : 7.0.1
*   Build Version        : S32K3_RTD_7_0_1_D2602_ASR_REL_4_9_REV_0000_20260206
*
*   Copyright 2020 - 2026 NXP
*
*   NXP Confidential and Proprietary. This software is owned or controlled by NXP and may only be
*   used strictly in accordance with the applicable license terms. By expressly
*   accepting such terms or by downloading, installing, activating and/or otherwise
*   using the software, you are agreeing that you have read, and that you agree to
*   comply with and are bound by, such license terms. If you do not agree to be
*   bound by the applicable license terms, then you may not retain, install,
*   activate or otherwise use the software.
==================================================================================================*/
/**
*   @implements startup.c_Artifact
*/

#ifdef __cplusplus
extern "C"{
#endif
#include "Std_Types.h"

/*******************************************************************************
 * Definitions
 *******************************************************************************/
 /*!
 * @brief Defines the init table layout
 */
typedef struct
{
    uint64 * ram_start; /*!< Start address of section in RAM */
    uint64 * rom_start; /*!< Start address of section in ROM */
    uint64 * rom_end;   /*!< End address of section in ROM */
} Sys_CopyLayoutType;

/*!
 * @brief Defines the zero table layout
 */
typedef struct
{
    uint64 * ram_start; /*!< Start address of section in RAM */
    uint64 * ram_end;   /*!< End address of section in RAM */
} Sys_ZeroLayoutType;

extern uint32 __INIT_TABLE[];
extern uint32 __ZERO_TABLE[];
extern uint32 __INDEX_COPY_CORE2[];
#if (defined(__ARMCC_VERSION))
    extern uint32 __VECTOR_RAM;
#else
    extern uint32 __VECTOR_RAM[];
#endif

/*******************************************************************************
 * Static Variables
 ******************************************************************************/

/*******************************************************************************
 * Code
 ******************************************************************************/
/*FUNCTION**********************************************************************
 *
 * Function Name : init_data_bss
 * Description   : Make necessary initializations for RAM.
 * - Copy the vector table from ROM to RAM.
 * - Copy initialized data from ROM to RAM.
 * - Copy code that should reside in RAM from ROM
 * - Clear the zero-initialized data section.
 *
 * Tool Chains:
 *   __GNUC__           : GNU Compiler Collection
 *   __ghs__            : Green Hills ARM Compiler
 *   __ICCARM__         : IAR ARM Compiler
 *   __DCC__            : Wind River Diab Compiler
 *   __ARMCC_VERSION    : ARMC Compiler
 *
 * Implements    : init_data_bss_Activity
 *END**************************************************************************/
#define PLATFORM_START_SEC_CODE
#include "Platform_MemMap.h"

void init_data_bss(void);
void init_data_bss_core2(void);

#if !defined(NDEBUG)
static void AssertAlign(uint32 Value) {
    if (Value & 7) {
        for (;;);
    }
}
#endif

void init_data_bss(void)
{
    const Sys_CopyLayoutType * copy_layout;
    const Sys_ZeroLayoutType * zero_layout;
    const uint64 * rom;
    uint64 * ram;
    uint32 len;
    uint32 size;
    uint32 i;
    uint32 j;

    const uint32 * initTable_Ptr = (uint32 *)__INIT_TABLE;
    const uint32 * zeroTable_Ptr = (uint32*)__ZERO_TABLE;

    /* Copy initialized table */
    len = *initTable_Ptr;
    initTable_Ptr++;
    copy_layout = (const Sys_CopyLayoutType *)initTable_Ptr;
    for(i = 0; i < len; i++)
    {
        rom = copy_layout[i].rom_start;
        ram = copy_layout[i].ram_start;
        size = (uint32)copy_layout[i].rom_end - (uint32)copy_layout[i].rom_start;
        /* Make sure the data area to be copied must be aligned with 8. Then, copy 8 bytes at per one read */
#if !defined(NDEBUG)
        AssertAlign((uint32)rom);
        AssertAlign((uint32)ram);
        AssertAlign((uint32)size);
#endif
        for(j = 0UL; j < (size >> 3); j++)
        {
            ram[j] = rom[j];
        }
    }

    /* Clear zero table */
    len = *zeroTable_Ptr;
    zeroTable_Ptr++;
    zero_layout = (const Sys_ZeroLayoutType *)zeroTable_Ptr;
    for(i = 0; i < len; i++)
    {
        ram = zero_layout[i].ram_start;
        size = (uint32)zero_layout[i].ram_end - (uint32)zero_layout[i].ram_start;
#if !defined(NDEBUG)
        AssertAlign((uint32)ram);
        AssertAlign((uint32)size);
#endif
        for(j = 0UL; j < (size >> 3); j++)
        {
#if !defined(NDEBUG)
            ram[j] = 0xDEADBEEFDEADCODEU;
#else
            ram[j] = 0U;
#endif
        }
    }
}

void init_data_bss_core2(void)
{
    const Sys_CopyLayoutType * copy_layout;
    const uint64 * rom;
    uint64 * ram;
    uint32 len;
    uint32 size;
    uint32 i;
    uint32 j;

    const uint32 * initTable_Ptr = (uint32 *)__INIT_TABLE;

    /* Copy initialized table */
    len = *initTable_Ptr;
    initTable_Ptr++;
    copy_layout = (const Sys_CopyLayoutType *)initTable_Ptr;
    for(i = (uint32)__INDEX_COPY_CORE2; i < len; i++)
    {
        rom = copy_layout[i].rom_start;
        ram = copy_layout[i].ram_start;
        size = (uint32)copy_layout[i].rom_end - (uint32)copy_layout[i].rom_start;
        /* Make sure the data area to be copied must be aligned with 8. Then, copy 8 bytes at per one read */
#if !defined(NDEBUG)
        AssertAlign((uint32)rom);
        AssertAlign((uint32)ram);
        AssertAlign((uint32)size);
#endif
        for(j = 0UL; j < (size >> 3); j++)
        {
            ram[j] = rom[j];
        }
    }
}
#define PLATFORM_STOP_SEC_CODE
#include "Platform_MemMap.h"

#ifdef __cplusplus
}
#endif

/*******************************************************************************
 * EOF
 ******************************************************************************/
