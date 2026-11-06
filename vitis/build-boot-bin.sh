#!/usr/bin/env bash
FP=$(realpath $0) ; PTH=$(dirname "${FP}") ; _ENV_SH="${PTH}/_env.sh" ; . "${_ENV_SH}"

unset FP_ERR
check_fp () {
  [ ! -f "${!1}" ] && perr "file not found $1=${!1}\n" && FP_ERR=true
}

check_fp MB_VITIS_FSBL_ELF_FP
check_fp MB_VIVADO_BIT_FP
check_fp MB_VITIS_APP_ELF_FP
[ ! -z $FP_ERR ] && exit

if [ "$MB_DISTRO_NAME" = "MINGW64_NT" ]; then
  MB_VITIS_FSBL_ELF_FP=$(cygpath -m "${MB_VITIS_FSBL_ELF_FP}")
  MB_VIVADO_BIT_FP=$(cygpath -m "${MB_VIVADO_BIT_FP}")
  MB_VITIS_APP_ELF_FP=$(cygpath -m "${MB_VITIS_APP_ELF_FP}")
fi

mkdir -p "${MB_BOOT_OUT_PATH}"
BIF_FP="${MB_BOOT_OUT_PATH}/${MB_VITIS_APP_OPT}.bif"

echo "\
//arch = ${MB_XILINX_ARCH_OPT}; split = false; format = BIN
the_ROM_image:
{
    [bootloader]${MB_VITIS_FSBL_ELF_FP}
    ${MB_VIVADO_BIT_FP}
    ${MB_VITIS_APP_ELF_FP}
}" > "${BIF_FP}"

bootgen -arch "${MB_XILINX_ARCH_OPT}" -image "${BIF_FP}" -w -o "${MB_BOOT_BIN_FP}"
