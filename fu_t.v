module stimulus;

  parameter DSIZE = `DSIZE;
  parameter OPSIZE = `OPSIZE;
  parameter cyc = `CYC;
  parameter mem_size = `MEMSIZE;
  
  //variables for pattern
  reg [OPSIZE+DSIZE+DSIZE-1:0] vector [0:mem_size-1];
  reg [4+DSIZE-1:0] respond [0:mem_size-1];
  reg error;
  integer index;
  //signals for fu module
  wire [DSIZE-1:0] F_o;
  wire N_o,C_o,V_o,Z_o;
  reg [DSIZE-1:0] data_a, data_b;
  reg [OPSIZE-1:0] op;
  reg rst_n, clk;
  
  fu fu(
  	.F_o(F_o),
  	.N_o(N_o),
  	.C_o(C_o),
  	.V_o(V_o),
  	.Z_o(Z_o),
  	.data_a(data_a),
  	.data_b(data_b),
  	.op(op),
  	.rst_n(rst_n),
  	.clk(clk)
  );
  
  always #(cyc/2) clk = ~clk;
  
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      error = 1'b0;
    end else begin
      if (respond [index-1] == {Z_o,N_o,C_o,V_o,F_o}) begin
        error = 1'b0;
      end else begin
        error = 1'b1;
      end
    end
  end
  
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
    $readmemb("pattern.dat",vector);
    $readmemb("gold.dat",respond);
    
    rst_n = 0;
    clk = 0;
    data_a = 16'b0; 
    data_b = 16'b0;
    op = 5'b0;
    
    #(cyc) rst_n = 1;

    for(index = 0; index < mem_size; index = index +1) begin
      instruction(vector[index]);
    end
    
    #(cyc*8);    
    $finish;
  end
  
  task instruction;
    input [OPSIZE+DSIZE+DSIZE-1:0] ins;
    begin
      #(cyc) op = ins[OPSIZE+DSIZE+DSIZE-1:DSIZE+DSIZE]; data_a = ins[DSIZE+DSIZE-1:DSIZE]; data_b = ins[DSIZE-1:0];  
    end
  endtask
    
endmodule
