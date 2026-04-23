set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)

set(MCU_FLAGS "-mcpu=cortex-m0plus -mthumb -mfloat-abi=soft -mlittle-endian")

include(${CMAKE_CURRENT_LIST_DIR}/gcc14.cmake)
