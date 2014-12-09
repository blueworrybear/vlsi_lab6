module stimulus;

  parameter DSIZE = `DSIZE;
  parameter OPSIZE = `OPSIZE;
  parameter cyc = `CYC;
  
  wire [DSIZE-1:0] f;
  reg [DSIZE-1:0] data_a, data_b;
  reg [OPSIZE-1:0] op;
  reg rst_n, clk;
  
  fu fu(
  	.f(f),
  	.data_a(data_a),
  	.data_b(data_b),
  	.op(op),
  	.rst_n(rst_n),
  	.clk(clk)
  );
  
  always #(cyc/2) clk = ~clk;
  
  initial begin
    `ifdef SYN
      $sdf_annotate("fu_syn.sdf", fifo1);
      $fsdbDumpfile("fu_syn.fsdb");
    `else
      $fsdbDumpfile("fu.fsdb");
    `endif

    $fsdbDumpvars;
    $monitor($time, "");
  end
  
  initial begin
    rst_n = 0;
    clk = 1;
    data_a = 16'b0; 
    data_b = 16'b0;
    op = 5'b0;
    
    #(cyc/2) rst_n = 1;
    #(cyc) data_a = 16'b1; data_b = 16'b1; op = 5'b00100;
    #(cyc) data_a = 16'b10; data_b = 16'b1; op = 5'b00100;

    #(cyc*8);    
    $finish;
  end
endmodule
