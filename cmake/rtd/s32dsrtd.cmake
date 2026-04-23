if(WIN32)
    set(S32DS_DIR "C:/NXP/S32DS.3.6.5" CACHE PATH "Path to S32 Design Studio installation" FORCE)
else()
    set(S32DS_DIR "/opt/NXP/S32DS.3.6.6/S32K3XX_RTD701/upper" CACHE PATH "Path to S32 Design Studio installation" FORCE)
endif()

set(RTD_DIR "${S32DS_DIR}/S32DS/software/PlatformSDK_S32K3/RTD")

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

get_ts_suffix("${RTD_DIR}" AR_PKG_NAME)

include_directories(
    "${RTD_DIR}/BaseNXP_${AR_PKG_NAME}/header"
    "${RTD_DIR}/BaseNXP_${AR_PKG_NAME}/include"
    "${RTD_DIR}/Platform_${AR_PKG_NAME}/include"
    "${RTD_DIR}/Platform_${AR_PKG_NAME}/startup/include"
)
