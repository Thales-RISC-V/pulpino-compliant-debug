#######################################
#  _______ _           _              #
# |__   __(_)         (_)             #
#    | |   _ _ __ ___  _ _ __   __ _  #
#    | |  | | '_ ` _ \| | '_ \ / _` | #
#    | |  | | | | | | | | | | | (_| | #
#    |_|  |_|_| |_| |_|_|_| |_|\__, | #
#                               __/ | #
#                              |___/  #
#######################################
## JTAG
create_clock -period 100.000 -name tck -waveform {0.000 50.000} [get_ports tck_i]
set_input_jitter tck 1.000
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets tck_i_IBUF_inst/O]


# minimize routing delay
set_input_delay -clock tck -clock_fall 5.000 [get_ports tdi_i]
set_input_delay -clock tck -clock_fall 5.000 [get_ports tms_i]
set_output_delay -clock tck 5.000 [get_ports tdo_o]

set_max_delay -to [get_ports tdo_o] 20.000
set_max_delay -from [get_ports tms_i] 20.000
set_max_delay -from [get_ports tdi_i] 20.000

set_max_delay -datapath_only -from [get_pins Base_Zynq_MPSoC_i/pulpino_0/inst/pulpino_i/core_region_i/i_dmi_jtag/i_dmi_cdc/i_cdc_resp/i_src/data_src_q_reg*/C] -to [get_pins Base_Zynq_MPSoC_i/pulpino_0/inst/pulpino_i/core_region_i/i_dmi_jtag/i_dmi_cdc/i_cdc_resp/i_dst/data_dst_q_reg*/D] 20.000
set_max_delay -datapath_only -from [get_pins Base_Zynq_MPSoC_i/pulpino_0/inst/pulpino_i/core_region_i/i_dmi_jtag/i_dmi_cdc/i_cdc_resp/i_src/req_src_q_reg/C] -to [get_pins Base_Zynq_MPSoC_i/pulpino_0/inst/pulpino_i/core_region_i/i_dmi_jtag/i_dmi_cdc/i_cdc_resp/i_dst/req_dst_q_reg/D] 20.000
set_max_delay -datapath_only -from [get_pins Base_Zynq_MPSoC_i/pulpino_0/inst/pulpino_i/core_region_i/i_dmi_jtag/i_dmi_cdc/i_cdc_req/i_dst/ack_dst_q_reg/C] -to [get_pins Base_Zynq_MPSoC_i/pulpino_0/inst/pulpino_i/core_region_i/i_dmi_jtag/i_dmi_cdc/i_cdc_req/i_src/ack_src_q_reg/D] 20.000

#set_clock_groups -asynchronous -group [get_clocks -of_objects [get_pins clk_out1_Base_Zynq_MPSoC_clk_wiz_1]] -group [get_clocks -of_objects [get_pins tck]]

#############################################################
#  _____ ____         _____      _   _   _                  #
# |_   _/ __ \       / ____|    | | | | (_)                 #
#   | || |  | |_____| (___   ___| |_| |_ _ _ __   __ _ ___  #
#   | || |  | |______\___ \ / _ \ __| __| | '_ \ / _` / __| #
#  _| || |__| |      ____) |  __/ |_| |_| | | | | (_| \__ \ #
# |_____\____/      |_____/ \___|\__|\__|_|_| |_|\__, |___/ #
#                                                 __/ |     #
#                                                |___/      #
#############################################################





#uart_pl
set_property PACKAGE_PIN F13 [get_ports uart_pl_tx]
set_property PACKAGE_PIN E13 [get_ports uart_pl_rx]

#set_property IOSTANDARD LVCMOS33 [get_ports uart_pl_tx]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_i[1]}]

## SW INPUT
#set_property PACKAGE_PIN AN14 [get_ports {sw_i[0]}]
#set_property PACKAGE_PIN AP14 [get_ports {sw_i[1]}]
#set_property PACKAGE_PIN AM14 [get_ports {sw_i[2]}]
#set_property PACKAGE_PIN AN13 [get_ports {sw_i[3]}]
#set_property PACKAGE_PIN AN12 [get_ports {sw_i[4]}]
#set_property PACKAGE_PIN AP12 [get_ports {sw_i[5]}]
#set_property PACKAGE_PIN AL13 [get_ports {sw_i[6]}]
#set_property PACKAGE_PIN AK13 [get_ports {sw_i[7]}]

#set_property IOSTANDARD LVCMOS33 [get_ports {sw_i[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_i[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_i[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_i[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_i[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_i[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_i[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_i[7]}]

## BTN INPUT
#set_property PACKAGE_PIN AG15 [get_ports {btn_i[0]}]
#set_property PACKAGE_PIN AE14 [get_ports {btn_i[1]}]
#set_property PACKAGE_PIN AF15 [get_ports {btn_i[2]}]
#set_property PACKAGE_PIN AE15 [get_ports {btn_i[3]}]
#set_property PACKAGE_PIN AG13 [get_ports {btn_i[4]}]

#set_property IOSTANDARD LVCMOS33 [get_ports {btn_i[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {btn_i[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {btn_i[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {btn_i[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {btn_i[4]}]

## LED OUTPUT
set_property PACKAGE_PIN AG14 [get_ports {LD_o[0]}]
set_property PACKAGE_PIN AF13 [get_ports {LD_o[1]}]
set_property PACKAGE_PIN AE13 [get_ports {LD_o[2]}]
set_property PACKAGE_PIN AJ14 [get_ports {LD_o[3]}]
set_property PACKAGE_PIN AJ15 [get_ports {LD_o[4]}]
set_property PACKAGE_PIN AH13 [get_ports {LD_o[5]}]
set_property PACKAGE_PIN AH14 [get_ports {LD_o[6]}]
set_property PACKAGE_PIN AL12 [get_ports {LD_o[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {LD_o[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LD_o[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LD_o[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LD_o[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LD_o[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LD_o[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LD_o[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LD_o[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports uart_pl_tx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_pl_rx]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets tck_i_IBUF_BUFGCE]
set_property PACKAGE_PIN D20 [get_ports tms_i]
set_property IOSTANDARD LVCMOS33 [get_ports tms_i]
set_property PACKAGE_PIN E20 [get_ports tdi_i]
set_property IOSTANDARD LVCMOS33 [get_ports tdi_i]
set_property PACKAGE_PIN D22 [get_ports tdo_o]
set_property IOSTANDARD LVCMOS33 [get_ports tdo_o]
set_property PACKAGE_PIN E22 [get_ports tck_i]
set_property IOSTANDARD LVCMOS33 [get_ports tck_i]
set_property PACKAGE_PIN F20 [get_ports trstn_i]
set_property IOSTANDARD LVCMOS33 [get_ports trstn_i]

set_property PACKAGE_PIN A20 [get_ports uart_tx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]
