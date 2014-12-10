module alu #(parameter OPSIZE = 4, parameter DSIZE = 16)(
  output reg [DSIZE-1:0] f,
  output wire n,
  output wire c,
  output wire v,
  input [OPSIZE-1:0] op,
  input [DSIZE-1:0] data_a,
  input [DSIZE-1:0] data_b
);
  reg co;
  wire [DSIZE:0] da,db;
  
  assign da = {data_a[DSIZE-1],data_a};
  assign db = {data_b[DSIZE-1],data_b};
  
  assign c = co & v;
  assign v = (co ^ f[DSIZE-1]) & ~op[OPSIZE-1];
  assign n = co;
  
  always @(*) begin
    if (op[OPSIZE-1] == 1'b0) begin
      //Arithmec operation
      case (op[OPSIZE-2:0])
        3'b000:
        begin
          {co,f} = da;
        end
        3'b001:
        begin
          {co,f} = da +1'b1;
        end
        3'b010:
        begin
          {co,f} = da + ~db;
        end
        3'b011:
        begin
          {co,f} = da + ~db +1;
        end
        3'b100:
        begin
          {co,f} = da + db;
        end
        3'b101:
        begin
          {co,f} = da + db +1'b1;
        end
        3'b110:
        begin
          {co,f} = db;
        end
        3'b111:
        begin
          {co,f} = da -1'b1;
        end
      endcase
    end else begin
      co = 1'b0;
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
