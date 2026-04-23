if(WIN32)
    set(TOOLCHAIN_POSTFIX ".exe")
else()
    set(TOOLCHAIN_POSTFIX "")
endif()
set(CMAKE_C_COMPILER   ${TOOLCHAIN_PREFIX}gcc${TOOLCHAIN_POSTFIX})
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}g++${TOOLCHAIN_POSTFIX})
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_PREFIX}gcc${TOOLCHAIN_POSTFIX})
set(CMAKE_AR           ${TOOLCHAIN_PREFIX}ar${TOOLCHAIN_POSTFIX})
set(CMAKE_RANLIB       ${TOOLCHAIN_PREFIX}ranlib${TOOLCHAIN_POSTFIX})
set(CMAKE_OBJCOPY      ${TOOLCHAIN_PREFIX}objcopy${TOOLCHAIN_POSTFIX})
set(CMAKE_SIZE         ${TOOLCHAIN_PREFIX}size${TOOLCHAIN_POSTFIX})

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# 将列表转换为以空格分隔的字符串
function(format_flags_to_string LIST_VAR OUTPUT_VAR)
    string(REPLACE ";" " " STR_VAL "${${LIST_VAR}}")
    string(REPLACE "\n" " " STR_VAL "${STR_VAL}")
    set(${OUTPUT_VAR} "${STR_VAL}" PARENT_SCOPE)
endfunction()

set(RTD_WARNING_FLAGS
    -pedantic
    -Wall
    -Wextra
    -Wunused
    -Wstrict-prototypes
    -Wsign-compare
    -Werror=implicit-function-declaration
    -Wundef
    -Wdouble-promotion
)

execute_process(
    COMMAND ${CMAKE_C_COMPILER} -print-sysroot
    OUTPUT_VARIABLE TOOLCHAIN_SYSROOT
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

set(RTD_COMPILE_OPTIONS
    -fno-short-enums
    -funsigned-bitfields
    -ffunction-sections
    -fdata-sections
    -fno-builtin
    -flto
    -specs=nano.specs
    -specs=nosys.specs
    --sysroot="${TOOLCHAIN_SYSROOT}"
)

format_flags_to_string(RTD_WARNING_FLAGS RTD_WARNING_FLAGS_STR)
format_flags_to_string(RTD_COMPILE_OPTIONS RTD_COMPILE_OPTIONS_STR)

set(CMAKE_C_FLAGS   "${MCU_FLAGS} ${RTD_WARNING_FLAGS_STR} ${RTD_COMPILE_OPTIONS_STR} -fno-common -funsigned-char -fomit-frame-pointer" CACHE INTERNAL "c compiler flags")
set(CMAKE_CXX_FLAGS "${MCU_FLAGS} ${RTD_WARNING_FLAGS_STR} ${RTD_COMPILE_OPTIONS_STR} -fno-common -funsigned-char -fomit-frame-pointer -fno-rtti -fno-exceptions" CACHE INTERNAL "cxx compiler flags")
set(CMAKE_ASM_FLAGS "${MCU_FLAGS} -x assembler-with-cpp" CACHE INTERNAL "asm compiler flags")
set(CMAKE_EXE_LINKER_FLAGS "-T${LINKER_SCRIPT} ${ADDITIONAL_LINKER_FLAGS} ${ADDITIONAL_LIBRARIES} --entry=Reset_Handler -Wl,--gc-sections -Wl,-Map=${PROJECT_NAME}.map -Wl,--relax" CACHE INTERNAL "exe link flags")

SET(CMAKE_C_FLAGS_DEBUG "-Og -g -ggdb3" CACHE INTERNAL "c debug compiler flags")
SET(CMAKE_CXX_FLAGS_DEBUG "-Og -g -ggdb3" CACHE INTERNAL "cxx debug compiler flags")
SET(CMAKE_ASM_FLAGS_DEBUG "-g -ggdb3" CACHE INTERNAL "asm debug compiler flags")

SET(CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG" CACHE INTERNAL "c release compiler flags")
SET(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG" CACHE INTERNAL "cxx release compiler flags")
SET(CMAKE_ASM_FLAGS_RELEASE "-DNDEBUG" CACHE INTERNAL "asm release compiler flags")
