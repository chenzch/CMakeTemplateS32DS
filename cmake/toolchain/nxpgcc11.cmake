if(WIN32)
    set(S32DS_DIR "C:/NXP/S32DS.3.6.5" CACHE PATH "Path to S32 Design Studio installation" FORCE)
else()
    set(S32DS_DIR "/opt/NXP/S32DS.3.6.6/S32DS" CACHE PATH "Path to S32 Design Studio installation" FORCE)
endif()

set(TOOLCHAIN_PREFIX "${S32DS_DIR}/S32DS/build_tools/gcc_v11.4/gcc-11.4-arm32-eabi/bin/arm-none-eabi-" CACHE STRING "ARM toolchain prefix")

include(${CMAKE_CURRENT_LIST_DIR}/arm-none-eabi.cmake)