#!/usr/bin/env sh

rm -rf "./mister/hdl/top.sv.patch"
diff -d "./out/Template_MiSTer/Template.sv" "./mister/hdl/reference-top.sv" > "./mister/hdl/top.sv.patch"
# mitigates 'Reversed (or previously applied) patch detected!  Assume -R? [n] n'
dos2unix "./mister/hdl/top.sv.patch"
