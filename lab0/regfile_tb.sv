module testbench ();
   
// Declares signals for interfacing with regfile modules
   logic clock, we3;
   logic [4:0] ra1, ra2, wa3;
   logic [31:0] rd1, rd2, wd3, errors, rd1expected, rd2expected;
	logic [111:0] testvectors[31:0];
   
   integer handle3;
   integer desc3;
   integer vectornum;
	
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
			we3 = testvectors[vectornum][111];
			ra1 = testvectors[vectornum][110:106];
			ra2 = testvectors[vectornum][105:101];
			wa3 = testvectors[vectornum][100:96];
			wd3 = testvectors[vectornum][95:64];
			rd1expected = testvectors[vectornum][63:32];
			rd2expected = testvectors[vectornum][31:0];

		//	 1+5+5+5+32+32+32=112
		end
always @(negedge clock)
	begin
		//$display("Write Enable: %b\n",we3);
		//$display("Vector: %b",testvectors[vectornum]);
		//$display("Vector: %b",{we3,ra1,ra2,wa3,wd3,rd1expected,rd2expected});

		if (rd1 !== rd1expected || rd2 !== rd1expected) begin // check result
			$display("Error: inputs = %b_%b_%b_%b_%b", we3,ra1,ra2,wa3,wd3);
			$display("Error: outputs rd1 = %b (%b expected)\nError: rd2 = %b (%b expected)\n\n",rd1, rd1expected, rd2, rd2expected);
			errors = errors + 1;
		end
		
		if (vectornum >= 31) begin
			$display("%d tests completed with %d errors", vectornum+1, errors);
			$stop;
		end
		#3;
		vectornum = vectornum + 1;
	end
	
	
endmodule // regfile

