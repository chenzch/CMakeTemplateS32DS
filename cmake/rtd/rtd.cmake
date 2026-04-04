set(RTD_DIR "/opt/NXP/S32DS.3.6.6/S32K3_7.0.1/upper/S32DS/software/PlatformSDK_S32K3/RTD")
set(RTD_CRYPTO_DIR "/opt/NXP/S32DS.3.6.6/S32K3_7.0.1/upper/S32DS/software/PlatformSDK_S32K3/RTD_CRYPTO")

set(AR_PKG_NAME "TS_T40D34M70I1R0")

include_directories(
    "${RTD_DIR}/BaseNXP_${AR_PKG_NAME}/header"
    "${RTD_DIR}/BaseNXP_${AR_PKG_NAME}/include"
    "${RTD_DIR}/Platform_${AR_PKG_NAME}/include"
    "${RTD_DIR}/Platform_${AR_PKG_NAME}/startup/include"
)
