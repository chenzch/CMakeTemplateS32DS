set(RTD_INCLUDE_DIRS
    ${PROJECT_SOURCE_DIR}/RTD/include
    ${PROJECT_SOURCE_DIR}/generate/include
    ${PROJECT_SOURCE_DIR}/board
    ${PROJECT_SOURCE_DIR}/include
)

aux_source_directory(${PROJECT_SOURCE_DIR}/RTD/src S32DS_RTD_SOURCES)
aux_source_directory(${PROJECT_SOURCE_DIR}/generate/src GENERATE_SOURCES)
aux_source_directory(${PROJECT_SOURCE_DIR}/board BOARD_SOURCES)
aux_source_directory(${PROJECT_SOURCE_DIR}/Project_Settings/Startup_Code STARTUP_SOURCES)
file(GLOB ASM_SOURCES "${PROJECT_SOURCE_DIR}/Project_Settings/Startup_Code/*.s")

set(ALL_RTD_SOURCES
    ${S32DS_RTD_SOURCES}
    ${GENERATE_SOURCES}
    ${BOARD_SOURCES}
    ${ASM_SOURCES}
)
