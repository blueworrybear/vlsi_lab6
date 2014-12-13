module datapath #(parameter OPSIZE = 5, parameter DSIZE = 16)(
  output reg [DSIZE-1:0] F_o,
  output reg N_o,
  output reg C_o,
  output reg V_o,
  output reg Z_o,
  input [DSIZE-1:0] data_a,
  input [DSIZE-1:0] data_b,
  input [OPSIZE-1:0] op
);

  wire [DSIZE-1:0] f_alu, f_shifter;
  wire n,c,v;
  
  alu alu(
    .f(f_alu),
    .n(n),
    .c(c),
    .v(v),
    .op(op[OPSIZE-2:0]),
    .data_a(data_a),
    .data_b(data_b)
  );
  
  shifter shifter(
    .f(f_shifter),
    .data_b(data_b),
    .op(op[OPSIZE-4:0])
  );

  always @(*) begin
    case (op[OPSIZE-1])
      1'b0:
      begin
        F_o <= f_alu;
        N_o <= n;
        C_o <= c;
        V_o <= v;
      end
      1'b1:
      begin
        F_o <= f_shifter;
        N_o <= 1'b0;
        C_o <= 1'b0;
        V_o <= 1'b0;
      end
    endcase    
  end
  
  always @(*) begin
    if( F_o == {DSIZE{1'b0}} ) begin
      Z_o = 1'b1;
    end else begin
      Z_o = 1'b0;
    end
  end
endmodule
