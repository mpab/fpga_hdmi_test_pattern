#!/usr/bin/env sh

ENV_FP="$(dirname $(realpath $0))/mister_env.sh"
if [ ! -f "$ENV_FP" ]; then
    echo "ERROR - no script: $ENV_FP"
    exit
fi
. "$ENV_FP"

if [ ! -d "${QUARTUS_PROJECT_NAME}" ]; then
    echo "WARNING - no project: ${QUARTUS_PROJECT_NAME}"
    exit
fi

cd "${QUARTUS_PROJECT_NAME}" || exit

del () {
    rm "$1"
}

rmdir_s_q () {
    rm -rf "$1"
}

del_s_file () {
    find . -name "$1" -exec rm {} \;
}

del_s_dir () {
    find "$1" -name "$2" -exec rm -rf {} \;
}

del_s_file *.bak
del_s_file *.orig
del_s_file *.rej
del_s_file *~
rmdir_s_q db
rmdir_s_q incremental_db
rmdir_s_q output_files
rmdir_s_q simulation
rmdir_s_q greybox_tmp
rmdir_s_q hc_output
rmdir_s_q .qsys_edit
rmdir_s_q hps_isw_handoff
rmdir_s_q sys/.qsys_edit
rmdir_s_q sys/vip
del_s_dir sys *_sim
del_s_dir rtl *_sim
del -f build_id.v
del -f c5_pin_model_dump.txt
del_s_file *.qws
del_s_file *.ppf
del_s_file *.ddb
del_s_file *.csv
del_s_file *.cmp
del_s_file *.sip
del_s_file *.spd
del_s_file *.bsf
del_s_file *.f
del_s_file *.sopcinfo
del_s_file *.xml
del_s_file *.cdf
del_s_file *.rpt
del_s_file new_rtl_netlist
del_s_file old_rtl_netlist