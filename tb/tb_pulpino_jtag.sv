`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2019 11:18:19 AM
// Design Name: 
// Module Name: tb_pulpino_jtag
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//`include "jtag_pkg.sv"
//`include "pulp_tap_pkg.sv"

import jtag_pkg::*;
import pulp_tap_pkg::*;


`define EXIT_SUCCESS  0
`define EXIT_FAIL     1
`define EXIT_ERROR   -1

module tb_pulpino_jtag;

    
    
logic         clk;
logic        s_rst_n;

logic         fetch_enable_i;

// enable Debug Module Tests
parameter ENABLE_DM_TESTS = 0;

parameter  LOAD_L2 = "JTAG";
// use frequency-locked loop to generate internal clock
parameter  USE_FLL = 1;



parameter  REF_CLK_PERIOD = 10ns;

// contains the program code
string stimuli_file;

/* simulation variables & flags */


int                   num_stim;
logic [63:0]          stimuli  [100000:0];                // array for the stimulus vectors

logic [1:0]           jtag_mux = 2'b00;

logic                 dev_dpi_en = 0;

logic [255:0][31:0]   jtag_data;



//jtag_pkg::test_mode_if_t   test_mode_if = new;
jtag_pkg::debug_mode_if_t  debug_mode_if = new;
//pulp_tap_pkg::pulp_tap_if_soc_t pulp_tap = new;

logic [8:0] jtag_conf_reg, jtag_conf_rego; //22bits but actually only the last 9bits are used
localparam BEGIN_L2_INSTR = 32'h80;

int                   exit_status = `EXIT_ERROR;

  // JTAG signals
  logic  tck_i;
  logic  trstn_i;
  logic  tms_i;
  logic  tdi_i;
  logic tdo_o;
  
  
    logic                 s_trstn = 1'b0;
    logic                 s_tck   = 1'b0;
    logic                 s_tdi   = 1'b0;
    logic                 s_tms   = 1'b0;
    logic                 s_tdo;

  parameter USE_ZERO_RISCY = 0;
  parameter RISCY_RV32F = 0;
  parameter ZERO_RV32M = 0;
  parameter ZERO_RV32E = 0;
   

 
    logic [31:0]   gpr;
  
  // PULP SoC
  pulpino_top
  #(
    .USE_ZERO_RISCY    ( USE_ZERO_RISCY ),
    .RISCY_RV32F       ( RISCY_RV32F    ),
    .ZERO_RV32M        ( ZERO_RV32M     ),
    .ZERO_RV32E        ( ZERO_RV32E     )
  )
  pulpino_i
  (
    .clk               ( clk               ),
    .rst_n             ( s_rst_n             ),

    .clk_sel_i         ( 1'b0              ),
    .clk_standalone_i  ( 1'b0              ),

    .testmode_i        ( 1'b0              ),
    .fetch_enable_i    ( 1'b1    ),
    .scan_enable_i     ( 1'b0              ),

    .spi_clk_i         ( 1'b0         ),
    .spi_cs_i          ( 1'b0          ),
    .spi_mode_o        (         ),
    .spi_sdo0_o        (         ),
    .spi_sdo1_o        (         ),
    .spi_sdo2_o        (         ),
    .spi_sdo3_o        (         ),
    .spi_sdi0_i        ( 1'b0        ),
    .spi_sdi1_i        ( 1'b0        ),
    .spi_sdi2_i        ( 1'b0        ),
    .spi_sdi3_i        ( 1'b0        ),

    .spi_master_clk_o  (   ),
    .spi_master_csn0_o (  ),
    .spi_master_csn1_o (  ),
    .spi_master_csn2_o (  ),
    .spi_master_csn3_o (  ),
    .spi_master_mode_o (  ),
    .spi_master_sdo0_o (  ),
    .spi_master_sdo1_o (  ),
    .spi_master_sdo2_o (  ),
    .spi_master_sdo3_o (  ),
    .spi_master_sdi0_i ( 1'b0 ),
    .spi_master_sdi1_i ( 1'b0 ),
    .spi_master_sdi2_i ( 1'b0 ),
    .spi_master_sdi3_i ( 1'b0 ),

    .uart_tx           (           ), // output
    .uart_rx           ( 1'b0      ), // input
    .uart_rts          (           ), // output
    .uart_dtr          (           ), // output
    .uart_cts          ( 1'b0      ), // input
    .uart_dsr          ( 1'b0      ), // input

    .scl_pad_i         ( 1'b0      ),
    .scl_pad_o         (           ),
    .scl_padoen_o      (           ),
    .sda_pad_i         ( 1'b0      ),
    .sda_pad_o         (           ),
    .sda_padoen_o      (           ),

    .gpio_in           ( 32'b0     ),
    .gpio_out          (           ),
    .gpio_dir          (           ),
    .gpio_padcfg       (           ),

    .tck_i             ( tck_i             ),
    .trstn_i           ( trstn_i           ),
    .tms_i             ( tms_i             ),
    .tdi_i             ( tdi_i             ),
    .tdo_o             ( tdo_o             ),

    .pad_cfg_o         (                   ),
    .pad_mux_o         (                   )
  );
  
    assign tck_i = s_tck;
    assign trstn_i = s_trstn;
    assign tms_i = s_tms;
    assign tdi_i = s_tdi;
    
    assign s_tdo = tdo_o;
  
   tb_clk_gen #( .CLK_PERIOD(REF_CLK_PERIOD) ) i_ref_clk_gen (.clk_o(clk) );
   
// testbench driver process
initial
begin

    logic [1:0]  dm_op;
    logic [31:0] dm_data;
    logic [6:0]  dm_addr;
    logic        error;
    automatic logic [9:0]  FC_CORE_ID = {5'd0,5'd0};
    
    $display("[TB] %t - Asserting hard reset", $realtime);
    s_rst_n = 1'b0;
    
    #1ns
      
    // read in the stimuli vectors  == address_value

     if ($value$plusargs("stimuli=%s", stimuli_file)) begin
          $display("Loading custom stimuli from %s", stimuli_file);
          $readmemh(stimuli_file, stimuli);
       end else begin
          $display("Loading default stimuli");
          $readmemh("./vectors/stim.txt", stimuli);
       end


    
    // before starting the actual boot procedure we do some light
    // testing on the jtag link
    jtag_pkg::jtag_reset(s_tck, s_tms, s_trstn, s_tdi);
    jtag_pkg::jtag_softreset(s_tck, s_tms, s_trstn, s_tdi);
    #5us;
    
    jtag_pkg::jtag_bypass_test(s_tck, s_tms, s_trstn, s_tdi, s_tdo);
    #5us;
    
    jtag_pkg::jtag_get_idcode(s_tck, s_tms, s_trstn, s_tdi, s_tdo);
    #5us;
    
   // test_mode_if.init(s_tck, s_tms, s_trstn, s_tdi);
    
    //jtag_conf_reg = {USE_FLL ? 1'b0 : 1'b1, 6'b0, LOAD_L2 == "JTAG" ? 2'b11 : 2'b00};
    //jtag_conf_reg = { 1'b0 , 6'b0, 2'b11};
    //$display("[TB] %t - Enabling clock out via jtag", $realtime);
    
    //test_mode_if.set_confreg(jtag_conf_reg, jtag_conf_rego,s_tck, s_tms, s_trstn, s_tdi, s_tdo);
    
  //  $display("[TB] %t - jtag_conf_reg set to %x", $realtime, jtag_conf_reg);
    
    //$display("[TB] %t - Releasing hard reset", $realtime);
    s_rst_n = 1'b1;
    
    //test if the PULP tap che write to the L2
    //pulp_tap.init(s_tck, s_tms, s_trstn, s_tdi);
    
    //$display("[TB] %t - Init PULP TAP", $realtime);
    
    //pulp_tap.write32(BEGIN_L2_INSTR, 1, 32'hABBAABBA,
    //s_tck, s_tms, s_trstn, s_tdi, s_tdo);
    
    //$display("[TB] %t - Write32 PULP TAP", $realtime);
    
    //#50us;
    //pulp_tap.read32(BEGIN_L2_INSTR, 1, jtag_data,
    //s_tck, s_tms, s_trstn, s_tdi, s_tdo);
    
    //if(jtag_data[0] != 32'hABBAABBA)
    //    $display("[JTAG] R/W test of L2 failed: %h != %h", jtag_data[0], 32'hABBAABBA);
    //else
    //    $display("[JTAG] R/W test of L2 succeeded");
    
    // From here on starts the actual jtag booting
    
    // Setup debug module and hart, halt hart and set dpc (return point
    // for boot).
    // Halting the fc hart transfers control of the program execution to
    // the debug module. This might take a bit until the debug request
    // signal is propagated so meanwhile the core is executing stuff
    // from the bootrom. For jtag booting (what we are doing right now),
    // bootsel is low so the code that is being executed in said bootrom
    // is only a busy wait or wfi until the debug unit grabs control.
    debug_mode_if.init_dmi_access(s_tck, s_tms, s_trstn, s_tdi);
    
    debug_mode_if.set_dmactive(1'b1, s_tck, s_tms, s_trstn, s_tdi, s_tdo);
    
    debug_mode_if.set_hartsel(FC_CORE_ID, s_tck, s_tms, s_trstn, s_tdi, s_tdo);
    
    $display("[TB] %t - Halting the Core", $realtime);
    debug_mode_if.halt_harts(s_tck, s_tms, s_trstn, s_tdi, s_tdo);
    
   $display("[TB] %t - reading gpr 0x1000 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1000, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x1001 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1001, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x1001 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1001, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x1002 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1002, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x1003 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1003, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x1004 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1004, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x1005 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1005, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x1006 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1006, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x1007 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1007, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x1008 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1008, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x1009 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1009, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x100a ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h100a, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

  $display("[TB] %t - reading gpr 0x100b ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h100b, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x100c ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h100c, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x100d ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h100d, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x100e ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h100e, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x100f ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h100f, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x1010 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1010, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);


   $display("[TB] %t - reading gpr 0x1011 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1011, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x1012 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1012, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x1013 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1013, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x1014 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1014, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x1015 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1015, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x1016 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1016, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x1017 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1017, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x1018 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1018, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x1019 ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h1019, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x101a ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h101a, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

  $display("[TB] %t - reading gpr 0x101b ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h101b, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x101c ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h101c, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x101d ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h101d, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x101e ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h101e, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

   $display("[TB] %t - reading gpr 0x101f ", $realtime);
    debug_mode_if.read_reg_abstract_cmd(16'h101f, gpr, s_tck, s_tms, s_trstn, s_tdi, s_tdo);


    $display("[TB] %t - Writing the boot address into dpc", $realtime);
    debug_mode_if.write_reg_abstract_cmd(riscv::CSR_DPC, BEGIN_L2_INSTR,s_tck, s_tms, s_trstn, s_tdi, s_tdo);

    
    // long debug module + jtag tests
    if(ENABLE_DM_TESTS == 1) begin
        debug_mode_if.run_dm_tests(FC_CORE_ID, BEGIN_L2_INSTR, error, s_tck, s_tms, s_trstn, s_tdi, s_tdo);
    end
    
    $display("[TB] %t - Loading L2", $realtime);

        // use debug module to load binary
        debug_mode_if.load_L2(num_stim, stimuli, s_tck, s_tms, s_trstn, s_tdi, s_tdo);

    
    // configure for debug module dmi access again
    debug_mode_if.init_dmi_access(s_tck, s_tms, s_trstn, s_tdi);
    
    // we have set dpc and loaded the binary, we can go now
    $display("[TB] %t - Resuming the CORE", $realtime);
    debug_mode_if.resume_harts(s_tck, s_tms, s_trstn, s_tdi, s_tdo);
    
    
    
    
    #500us;
    
    
    
    // enable sb access for subsequent readMem calls
    debug_mode_if.set_sbreadonaddr(1'b1, s_tck, s_tms, s_trstn, s_tdi, s_tdo);
    
    // wait for end of computation signal
    $display("[TB] %t - Waiting for end of computation", $realtime);
    
    jtag_data[0] = 0;
    while(jtag_data[0][31] == 0) begin
    debug_mode_if.readMem(32'h1A1040A0, jtag_data[0], s_tck, s_tms, s_trstn, s_tdi, s_tdo);
    
    #50us;
    end
    
    if (jtag_data[0][30:0] == 0)
    exit_status = `EXIT_SUCCESS;
    else
    exit_status = `EXIT_FAIL;
    $display("[TB] %t - Received status core: 0x%h", $realtime, jtag_data[0][30:0]);
    
    $stop;

end
   


endmodule
