cmake_minimum_required(VERSION 3.20)

set(PROJECT_NAME "Wkpu_Icu_Ip_BlinkLed_S32K344")

list(APPEND CMAKE_MODULE_PATH "C:/Users/Peter_Chen/Documents/Projects/CMakeTemplateS32DS/cmake")

set(BUILD_TYPE "Debug" CACHE STRING "Build type: Debug or Release")

add_definitions(
    -DD_CACHE_ENABLE
    -DI_CACHE_ENABLE
    -DENABLE_FPU
    -DGCC
    -DCPU_S32K312
    -DMPU_ENABLE
    -DCPU_CORTEX_M7
)

include_directories(
    ${CMAKE_SOURCE_DIR}/include
)

aux_source_directory(${CMAKE_SOURCE_DIR}/src APPLICATION_SOURCES)

set(LINKER_SCRIPT "${CMAKE_SOURCE_DIR}/Project_Settings/Linker_Files/linker_flash_s32k312.ld")

set(ADDITIONAL_LIBRARIES "-lc -lgcc -lm")

set(ADDITIONAL_LINKER_FLAGS "-nostartfiles -nodefaultlibs -nostdlib")

include(rtd/s32dsrtd)
include(source/s32ds)
include(toolchain/nxpgcc11)

include(template)

project(${PROJECT_NAME} C ASM)
