module fu #(parameter OPSIZE = 5, parameter DSIZE = 16)(
  output reg [DSIZE-1:0] f,
  input [DSIZE-1:0] data_a,
  input [DSIZE-1:0] data_b,
  input [OPSIZE-1:0] op,
  input rst_n,
  input clk
);

wire [DSIZE-1:0] f_alu, f_shifter;

  alu alu(
  	.f(f_alu),
  	.op(op[OPSIZE-2:0]),
  	.data_a(data_a),
  	.data_b(data_b),
  	.rst_n(rst_n),
  	.clk(clk)
  );
  
  shifter shifter(
  	.f(f_shifter),
  	.data_a(data_a),
  	.data_b(data_b),
  	.op(op[OPSIZE-4:0]),
  	.rst_n(rst_n),
  	.clk(clk)
  );

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      f <= {DSIZE{1'b1}};
    end else begin
      case (op[OPSIZE-1])
        1'b0:
        begin
          f <= f_alu;
        end
        1'b1:
        begin
          f <= f_shifter;
        end
      endcase
    end
  end

endmodule
