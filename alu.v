module alu #(parameter OPSIZE = 4, parameter DSIZE = 16)(
  output reg [DSIZE-1:0] f,
  output wire n,
  output wire c,
  output wire v,
  input [OPSIZE-1:0] op,
  input [DSIZE-1:0] data_a,
  input [DSIZE-1:0] data_b
);
  assign c = f[DSIZE-1] & ~(data_a[DSIZE-1] | data_b[DSIZE-1]) & ~op[OPSIZE-1];
  assign v = ~((f[DSIZE-1] ^ data_a[DSIZE-1]) | (f[DSIZE-1] ^ data_b[DSIZE-1])) & ~op[OPSIZE-1];
  assign n = f[DSIZE-1] & ~v & ~op[OPSIZE-1];
  
  always @(*) begin
    if (op[OPSIZE-1] == 1'b0) begin
      //Arithmec operation
      case (op[OPSIZE-2:0])
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
      case (op[OPSIZE-3:0])
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
