set(RTD_INCLUDE_DIRS
    ${CMAKE_SOURCE_DIR}/RTD/include
    ${CMAKE_SOURCE_DIR}/generate/include
    ${CMAKE_SOURCE_DIR}/board
    ${CMAKE_SOURCE_DIR}/include
)

aux_source_directory(${CMAKE_SOURCE_DIR}/RTD/src ALL_RTD_SOURCES)
aux_source_directory(${CMAKE_SOURCE_DIR}/generate/src ALL_RTD_SOURCES)
aux_source_directory(${CMAKE_SOURCE_DIR}/board ALL_RTD_SOURCES)
aux_source_directory(${CMAKE_SOURCE_DIR}/Project_Settings/Startup_Code ALL_RTD_SOURCES)
file(GLOB ASM_SOURCES "${CMAKE_SOURCE_DIR}/Project_Settings/Startup_Code/*.s")
list(APPEND ALL_RTD_SOURCES ${ASM_SOURCES})
