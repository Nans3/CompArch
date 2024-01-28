module testbench ();
   
// Declares signals for interfacing with regfile modules
    logic clock;
    logic [4:0]   ra1, ra2;
    logic [31:0] rd1, rd2;
   
   integer handle3;
   integer desc3;

    logic [31:0] RefReg[31:0];
    assign RefReg[5'b00000] = 32'b00000000000000000000000000000000;
    assign RefReg[5'b00001] = 32'b00101011100101110001010010000101;
    assign RefReg[5'b00010] = 32'b00110110000111000111101001011100;
    assign RefReg[5'b00011] = 32'b10110111001010111010000011111000;
    assign RefReg[5'b00100] = 32'b11100000111111010110110001101000;
    assign RefReg[5'b00101] = 32'b01101101110001000101000010110010;
    assign RefReg[5'b00110] = 32'b00101101110011110000111110001011;
    assign RefReg[5'b00111] = 32'b11111011110101101111010001111001;
    assign RefReg[5'b01000] = 32'b11000001100011111000100001000010;
    assign RefReg[5'b01001] = 32'b01000011011010110110110011101010;
    assign RefReg[5'b01010] = 32'b00110111101000100010011011110100;
    assign RefReg[5'b01011] = 32'b01011100000111010010101111110011;
    assign RefReg[5'b01100] = 32'b00101110010100001001000011101111;
    assign RefReg[5'b01101] = 32'b01111110111001110000100000011101;
    assign RefReg[5'b01110] = 32'b11100011110010010111110010110101;
    assign RefReg[5'b01111] = 32'b11110000001110110101000101001011;
    assign RefReg[5'b10000] = 32'b00001100001111011100100100101011;
    assign RefReg[5'b10001] = 32'b00011110110100101110011110101010;
    assign RefReg[5'b10010] = 32'b01110101011010100111011010010000;
    assign RefReg[5'b10011] = 32'b10011001100110111001000110111100;
    assign RefReg[5'b10100] = 32'b11110011101011001000101000110110;
    assign RefReg[5'b10101] = 32'b10110010111011111111001001100010;
    assign RefReg[5'b10110] = 32'b10010101000010101011011110000010;
    assign RefReg[5'b10111] = 32'b00010100111000001111001000001011;
    assign RefReg[5'b11000] = 32'b01100000100101010100001101110010;
    assign RefReg[5'b11001] = 32'b01001000001100110101011011000111;
    assign RefReg[5'b11010] = 32'b00100101111110101000011110101001;
    assign RefReg[5'b11011] = 32'b00000110010110110110111011111101;
    assign RefReg[5'b11100] = 32'b10101111011100010010010110011110;
    assign RefReg[5'b11101] = 32'b11110001110110011101101000011111;
    assign RefReg[5'b11110] = 32'b10010010110011000001001111000111;
    assign RefReg[5'b11111] = 32'b10011010110010001100101000010000;


   // Instantiate DUT
   regfile dut (clock,1'b0,ra1,ra2,5'b00000,32'b01111110111001110000100000011101,RefReg,rd1, rd2);

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
	#500 $finish;		
     end

   always 
     begin
	desc3 = handle3;
	#5 $fdisplay(desc3, "%b || %b\n%b || %b\n\n", 
		   ra1, rd1, ra2, rd2);

   end   
   
   initial 
     begin      
	#0  ra1 = 5'b0;
	#0  ra2 = 5'b11110;
	#22 ra1 = 5'b11110;
	#0 ra2 = 5'b0;
	// #12 reset_b = 1'b1;	
	// #0  In = 1'b0;
	// #20 In = 1'b1;
	// #20 In = 1'b0;
     end

endmodule // regfile

