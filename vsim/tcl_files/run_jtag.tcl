#!/bin/bash
# \
exec vsim -64 -do "$0"

set STIMULI_JTAG $::env(STIMULI_JTAG)
set VSIM_FLAGS    "+stimuli=$STIMULI_JTAG"

set TB            tb_pulpino_jtag
set MEMLOAD       ""


source ./tcl_files/config/vsim.tcl
