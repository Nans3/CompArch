module regfile (input logic         clk, 
		input logic 	    we3, 
		input logic [4:0]   ra1, ra2, wa3, 
		input logic [31:0]  wd3, 
    //input logic [31:0] 		    erf[31:0],
		output logic [31:0] rd1, rd2);
   
  logic [31:0] rf[31:0];
//
  //  initial begin
  // rf <= erf;
  //  end
   
   // three ported register file
   // read two ports combinationally
   // write third port on rising edge of clock
   // register 0 hardwired to 0

   always_ff @ (posedge clk) 
    begin
      if(we3) rf[wa3] <= (wa3 != 5'b0) ? wd3 : 32'b0; 
    end
   
   assign rd1 = rf[ra1];
   assign rd2 = rf[ra2];
      
endmodule // regfile
