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

set(CMAKE_C_FLAGS_INIT "${MCU_FLAGS} -fno-common -funsigned-char -fomit-frame-pointer")
set(CMAKE_CXX_FLAGS_INIT "${MCU_FLAGS} -fno-common -funsigned-char -fomit-frame-pointer -fno-rtti -fno-exceptions")
set(CMAKE_ASM_FLAGS_INIT "${MCU_FLAGS} -x assembler-with-cpp")

set(CMAKE_C_FLAGS_DEBUG "-ggdb3 -O0")
set(CMAKE_C_FLAGS_RELEASE "-Os -DNDEBUG")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_C_LINK_FLAGS "-T${LINKER_SCRIPT} ${ADDITIONAL_LINKER_FLAGS} ${ADDITIONAL_LIBRARIES} --entry=Reset_Handler -Wl,--gc-sections -Wl,-Map=${PROJECT_NAME}.map -Wl,--relax")

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
