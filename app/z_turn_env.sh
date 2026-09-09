export XILINX_ARCH="zynq"
export XILINX_BOARD="z_turn"
export XILINX_BOARD_PART="xc7z020clg400-3"
export VIVADO_PROJECT_SLUG="vivado"
export VIVADO_PROJECT_FOLDER="${XILINX_BOARD}_hw"
export VITIS_PROJECT_SLUG="vitis"
export VITIS_PROJECT_FOLDER="${XILINX_BOARD}_fw"

APP_PATH="$(dirname $(dirname $(dirname $(realpath $0))))"
export VIVADO_APP_ROOT="${APP_PATH}/${XILINX_BOARD}_hw"
export VITIS_APP_ROOT="${APP_PATH}/${XILINX_BOARD}_fw"
export VHDL_APP_ROOT="${APP_PATH}/vhdl"

APP_PARENT_PATH="$(dirname ${APP_PATH})"
export VIVADO_PROJECT_PATH="${APP_PARENT_PATH}/${VIVADO_PROJECT_FOLDER}"
export VITIS_PROJECT_PATH="${APP_PARENT_PATH}/${VITIS_PROJECT_FOLDER}"

# ---------------------------------------- project settings ----------------------------------------

export VIVADO_DESIGN_WRAPPER_SLUG="design_1_wrapper"
export VIVADO_IMPL="impl_1"
export XSA_FILEPATH="${VIVADO_PROJECT_PATH}/${VIVADO_DESIGN_WRAPPER_SLUG}.xsa"

export VITIS_APP="${VITIS_PROJECT_SLUG}_app"
export VITIS_SYSTEM="${VITIS_APP}_system"
export VITIS_PLATFORM="${VITIS_PROJECT_SLUG}_pfm"

export BIF_PATH="${VITIS_PROJECT_PATH}/${VITIS_SYSTEM}/_ide/bootimage"
export BIF_FILEPATH="${BIF_PATH}/${VITIS_SYSTEM}.bif"
