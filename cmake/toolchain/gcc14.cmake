set(TOOLCHAIN_PREFIX "arm-none-eabi-" CACHE STRING "ARM toolchain prefix")

include(${CMAKE_CURRENT_LIST_DIR}/arm-none-eabi.cmake)

execute_process(
    COMMAND ${CMAKE_C_COMPILER} -print-file-name=plugin
    OUTPUT_VARIABLE GCCPLUGINS_DIR
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

execute_process(COMMAND ${CMAKE_CXX_COMPILER} -dumpversion OUTPUT_VARIABLE GCC_VER)
string(REGEX REPLACE "^([0-9]+)\\..*" "\\1" GCC_VER "${GCC_VER}")

add_compile_options(-fplugin=${GCCPLUGINS_DIR}/gccsection${GCC_VER}.so)