cmake_minimum_required(VERSION 3.20)

set(PROJECT_NAME "Siul2_Port_Ip_Example_S32K344")

list(APPEND CMAKE_MODULE_PATH "/home/chenzch/Projects/NXP/CMakeTemplateS32DS/cmake")

set(BUILD_TYPE "Debug" CACHE STRING "Build type: Debug or Release")

add_definitions(
    -DD_CACHE_ENABLE
    -DI_CACHE_ENABLE
    -DENABLE_FPU
    -DGCC
    -DCPU_S32K344
    -DMPU_ENABLE
    -DCPU_CORTEX_M7
    -DVV_RESULT_ADDRESS=0x2043FF00
)

set(APPLICATION_SOURCES
    ${CMAKE_SOURCE_DIR}/src/main.c
)

set(LINKER_SCRIPT "${CMAKE_SOURCE_DIR}/Project_Settings/Linker_Files/linker_flash_s32k312.ld")

include(rtd/rtd)
include(source/s32ds)
include(toolchain/nxpgcc11)

include(template)

project(${PROJECT_NAME} C ASM)
