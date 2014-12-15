module barrel_shifter#(parameter DSIZE = 64, parameter ASIZE = 6)(
  output reg [DSIZE-1:0] out,
  input [ASIZE-1:0] amount,
  input [1:0] mode,
  input [DSIZE-1:0] in
);

  always @(*) begin
    case(mode)
      2'b00:
      begin
        out <= in << {1'b0,amount};
      end
      2'b01:
      begin
        out <= in >> {1'b0,amount} | {DSIZE{1'b1}} << ({1'b0,~amount}+1'b1);
        //out <= in >> {1'b0,amount};
      end
      2'b10:
      begin
        out <= in << {1'b0,amount} | in >> ({1'b0,~amount}+1'b1); 
      end
      2'b11:
      begin
        out <= in >> {1'b0,amount} | in << ({1'b0,~amount}+1'b1);
      end
    endcase
  end
  
endmodule