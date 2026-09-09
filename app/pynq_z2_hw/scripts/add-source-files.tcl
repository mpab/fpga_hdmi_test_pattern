# add VHDL assets
set src_files_platform [glob -nocomplain -directory ${VIVADO_APP_ROOT}/src/ -type f *]
add_files -norecurse -fileset sources_1 $src_files_platform
set src_files_application [glob -nocomplain -directory ${VHDL_APP_ROOT}/src/ -type f *]
add_files -norecurse -fileset sources_1 $src_files_application

#to copy files, do s'th like...
#foreach file $src_files_platform {
#    puts $file
#}