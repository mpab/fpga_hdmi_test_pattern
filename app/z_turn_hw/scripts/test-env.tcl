# variable THIS_DIR [file normalize [info script]]
# set ENV_FP "[file dirname [file dirname [file dirname $THIS_DIR]]]/xilinx_env.tcl"
# source "${ENV_FP}"

variable THIS_DIR [file normalize [info script]]
set ENV_FP "[file dirname [file dirname [file dirname $THIS_DIR]]]/xilinx_env.tcl"
source "${ENV_FP}"

puts "XILINX_BOARD: ${XILINX_BOARD}"
puts "VIVADO_PROJECT_SLUG: ${VIVADO_PROJECT_SLUG}"
puts "VIVADO_PROJECT_FOLDER: ${VIVADO_PROJECT_FOLDER}"
puts "VITIS_PROJECT_SLUG: ${VITIS_PROJECT_SLUG}"
puts "VITIS_PROJECT_FOLDER: ${VITIS_PROJECT_FOLDER}"
puts "VIVADO_APP_ROOT: ${VIVADO_APP_ROOT}"
puts "VITIS_APP_ROOT: ${VITIS_APP_ROOT}"
puts "VHDL_APP_ROOT: ${VHDL_APP_ROOT}"

puts "VIVADO_DESIGN_WRAPPER_SLUG: ${VIVADO_DESIGN_WRAPPER_SLUG}"
puts "VIVADO_IMPL: ${VIVADO_IMPL}"
puts "VIVADO_PROJECT_PATH: ${VIVADO_PROJECT_PATH}"
puts "VITIS_PROJECT_PATH: ${VITIS_PROJECT_PATH}"

puts "APP: ${APP}"
puts "SYSTEM: ${SYSTEM}"
puts "PLATFORM: ${PLATFORM}"
puts "BIF_PATH: ${BIF_PATH}"
puts "BIF_FILEPATH: ${BIF_FILEPATH}"
