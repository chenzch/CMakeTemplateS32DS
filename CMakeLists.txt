cmake_minimum_required(VERSION 3.24)

get_filename_component(PROJECT_NAME "${CMAKE_CURRENT_SOURCE_DIR}" NAME)
if(NOT PROJECT_NAME)
  set(PROJECT_NAME "MyProject")
endif()

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
)

include_directories(
    ${CMAKE_SOURCE_DIR}/include
    ${CMAKE_SOURCE_DIR}/generate/include
)

aux_source_directory(${CMAKE_SOURCE_DIR}/src APPLICATION_SOURCES)
aux_source_directory(${CMAKE_SOURCE_DIR}/generate/src APPLICATION_SOURCES)

set(LINKER_SCRIPT "${CMAKE_SOURCE_DIR}/linker_flash_s32k344.ld")

set(ADDITIONAL_LIBRARIES gcc)

set(ADDITIONAL_LIBRARIE_DIRS )

set(ADDITIONAL_LINKER_FLAGS -nostartfiles -nodefaultlibs -nostdlib)

#set(MCAL_MODULES BaseNXP Dem Dio EcuC Mcu Platform Port Det)
#include(rtd/rtd7.0.1)
#include(source/rtdstartup)

include(rtd/s32dsrtd)
include(source/s32dsstartup)

include(toolchain/s32k3xx)

include(template)

project(${PROJECT_NAME} C ASM)
