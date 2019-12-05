

# Set the reference directory for source file relative paths (by default the value is script directory path)
#set origin_dir "/home/sjacq/Work_dir/USE_CASE/2019/pulp/pulpino_debug_commit_0/fpga/pulpino_zcu102"
set origin_dir "."


# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

# Set the project name
set _xil_proj_name_ "pulpino_zcu102"

# Use project name variable, if specified in the tcl shell
if { [info exists ::user_project_name] } {
  set _xil_proj_name_ $::user_project_name
}

variable script_file
set script_file "pulpino_zcu102.tcl"

# Help information for this script
proc help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--project_name <name>\] Create project with the specified name. Default"
  puts "                       name is the name of the project from where this"
  puts "                       script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < $::argc} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir"   { incr i; set origin_dir [lindex $::argv $i] }
      "--project_name" { incr i; set _xil_proj_name_ [lindex $::argv $i] }
      "--help"         { help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/../pulpzcu102/project_pulpzcu102_1"]"

# Create project
create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xczu9eg-ffvb1156-2-e

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Reconstruct message rules
# None

# Set project properties
set obj [current_project]
set_property -name "board_part" -value "xilinx.com:zcu102:part0:3.2" -objects $obj
set_property -name "corecontainer.enable" -value "1" -objects $obj
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "dsa.accelerator_binary_content" -value "bitstream" -objects $obj
set_property -name "dsa.accelerator_binary_format" -value "xclbin2" -objects $obj
set_property -name "dsa.board_id" -value "zcu102_es2" -objects $obj
set_property -name "dsa.description" -value "Vivado generated DSA" -objects $obj
set_property -name "dsa.dr_bd_base_address" -value "0" -objects $obj
set_property -name "dsa.emu_dir" -value "emu" -objects $obj
set_property -name "dsa.flash_interface_type" -value "bpix16" -objects $obj
set_property -name "dsa.flash_offset_address" -value "0" -objects $obj
set_property -name "dsa.flash_size" -value "1024" -objects $obj
set_property -name "dsa.host_architecture" -value "x86_64" -objects $obj
set_property -name "dsa.host_interface" -value "pcie" -objects $obj
set_property -name "dsa.num_compute_units" -value "60" -objects $obj
set_property -name "dsa.platform_state" -value "pre_synth" -objects $obj
set_property -name "dsa.uses_pr" -value "1" -objects $obj
set_property -name "dsa.vendor" -value "xilinx" -objects $obj
set_property -name "dsa.version" -value "0.0" -objects $obj
set_property -name "enable_core_container" -value "1" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/${_xil_proj_name_}.cache/ip" -objects $obj
set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
set_property -name "sim.central_dir" -value "$proj_dir/${_xil_proj_name_}.ip_user_files" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj
set_property -name "webtalk.activehdl_export_sim" -value "57" -objects $obj
set_property -name "webtalk.ies_export_sim" -value "57" -objects $obj
set_property -name "webtalk.modelsim_export_sim" -value "58" -objects $obj
set_property -name "webtalk.questa_export_sim" -value "57" -objects $obj
set_property -name "webtalk.riviera_export_sim" -value "57" -objects $obj
set_property -name "webtalk.vcs_export_sim" -value "57" -objects $obj
set_property -name "webtalk.xcelium_export_sim" -value "2" -objects $obj
set_property -name "webtalk.xsim_export_sim" -value "58" -objects $obj
set_property -name "webtalk.xsim_launch_sim" -value "152" -objects $obj
set_property -name "xpm_libraries" -value "XPM_CDC XPM_MEMORY" -objects $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# xilinx_mem_8192x32 coregen
create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name xilinx_mem_8192x32
set_property -dict [list CONFIG.Use_Byte_Write_Enable {true} \
                        CONFIG.Byte_Size {8} \
                         CONFIG.Write_Width_A {32} \
                         CONFIG.Write_Depth_A {8192} \
                         CONFIG.Read_Width_A {32} \
                         CONFIG.Write_Width_B {32} \
                         CONFIG.Read_Width_B {32} \
                         CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
                         CONFIG.Use_RSTA_Pin {true} \
                         CONFIG.EN_SAFETY_CKT {true}] [get_ips xilinx_mem_8192x32]

generate_target all [get_files  ${_xil_proj_name_}/${_xil_proj_name_}.srcs/sources_1/ip/xilinx_mem_8192x32/xilinx_mem_8192x32.xci]
catch { config_ip_cache -export [get_ips -all xilinx_mem_8192x32] }
export_ip_user_files -of_objects [get_files ${_xil_proj_name_}/${_xil_proj_name_}.srcs/sources_1/ip/xilinx_mem_8192x32/xilinx_mem_8192x32.xci] -no_script -sync -force -quiet
create_ip_run [get_files -of_objects [get_fileset sources_1] ${_xil_proj_name_}/${_xil_proj_name_}.srcs/sources_1/ip/xilinx_mem_8192x32/xilinx_mem_8192x32.xci]
launch_runs  xilinx_mem_8192x32_synth_1
wait_on_run xilinx_mem_8192x32_synth_1 
set_property generate_synth_checkpoint 0 [get_files xilinx_mem_8192x32.xci]



# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 [file normalize "${origin_dir}/../../ips/axi/axi_slice_dc/dc_data_buffer.v"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_slice_dc/dc_full_detector.v"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_slice_dc/dc_synchronizer.v"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_slice_dc/dc_token_ring.v"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_slice_dc/dc_token_ring_fifo_din.v"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_slice_dc/dc_token_ring_fifo_dout.v"] \
 [file normalize "${origin_dir}/../../rtl/includes/config.sv"] \
 [file normalize "${origin_dir}/../../rtl/includes/apb_bus.sv"] \
 [file normalize "${origin_dir}/../../rtl/includes/axi_bus.sv"] \
 [file normalize "${origin_dir}/../../rtl/includes/debug_bus.sv"] \
 [file normalize "${origin_dir}/../../rtl/includes/pulp_interfaces.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb2per/apb2per.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_event_unit/include/defines_event_unit.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_event_unit/apb_event_unit.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_fll_if/apb_fll_if.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_gpio/apb_gpio.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_i2c/i2c_master_defines.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_i2c/apb_i2c.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_node/apb_node.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_node/apb_node_wrap.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_pulpino/apb_pulpino.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_spi_master/apb_spi_master.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_timer/apb_timer.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_uart_sv/apb_uart_sv.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/include/apu_core_package.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi2apb/axi2apb.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi2apb/axi2apb32.sv"] \
 [file normalize "${origin_dir}/../../rtl/axi2apb_wrap.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/axi_AR_allocator.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/axi_AW_allocator.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/axi_ArbitrationTree.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/defines.v"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/axi_BR_allocator.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/axi_BW_allocator.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/axi_DW_allocator.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/axi_FanInPrimitive_Req.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/axi_RR_Flag_Req.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/axi_address_decoder_AR.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/axi_address_decoder_AW.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/axi_address_decoder_BR.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/axi_address_decoder_BW.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/axi_address_decoder_DW.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_slice/axi_ar_buffer.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_slice/axi_aw_buffer.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_slice/axi_b_buffer.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_mem_if_DP/axi_mem_if_SP.sv"] \
 [file normalize "${origin_dir}/../../rtl/axi_mem_if_SP_wrap.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/axi_multiplexer.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/axi_node.sv"] \
 [file normalize "${origin_dir}/../../rtl/axi_node_intf_wrap.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_slice/axi_r_buffer.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_mem_if_DP/axi_read_only_ctrl.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/axi_request_block.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/axi_response_block.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_slice/axi_slice.sv"] \
 [file normalize "${origin_dir}/../../rtl/axi_slice_wrap.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_spi_slave/axi_spi_slave.sv"] \
 [file normalize "${origin_dir}/../../rtl/axi_spi_slave_wrap.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_slice/axi_w_buffer.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_mem_if_DP/axi_write_only_ctrl.sv"] \
 [file normalize "${origin_dir}/../../rtl/boot_code.sv"] \
 [file normalize "${origin_dir}/../../rtl/boot_rom_wrap.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv-dbg/src/cdc_2phase.sv"] \
 [file normalize "${origin_dir}/../../rtl/clk_rst_gen.sv"] \
 [file normalize "${origin_dir}/../../rtl/components/cluster_clock_gating.sv"] \
 [file normalize "${origin_dir}/../../rtl/components/cluster_clock_inverter.sv"] \
 [file normalize "${origin_dir}/../../rtl/components/cluster_clock_mux2.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/core2axi/core2axi.sv"] \
 [file normalize "${origin_dir}/../../rtl/core2axi_wrap.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv-dbg/src/dm_pkg.sv"] \
 [file normalize "${origin_dir}/../../rtl/includes/pulp_soc_defines.sv"] \
 [file normalize "${origin_dir}/../../rtl/core_region.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv-dbg/debug_rom/debug_rom.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv-dbg/src/dm_csrs.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv-dbg/src/dm_mem.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv-dbg/src/dm_sba.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv-dbg/src/dm_top.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv-dbg/src/dmi_cdc.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv-dbg/src/dmi_jtag.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv-dbg/src/dmi_jtag_tap.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv-dbg/src/fifo_v2.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv-dbg/src/fifo_v3.sv"] \
 [file normalize "${origin_dir}/../../ips/fpnew/src/fpnew_pkg.sv"] \
 [file normalize "${origin_dir}/../../ips/fpnew/src/fpnew_cast_multi.sv"] \
 [file normalize "${origin_dir}/../../ips/fpnew/src/fpnew_classifier.sv"] \
 [file normalize "${origin_dir}/../../ips/fpnew/src/registers.svh"] \
 [file normalize "${origin_dir}/../../ips/fpnew/src/fpnew_divsqrt_multi.sv"] \
 [file normalize "${origin_dir}/../../ips/fpnew/src/fpnew_fma.sv"] \
 [file normalize "${origin_dir}/../../ips/fpnew/src/fpnew_fma_multi.sv"] \
 [file normalize "${origin_dir}/../../ips/fpnew/src/fpnew_noncomp.sv"] \
 [file normalize "${origin_dir}/../../ips/fpnew/src/fpnew_opgroup_block.sv"] \
 [file normalize "${origin_dir}/../../ips/fpnew/src/fpnew_opgroup_fmt_slice.sv"] \
 [file normalize "${origin_dir}/../../ips/fpnew/src/fpnew_opgroup_multifmt_slice.sv"] \
 [file normalize "${origin_dir}/../../ips/fpnew/src/fpnew_pipe_in.sv"] \
 [file normalize "${origin_dir}/../../ips/fpnew/src/fpnew_pipe_inside_cast.sv"] \
 [file normalize "${origin_dir}/../../ips/fpnew/src/fpnew_pipe_inside_fma.sv"] \
 [file normalize "${origin_dir}/../../ips/fpnew/src/fpnew_pipe_out.sv"] \
 [file normalize "${origin_dir}/../../ips/fpnew/src/fpnew_rounding.sv"] \
 [file normalize "${origin_dir}/../../ips/fpnew/src/fpnew_top.sv"] \
 [file normalize "${origin_dir}/../../rtl/components/generic_fifo.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_event_unit/generic_service_unit.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_i2c/i2c_master_bit_ctrl.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_i2c/i2c_master_byte_ctrl.sv"] \
 [file normalize "${origin_dir}/../../rtl/instr_ram_wrap.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_uart_sv/io_generic_fifo.sv"] \
 [file normalize "${origin_dir}/../../ips/L2_tcdm_hybrid_interco/RTL/lint_2_axi.sv"] \
 [file normalize "${origin_dir}/../../rtl/periph_bus_wrap.sv"] \
 [file normalize "${origin_dir}/../../rtl/peripherals.sv"] \
 [file normalize "${origin_dir}/../../rtl/components/pulp_clock_inverter.sv"] \
 [file normalize "${origin_dir}/../../rtl/components/pulp_clock_mux2.sv"] \
 [file normalize "${origin_dir}/../../rtl/pulpino_top.sv"] \
 [file normalize "${origin_dir}/../../rtl/ram_mux.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/register_file_test_wrap.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_L0_buffer.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/include/riscv_defines.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_alu.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_alu_div.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/include/apu_macros.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_apu_disp.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_compressed_decoder.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_controller.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/include/riscv_config.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_core.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_cs_registers.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_decoder.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_ex_stage.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_fetch_fifo.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_hwloop_controller.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_hwloop_regs.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_id_stage.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_if_stage.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_int_controller.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_load_store_unit.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_mult.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_prefetch_L0_buffer.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_prefetch_buffer.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_register_file.sv"] \
 [file normalize "${origin_dir}/../../rtl/components/rstgen.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_event_unit/sleep_unit.sv"] \
 [file normalize "${origin_dir}/../../rtl/sp_ram_wrap.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_spi_master/spi_master_apb_if.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_spi_master/spi_master_clkgen.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_spi_master/spi_master_controller.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_spi_master/spi_master_fifo.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_spi_master/spi_master_rx.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_spi_master/spi_master_tx.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_spi_slave/spi_slave_axi_plug.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_spi_slave/spi_slave_cmd_parser.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_spi_slave/spi_slave_controller.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_spi_slave/spi_slave_dc_fifo.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_spi_slave/spi_slave_regs.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_spi_slave/spi_slave_rx.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_spi_slave/spi_slave_syncro.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_spi_slave/spi_slave_tx.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_timer/timer.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_uart_sv/uart_interrupt.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_uart_sv/uart_rx.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_uart_sv/uart_tx.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_uart/apb_uart.vhd"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_uart/slib_clock_div.vhd"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_uart/slib_counter.vhd"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_uart/slib_edge_detect.vhd"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_uart/slib_fifo.vhd"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_uart/slib_input_filter.vhd"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_uart/slib_input_sync.vhd"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_uart/slib_mv_filter.vhd"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_uart/uart_baudgen.vhd"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_uart/uart_interrupt.vhd"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_uart/uart_receiver.vhd"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_uart/uart_transmitter.vhd"] \
 [file normalize "${origin_dir}/../rtl/pulpino_wrap.v"] \
 [file normalize "${origin_dir}/../../rtl/components/sp_ram.sv"] \
 [file normalize "${origin_dir}/../../rtl/components/pulp_clock_gating.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/axi_node_wrap_with_slices.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/axi_regs_top.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/axi_node_wrap.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_node/apb_regs_top.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_mem_if_DP/axi_mem_if_DP.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_mem_if_DP/axi_mem_if_MP_Hybrid_multi_bank.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_mem_if_DP/axi_mem_if_multi_bank.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_mem_if_DP/axi_mem_if_DP_hybr.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_spi_master/axi_spi_master.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_spi_master/spi_master_axi_if.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_uart_sv/apb_uart.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_spi_master/spi_master_clkgen.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_spi_master/spi_master_fifo.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_spi_master/spi_master_tx.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_spi_master/spi_master_rx.sv"] \
 [file normalize "${origin_dir}/../../ips/apb/apb_spi_master/spi_master_controller.sv"] \
 [file normalize "${origin_dir}/../../ips/riscv/rtl/riscv_alu_basic.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_slice/axi_buffer.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_slice_dc/axi_slice_dc_slave.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi_slice_dc/axi_slice_dc_master.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi2apb/AXI_2_APB.sv"] \
 [file normalize "${origin_dir}/../../ips/axi/axi2apb/AXI_2_APB_32.sv"] \
]
add_files -norecurse -fileset $obj $files





set files [list \
 [file normalize "${origin_dir}/../rtl/Base_Zynq_MPSoC_wrapper.v" ]\
]

set imported_files [import_files -fileset sources_1 $files]


# Set 'sources_1' fileset file properties for remote files
set file "$origin_dir/../../rtl/includes/config.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../rtl/includes/apb_bus.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../rtl/includes/axi_bus.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../rtl/includes/debug_bus.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../rtl/includes/pulp_interfaces.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb2per/apb2per.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_event_unit/include/defines_event_unit.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_event_unit/apb_event_unit.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_fll_if/apb_fll_if.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_gpio/apb_gpio.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_i2c/i2c_master_defines.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_i2c/apb_i2c.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_node/apb_node.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_node/apb_node_wrap.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_pulpino/apb_pulpino.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_spi_master/apb_spi_master.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_timer/apb_timer.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_uart_sv/apb_uart_sv.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/include/apu_core_package.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi2apb/axi2apb.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi2apb/axi2apb32.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/axi2apb_wrap.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/axi_AR_allocator.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/axi_AW_allocator.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/axi_ArbitrationTree.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/defines.v"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/axi_BR_allocator.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/axi_BW_allocator.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/axi_DW_allocator.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/axi_FanInPrimitive_Req.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/axi_RR_Flag_Req.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/axi_address_decoder_AR.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/axi_address_decoder_AW.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/axi_address_decoder_BR.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/axi_address_decoder_BW.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/axi_address_decoder_DW.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_slice/axi_ar_buffer.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_slice/axi_aw_buffer.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_slice/axi_b_buffer.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_mem_if_DP/axi_mem_if_SP.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/axi_mem_if_SP_wrap.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/axi_multiplexer.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/axi_node.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/axi_node_intf_wrap.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_slice/axi_r_buffer.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_mem_if_DP/axi_read_only_ctrl.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/axi_request_block.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/axi_response_block.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_slice/axi_slice.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/axi_slice_wrap.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_spi_slave/axi_spi_slave.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/axi_spi_slave_wrap.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_slice/axi_w_buffer.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_mem_if_DP/axi_write_only_ctrl.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/boot_code.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/boot_rom_wrap.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv-dbg/src/cdc_2phase.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/clk_rst_gen.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/components/cluster_clock_gating.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/components/cluster_clock_inverter.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/components/cluster_clock_mux2.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/core2axi/core2axi.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/core2axi_wrap.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv-dbg/src/dm_pkg.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/includes/pulp_soc_defines.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../rtl/core_region.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv-dbg/debug_rom/debug_rom.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv-dbg/src/dm_csrs.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv-dbg/src/dm_mem.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv-dbg/src/dm_sba.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv-dbg/src/dm_top.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv-dbg/src/dmi_cdc.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv-dbg/src/dmi_jtag.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv-dbg/src/dmi_jtag_tap.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv-dbg/src/fifo_v2.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv-dbg/src/fifo_v3.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/fpnew/src/fpnew_pkg.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/fpnew/src/fpnew_cast_multi.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/fpnew/src/fpnew_classifier.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/fpnew/src/registers.svh"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../ips/fpnew/src/fpnew_divsqrt_multi.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/fpnew/src/fpnew_fma.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/fpnew/src/fpnew_fma_multi.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/fpnew/src/fpnew_noncomp.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/fpnew/src/fpnew_opgroup_block.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/fpnew/src/fpnew_opgroup_fmt_slice.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/fpnew/src/fpnew_opgroup_multifmt_slice.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/fpnew/src/fpnew_pipe_in.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/fpnew/src/fpnew_pipe_inside_cast.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/fpnew/src/fpnew_pipe_inside_fma.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/fpnew/src/fpnew_pipe_out.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/fpnew/src/fpnew_rounding.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/fpnew/src/fpnew_top.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/components/generic_fifo.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_event_unit/generic_service_unit.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_i2c/i2c_master_bit_ctrl.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_i2c/i2c_master_byte_ctrl.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/instr_ram_wrap.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_uart_sv/io_generic_fifo.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/L2_tcdm_hybrid_interco/RTL/lint_2_axi.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/periph_bus_wrap.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/peripherals.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/components/pulp_clock_inverter.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/components/pulp_clock_mux2.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/pulpino_top.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/ram_mux.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/register_file_test_wrap.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_L0_buffer.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/include/riscv_defines.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_alu.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_alu_div.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/include/apu_macros.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_apu_disp.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_compressed_decoder.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_controller.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/include/riscv_config.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Verilog Header" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_core.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_cs_registers.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_decoder.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_ex_stage.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_fetch_fifo.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_hwloop_controller.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_hwloop_regs.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_id_stage.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_if_stage.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_int_controller.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_load_store_unit.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_mult.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_prefetch_L0_buffer.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_prefetch_buffer.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_register_file.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/components/rstgen.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_event_unit/sleep_unit.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/sp_ram_wrap.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_spi_master/spi_master_apb_if.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_spi_master/spi_master_clkgen.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_spi_master/spi_master_controller.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_spi_master/spi_master_fifo.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_spi_master/spi_master_rx.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_spi_master/spi_master_tx.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_spi_slave/spi_slave_axi_plug.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_spi_slave/spi_slave_cmd_parser.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_spi_slave/spi_slave_controller.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_spi_slave/spi_slave_dc_fifo.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_spi_slave/spi_slave_regs.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_spi_slave/spi_slave_rx.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_spi_slave/spi_slave_syncro.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_spi_slave/spi_slave_tx.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_timer/timer.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_uart_sv/uart_interrupt.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_uart_sv/uart_rx.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_uart_sv/uart_tx.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_uart/apb_uart.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_uart/slib_clock_div.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_uart/slib_counter.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_uart/slib_edge_detect.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_uart/slib_fifo.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_uart/slib_input_filter.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_uart/slib_input_sync.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_uart/slib_mv_filter.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_uart/uart_baudgen.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_uart/uart_interrupt.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_uart/uart_receiver.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_uart/uart_transmitter.vhd"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "VHDL" -objects $file_obj

set file "$origin_dir/../../rtl/components/sp_ram.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../rtl/components/pulp_clock_gating.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/axi_node_wrap_with_slices.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/axi_regs_top.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/axi_node_wrap.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_node/apb_regs_top.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_mem_if_DP/axi_mem_if_DP.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_mem_if_DP/axi_mem_if_MP_Hybrid_multi_bank.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_mem_if_DP/axi_mem_if_multi_bank.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_mem_if_DP/axi_mem_if_DP_hybr.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_spi_master/axi_spi_master.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_spi_master/spi_master_axi_if.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_uart_sv/apb_uart.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_spi_master/spi_master_clkgen.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_spi_master/spi_master_fifo.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_spi_master/spi_master_tx.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_spi_master/spi_master_rx.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/apb/apb_spi_master/spi_master_controller.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/riscv/rtl/riscv_alu_basic.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_slice/axi_buffer.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_slice_dc/axi_slice_dc_slave.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi_slice_dc/axi_slice_dc_master.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi2apb/AXI_2_APB.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj

set file "$origin_dir/../../ips/axi/axi2apb/AXI_2_APB_32.sv"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "SystemVerilog" -objects $file_obj


# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "generic" -value "PULP_FPGA_EMUL=1" -objects $obj
set_property -name "include_dirs" -value "[file normalize "$origin_dir/../../rtl/includes"] [file normalize "$origin_dir/../../ips/axi/axi_node"] [file normalize "$origin_dir/../../ips/apb/apb_event_unit/include"] [file normalize "$origin_dir/../../ips/apb/apb_i2c"] [file normalize "$origin_dir/../../ips/riscv/rtl/include"] [file normalize "$origin_dir/../../ips/riscv-dbg/src"] [file normalize "$origin_dir/../../ips/fpnew/src/common_cells"]" -objects $obj
set_property -name "top" -value "Base_Zynq_MPSoC_wrapper" -objects $obj
set_property -name "top_auto_set" -value "0" -objects $obj
set_property -name "verilog_define" -value "PULP_FPGA_EMU=1 RISCV" -objects $obj
set_property -name "vhdl_generic" -value "PULP_FPGA_EMUL=1" -objects $obj

# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties

set file "[file normalize "${origin_dir}/../constraints/constr_pulpino_zcu102.xdc"]"
set file_imported [import_files -fileset constrs_1 [list $file]]

set file "constraints/constr_pulpino_zcu102.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]


# Proc to create BD Base_Zynq_MPSoC
proc cr_bd_Base_Zynq_MPSoC { parentCell } {
# The design that will be created by this Tcl proc contains the following 
# module references:
# pulpino



  # CHANGE DESIGN NAME HERE
  set design_name Base_Zynq_MPSoC

  common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

  create_bd_design $design_name

  set bCheckIPsPassed 1
  ##################################################################
  # CHECK IPs
  ##################################################################
  set bCheckIPs 1
  if { $bCheckIPs == 1 } {
     set list_check_ips "\ 
  xilinx.com:ip:clk_wiz:6.0\
  xilinx.com:ip:proc_sys_reset:5.0\
  xilinx.com:ip:xlconcat:2.1\
  xilinx.com:ip:xlconstant:1.1\
  xilinx.com:ip:xlslice:1.0\
  "

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

  }

  ##################################################################
  # CHECK Modules
  ##################################################################
  set bCheckModules 1
  if { $bCheckModules == 1 } {
     set list_check_mods "\ 
  pulpino\
  "

   set list_mods_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_msg_id "BD_TCL-008" "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

  if { $bCheckIPsPassed != 1 } {
    common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
    return 3
  }

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set user_si570_sysclk [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 user_si570_sysclk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {300000000} \
   ] $user_si570_sysclk

  # Create ports
  set LD_o [ create_bd_port -dir O -from 7 -to 0 LD_o ]
  set reset [ create_bd_port -dir I -type rst reset ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset
  set tck_i [ create_bd_port -dir I tck_i ]
  set tdi_i [ create_bd_port -dir I tdi_i ]
  set tdo_o [ create_bd_port -dir O tdo_o ]
  set tms_i [ create_bd_port -dir I tms_i ]
  set trstn_i [ create_bd_port -dir I trstn_i ]
  set uart_pl_rx [ create_bd_port -dir I uart_pl_rx ]
  set uart_pl_tx [ create_bd_port -dir O uart_pl_tx ]
  set uart_tx [ create_bd_port -dir O uart_tx ]

  # Create instance: clk_wiz, and set properties
  set clk_wiz [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz ]
  set_property -dict [ list \
   CONFIG.CLKIN1_JITTER_PS {33.330000000000005} \
   CONFIG.CLKOUT1_JITTER {101.475} \
   CONFIG.CLKOUT1_PHASE_ERROR {77.836} \
   CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100.000} \
   CONFIG.CLK_IN1_BOARD_INTERFACE {user_si570_sysclk} \
   CONFIG.MMCM_CLKFBOUT_MULT_F {4.000} \
   CONFIG.MMCM_CLKIN1_PERIOD {3.333} \
   CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
   CONFIG.MMCM_CLKOUT0_DIVIDE_F {12.000} \
   CONFIG.MMCM_DIVCLK_DIVIDE {1} \
   CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $clk_wiz

  # Create instance: pulpino_0, and set properties
  set block_name pulpino
  set block_cell_name pulpino_0
  if { [catch {set pulpino_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $pulpino_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: rst_clk_wiz_1_100M, and set properties
  set rst_clk_wiz_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M ]
  set_property -dict [ list \
   CONFIG.RESET_BOARD_INTERFACE {reset} \
   CONFIG.USE_BOARD_FLOW {true} \
 ] $rst_clk_wiz_1_100M

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.IN0_WIDTH {7} \
 ] $xlconcat_0

  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
 ] $xlconstant_1

  # Create instance: xlconstant_2, and set properties
  set xlconstant_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_2 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {1} \
 ] $xlconstant_2

  # Create instance: xlconstant_3, and set properties
  set xlconstant_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_3 ]
  set_property -dict [ list \
   CONFIG.CONST_VAL {0} \
   CONFIG.CONST_WIDTH {32} \
 ] $xlconstant_3

  # Create instance: xlslice_1, and set properties
  set xlslice_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 xlslice_1 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {14} \
   CONFIG.DIN_TO {8} \
   CONFIG.DOUT_WIDTH {7} \
 ] $xlslice_1

  # Create interface connections
  connect_bd_intf_net -intf_net user_si570_sysclk_1 [get_bd_intf_ports user_si570_sysclk] [get_bd_intf_pins clk_wiz/CLK_IN1_D]

  # Create port connections
  connect_bd_net -net clk_wiz_locked [get_bd_pins clk_wiz/locked] [get_bd_pins rst_clk_wiz_1_100M/dcm_locked]
  connect_bd_net -net pulpino_0_gpio_out [get_bd_pins pulpino_0/gpio_out] [get_bd_pins xlslice_1/Din]
  connect_bd_net -net pulpino_0_tdo_o [get_bd_ports tdo_o] [get_bd_pins pulpino_0/tdo_o]
  connect_bd_net -net pulpino_0_uart_tx [get_bd_ports uart_pl_tx] [get_bd_ports uart_tx] [get_bd_pins pulpino_0/uart_tx]
  connect_bd_net -net reset_1 [get_bd_ports reset] [get_bd_pins clk_wiz/reset] [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in]
  connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins pulpino_0/rst_n] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn]
  connect_bd_net -net tck_i_1 [get_bd_ports tck_i] [get_bd_pins pulpino_0/tck_i]
  connect_bd_net -net tdi_i_1 [get_bd_ports tdi_i] [get_bd_pins pulpino_0/tdi_i]
  connect_bd_net -net tms_i_1 [get_bd_ports tms_i] [get_bd_pins pulpino_0/tms_i]
  connect_bd_net -net trstn_i_1 [get_bd_ports trstn_i] [get_bd_pins pulpino_0/trstn_i]
  connect_bd_net -net uart_pl_rx_1 [get_bd_ports uart_pl_rx] [get_bd_pins pulpino_0/uart_rx]
  connect_bd_net -net xlconcat_0_dout [get_bd_ports LD_o] [get_bd_pins xlconcat_0/dout]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins pulpino_0/scl_i] [get_bd_pins pulpino_0/sda_i] [get_bd_pins pulpino_0/spi_clk_i] [get_bd_pins pulpino_0/spi_cs_i] [get_bd_pins pulpino_0/spi_master_sdi0_i] [get_bd_pins pulpino_0/spi_master_sdi1_i] [get_bd_pins pulpino_0/spi_master_sdi2_i] [get_bd_pins pulpino_0/spi_master_sdi3_i] [get_bd_pins pulpino_0/spi_sdi0_i] [get_bd_pins pulpino_0/spi_sdi1_i] [get_bd_pins pulpino_0/spi_sdi2_i] [get_bd_pins pulpino_0/spi_sdi3_i] [get_bd_pins pulpino_0/uart_cts] [get_bd_pins pulpino_0/uart_dsr] [get_bd_pins xlconstant_1/dout]
  connect_bd_net -net xlconstant_2_dout [get_bd_pins pulpino_0/fetch_enable_i] [get_bd_pins xlconcat_0/In1] [get_bd_pins xlconstant_2/dout]
  connect_bd_net -net xlconstant_3_dout [get_bd_pins pulpino_0/gpio_in] [get_bd_pins xlconstant_3/dout]
  connect_bd_net -net xlslice_1_Dout [get_bd_pins xlconcat_0/In0] [get_bd_pins xlslice_1/Dout]
  connect_bd_net -net zynq_ultra_ps_e_0_pl_clk0 [get_bd_pins clk_wiz/clk_out1] [get_bd_pins pulpino_0/clk] [get_bd_pins rst_clk_wiz_1_100M/slowest_sync_clk]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
  close_bd_design $design_name 
}
# End of cr_bd_Base_Zynq_MPSoC()
cr_bd_Base_Zynq_MPSoC ""
set_property IS_MANAGED "0" [get_files Base_Zynq_MPSoC.bd ] 
set_property REGISTERED_WITH_MANAGER "1" [get_files Base_Zynq_MPSoC.bd ] 
set_property SYNTH_CHECKPOINT_MODE "Hierarchical" [get_files Base_Zynq_MPSoC.bd ] 

# Create 'synth_1' run (if not found)
if {[string equal [get_runs -quiet synth_1] ""]} {
    create_run -name synth_1 -part xczu9eg-ffvb1156-2-e -flow {Vivado Synthesis 2018} -strategy "Flow_PerfOptimized_high" -report_strategy {No Reports} -constrset constrs_1
} else {
  set_property strategy "Flow_PerfOptimized_high" [get_runs synth_1]
  set_property flow "Vivado Synthesis 2018" [get_runs synth_1]
}
set obj [get_runs synth_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Synthesis Default Reports} $obj
set_property set_report_strategy_name 0 $obj
# Create 'synth_1_synth_report_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs synth_1] synth_1_synth_report_utilization_0] "" ] } {
  create_report_config -report_name synth_1_synth_report_utilization_0 -report_type report_utilization:1.0 -steps synth_design -runs synth_1
}
set obj [get_report_configs -of_objects [get_runs synth_1] synth_1_synth_report_utilization_0]
if { $obj != "" } {

}
set obj [get_runs synth_1]
set_property -name "strategy" -value "Flow_PerfOptimized_high" -objects $obj
set_property -name "steps.synth_design.args.fanout_limit" -value "400" -objects $obj
set_property -name "steps.synth_design.args.fsm_extraction" -value "one_hot" -objects $obj
set_property -name "steps.synth_design.args.keep_equivalent_registers" -value "1" -objects $obj
set_property -name "steps.synth_design.args.resource_sharing" -value "off" -objects $obj
set_property -name "steps.synth_design.args.no_lc" -value "1" -objects $obj
set_property -name "steps.synth_design.args.shreg_min_size" -value "5" -objects $obj

# set the current synth run
current_run -synthesis [get_runs synth_1]

# Create 'impl_1' run (if not found)
if {[string equal [get_runs -quiet impl_1] ""]} {
    create_run -name impl_1 -part xczu9eg-ffvb1156-2-e -flow {Vivado Implementation 2018} -strategy "Vivado Implementation Defaults" -report_strategy {No Reports} -constrset constrs_1 -parent_run synth_1
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
  set_property flow "Vivado Implementation 2018" [get_runs impl_1]
}
set obj [get_runs impl_1]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Performance Explore Reports} $obj
set_property set_report_strategy_name 0 $obj
# Create 'impl_1_opt_report_drc_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_drc_0] "" ] } {
  create_report_config -report_name impl_1_opt_report_drc_0 -report_type report_drc:1.0 -steps opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_drc_0]
if { $obj != "" } {

}
# Create 'impl_1_opt_report_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_utilization_0] "" ] } {
  create_report_config -report_name impl_1_opt_report_utilization_0 -report_type report_utilization:1.0 -steps opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_utilization_0]
if { $obj != "" } {

}
# Create 'impl_1_opt_report_methodology_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_methodology_0] "" ] } {
  create_report_config -report_name impl_1_opt_report_methodology_0 -report_type report_methodology:1.0 -steps opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_methodology_0]
if { $obj != "" } {

}
# Create 'impl_1_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_opt_report_timing_summary_0]
if { $obj != "" } {

}
# Create 'impl_1_place_report_io_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_io_0] "" ] } {
  create_report_config -report_name impl_1_place_report_io_0 -report_type report_io:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_io_0]
if { $obj != "" } {

}
# Create 'impl_1_place_report_incremental_reuse_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_0] "" ] } {
  create_report_config -report_name impl_1_place_report_incremental_reuse_0 -report_type report_incremental_reuse:1.0 -steps place_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_place_report_incremental_reuse_0]
if { $obj != "" } {

}
# Create 'impl_1_phys_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_phys_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_phys_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps phys_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_phys_opt_report_timing_summary_0]
if { $obj != "" } {

}
# Create 'impl_1_phys_opt_report_design_analysis_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_phys_opt_report_design_analysis_0] "" ] } {
  create_report_config -report_name impl_1_phys_opt_report_design_analysis_0 -report_type report_design_analysis:1.0 -steps phys_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_phys_opt_report_design_analysis_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_utilization_0] "" ] } {
  create_report_config -report_name impl_1_route_report_utilization_0 -report_type report_utilization:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_utilization_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_drc_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_drc_0] "" ] } {
  create_report_config -report_name impl_1_route_report_drc_0 -report_type report_drc:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_drc_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_power_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_power_0] "" ] } {
  create_report_config -report_name impl_1_route_report_power_0 -report_type report_power:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_power_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_route_status_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_route_status_0] "" ] } {
  create_report_config -report_name impl_1_route_report_route_status_0 -report_type report_route_status:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_route_status_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_route_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_timing_summary_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_incremental_reuse_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_incremental_reuse_0] "" ] } {
  create_report_config -report_name impl_1_route_report_incremental_reuse_0 -report_type report_incremental_reuse:1.0 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_incremental_reuse_0]
if { $obj != "" } {

}
# Create 'impl_1_route_report_bus_skew_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_bus_skew_0] "" ] } {
  create_report_config -report_name impl_1_route_report_bus_skew_0 -report_type report_bus_skew:1.1 -steps route_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_route_report_bus_skew_0]
if { $obj != "" } {

}
# Create 'impl_1_post_route_phys_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_1_post_route_phys_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps post_route_phys_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_timing_summary_0]
if { $obj != "" } {

}
# Create 'impl_1_post_route_phys_opt_report_bus_skew_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_bus_skew_0] "" ] } {
  create_report_config -report_name impl_1_post_route_phys_opt_report_bus_skew_0 -report_type report_bus_skew:1.1 -steps post_route_phys_opt_design -runs impl_1
}
set obj [get_report_configs -of_objects [get_runs impl_1] impl_1_post_route_phys_opt_report_bus_skew_0]
if { $obj != "" } {

}
set obj [get_runs impl_1]
set_property -name "strategy" -value "Vivado Implementation Defaults" -objects $obj
set_property -name "steps.write_bitstream.args.readback_file" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.verbose" -value "0" -objects $obj

# set the current impl run
current_run -implementation [get_runs impl_1]

puts "INFO: Project created:${_xil_proj_name_}"

# launch synthesis
set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY none [get_runs synth_1]
set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value -sfcu -objects [get_runs synth_1] ;# Use single file compilation unit mode to prevent issues with import pkg::* statements in the codebase
launch_runs synth_1 -jobs 8
wait_on_run synth_1
open_run synth_1 -name netlist_1
set_property needs_refresh false [get_runs synth_1]

# Remove unused IOBUF cells in padframe (they are not optimized away since the
# pad driver also drives the input creating a datapath from pad_xy_o to pad_xy_i
# )
remove_cell i_pulpissimo/pad_frame_i/padinst_bootsel


# Launch Implementation

# set for RuntimeOptimized implementation
set_property "steps.opt_design.args.directive" "RuntimeOptimized" [get_runs impl_1]
set_property "steps.place_design.args.directive" "RuntimeOptimized" [get_runs impl_1]
set_property "steps.route_design.args.directive" "RuntimeOptimized" [get_runs impl_1]
set_property "steps.phys_opt_design.args.is_enabled" true [get_runs impl_1]
set_property "steps.phys_opt_design.args.directive" "ExploreWithHoldFix" [get_runs impl_1]
set_property "steps.post_route_phys_opt_design.args.is_enabled" true [get_runs impl_1]
set_property "steps.post_route_phys_opt_design.args.directive" "ExploreWithAggressiveHoldFix" [get_runs impl_1]

set_property STEPS.WRITE_BITSTREAM.ARGS.BIN_FILE true [get_runs impl_1]

launch_runs impl_1 -jobs 8
wait_on_run impl_1
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

open_run impl_1

# Generate reports
exec mkdir -p reports/
exec rm -rf reports/*
check_timing                                                              -file reports/${_xil_proj_name_}.check_timing.rpt
report_timing -max_paths 100 -nworst 100 -delay_type max -sort_by slack   -file reports/${_xil_proj_name_}.timing_WORST_100.rpt
report_timing -nworst 1 -delay_type max -sort_by group                    -file reports/${_xil_proj_name_}.timing.rpt
report_utilization -hierarchical                                          -file reports/${_xil_proj_name_}.utilization.rpt
