module stimulus;

  parameter DSIZE = 64;
  parameter OPSIZE = 5;
  parameter ASIZE = 6;
  parameter cyc = 10;
  parameter delay = 1;
  parameter mem_size = 200;
  
  //variables for pattern
  reg [DSIZE*4+OPSIZE*2+ASIZE+3-1:0] vector [0:mem_size-1];
  reg [4+DSIZE-1:0] respond [0:mem_size-1];
  reg [DSIZE-1:0] OUT_r;
  reg N_r,R_r,O_r,Z_r;
  reg error;
  integer index;
  //signals for fu module
  wire [DSIZE-1:0] OUT;
  wire N,R,O,Z;
  reg [DSIZE-1:0] A, B, C, D;
  reg [OPSIZE-1:0] OP1,OP2;
  reg [ASIZE-1:0] SHF_AMT;
  reg [1:0] SHF_MODE;
  reg clk,SEL;
  
  fu2 fu2(
  	.OUT(OUT),
  	.Z(Z),
  	.R(R),
  	.O(O),
  	.N(N),
  	.A(A),
  	.B(B),
  	.C(C),
  	.D(D),
  	.OP1(OP1),
  	.OP2(OP2),
  	.SHF_AMT(SHF_AMT),
  	.SHF_MODE(SHF_MODE),
  	.SEL(SEL),
  	.CLK(clk)
  );
  
  always #(cyc/2) clk = ~clk;
  
  always @(posedge clk) begin
    OUT_r = respond [index-1][DSIZE+4-1:4];
    Z_r = respond [index-1][3];
    N_r = respond [index-1][2];
    R_r = respond [index-1][1];
    O_r = respond [index-1][0];
    #(delay);
    if (respond [index-1] == {OUT,Z,N,R,O}) begin
      error = 1'b0;
    end else begin
      error = 1'b1;
    end
  end
  
  initial begin
    `ifdef SYN
      $sdf_annotate("fu2.sdf", fu);
      $fsdbDumpfile("fu2_syn.fsdb");
    `else
      $fsdbDumpfile("fu2.fsdb");
    `endif

    $fsdbDumpvars;
    $monitor($time, "");
  end
  
  initial begin
    $readmemb("pattern.dat",vector);
    $readmemb("gold.dat",respond);
    
    clk = 0;
    
    #(cyc/2)

    for(index = 0; index < mem_size; index = index +1) begin
      instruction(vector[index]);
    end
    
    #(cyc*8);    
    $finish;
  end
  
  task instruction;
    input [DSIZE*4+OPSIZE*2+ASIZE+3-1:0] ins;
    begin
      #(cyc)
      A = ins[DSIZE*4+OPSIZE*2+ASIZE+3-1:DSIZE*3+OPSIZE*2+ASIZE+3];
      B = ins[DSIZE*3+OPSIZE*2+ASIZE+3-1:DSIZE*2+OPSIZE*2+ASIZE+3];
      C = int[DSIZE*2+OPSIZE*2+ASIZE+3-1:DSIZE+OPSIZE*2+ASIZE+3];
      D = int[DSIZE+OPSIZE*2+ASIZE+3-1:OPSIZE*2+ASIZE+3];
      SEL = int[OPSIZE*2+ASIZE+3-1:OPSIZE*2+ASIZE+2];
      SHF_MODE = int[OPSIZE*2+ASIZE+2-1:OPSIZE*2+ASIZE];
      SHF_AMT = int[OPSIZE*2+ASIZE-1:OPSIZE*2];
      OP1 = int[OPSIZE*2-1:OPSIZE];
      OP2 = int[OPSIZE-1:0];
    end
  endtask
    
endmodule
