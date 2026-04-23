function(aux_asm_source_directory dir var)
    file(GLOB ASM_SOURCES "${dir}/*.s" "${dir}/*.S")
    set(${var} ${${var}} ${ASM_SOURCES} PARENT_SCOPE)
endfunction()

include_directories(${PLUGINS_DIR}/Platform_${AR_PKG_NAME}/startup/include)
aux_source_directory(${PLUGINS_DIR}/Platform_${AR_PKG_NAME}/startup/src ALL_RTD_SOURCES)
aux_source_directory(${PLUGINS_DIR}/Platform_${AR_PKG_NAME}/startup/src/m7 ALL_RTD_SOURCES)
aux_asm_source_directory(${PLUGINS_DIR}/Platform_${AR_PKG_NAME}/startup/src/m7/gcc ALL_RTD_SOURCES)
