# Based on original: https://github.com/jwinarske/meta-flutter/blob/zeus/recipes-graphics/rpi-vk-driver/rpi-vk-driver_git.bb (Joel Winarske)

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=0e9db807e4f1ed14373059c8499d5f82"

inherit cmake features_check python3native

SRC_URI = "git://github.com/Yours3lf/rpi-vk-driver.git;protocol=https;branch=master"
SRCREV = "6bfd11b1ccb947e4eb8d1665083d56d66707de01"
S = "${WORKDIR}/git"

PV = "1.0+git${SRCPV}"

DEPENDS += "libdrm vulkan-headers expat zlib"

REQUIRED_DISTRO_FEATURES = "vulkan"
OECMAKE_FIND_ROOT_PATH_MODE_PROGRAM = "BOTH"

# todo add package flags
EXTRA_OECMAKE:append = " \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_VERBOSE_MAKEFILE=TRUE \
    -DCMAKE_SKIP_INSTALL_RPATH=ON \
    -DBUILD_TESTING=OFF \
"

FILES:${PN} = " \
    ${libdir}/librpi-vk-driver.so \
    ${datadir}/vulkan/icd.d/rpi-vk-driver.json \
"

FILES:${PN}-dev  = " \
    ${bindir}/QPUassemblerExe \
"

PACKAGECONFIG ??= "${@bb.utils.filter('DISTRO_FEATURES', 'wayland x11', d)}"

PACKAGECONFIG[x11] = "-DBUILD_WSI_XLIB_SUPPORT=ON -DBUILD_WSI_XCB_SUPPORT=ON, -DBUILD_WSI_XLIB_SUPPORT=OFF -DBUILD_WSI_XCB_SUPPORT=OFF, libxcb libx11 libxrandr"
PACKAGECONFIG[wayland] = "-DBUILD_WSI_WAYLAND_SUPPORT=ON, -DBUILD_WSI_WAYLAND_SUPPORT=OFF, wayland"

#  The driver currently supports the following Raspberry Pi models:
#
#  Zero
#  Zero W
#  1 Model A
#  1 Model A+
#  1 Model B
#  1 Model B+
#  2 Model B
#  3 Model A+
#  3 Model B
#  3 Model B+
#  Compute Module 1
#  Compute Module 3
#  Compute Module 3 lite
#  Compute Module 3+
#  Compute Module 3+ lite

COMPATIBLE_MACHINE:raspberrypi = "(.*)"
COMPATIBLE_MACHINE:raspberrypi-cm = "(.*)"
COMPATIBLE_MACHINE:raspberrypi-cm3 = "(.*)"
COMPATIBLE_MACHINE:raspberrypi0 = "(.*)"
COMPATIBLE_MACHINE:raspberrypi0-wifi = "(.*)"
COMPATIBLE_MACHINE:raspberrypi2 = "(.*)"
COMPATIBLE_MACHINE:raspberrypi3 = "(.*)"
COMPATIBLE_MACHINE:raspberrypi3-64 = "(.*)"

# It is not compatible with raspberrypi4 (Video Core VI) chipsets 
COMPATIBLE_MACHINE = "(!.*)"
