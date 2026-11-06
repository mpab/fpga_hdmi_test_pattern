source env.tcl

set fh [open env.tcl]
set lines [split [read $fh] "\n"]
close $fh;
foreach line $lines {
  set VAR [lindex [regexp -all -inline {\S+} ${line}] 1]
  if {$VAR eq ""} { continue }
  eval puts \"$VAR \$$VAR\"
}
