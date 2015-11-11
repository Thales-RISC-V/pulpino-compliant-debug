
module boot_code
(
    input  logic        CLK,
    input  logic        RSTN,

    input  logic        CSN,
    input  logic [8:0]  A,
    output logic [63:0] Q
  );

  const logic [63:0] mem[0:511] = {
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000,
    64'h0000000000000000};

  logic [9:0] A_Q;

  always_ff @(posedge CLK)
  begin
    if (~RSTN)
      A_Q <= '0;
    else
      if (~CSN)
        A_Q <= A;
  end

  assign Q = mem[A_Q];

endmodule