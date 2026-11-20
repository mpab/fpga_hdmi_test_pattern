#!/usr/bin/env sh

rm -rf "./out/mister/top.sv"
cp "./out/Template_MiSTer/Template.sv" "./out/mister/top.sv"
patch "./out/mister/top.sv" "./mister/hdl/top.sv.patch"
