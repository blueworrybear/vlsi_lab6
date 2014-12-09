module shifter #(parameter OPSIZE = 2, parameter DSIZE = 16)(
  output reg [DSIZE-1:0] f,
  input [DSIZE-1:0] data_a,
  input [DSIZE-1:0] data_b,
  input [OPSIZE-1:0] op,
  input rst_n,
  input clk
);

 reg [OPSIZE-1:0] opcode;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      opcode <= { OPSIZE{1'b0} };
    end else begin
      opcode <= op;
    end
  end
  
  always @(*) begin
    case(opcode)
      2'b00:
      begin
        f <= data_a >> data_b;
      end
      2'b01:
      begin
        f <= data_a << data_b;
      end
      2'b10:
      begin
        f <= data_a >> data_b | data_a << ~data_b;
      end
      2'b11:
      begin
        f <= data_a << data_b | data_a >> ~data_b;
      end
    endcase
  end
endmodule