module alu #(parameter OPSIZE = 4, parameter DSIZE = 16)(
  output reg [DSIZE-1:0] f,
  input [OPSIZE-1:0] op,
  input [DSIZE-1:0] data_a,
  input [DSIZE-1:0] data_b,
  input rst_n,
  input clk
);
  
  reg [OPSIZE-1:0] opcode;
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      opcode <= {OPSIZE{1'b0}};
    end else begin
      opcode <= op;
    end
  end
  
  always @(*) begin
    if (opcode[OPSIZE-1] == 1'b0) begin
      //Arithmec operation
      case (opcode[OPSIZE-2:0])
        3'b000:
        begin
          f = data_a;
        end
        3'b001:
        begin
          f = data_a +1'b1;
        end
        3'b010:
        begin
          f = data_a + ~data_b;
        end
        3'b011:
        begin
          f = data_a + ~data_b +1;
        end
        3'b100:
        begin
          f = data_a + data_b;
        end
        3'b101:
        begin
          f = data_a + data_b +1'b1;
        end
        3'b110:
        begin
          f = data_b;
        end
        3'b111:
        begin
          f = data_a -1'b1;
        end
      endcase
    end else begin
      case (opcode[OPSIZE-3:0])
        2'b00:
        begin
          f = data_a & data_b;
        end
        2'b01:
        begin
          f = data_a | data_b;
        end
        2'b10:
        begin
          f = data_a ^ data_b;
        end
        2'b11:
        begin
          f = ~data_a;
        end
      endcase
    end
  end
  
endmodule
