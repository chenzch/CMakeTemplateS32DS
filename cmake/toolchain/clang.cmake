if(WIN32)
    set(TOOLCHAIN_POSTFIX ".exe")
else()
    set(TOOLCHAIN_POSTFIX "")
endif()

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)

set(CMAKE_C_COMPILER   ${TOOLCHAIN_PREFIX}clang${TOOLCHAIN_POSTFIX} CACHE FILEPATH "C compiler")
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}clang++${TOOLCHAIN_POSTFIX} CACHE FILEPATH "C++ compiler")
set(CMAKE_ASM_COMPILER ${TOOLCHAIN_PREFIX}clang${TOOLCHAIN_POSTFIX} CACHE FILEPATH "ASM compiler")
set(CMAKE_AR           ${TOOLCHAIN_PREFIX}llvm-ar${TOOLCHAIN_POSTFIX} CACHE FILEPATH "Archiver")
set(CMAKE_RANLIB       ${TOOLCHAIN_PREFIX}llvm-ranlib${TOOLCHAIN_POSTFIX} CACHE FILEPATH "Ranlib")
set(CMAKE_OBJCOPY      ${TOOLCHAIN_PREFIX}llvm-objcopy${TOOLCHAIN_POSTFIX} CACHE FILEPATH "Objcopy")
set(CMAKE_SIZE         ${TOOLCHAIN_PREFIX}llvm-size${TOOLCHAIN_POSTFIX} CACHE FILEPATH "Size")

set(CMAKE_C_COMPILER_TARGET arm-none-eabi CACHE STRING "Clang target triple")
set(CMAKE_CXX_COMPILER_TARGET arm-none-eabi CACHE STRING "Clang target triple")
set(CMAKE_ASM_COMPILER_TARGET arm-none-eabi CACHE STRING "Clang target triple")

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

find_program(ARM_GCC_EXECUTABLE arm-none-eabi-gcc)

if(NOT ARM_GCC_EXECUTABLE)
    message(FATAL_ERROR "未找到 arm-none-eabi-gcc，请将其加入到环境变量 PATH 中！")
endif()

# 2. 运行 gcc -print-search-dirs 并获取输出
execute_process(
    COMMAND ${ARM_GCC_EXECUTABLE} -print-search-dirs
    OUTPUT_VARIABLE GCC_SEARCH_DIRS_OUTPUT
    ERROR_QUIET
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

# 3. 使用正则表达式提取 install: 后面的路径
#    匹配以 install: 开头，直到 /bin/ 出现为止的前半部分
if(GCC_SEARCH_DIRS_OUTPUT MATCHES "install:[ \t]*([^\n\r]*)/")
    set(GCC_TOOLCHAIN_ROOT "${CMAKE_MATCH_1}")
    
    # 将 Windows 的反斜杠 \ 统一转换为 CMake 的正斜杠 /
    file(TO_CMAKE_PATH "${GCC_TOOLCHAIN_ROOT}" GCC_TOOLCHAIN_ROOT)
    
    message(STATUS "成功自动获取 GCC Toolchain 根目录: ${GCC_TOOLCHAIN_ROOT}")
else()
    message(FATAL_ERROR "无法从 arm-none-eabi-gcc 的输出中解析出根目录！")
endif()

# 4. 将获取到的路径配置给 Clang 编译器和链接器参数
add_link_options(-L${GCC_TOOLCHAIN_ROOT} -fuse-ld=lld)

set(RTD_COMPILE_OPTIONS
    -fno-short-enums
    -ffunction-sections
    -fdata-sections
    -fno-builtin
    -flto
    -D_ARM_DS6_S32K3XX_
    --target=arm-none-eabi
)

format_flags_to_string(RTD_WARNING_FLAGS RTD_WARNING_FLAGS_STR)
format_flags_to_string(RTD_COMPILE_OPTIONS RTD_COMPILE_OPTIONS_STR)

set(CMAKE_C_FLAGS   "${MCU_FLAGS} ${RTD_WARNING_FLAGS_STR} ${RTD_COMPILE_OPTIONS_STR} -fno-common -funsigned-char -fomit-frame-pointer" CACHE INTERNAL "c compiler flags")
set(CMAKE_CXX_FLAGS "${MCU_FLAGS} ${RTD_WARNING_FLAGS_STR} ${RTD_COMPILE_OPTIONS_STR} -fno-common -funsigned-char -fomit-frame-pointer -fno-rtti -fno-exceptions" CACHE INTERNAL "cxx compiler flags")
set(CMAKE_ASM_FLAGS "${MCU_FLAGS} -x assembler-with-cpp --target=arm-none-eabi" CACHE INTERNAL "asm compiler flags")
set(CMAKE_EXE_LINKER_FLAGS "-T${LINKER_SCRIPT} -Wl,--entry=Reset_Handler -Wl,--gc-sections -Wl,-Map=${PROJECT_NAME}.map -Wl,--relax" CACHE INTERNAL "exe link flags")

set(CMAKE_C_FLAGS_DEBUG "-Og -g -ggdb3" CACHE INTERNAL "c debug compiler flags")
set(CMAKE_CXX_FLAGS_DEBUG "-Og -g -ggdb3" CACHE INTERNAL "cxx debug compiler flags")
set(CMAKE_ASM_FLAGS_DEBUG "-g -ggdb3" CACHE INTERNAL "asm debug compiler flags")

set(CMAKE_C_FLAGS_RELEASE "-O3 -DNDEBUG" CACHE INTERNAL "c release compiler flags")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG" CACHE INTERNAL "cxx release compiler flags")
set(CMAKE_ASM_FLAGS_RELEASE "-DNDEBUG" CACHE INTERNAL "asm release compiler flags")
