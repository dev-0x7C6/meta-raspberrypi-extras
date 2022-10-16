# Check overclocking settings before running
RPI_ENABLE_MANUAL_OVERCLOCKING ?= "0"

RPI_OC_INITIAL_TURBO ?= "0"

RPI_OC_FORCE_TURBO ?= "0"

RPI_OC_OVER_VOLTAGE ?= "0"
RPI_OC_ARM_FREQ ?= "0"
RPI_OC_GPU_FREQ ?= "0"

RPI_OC_SDRAM_SCHMOO ?= ""
RPI_OC_SDRAM_FREQ ?= "0"
RPI_OC_OVER_VOLTAGE_SDRAM_P ?= "0"
RPI_OC_OVER_VOLTAGE_SDRAM_I ?= "0"
RPI_OC_OVER_VOLTAGE_SDRAM_C ?= "0"

RPI_CONFIG_FILE = "${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt"

write_comment() {
    echo -e "\n# ${1}" >> ${RPI_CONFIG_FILE}
}

write_cfg() {
    echo "${1}" >> ${RPI_CONFIG_FILE}
}

do_deploy:append() {
    local configfile=${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt

    if [ "${DISABLE_BLUETOOTH}" = "1" ]; then
        write_comment "Disable bluetooth"
        write_cfg "dtoverlay=pi3-disable-bt"
    fi

    if [ "${RPI_ALWAYS_FULLHD}" = "1" ]; then
        write_comment "Always run in 1080p@60hz HDMI with audio"
        write_cfg "hdmi_group=1"
        write_cfg "hdmi_mode=16"
        write_cfg "hdmi_force_hotplug=1"
        write_cfg "disable_overscan=1"
        write_cfg "hdmi_drive=2"
    fi

    if [ "${RPI_ENABLE_AUDIO}" = "1" ]; then
        write_comment "Enable audio"
        write_cfg "dtparam=audio=on"
    fi

    if [ "${RPI_OVERCLOCK_SD}" = "1" ]; then
        write_comment "Overclock sd"
        write_cfg "dtparam=sd_overclock=100"
    fi

    if [ "${RPI_ENABLE_MANUAL_OVERCLOCKING}" = "1" ]; then
        write_comment "# Manual overclock "
        [ "${RPI_OC_OVER_VOLTAGE}" != "0" ] && write_cfg "over_voltage=${RPI_OC_OVER_VOLTAGE}"
        [ "${RPI_OC_ARM_FREQ}" != "0" ] && write_cfg "arm_freq=${RPI_OC_ARM_FREQ}"
        [ "${RPI_OC_GPU_FREQ}" != "0" ] && write_cfg "gpu_freq=${RPI_OC_GPU_FREQ}"
        [ "${RPI_OC_SDRAM_FREQ}" != "0" ] && write_cfg "sdram_freq=${RPI_OC_SDRAM_FREQ}"
        [ "${RPI_OC_SDRAM_SCHMOO}" != "" ] && write_cfg "sdram_schmoo=${RPI_OC_SDRAM_SCHMOO}"
        [ "${RPI_OC_OVER_VOLTAGE_SDRAM_P}" != "0" ] && write_cfg "over_voltage_sdram_p=${RPI_OC_OVER_VOLTAGE_SDRAM_P}"
        [ "${RPI_OC_OVER_VOLTAGE_SDRAM_I}" != "0" ] && write_cfg "over_voltage_sdram_i=${RPI_OC_OVER_VOLTAGE_SDRAM_I}"
        [ "${RPI_OC_OVER_VOLTAGE_SDRAM_C}" != "0" ] && write_cfg "over_voltage_sdram_c=${RPI_OC_OVER_VOLTAGE_SDRAM_C}"
        [ "${RPI_OC_INITIAL_TURBO}" != "0" ] && write_cfg "initial_turbo=${RPI_OC_INITIAL_TURBO}"
        [ "${RPI_OC_FORCE_TURBO}" = "1" ] && write_cfg "force_turbo=1"
    else
        [ "${RPI_OC_OVER_VOLTAGE}" != "0" ] && bbwarn "using RPI_OC_OVER_VOLTAGE without RPI_ENABLE_MANUAL_OVERCLOCKING enabled, ignoring..."
        [ "${RPI_OC_ARM_FREQ}" != "0" ] && bbwarn "using RPI_OC_ARM_FREQ without RPI_ENABLE_MANUAL_OVERCLOCKING enabled, ignoring..."
        [ "${RPI_OC_GPU_FREQ}" != "0" ] && bbwarn "using RPI_OC_GPU_FREQ without RPI_ENABLE_MANUAL_OVERCLOCKING enabled, ignoring..."
        [ "${RPI_OC_SDRAM_FREQ}" != "0" ] && bbwarn "using RPI_OC_SDRAM_FREQ without RPI_ENABLE_MANUAL_OVERCLOCKING enabled, ignoring..."
        [ "${RPI_OC_SDRAM_SCHMOO}" != "" ] && bbwarn "using RPI_OC_SDRAM_SCHMOO without RPI_ENABLE_MANUAL_OVERCLOCKING enabled, ignoring..."
        [ "${RPI_OC_OVER_VOLTAGE_SDRAM_P}" != "0" ] && bbwarn "using RPI_OC_OVER_VOLTAGE_SDRAM_P without RPI_ENABLE_MANUAL_OVERCLOCKING enabled, ignoring..."
        [ "${RPI_OC_OVER_VOLTAGE_SDRAM_I}" != "0" ] && bbwarn "using RPI_OC_OVER_VOLTAGE_SDRAM_I without RPI_ENABLE_MANUAL_OVERCLOCKING enabled, ignoring..."
        [ "${RPI_OC_OVER_VOLTAGE_SDRAM_C}" != "0" ] && bbwarn "using RPI_OC_OVER_VOLTAGE_SDRAM_C without RPI_ENABLE_MANUAL_OVERCLOCKING enabled, ignoring..."
        [ "${RPI_OC_INITIAL_TURBO}" != "0" ] && bbwarn "enabled RPI_OC_INITIAL_TURBO without RPI_ENABLE_MANUAL_OVERCLOCKING enabled, ignoring..."
        [ "${RPI_OC_FORCE_TURBO}" = "1" ] && bbwarn "enabled RPI_OC_FORCE_TURBO without RPI_ENABLE_MANUAL_OVERCLOCKING enabled, ignoring..."
        true
    fi
}
