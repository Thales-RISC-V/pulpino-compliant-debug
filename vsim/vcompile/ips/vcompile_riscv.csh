#!/bin/tcsh
source ${PULP_PATH}/./vsim/vcompile/setup.csh

##############################################################################
# Settings
##############################################################################

set IP=riscv

##############################################################################
# Check settings
##############################################################################

# check if environment variables are defined
if (! $?MSIM_LIBS_PATH ) then
  echo "${Red} MSIM_LIBS_PATH is not defined ${NC}"
  exit 1
endif

if (! $?IPS_PATH ) then
  echo "${Red} IPS_PATH is not defined ${NC}"
  exit 1
endif
 echo "${IPS_PATH}"

set LIB_NAME="${IP}_lib"
set LIB_PATH="${MSIM_LIBS_PATH}/${LIB_NAME}"
set IP_PATH="${IPS_PATH}/riscv"
set RTL_PATH="${RTL_PATH}"

##############################################################################
# Preparing library
##############################################################################

echo "${Green}--> Compiling ${IP}... ${NC}"

echo " ${MSIM_LIBS_PATH}/fpnew_lib"

rm -rf $LIB_PATH

vlib $LIB_PATH
vmap $LIB_NAME $LIB_PATH

##############################################################################
# Compiling RTL
##############################################################################

echo "${Green}Compiling component: ${Brown} riscv ${NC}"
echo "${Red}"
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IPS_PATH}/fpnew/src ${IPS_PATH}/fpnew/src/fpnew_pkg.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/include/apu_core_package.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/include/riscv_defines.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/include/riscv_tracer_defines.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_alu.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_alu_basic.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_alu_div.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_compressed_decoder.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_controller.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_cs_registers.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_decoder.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_int_controller.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_ex_stage.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_hwloop_controller.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_hwloop_regs.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_id_stage.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_if_stage.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_load_store_unit.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_mult.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_prefetch_buffer.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_prefetch_L0_buffer.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_core.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_apu_disp.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_fetch_fifo.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_L0_buffer.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_pmp.sv || goto error

echo "${Green}Compiling component: ${Brown} riscv_regfile_rtl ${NC}"
echo "${Red}"
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include ${IP_PATH}/rtl/riscv_register_file_latch.sv || goto error
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include ${IP_PATH}/rtl/register_file_test_wrap.sv || goto error

echo "${Green}Compiling component: ${Brown} riscv_vip_rtl ${NC}"
echo "${Red}"
vlog -quiet -sv -suppress 2583 -work ${LIB_PATH}    +incdir+${IP_PATH}/rtl/include+incdir+${IP_PATH}/../../rtl/includes ${IP_PATH}/rtl/riscv_tracer.sv || goto error



echo "${Cyan}--> ${IP} compilation complete! ${NC}"
exit 0

##############################################################################
# Error handler
##############################################################################

error:
echo "${NC}"
exit 1
