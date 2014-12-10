module shifter #(parameter OPSIZE = 2, parameter DSIZE = 16)(
  output reg [DSIZE-1:0] f,
  input [DSIZE-1:0] data_b,
  input [OPSIZE-1:0] op
);
  
  always @(*) begin
    case(op)
      2'b00:
      begin
        f <= data_b >> {{DSIZE-1{1'b0}},1'b1};
      end
      2'b01:
      begin
        f <= data_b << {{DSIZE-1{1'b0}},1'b1};
      end
      2'b10:
      begin
        f <= data_b >> {{DSIZE-1{1'b0}},1'b1} | data_b << {1'b0,~{{(DSIZE-2){1'b0}},1'b1}};
      end
      2'b11:
      begin
        f <= data_b << {{DSIZE-1{1'b0}},1'b1} | data_b >> {1'b0,~{{(DSIZE-2){1'b0}},1'b1}};
      end
    endcase
  end
endmodule