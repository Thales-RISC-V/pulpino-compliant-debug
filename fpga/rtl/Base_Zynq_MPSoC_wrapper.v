//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.2.1 (lin64) Build 2288692 Thu Jul 26 18:23:50 MDT 2018
//Date        : Mon Nov 25 17:40:37 2019
//Host        : D354044 running 64-bit Ubuntu 16.04.3 LTS
//Command     : generate_target Base_Zynq_MPSoC_wrapper.bd
//Design      : Base_Zynq_MPSoC_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module Base_Zynq_MPSoC_wrapper
   (LD_o,
    reset,
    tck_i,
    tdi_i,
    tdo_o,
    tms_i,
    trstn_i,
    uart_pl_rx,
    uart_pl_tx,
    uart_tx,
    user_si570_sysclk_clk_n,
    user_si570_sysclk_clk_p);
  output [7:0]LD_o;
  input reset;
  input tck_i;
  input tdi_i;
  output tdo_o;
  input tms_i;
  input trstn_i;
  input uart_pl_rx;
  output uart_pl_tx;
  output uart_tx;
  input user_si570_sysclk_clk_n;
  input user_si570_sysclk_clk_p;

  wire [7:0]LD_o;
  wire reset;
  wire tck_i;
  wire tdi_i;
  wire tdo_o;
  wire tms_i;
  wire trstn_i;
  wire uart_pl_rx;
  wire uart_pl_tx;
  wire uart_tx;
  wire user_si570_sysclk_clk_n;
  wire user_si570_sysclk_clk_p;

  Base_Zynq_MPSoC Base_Zynq_MPSoC_i
       (.LD_o(LD_o),
        .reset(reset),
        .tck_i(tck_i),
        .tdi_i(tdi_i),
        .tdo_o(tdo_o),
        .tms_i(tms_i),
        .trstn_i(1'b1),
        .uart_pl_rx(uart_pl_rx),
        .uart_pl_tx(uart_pl_tx),
        .uart_tx(uart_tx),
        .user_si570_sysclk_clk_n(user_si570_sysclk_clk_n),
        .user_si570_sysclk_clk_p(user_si570_sysclk_clk_p));
endmodule
