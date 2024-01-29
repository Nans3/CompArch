module testbench ();
   
// Declares signals for interfacing with regfile modules
   logic clock, we3, rd1expected, rd2expected;
   logic [4:0] ra1, ra2, wa3;
   logic [31:0] rd1, rd2, wd3, vectornum, errors;
	logic [111:0] testvectors[999:0];
   
   integer handle3;
   integer desc3;
	
   // Instantiate DUT
   regfile dut (clock,we3,ra1,ra2,wa3,wd3,rd1,rd2);

   // Setup the clock to toggle every 1 time units 
   initial 
     begin	
	clock = 1'b1;
	forever #5 clock = ~clock;
     end

   initial
     begin
	// Gives output file name
	handle3 = $fopen("rftest.out");
	// Tells when to finish simulation
	$readmemb("regfile.tv", testvectors);
	vectornum = 0; errors = 0;
	#500 $finish;		
     end
	always @(posedge clock)
		begin
			#1;
			{we3,ra1,ra2,wa3,wd3,rd1expected,rd2expected} = testvectors[vectornum];
		//	 1+5+5+5+32+32+32=112
		end
always @(negedge clk)
	if (rd1 !== rd1expected | rd2 !== rd1expected) begin // check result
		$display("Error: inputs = %b_%b_%b_%b_%b", {we3,ra1,ra2,wa3,wd3});
		$display(" outputs cout s = %b%b (%b%b expected)",rd1, rd2, rd1expected, rd2expected);
		errors = errors + 1;
	end
	vectornum = vectornum + 1;
	if (testvectors[vectornum] === 'bx) begin
		$display("%d tests completed with %d errors", vectornum, errors);
		$stop;
	end
	
endmodule // regfile

