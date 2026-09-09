variable THIS_DIR [file normalize [info script]]
set ENV_FP "[file dirname [file dirname [file dirname $THIS_DIR]]]/xilinx_env.tcl"
source "${ENV_FP}"
set_param general.maxThreads 8

open_project "${VIVADO_PROJECT_FOLDER}/${VIVADO_PROJECT_SLUG}.xpr"
source "${VIVADO_APP_ROOT}/scripts/add-constraints.tcl"
source "${VIVADO_APP_ROOT}/scripts/add-source-files.tcl" 
source "${VIVADO_APP_ROOT}/scripts/extend-design.tcl"
source "${VIVADO_APP_ROOT}/scripts/create-hdl-design-wrapper.tcl"
close_project
