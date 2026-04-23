if(WIN32)
    set(RTD_DIR "C:/NXP/AUTOSAR/SW32K3_S32M27x_RTD_R23-11_7.0.1" CACHE PATH "Path to S32 Design Studio installation" FORCE)
else()
    set(RTD_DIR "/run/media/chenzch/5D23072D6D8B609D/AUTOSAR/SW32K3_S32M27x_RTD_R23-11_7.0.1" CACHE PATH "Path to S32 Design Studio installation" FORCE)
endif()

set(PLUGINS_DIR "${RTD_DIR}/eclipse/plugins")

function(get_ts_suffix INPUT_DIR OUT_VAR)
    # 初始化结果为空
    set(RESULT "")

    # 检查输入目录是否存在
    if(NOT EXISTS "${INPUT_DIR}" OR NOT IS_DIRECTORY "${INPUT_DIR}")
        set(${OUT_VAR} "${RESULT}" PARENT_SCOPE)
        return()
    endif()

    # 获取第一层子目录（只目录，不递归）
    file(GLOB SUB_DIRS LIST_DIRECTORIES true "${INPUT_DIR}/*")

    # 遍历查找第一个包含 _TS_ 的目录
    foreach(DIR ${SUB_DIRS})
        # 只处理目录
        if(IS_DIRECTORY "${DIR}")
            # 获取纯目录名
            get_filename_component(DIR_NAME "${DIR}" NAME)

            # 匹配 _TS_
            if(DIR_NAME MATCHES "_TS_")
                # 截取 _TS_ 之后的内容
                string(REGEX REPLACE ".*_TS_(.*)" "\\1" RESULT "${DIR_NAME}")
                break() # 找到第一个立即退出
            endif()
        endif()
    endforeach()

    # 返回结果到父作用域
    set(${OUT_VAR} "TS_${RESULT}" PARENT_SCOPE)
endfunction()

get_ts_suffix("${PLUGINS_DIR}" AR_PKG_NAME)

include_directories(
    "${PLUGINS_DIR}/BaseNXP_${AR_PKG_NAME}/header"
    "${PLUGINS_DIR}/BaseNXP_${AR_PKG_NAME}/include"
    "${PLUGINS_DIR}/Platform_${AR_PKG_NAME}/include"
    "${PLUGINS_DIR}/Platform_${AR_PKG_NAME}/startup/include"
    "${PLUGINS_DIR}/Rte_${AR_PKG_NAME}/include"
)

foreach(MODULE ${MCAL_MODULES})
    include_directories(${PLUGINS_DIR}/${MODULE}_${AR_PKG_NAME}/include)
    aux_source_directory(${PLUGINS_DIR}/${MODULE}_${AR_PKG_NAME}/src ALL_RTD_SOURCES)
    file(GLOB RTE_SOURCE "${PLUGINS_DIR}/Rte_${AR_PKG_NAME}/src/SchM_${MODULE}.c")
    list(APPEND ALL_RTD_SOURCES ${RTE_SOURCE})
endforeach()

function(aux_asm_source_directory dir var)
    file(GLOB ASM_SOURCES "${dir}/*.s" "${dir}/*.S")
    set(${var} ${${var}} ${ASM_SOURCES} PARENT_SCOPE)
endfunction()

include_directories(${PLUGINS_DIR}/Platform_${AR_PKG_NAME}/startup/include)
aux_source_directory(${PLUGINS_DIR}/Platform_${AR_PKG_NAME}/startup/src ALL_RTD_SOURCES)
aux_source_directory(${PLUGINS_DIR}/Platform_${AR_PKG_NAME}/startup/src/m7 ALL_RTD_SOURCES)
aux_asm_source_directory(${PLUGINS_DIR}/Platform_${AR_PKG_NAME}/startup/src/m7/gcc ALL_RTD_SOURCES)

list(APPEND ALL_RTD_SOURCES ${ASM_SOURCES})
