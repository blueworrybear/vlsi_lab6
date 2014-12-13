module fu2#(parameter DSIZE = 64, parameter OPSIZE = 5, parameter ASIZE = 6)(
  output reg [DSIZE-1:0] OUT,
  output reg Z,
  output reg R,
  output reg O,
  output reg N,
  input [DSIZE-1:0] A,
  input [DSIZE-1:0] B,
  input [DSIZE-1:0] C,
  input [DSIZE-1:0] D,
  input [OPSIZE-1:0] OP1,
  input [OPSIZE-1:0] OP2,
  input [ASIZE-1:0] SHF_AMT,
  input [1:0] SHF_MODE,
  input SEL,
  input CLK
  
);
  
  wire n1,r1,o1,n2,r2,o2,z1,z2;
  wire [DSIZE-1:0] f1,f2;
  wire [DSIZE-1:0] shf_in, shf_out;
  
  assign shf_in = (SEL==1'b0) ? C : f1;
  
  datapath #(.DSIZE(DSIZE)) datapath1(
  	.F_o(f1),
  	.N_o(n1),
  	.C_o(r1),
  	.V_o(o1),
  	.Z_o(z1),
  	.data_a(A),
  	.data_b(B),
  	.op(OP1)
  );
  
  datapath #(.DSIZE(DSIZE)) datapath2(
    .F_o(f2),
    .N_o(n2),
    .C_o(r2),
    .V_o(o2),
    .Z_o(z2),
    .data_a(D),
    .data_b(shf_out),
    .op(OP2)
  );
  
  barrel_shifter barrel_shifter(
  	.out(shf_out),
  	.amount(SHF_AMT),
  	.mode(SHF_MODE),
  	.in(shf_in)
  );
  
  always @(posedge CLK) begin
    if (SEL == 1'b0) begin
      OUT <= f2;
      N <= n2;
      R <= r2;
      O <= o2;
      Z <= z2;
    end else begin
      OUT <= shf_out;
      N <= 1'b0;
      R <= 1'b0;
      O <= 1'b0;
      if (shf_out == {DSIZE{1'b0}}) begin
        Z <= 1'b1;
      end else begin
        Z <= 1'b0;
      end
    end
  end
endmodule