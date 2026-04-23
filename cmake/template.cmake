set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(BUILD_TYPE STREQUAL "Release")
    set(CMAKE_BUILD_TYPE Release)
    message("Release Build")
else()
    set(CMAKE_BUILD_TYPE Debug)
    message("Debug Build")
endif()

include_directories(${RTD_INCLUDE_DIRS})

set(ALL_SOURCES
    ${ALL_RTD_SOURCES}
    ${APPLICATION_SOURCES}
)

add_executable(${PROJECT_NAME}.elf ${ALL_SOURCES})

add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O ihex $<TARGET_FILE:${PROJECT_NAME}.elf> ${PROJECT_NAME}.hex
    COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${PROJECT_NAME}.elf> ${PROJECT_NAME}.bin
    COMMAND ${CMAKE_OBJCOPY} -O srec $<TARGET_FILE:${PROJECT_NAME}.elf> ${PROJECT_NAME}.srec
    COMMAND ${CMAKE_SIZE} -Gx $<TARGET_FILE:${PROJECT_NAME}.elf>
    COMMAND ${CMAKE_SIZE} -Gd $<TARGET_FILE:${PROJECT_NAME}.elf>
    COMMENT "Generating hex and bin files..."
)
