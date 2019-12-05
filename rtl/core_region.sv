// Copyright 2017 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


`include "axi_bus.sv"
`include "config.sv"

`include "pulp_interfaces.sv"
`include "pulp_soc_defines.sv"

module core_region
#(
    parameter AXI_ADDR_WIDTH       = 32,
    parameter AXI_DATA_WIDTH       = 64,
    parameter AXI_ID_MASTER_WIDTH  = 10,
    parameter AXI_ID_SLAVE_WIDTH   = 10,
    parameter AXI_USER_WIDTH       = 0,
    parameter DATA_RAM_SIZE        = 32768, // in bytes
    parameter INSTR_RAM_SIZE       = 32768, // in bytes
    parameter USE_ZERO_RISCY       = 0,
    parameter RISCY_RV32F          = 0,
    parameter ZERO_RV32M           = 1,
    parameter ZERO_RV32E           = 0

  )
(
    // Clock and Reset
    input logic         clk,
    input logic         rst_n,

    input  logic        testmode_i,
    input  logic        fetch_enable_i,
    input  logic [31:0] irq_i,
    output logic        core_busy_o,
    input  logic        clock_gating_i,
    input  logic [31:0] boot_addr_i,

    AXI_BUS.Master      core_master,
    AXI_BUS.Master      dbg_master,
    AXI_BUS.Slave       data_slave,
    AXI_BUS.Slave       instr_slave,
    AXI_BUS.Master      dbg_instr_master,
    DEBUG_BUS.Slave     debug,

    // JTAG signals
    input  logic        tck_i,
    input  logic        trstn_i,
    input  logic        tms_i,
    input  logic        tdi_i,
    output logic        tdo_o
  );

  localparam INSTR_ADDR_WIDTH = $clog2(INSTR_RAM_SIZE)+1; // to make space for the boot rom
  localparam DATA_ADDR_WIDTH  = $clog2(DATA_RAM_SIZE);

  localparam AXI_B_WIDTH      = $clog2(AXI_DATA_WIDTH/8); // AXI "Byte" width
  
//*************************************************************************************
// DEBUG ADDING
//*************************************************************************************
     
  localparam FC_Core_CLUSTER_ID    = 6'd0;
  localparam FC_Core_CORE_ID       = 4'd0;
  localparam FC_Core_MHARTID       = {FC_Core_CLUSTER_ID,1'b0,FC_Core_CORE_ID};

  //localparam NrHarts                               = 1024;
   localparam NrHarts                               = 16;
  localparam logic [NrHarts-1:0] SELECTABLE_HARTS  = 1 << FC_Core_MHARTID;
  localparam dm::hartinfo_t RI5CY_HARTINFO = '{
                                                zero1:        '0,
                                                nscratch:      2, // Debug module needs at least two scratch regs
                                                zero0:        '0,
                                                dataaccess: 1'b1, // data registers are memory mapped in the debugger
                                                datasize: dm::DataCount,
                                                dataaddr: dm::DataAddr
                                               };

    dm::hartinfo_t [NrHarts-1:0] hartinfo;
    
    
    
    //logic         dmi_rst_no; // hard reset
    dm::dmi_req_t dmi_req;
    logic         dmi_req_valid;
    logic         dmi_req_ready;
    
    dm::dmi_resp_t dmi_resp;
    logic         dmi_resp_ready;
    logic         dmi_resp_valid;
    
    logic         lint_riscv_jtag_bus_master_we;
    

logic [NrHarts-1:0]    dm_debug_req;

 logic          is_axi_dbg_instr_addr;
  // signals to/from core2axi
  logic         dbg_instr_master_req;
  logic         dbg_instr_master_gnt;
  logic         dbg_instr_master_rvalid;
  logic [31:0]  dbg_instr_master_addr;
  //logic         dbg_instr_master_we;
  //logic [3:0]   dbg_instr_master_be;
  logic [31:0]  dbg_instr_master_rdata;
  //logic [31:0]  dbg_instr_master_wdata;

 // enum logic [0:0] { AXI, RAM } core_instr_resp_CS, core_instr_resp_NS;

  logic         core_instr_mem_req;
  logic         core_instr_mem_gnt;
  logic         core_instr_mem_rvalid;
  logic [31:0]  core_instr_mem_addr;
  logic [31:0]  core_instr_mem_rdata;

  AXI_BUS
  #(
    .AXI_ADDR_WIDTH   ( AXI_ADDR_WIDTH      ),
    .AXI_DATA_WIDTH   ( AXI_DATA_WIDTH      ),
    .AXI_ID_WIDTH     ( AXI_ID_MASTER_WIDTH ),
    .AXI_USER_WIDTH   ( AXI_USER_WIDTH      )
  )
  dbg_instr_master_int();

//*************************************************************************************
// END DEBUG ADDING
//*************************************************************************************


  // signals from/to core
  logic         core_instr_req;
  logic         core_instr_gnt;
  logic         core_instr_rvalid;
  logic [31:0]  core_instr_addr;
  logic [31:0]  core_instr_rdata;

  logic         core_lsu_req;
  logic         core_lsu_gnt;
  logic         core_lsu_rvalid;
  logic [31:0]  core_lsu_addr;
  logic         core_lsu_we;
  logic [3:0]   core_lsu_be;
  logic [31:0]  core_lsu_rdata;
  logic [31:0]  core_lsu_wdata;

  logic         core_data_req;
  logic         core_data_gnt;
  logic         core_data_rvalid;
  logic [31:0]  core_data_addr;
  logic         core_data_we;
  logic [3:0]   core_data_be;
  logic [31:0]  core_data_rdata;
  logic [31:0]  core_data_wdata;

  // signals to/from AXI mem
  logic                        is_axi_addr;
  logic                        axi_mem_req;
  logic [DATA_ADDR_WIDTH-1:0]  axi_mem_addr;
  logic                        axi_mem_we;
  logic [AXI_DATA_WIDTH/8-1:0] axi_mem_be;
  logic [AXI_DATA_WIDTH-1:0]   axi_mem_rdata;
  logic [AXI_DATA_WIDTH-1:0]   axi_mem_wdata;

  // signals to/from AXI instr
  logic                        axi_instr_req;
  logic [INSTR_ADDR_WIDTH-1:0] axi_instr_addr;
  logic                        axi_instr_we;
  logic [AXI_DATA_WIDTH/8-1:0] axi_instr_be;
  logic [AXI_DATA_WIDTH-1:0]   axi_instr_rdata;
  logic [AXI_DATA_WIDTH-1:0]   axi_instr_wdata;


  // signals to/from instr mem
  logic                        instr_mem_en;
  logic [INSTR_ADDR_WIDTH-1:0] instr_mem_addr;
  logic                        instr_mem_we;
  logic [AXI_DATA_WIDTH/8-1:0] instr_mem_be;
  logic [AXI_DATA_WIDTH-1:0]   instr_mem_rdata;
  logic [AXI_DATA_WIDTH-1:0]   instr_mem_wdata;

  // signals to/from data mem
  logic                        data_mem_en;
  logic [DATA_ADDR_WIDTH-1:0]  data_mem_addr;
  logic                        data_mem_we;
  logic [AXI_DATA_WIDTH/8-1:0] data_mem_be;
  logic [AXI_DATA_WIDTH-1:0]   data_mem_rdata;
  logic [AXI_DATA_WIDTH-1:0]   data_mem_wdata;



  enum logic [0:0] { AXI, RAM } lsu_resp_CS, lsu_resp_NS, core_instr_resp_CS, core_instr_resp_NS;

  // signals to/from core2axi
  logic         core_axi_req;
  logic         core_axi_gnt;
  logic         core_axi_rvalid;
  logic [31:0]  core_axi_addr;
  logic         core_axi_we;
  logic [3:0]   core_axi_be;
  logic [31:0]  core_axi_rdata;
  logic [31:0]  core_axi_wdata;
  
  XBAR_TCDM_BUS s_lint_riscv_jtag_bus();
  
  

  AXI_BUS
  #(
    .AXI_ADDR_WIDTH   ( AXI_ADDR_WIDTH      ),
    .AXI_DATA_WIDTH   ( AXI_DATA_WIDTH      ),
    .AXI_ID_WIDTH     ( AXI_ID_MASTER_WIDTH ),
    .AXI_USER_WIDTH   ( AXI_USER_WIDTH      )
  )
  core_master_int();

  //----------------------------------------------------------------------------//
  // Core Instantiation
  //----------------------------------------------------------------------------//

  logic [4:0] irq_id;
  always_comb begin
    irq_id = '0;
    for (int i = 0; i < 32; i+=1) begin
      if(irq_i[i]) begin
        irq_id = i[4:0];
      end
    end
  end

  if(USE_ZERO_RISCY) begin: CORE
      zeroriscy_core
      #(
        .N_EXT_PERF_COUNTERS (     0      ),
        .RV32E               ( ZERO_RV32E ),
        .RV32M               ( ZERO_RV32M )
      )
      RISCV_CORE
      (
        .clk_i           ( clk               ),
        .rst_ni          ( rst_n             ),

        .clock_en_i      ( clock_gating_i    ),
        .test_en_i       ( testmode_i        ),

        .boot_addr_i     ( boot_addr_i       ),
        .core_id_i       ( 4'h0              ),
        .cluster_id_i    ( 6'h0              ),

        .instr_addr_o    ( core_instr_addr   ),
        .instr_req_o     ( core_instr_req    ),
        .instr_rdata_i   ( core_instr_rdata  ),
        .instr_gnt_i     ( core_instr_gnt    ),
        .instr_rvalid_i  ( core_instr_rvalid ),

        .data_addr_o     ( core_lsu_addr     ),
        .data_wdata_o    ( core_lsu_wdata    ),
        .data_we_o       ( core_lsu_we       ),
        .data_req_o      ( core_lsu_req      ),
        .data_be_o       ( core_lsu_be       ),
        .data_rdata_i    ( core_lsu_rdata    ),
        .data_gnt_i      ( core_lsu_gnt      ),
        .data_rvalid_i   ( core_lsu_rvalid   ),
        .data_err_i      ( 1'b0              ),

        .irq_i           ( (|irq_i)          ),
        .irq_id_i        ( irq_id            ),
        .irq_ack_o       (                   ),
        .irq_id_o        (                   ),

        .debug_req_i     ( debug.req         ),
        .debug_gnt_o     ( debug.gnt         ),
        .debug_rvalid_o  ( debug.rvalid      ),
        .debug_addr_i    ( debug.addr        ),
        .debug_we_i      ( debug.we          ),
        .debug_wdata_i   ( debug.wdata       ),
        .debug_rdata_o   ( debug.rdata       ),
        .debug_halted_o  (                   ),
        .debug_halt_i    ( 1'b0              ),
        .debug_resume_i  ( 1'b0              ),

        .fetch_enable_i  ( fetch_enable_i    ),
        .core_busy_o     ( core_busy_o       ),
        .ext_perf_counters_i (               )
      );
  end else begin: CORE

//    riscv_core
//    #(
//      .N_EXT_PERF_COUNTERS (     0       ),
//      .FPU                 ( RISCY_RV32F ),
//      .SHARED_FP           (     0       ),
//      .SHARED_FP_DIVSQRT   (     2       )
//    )
//    RISCV_CORE
//    (
//      .clk_i           ( clk               ),
//      .rst_ni          ( rst_n             ),

//      .clock_en_i      ( clock_gating_i    ),
//      .test_en_i       ( testmode_i        ),

//      .boot_addr_i     ( boot_addr_i       ),
//      .core_id_i       ( 4'h0              ),
//      .cluster_id_i    ( 6'h0              ),

//      .instr_addr_o    ( core_instr_addr   ),
//      .instr_req_o     ( core_instr_req    ),
//      .instr_rdata_i   ( core_instr_rdata  ),
//      .instr_gnt_i     ( core_instr_gnt    ),
//      .instr_rvalid_i  ( core_instr_rvalid ),

//      .data_addr_o     ( core_lsu_addr     ),
//      .data_wdata_o    ( core_lsu_wdata    ),
//      .data_we_o       ( core_lsu_we       ),
//      .data_req_o      ( core_lsu_req      ),
//      .data_be_o       ( core_lsu_be       ),
//      .data_rdata_i    ( core_lsu_rdata    ),
//      .data_gnt_i      ( core_lsu_gnt      ),
//      .data_rvalid_i   ( core_lsu_rvalid   ),
//      .data_err_i      ( 1'b0              ),

//      .irq_i           ( (|irq_i)          ),
//      .irq_id_i        ( irq_id            ),
//      .irq_ack_o       (                   ),
//      .irq_id_o        (                   ),
//      .irq_sec_i       ( 1'b0              ),
//      .sec_lvl_o       (                   ),

//      .debug_req_i     ( debug.req         ),
//      .debug_gnt_o     ( debug.gnt         ),
//      .debug_rvalid_o  ( debug.rvalid      ),
//      .debug_addr_i    ( debug.addr        ),
//      .debug_we_i      ( debug.we          ),
//      .debug_wdata_i   ( debug.wdata       ),
//      .debug_rdata_o   ( debug.rdata       ),
//      .debug_halted_o  (                   ),
//      .debug_halt_i    ( 1'b0              ),
//      .debug_resume_i  ( 1'b0              ),

//      .fetch_enable_i  ( fetch_enable_i    ),
//      .core_busy_o     ( core_busy_o       ),

//      // apu-interconnect
//      // handshake signals
//      .apu_master_req_o      (             ),
//      .apu_master_ready_o    (             ),
//      .apu_master_gnt_i      ( 1'b1        ),
//      // request channel
//      .apu_master_operands_o (             ),
//      .apu_master_op_o       (             ),
//      .apu_master_type_o     (             ),
//      .apu_master_flags_o    (             ),
//      // response channel
//      .apu_master_valid_i    ( '0          ),
//      .apu_master_result_i   ( '0          ),
//      .apu_master_flags_i    ( '0          ),

//      .ext_perf_counters_i (               )
//      );
      
      riscv_core #(
              .N_EXT_PERF_COUNTERS ( 0 ),
              .PULP_SECURE         ( 0                   ),
              .PULP_CLUSTER        ( 0                   ),
              .FPU                 ( RISCY_RV32F             ),
              .FP_DIVSQRT          ( RISCY_RV32F             ),
              .SHARED_FP           ( 0                   ),
              .SHARED_FP_DIVSQRT   ( 2                   )
          ) lFC_CORE (
              .clk_i                 ( clk             ),
              .rst_ni                ( rst_n            ),
              
              .clock_en_i            ( clock_gating_i     ),
              .test_en_i             ( testmode_i         ),
              
              .boot_addr_i           ( boot_addr_i       ),
              .core_id_i             ( 4'h0           ),
              .cluster_id_i          ( 6'h0        ),
      
              // Instruction Memory Interface:  Interface to Instruction Logaritmic interconnect: Req->grant handshake
              .instr_addr_o          ( core_instr_addr   ),
              .instr_req_o           ( core_instr_req    ),
              .instr_rdata_i         ( core_instr_rdata  ),
              .instr_gnt_i           ( core_instr_gnt    ),
              .instr_rvalid_i        ( core_instr_rvalid ),


              //.instr_addr_o          ( instr_addr   ),
              //.instr_req_o           ( instr_req    ),
              //.instr_rdata_i         ( instr_rdata  ),
              //.instr_gnt_i           ( instr_gnt    ),
              //.instr_rvalid_i        ( instr_rvalid ),
      
              // Data memory interface:
             
                .data_addr_o     ( core_lsu_addr     ),
                .data_req_o      ( core_lsu_req      ),
                .data_be_o       ( core_lsu_be       ),
                .data_rdata_i    ( core_lsu_rdata    ),
                .data_we_o       ( core_lsu_we       ),
                .data_gnt_i      ( core_lsu_gnt      ),
                .data_wdata_o    ( core_lsu_wdata    ),
                .data_rvalid_i   ( core_lsu_rvalid   ),
                //.data_err_i      ( 1'b0              ),
      
              // apu-interconnect
              // handshake signals
              .apu_master_req_o      (                   ),
              .apu_master_ready_o    (                   ),
              .apu_master_gnt_i      ( 1'b1              ),
              // request channel
              .apu_master_operands_o (                   ),
              .apu_master_op_o       (                   ),
              .apu_master_type_o     (                   ),
              .apu_master_flags_o    (                   ),
              // response channel
              .apu_master_valid_i    ( '0                ),
              .apu_master_result_i   ( '0                ),
              .apu_master_flags_i    ( '0                ),
      
              
              .irq_i           ( (|irq_i)          ),
              .irq_id_i        ( irq_id            ),
              .irq_ack_o       (                   ),
              .irq_id_o        (                   ),
              .irq_sec_i       ( 1'b0              ),
              .sec_lvl_o       (                   ),
      
              .debug_req_i           ( dm_debug_req[FC_Core_MHARTID]       ),
              //.debug_req_i           ( 1'b0       ),
      
              .fetch_enable_i        ( fetch_enable_i   ),
              .core_busy_o           (  core_busy_o        ),
              .ext_perf_counters_i   (                   ),
              .fregfile_disable_i    ( 1'b0              ) // try me!
               );
  end

  core2axi_wrap
  #(
    .AXI_ADDR_WIDTH   ( AXI_ADDR_WIDTH      ),
    .AXI_DATA_WIDTH   ( AXI_DATA_WIDTH      ),
    .AXI_ID_WIDTH     ( AXI_ID_MASTER_WIDTH ),
    .AXI_USER_WIDTH   ( AXI_USER_WIDTH      ),
    .REGISTERED_GRANT ( "FALSE"             )
  )
  core2axi_i
  (
    .clk_i         ( clk             ),
    .rst_ni        ( rst_n           ),

    .data_req_i    ( core_axi_req    ),
    .data_gnt_o    ( core_axi_gnt    ),
    .data_rvalid_o ( core_axi_rvalid ),
    .data_addr_i   ( core_axi_addr   ),
    .data_we_i     ( core_axi_we     ),
    .data_be_i     ( core_axi_be     ),
    .data_rdata_o  ( core_axi_rdata  ),
    .data_wdata_i  ( core_axi_wdata  ),

    .master        ( core_master_int )
  );

  //----------------------------------------------------------------------------//
  // AXI Slices
  //----------------------------------------------------------------------------//

  axi_slice_wrap
  #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH       ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH       ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH       ),
    .AXI_ID_WIDTH   ( AXI_ID_MASTER_WIDTH  ),
    .SLICE_DEPTH    ( 2                    )
  )
  axi_slice_core2axi
  (
    .clk_i      ( clk             ),
    .rst_ni     ( rst_n           ),

    .test_en_i  ( testmode_i      ),

    .axi_slave  ( core_master_int ),
    .axi_master ( core_master     )
  );


  //----------------------------------------------------------------------------//
  // DEMUX
  //----------------------------------------------------------------------------//
  assign is_axi_addr     = (core_lsu_addr[31:20] != 12'h001);
  assign core_data_req   = (~is_axi_addr) & core_lsu_req;
  assign core_axi_req    =   is_axi_addr  & core_lsu_req;

  assign core_data_addr  = core_lsu_addr;
  assign core_data_we    = core_lsu_we;
  assign core_data_be    = core_lsu_be;
  assign core_data_wdata = core_lsu_wdata;

  assign core_axi_addr   = core_lsu_addr;
  assign core_axi_we     = core_lsu_we;
  assign core_axi_be     = core_lsu_be;
  assign core_axi_wdata  = core_lsu_wdata;

  always_ff @(posedge clk, negedge rst_n)
  begin
    if (rst_n == 1'b0)
      lsu_resp_CS <= RAM;
    else
      lsu_resp_CS <= lsu_resp_NS;
  end

  // figure out where the next response will be coming from
  always_comb
  begin
    lsu_resp_NS = lsu_resp_CS;
    core_lsu_gnt = 1'b0;

    if (core_axi_req)
    begin
      core_lsu_gnt = core_axi_gnt;
      lsu_resp_NS = AXI;
    end
    else if (core_data_req)
    begin
      core_lsu_gnt = core_data_gnt;
      lsu_resp_NS = RAM;
    end
  end

  // route response back to LSU
  assign core_lsu_rdata  = (lsu_resp_CS == AXI) ? core_axi_rdata : core_data_rdata;
  assign core_lsu_rvalid = core_axi_rvalid | core_data_rvalid;

 //----------------------------------------------------------------------------//
  // DEMUX INSTRUCTIONS
  //----------------------------------------------------------------------------//
  assign is_axi_dbg_instr_addr     = (core_instr_addr[31:16] != 16'h0000) ;
  assign core_instr_mem_req   = (~is_axi_dbg_instr_addr) & core_instr_req;
  assign dbg_instr_master_req    =   is_axi_dbg_instr_addr  & core_instr_req;

  assign core_instr_mem_addr  = core_instr_addr;
  //assign core_instr_mem_we    = core_instr_we;
  //assign core_instr_mem_be    = core_instr_be;
 // assign core_instr_mem_wdata = core_instr_wdata;

  assign dbg_instr_master_addr   = core_instr_addr;
  //assign dbg_instr_master_we     = core_instr_we;
  //assign dbg_instr_master_be     = core_instr_be;
  //assign dbg_instr_master_wdata  = core_instr_wdata;

  always_ff @(posedge clk, negedge rst_n)
  begin
    if (rst_n == 1'b0)
      core_instr_resp_CS <= RAM;
    else
      core_instr_resp_CS <= core_instr_resp_NS;
  end

  // figure out where the next response will be coming from
  always_comb
  begin
    core_instr_resp_NS = core_instr_resp_CS;
    core_instr_gnt = 1'b0;

    if (dbg_instr_master_req)
    begin
      core_instr_gnt = dbg_instr_master_gnt;
      core_instr_resp_NS = AXI;
    end
    else if (core_instr_mem_req)
    begin
      core_instr_gnt = core_instr_mem_gnt;
      core_instr_resp_NS = RAM;
    end
  end

  // route response back to core_instr
  assign core_instr_rdata  = (core_instr_resp_CS == AXI) ? dbg_instr_master_rdata : core_instr_mem_rdata;
  assign core_instr_rvalid = dbg_instr_master_rvalid | core_instr_mem_rvalid;

  //----------------------------------------------------------------------------//
  // Instruction RAM
  //----------------------------------------------------------------------------//

  instr_ram_wrap
  #(
    .RAM_SIZE   ( INSTR_RAM_SIZE ),
    .DATA_WIDTH ( AXI_DATA_WIDTH )
  )
  instr_mem
  (
    .clk         ( clk             ),
    .rst_n       ( rst_n           ),
    .en_i        ( instr_mem_en    ),
    .addr_i      ( instr_mem_addr  ),
    .wdata_i     ( instr_mem_wdata ),
    .rdata_o     ( instr_mem_rdata ),
    .we_i        ( instr_mem_we    ),
    .be_i        ( instr_mem_be    ),
    .bypass_en_i ( testmode_i      )
  );

  axi_mem_if_SP_wrap
  #(
    .AXI_ADDR_WIDTH  ( AXI_ADDR_WIDTH         ),
    .AXI_DATA_WIDTH  ( AXI_DATA_WIDTH         ),
    .AXI_ID_WIDTH    ( AXI_ID_SLAVE_WIDTH     ),
    .AXI_USER_WIDTH  ( AXI_USER_WIDTH         ),
    .MEM_ADDR_WIDTH  ( INSTR_ADDR_WIDTH       )
  )
  instr_mem_axi_if
  (
    .clk         ( clk               ),
    .rst_n       ( rst_n             ),
    .test_en_i   ( testmode_i        ),

    .mem_req_o   ( axi_instr_req     ),
    .mem_addr_o  ( axi_instr_addr    ),
    .mem_we_o    ( axi_instr_we      ),
    .mem_be_o    ( axi_instr_be      ),
    .mem_rdata_i ( axi_instr_rdata   ),
    .mem_wdata_o ( axi_instr_wdata   ),

    .slave       ( instr_slave       )
  );


//  ram_mux
//  #(
//    .ADDR_WIDTH ( INSTR_ADDR_WIDTH ),
//    .IN0_WIDTH  ( AXI_DATA_WIDTH   ),
//    .IN1_WIDTH  ( 32               ),
//    .OUT_WIDTH  ( AXI_DATA_WIDTH   )
//  )
//  instr_ram_mux_i
//  (
//    .clk            ( clk               ),
//    .rst_n          ( rst_n             ),

//    .port0_req_i    ( axi_instr_req     ),
//    .port0_gnt_o    (                   ),
//    .port0_rvalid_o (                   ),
//    .port0_addr_i   ( {axi_instr_addr[INSTR_ADDR_WIDTH-AXI_B_WIDTH-1:0], {AXI_B_WIDTH{1'b0}}} ),
//    .port0_we_i     ( axi_instr_we      ),
//    .port0_be_i     ( axi_instr_be      ),
//    .port0_rdata_o  ( axi_instr_rdata   ),
//    .port0_wdata_i  ( axi_instr_wdata   ),

//    .port1_req_i    ( core_instr_req    ),
//    .port1_gnt_o    ( core_instr_gnt    ),
//    .port1_rvalid_o ( core_instr_rvalid ),
//    .port1_addr_i   ( core_instr_addr[INSTR_ADDR_WIDTH-1:0] ),
//    .port1_we_i     ( 1'b0              ),
//    .port1_be_i     ( '1                ),
//    .port1_rdata_o  ( core_instr_rdata  ),
//    .port1_wdata_i  ( '0                ),

//    .ram_en_o       ( instr_mem_en      ),
//    .ram_addr_o     ( instr_mem_addr    ),
//    .ram_we_o       ( instr_mem_we      ),
//    .ram_be_o       ( instr_mem_be      ),
//    .ram_rdata_i    ( instr_mem_rdata   ),
//    .ram_wdata_o    ( instr_mem_wdata   )
//  );

  ram_mux
  #(
    .ADDR_WIDTH ( INSTR_ADDR_WIDTH ),
    .IN0_WIDTH  ( AXI_DATA_WIDTH   ),
    .IN1_WIDTH  ( 32               ),
    .OUT_WIDTH  ( AXI_DATA_WIDTH   )
  )
  instr_ram_mux_i
  (
    .clk            ( clk               ),
    .rst_n          ( rst_n             ),

    .port0_req_i    ( axi_instr_req     ),
    .port0_gnt_o    (                   ),
    .port0_rvalid_o (                   ),
    .port0_addr_i   ( {axi_instr_addr[INSTR_ADDR_WIDTH-AXI_B_WIDTH-1:0], {AXI_B_WIDTH{1'b0}}} ),
    .port0_we_i     ( axi_instr_we      ),
    .port0_be_i     ( axi_instr_be      ),
    .port0_rdata_o  ( axi_instr_rdata   ),
    .port0_wdata_i  ( axi_instr_wdata   ),

    .port1_req_i    ( core_instr_mem_req    ),
    .port1_gnt_o    ( core_instr_mem_gnt    ),
    .port1_rvalid_o ( core_instr_mem_rvalid ),
    .port1_addr_i   ( core_instr_mem_addr[INSTR_ADDR_WIDTH-1:0] ),
    .port1_we_i     ( 1'b0              ),
    .port1_be_i     ( '1                ),
    .port1_rdata_o  ( core_instr_mem_rdata  ),
    .port1_wdata_i  ( '0                ),

    .ram_en_o       ( instr_mem_en      ),
    .ram_addr_o     ( instr_mem_addr    ),
    .ram_we_o       ( instr_mem_we      ),
    .ram_be_o       ( instr_mem_be      ),
    .ram_rdata_i    ( instr_mem_rdata   ),
    .ram_wdata_o    ( instr_mem_wdata   )
  );

  //----------------------------------------------------------------------------//
  // Data RAM
  //----------------------------------------------------------------------------//
  sp_ram_wrap
  #(
    .RAM_SIZE   ( DATA_RAM_SIZE  ),
    .DATA_WIDTH ( AXI_DATA_WIDTH )
  )
  data_mem
  (
    .clk          ( clk            ),
    .rstn_i       ( rst_n          ),
    .en_i         ( data_mem_en    ),
    .addr_i       ( data_mem_addr  ),
    .wdata_i      ( data_mem_wdata ),
    .rdata_o      ( data_mem_rdata ),
    .we_i         ( data_mem_we    ),
    .be_i         ( data_mem_be    ),
    .bypass_en_i  ( testmode_i     )
  );

  axi_mem_if_SP_wrap
  #(
    .AXI_ADDR_WIDTH  ( AXI_ADDR_WIDTH     ),
    .AXI_DATA_WIDTH  ( AXI_DATA_WIDTH     ),
    .AXI_ID_WIDTH    ( AXI_ID_SLAVE_WIDTH ),
    .AXI_USER_WIDTH  ( AXI_USER_WIDTH     ),
    .MEM_ADDR_WIDTH  ( DATA_ADDR_WIDTH    )
  )
  data_mem_axi_if
  (
    .clk         ( clk               ),
    .rst_n       ( rst_n             ),
    .test_en_i   ( testmode_i        ),

    .mem_req_o   ( axi_mem_req       ),
    .mem_addr_o  ( axi_mem_addr      ),
    .mem_we_o    ( axi_mem_we        ),
    .mem_be_o    ( axi_mem_be        ),
    .mem_rdata_i ( axi_mem_rdata     ),
    .mem_wdata_o ( axi_mem_wdata     ),

    .slave       ( data_slave        )
  );


  ram_mux
  #(
    .ADDR_WIDTH ( DATA_ADDR_WIDTH ),
    .IN0_WIDTH  ( AXI_DATA_WIDTH  ),
    .IN1_WIDTH  ( 32              ),
    .OUT_WIDTH  ( AXI_DATA_WIDTH  )
  )
  data_ram_mux_i
  (
    .clk            ( clk              ),
    .rst_n          ( rst_n            ),

    .port0_req_i    ( axi_mem_req      ),
    .port0_gnt_o    (                  ),
    .port0_rvalid_o (                  ),
    .port0_addr_i   ( {axi_mem_addr[DATA_ADDR_WIDTH-AXI_B_WIDTH-1:0], {AXI_B_WIDTH{1'b0}}} ),
    .port0_we_i     ( axi_mem_we       ),
    .port0_be_i     ( axi_mem_be       ),
    .port0_rdata_o  ( axi_mem_rdata    ),
    .port0_wdata_i  ( axi_mem_wdata    ),

    .port1_req_i    ( core_data_req    ),
    .port1_gnt_o    ( core_data_gnt    ),
    .port1_rvalid_o ( core_data_rvalid ),
    .port1_addr_i   ( core_data_addr[DATA_ADDR_WIDTH-1:0] ),
    .port1_we_i     ( core_data_we     ),
    .port1_be_i     ( core_data_be     ),
    .port1_rdata_o  ( core_data_rdata  ),
    .port1_wdata_i  ( core_data_wdata  ),

    .ram_en_o       ( data_mem_en      ),
    .ram_addr_o     ( data_mem_addr    ),
    .ram_we_o       ( data_mem_we      ),
    .ram_be_o       ( data_mem_be      ),
    .ram_rdata_i    ( data_mem_rdata   ),
    .ram_wdata_o    ( data_mem_wdata   )
  );


  //----------------------------------------------------------------------------//
  // Advanced Debug Unit
  //----------------------------------------------------------------------------//

//  // TODO: remove the debug connections to the core
//  adv_dbg_if
//  #(
//    .NB_CORES           ( 1                   ),
//    .AXI_ADDR_WIDTH     ( AXI_ADDR_WIDTH      ),
//    .AXI_DATA_WIDTH     ( AXI_DATA_WIDTH      ),
//    .AXI_USER_WIDTH     ( AXI_USER_WIDTH      ),
//    .AXI_ID_WIDTH       ( AXI_ID_MASTER_WIDTH )
//    )
//  adv_dbg_if_i
//  (
//    .tms_pad_i   ( tms_i           ),
//    .tck_pad_i   ( tck_i           ),
//    .trstn_pad_i ( trstn_i         ),
//    .tdi_pad_i   ( tdi_i           ),
//    .tdo_pad_o   ( tdo_o           ),

//    .test_mode_i ( testmode_i      ),

//    .cpu_addr_o  (                 ),
//    .cpu_data_i  ( '0              ),
//    .cpu_data_o  (                 ),
//    .cpu_bp_i    ( '0              ),
//    .cpu_stall_o (                 ),
//    .cpu_stb_o   (                 ),
//    .cpu_we_o    (                 ),
//    .cpu_ack_i   ( '1              ),
//    .cpu_rst_o   (                 ),

//    .axi_aclk             ( clk                  ),
//    .axi_aresetn          ( rst_n                ),

//    .axi_master_aw_valid  ( dbg_master.aw_valid  ),
//    .axi_master_aw_addr   ( dbg_master.aw_addr   ),
//    .axi_master_aw_prot   ( dbg_master.aw_prot   ),
//    .axi_master_aw_region ( dbg_master.aw_region ),
//    .axi_master_aw_len    ( dbg_master.aw_len    ),
//    .axi_master_aw_size   ( dbg_master.aw_size   ),
//    .axi_master_aw_burst  ( dbg_master.aw_burst  ),
//    .axi_master_aw_lock   ( dbg_master.aw_lock   ),
//    .axi_master_aw_cache  ( dbg_master.aw_cache  ),
//    .axi_master_aw_qos    ( dbg_master.aw_qos    ),
//    .axi_master_aw_id     ( dbg_master.aw_id     ),
//    .axi_master_aw_user   ( dbg_master.aw_user   ),
//    .axi_master_aw_ready  ( dbg_master.aw_ready  ),

//    .axi_master_ar_valid  ( dbg_master.ar_valid  ),
//    .axi_master_ar_addr   ( dbg_master.ar_addr   ),
//    .axi_master_ar_prot   ( dbg_master.ar_prot   ),
//    .axi_master_ar_region ( dbg_master.ar_region ),
//    .axi_master_ar_len    ( dbg_master.ar_len    ),
//    .axi_master_ar_size   ( dbg_master.ar_size   ),
//    .axi_master_ar_burst  ( dbg_master.ar_burst  ),
//    .axi_master_ar_lock   ( dbg_master.ar_lock   ),
//    .axi_master_ar_cache  ( dbg_master.ar_cache  ),
//    .axi_master_ar_qos    ( dbg_master.ar_qos    ),
//    .axi_master_ar_id     ( dbg_master.ar_id     ),
//    .axi_master_ar_user   ( dbg_master.ar_user   ),
//    .axi_master_ar_ready  ( dbg_master.ar_ready  ),

//    .axi_master_w_valid   ( dbg_master.w_valid   ),
//    .axi_master_w_data    ( dbg_master.w_data    ),
//    .axi_master_w_strb    ( dbg_master.w_strb    ),
//    .axi_master_w_user    ( dbg_master.w_user    ),
//    .axi_master_w_last    ( dbg_master.w_last    ),
//    .axi_master_w_ready   ( dbg_master.w_ready   ),

//    .axi_master_r_valid   ( dbg_master.r_valid   ),
//    .axi_master_r_data    ( dbg_master.r_data    ),
//    .axi_master_r_resp    ( dbg_master.r_resp    ),
//    .axi_master_r_last    ( dbg_master.r_last    ),
//    .axi_master_r_id      ( dbg_master.r_id      ),
//    .axi_master_r_user    ( dbg_master.r_user    ),
//    .axi_master_r_ready   ( dbg_master.r_ready   ),

//    .axi_master_b_valid   ( dbg_master.b_valid   ),
//    .axi_master_b_resp    ( dbg_master.b_resp    ),
//    .axi_master_b_id      ( dbg_master.b_id      ),
//    .axi_master_b_user    ( dbg_master.b_user    ),
//    .axi_master_b_ready   ( dbg_master.b_ready   )
//    );
    
//*************************************************************************************
// DEBUG ADDING
//*************************************************************************************    

   
  core2axi_wrap
  #(
    .AXI_ADDR_WIDTH   ( AXI_ADDR_WIDTH      ),
    .AXI_DATA_WIDTH   ( AXI_DATA_WIDTH      ),
    .AXI_ID_WIDTH     ( AXI_ID_MASTER_WIDTH ),
    .AXI_USER_WIDTH   ( AXI_USER_WIDTH      ),
    .REGISTERED_GRANT ( "FALSE"             )
  )
  core2axi_dbg_instr_i
  (
    .clk_i         ( clk             ),
    .rst_ni        ( rst_n           ),

    .data_req_i    ( dbg_instr_master_req    ),
    .data_gnt_o    ( dbg_instr_master_gnt    ),
    .data_rvalid_o ( dbg_instr_master_rvalid ),
    .data_addr_i   ( dbg_instr_master_addr   ),
    .data_we_i     ( 1'b0     ),
    .data_be_i     ( '1     ),
    .data_rdata_o  ( dbg_instr_master_rdata  ),
    .data_wdata_i  ( '0  ),

    .master        ( dbg_instr_master_int )
  );



  axi_slice_wrap
  #(
    .AXI_ADDR_WIDTH ( AXI_ADDR_WIDTH       ),
    .AXI_DATA_WIDTH ( AXI_DATA_WIDTH       ),
    .AXI_USER_WIDTH ( AXI_USER_WIDTH       ),
    .AXI_ID_WIDTH   ( AXI_ID_MASTER_WIDTH  ),
    .SLICE_DEPTH    ( 2                    )
  )
  axi_slice_core2axi_dbg_instr
  (
    .clk_i      ( clk             ),
    .rst_ni     ( rst_n           ),

    .test_en_i  ( testmode_i      ),

    .axi_slave  ( dbg_instr_master_int ),
    .axi_master ( dbg_instr_master     )
  );


 
    dmi_jtag #(
        .IdcodeValue          ( `DMI_JTAG_IDCODE    )
    ) i_dmi_jtag (
        .clk_i                ( clk           ),
        .rst_ni               ( rst_n          ),
        .testmode_i           ( 1'b0                ),
        .dmi_req_o            ( dmi_req        ),
        .dmi_req_valid_o      ( dmi_req_valid      ),
        .dmi_req_ready_i      ( dmi_req_ready     ),
        .dmi_resp_i           ( dmi_resp          ),
        .dmi_resp_ready_o     ( dmi_resp_ready     ),
        .dmi_resp_valid_i     ( dmi_resp_valid     ),
        .dmi_rst_no           (                     ), // not connected
        .tck_i                ( tck_i          ),
        .tms_i                ( tms_i          ),
        .trst_ni              ( trstn_i        ),
        .td_i                 ( tdi_i          ),
        .td_o                 ( tdo_o              ),
        .tdo_oe_o             (                     )
    );
    
     // assign hartinfo
       always_comb begin
           hartinfo = '{default: '0};
           hartinfo[FC_Core_MHARTID] = RI5CY_HARTINFO;
       end
   
       dm_top #(
          .NrHarts           ( NrHarts                   ),
          .BusWidth          ( 32                        ),
          .SelectableHarts   ( SELECTABLE_HARTS          )
       ) i_dm_top (
   
          .clk_i             ( clk                 ),
          .rst_ni            ( rst_n                ),
          .testmode_i        ( 1'b0                      ),
          .ndmreset_o        (                           ),
          .dmactive_o        (                           ), // active debug session
          .debug_req_o       ( dm_debug_req              ),
          .unavailable_i     ( ~SELECTABLE_HARTS         ),
          .hartinfo_i        ( hartinfo                  ),
   
          .slave_req_i       ( debug.req                 ),
          .slave_we_i        ( debug.wen                  ),
          .slave_addr_i      ( debug.add                ),
          .slave_be_i        ( debug.be                  ),
          .slave_wdata_i     ( debug.wdata               ),
          .slave_rdata_o     ( debug.r_rdata               ),
   
          .master_req_o      ( s_lint_riscv_jtag_bus.req      ),
          .master_add_o      ( s_lint_riscv_jtag_bus.add      ),
          //.master_we_o       ( lint_riscv_jtag_bus_master_we  ),
	  .master_we_o       ( s_lint_riscv_jtag_bus.wen  ),
          .master_wdata_o    ( s_lint_riscv_jtag_bus.wdata    ),
          .master_be_o       ( s_lint_riscv_jtag_bus.be       ),
          .master_gnt_i      ( s_lint_riscv_jtag_bus.gnt      ),
          .master_r_valid_i  ( s_lint_riscv_jtag_bus.r_valid  ),
          .master_r_rdata_i  ( s_lint_riscv_jtag_bus.r_rdata  ),
   
          .dmi_rst_ni        ( rst_n                ),
          .dmi_req_valid_i   ( dmi_req_valid        ),
          .dmi_req_ready_o   ( dmi_req_ready        ),
          .dmi_req_i         ( dmi_req              ),
          .dmi_resp_valid_o  ( dmi_resp_valid       ),
          .dmi_resp_ready_i  ( dmi_resp_ready       ),
          .dmi_resp_o        ( dmi_resp             )
       );
      // assign s_lint_riscv_jtag_bus.wen = ~lint_riscv_jtag_bus_master_we;
       
       lint_2_axi #(
               .ADDR_WIDTH       ( AXI_ADDR_WIDTH        ),
               .DATA_WIDTH       ( AXI_DATA_WIDTH        ),
               .BE_WIDTH         ( AXI_DATA_WIDTH/8          ),
               .ID_WIDTH         ( 1      ),
               .USER_WIDTH       ( AXI_USER_WIDTH ),
               .AUX_WIDTH        ( 1         ),
               .AXI_ID_WIDTH     ( AXI_ID_MASTER_WIDTH   ),
               .REGISTERED_GRANT ( "FALSE"           )  // "TRUE"|"FALSE"
           ) i_lint_2_axi (
               // Clock and Reset
               .clk_i         ( clk                            ),
               .rst_ni        ( rst_n                          ),
       
               .data_req_i    (  s_lint_riscv_jtag_bus.req  ),
               .data_addr_i   (  s_lint_riscv_jtag_bus.add  ),
               .data_we_i     ( s_lint_riscv_jtag_bus.wen ),
               .data_wdata_i  ( s_lint_riscv_jtag_bus.wdata  ),
               .data_be_i     ( s_lint_riscv_jtag_bus.be  ),
               .data_aux_i    ( '0  ),
               .data_ID_i     ( '0  ),
               .data_gnt_o    ( s_lint_riscv_jtag_bus.gnt  ),
       
               .data_rvalid_o ( s_lint_riscv_jtag_bus.r_valid ),
               .data_rdata_o  ( s_lint_riscv_jtag_bus.r_rdata ),
               .data_ropc_o   (  ),
               .data_raux_o   ( ),
               .data_rID_o    (  ),
               // ---------------------------------------------------------
               // AXI TARG Port Declarations ------------------------------
               // ---------------------------------------------------------
               //AXI write address bus -------------- // USED// -----------
               .aw_id_o       ( dbg_master.aw_id             ),
               .aw_addr_o     ( dbg_master.aw_addr           ),
               .aw_len_o      ( dbg_master.aw_len            ),
               .aw_size_o     ( dbg_master.aw_size           ),
               .aw_burst_o    ( dbg_master.aw_burst          ),
               .aw_lock_o     ( dbg_master.aw_lock           ),
               .aw_cache_o    ( dbg_master.aw_cache          ),
               .aw_prot_o     ( dbg_master.aw_prot           ),
               .aw_region_o   ( dbg_master.aw_region         ),
               .aw_user_o     ( dbg_master.aw_user           ),
               .aw_qos_o      ( dbg_master.aw_qos            ),
               .aw_valid_o    ( dbg_master.aw_valid          ),
               .aw_ready_i    ( dbg_master.aw_ready          ),
               // ---------------------------------------------------------
       
               //AXI write data bus -------------- // USED// --------------
               .w_data_o      ( dbg_master.w_data            ),
               .w_strb_o      ( dbg_master.w_strb            ),
               .w_last_o      ( dbg_master.w_last            ),
               .w_user_o      ( dbg_master.w_user            ),
               .w_valid_o     ( dbg_master.w_valid           ),
               .w_ready_i     ( dbg_master.w_ready           ),
               // ---------------------------------------------------------
       
               //AXI write response bus -------------- // USED// ----------
               .b_id_i        ( dbg_master.b_id              ),
               .b_resp_i      ( dbg_master.b_resp            ),
               .b_valid_i     ( dbg_master.b_valid           ),
               .b_user_i      ( dbg_master.b_user            ),
               .b_ready_o     ( dbg_master.b_ready           ),
               // ---------------------------------------------------------
       
               //AXI read address bus -------------------------------------
               .ar_id_o       ( dbg_master.ar_id             ),
               .ar_addr_o     ( dbg_master.ar_addr           ),
               .ar_len_o      ( dbg_master.ar_len            ),
               .ar_size_o     ( dbg_master.ar_size           ),
               .ar_burst_o    ( dbg_master.ar_burst          ),
               .ar_lock_o     ( dbg_master.ar_lock           ),
               .ar_cache_o    ( dbg_master.ar_cache          ),
               .ar_prot_o     ( dbg_master.ar_prot           ),
               .ar_region_o   ( dbg_master.ar_region         ),
               .ar_user_o     ( dbg_master.ar_user           ),
               .ar_qos_o      ( dbg_master.ar_qos            ),
               .ar_valid_o    ( dbg_master.ar_valid          ),
               .ar_ready_i    ( dbg_master.ar_ready          ),
               // ---------------------------------------------------------
       
               //AXI read data bus ----------------------------------------
               .r_id_i        ( dbg_master.r_id            ),
               .r_data_i      ( dbg_master.r_data            ),
               .r_resp_i      ( dbg_master.r_resp            ),
               .r_last_i      ( dbg_master.r_last            ),
               .r_user_i      ( dbg_master.r_user            ),
               .r_valid_i     ( dbg_master.r_valid           ),
               .r_ready_o     ( dbg_master.r_ready           )
               // ---------------------------------------------------------
           );

       
//*************************************************************************************
// END DEBUG ADDING
//*************************************************************************************    

  //----------------------------------------------------------------------------//
  // Test Code
  //----------------------------------------------------------------------------//

  // introduce random stalls for data access to stress LSU
`ifdef DATA_STALL_RANDOM
  random_stalls data_stalls_i
  (
    .clk           ( clk                     ),

    .core_req_i    ( CORE.RISCV_CORE.data_req_o   ),
    .core_addr_i   ( CORE.RISCV_CORE.data_addr_o  ),
    .core_we_i     ( CORE.RISCV_CORE.data_we_o    ),
    .core_be_i     ( CORE.RISCV_CORE.data_be_o    ),
    .core_wdata_i  ( CORE.RISCV_CORE.data_wdata_o ),
    .core_gnt_o    (                         ),
    .core_rdata_o  (                         ),
    .core_rvalid_o (                         ),

    .data_req_o    (                         ),
    .data_addr_o   (                         ),
    .data_we_o     (                         ),
    .data_be_o     (                         ),
    .data_wdata_o  (                         ),
    .data_gnt_i    ( core_lsu_gnt            ),
    .data_rdata_i  ( core_lsu_rdata          ),
    .data_rvalid_i ( core_lsu_rvalid         )
  );

  initial begin
    force CORE.RISCV_CORE.data_gnt_i    = data_stalls_i.core_gnt_o;
    force CORE.RISCV_CORE.data_rvalid_i = data_stalls_i.core_rvalid_o;
    force CORE.RISCV_CORE.data_rdata_i  = data_stalls_i.core_rdata_o;

    force core_lsu_req   = data_stalls_i.data_req_o;
    force core_lsu_addr  = data_stalls_i.data_addr_o;
    force core_lsu_we    = data_stalls_i.data_we_o;
    force core_lsu_be    = data_stalls_i.data_be_o;
    force core_lsu_wdata = data_stalls_i.data_wdata_o;
  end
`endif

  // introduce random stalls for instruction access to stress instruction
  // fetcher
`ifdef INSTR_STALL_RANDOM
  random_stalls instr_stalls_i
  (
    .clk           ( clk                     ),

    .core_req_i    ( CORE.RISCV_CORE.instr_req_o  ),
    .core_addr_i   ( CORE.RISCV_CORE.instr_addr_o ),
    .core_we_i     (                         ),
    .core_be_i     (                         ),
    .core_wdata_i  (                         ),
    .core_gnt_o    (                         ),
    .core_rdata_o  (                         ),
    .core_rvalid_o (                         ),

    .data_req_o    (                         ),
    .data_addr_o   (                         ),
    .data_we_o     (                         ),
    .data_be_o     (                         ),
    .data_wdata_o  (                         ),
    .data_gnt_i    ( core_instr_gnt          ),
    .data_rdata_i  ( core_instr_rdata        ),
    .data_rvalid_i ( core_instr_rvalid       )
  );

  initial begin
    force CORE.RISCV_CORE.instr_gnt_i    = instr_stalls_i.core_gnt_o;
    force CORE.RISCV_CORE.instr_rvalid_i = instr_stalls_i.core_rvalid_o;
    force CORE.RISCV_CORE.instr_rdata_i  = instr_stalls_i.core_rdata_o;

    force core_instr_req   = instr_stalls_i.data_req_o;
    force core_instr_addr  = instr_stalls_i.data_addr_o;
  end
`endif

endmodule
