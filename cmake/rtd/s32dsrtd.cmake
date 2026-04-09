set(S32DS_DIR "C:/NXP/S32DS.3.6.5" CACHE PATH "Path to S32 Design Studio installation")

set(RTD_DIR "${S32DS_DIR}/S32DS/software/PlatformSDK_S32K3/RTD")

set(AR_PKG_NAME "TS_T40D34M70I0R0")

include_directories(
    "${RTD_DIR}/BaseNXP_${AR_PKG_NAME}/header"
    "${RTD_DIR}/BaseNXP_${AR_PKG_NAME}/include"
    "${RTD_DIR}/Platform_${AR_PKG_NAME}/include"
    "${RTD_DIR}/Platform_${AR_PKG_NAME}/startup/include"
)
