aux_source_directory(${CMAKE_SOURCE_DIR}/Project_Settings/Startup_Code ALL_RTD_SOURCES)
file(GLOB ASM_SOURCES "${CMAKE_SOURCE_DIR}/Project_Settings/Startup_Code/*.s")
list(APPEND ALL_RTD_SOURCES ${ASM_SOURCES})
