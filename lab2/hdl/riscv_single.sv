// riscvsingle.sv

// RISC-V single-cycle processor
// From Section 7.6 of Digital Design & Computer Architecture
// 27 April 2020
// David_Harris@hmc.edu 
// Sarah.Harris@unlv.edu

// run 210
// Expect simulator to print "Simulation succeeded"
// when the value 25 (0x19) is written to address 100 (0x64)

//   Instruction  opcode    funct3    funct7
// R Type
//   add          0110011   000       0000000
//   sub          0110011   000       0100000
//   sll          0110011   001       0000000
//   slt          0110011   010       0000000
//   sltu         0110011   011       0000000
//   xor          0110011   100       0000000 
//   srl          0110011   101       0000000
//   sra          0110011   101       0100000
//   or           0110011   110       0000000
//   and          0110011   111       0000000
// I Type -Standard
//   addi         0010011   000       immediate[11:0]
//   slli         0010011   001       immediate[11:0]
//   slti         0010011   010       immediate[11:0]
//   sltiu        0010011   011       immediate[11:0]
//   xori         0010011   100       immediate[11:0]
//   srli         0010011   101       immediate[11:0]
//   srai         0010011   101       immediate[11:0]
//   ori          0010011   110       immediate[11:0]
//   andi         0010011   111       immediate[11:0]
// I Type -Loads
//   lb           0000011   000       immediate[11:0]
//   lh           0000011   001       immediate[11:0]
//   lw	          0000011   010       immediate[11:0]
//   lbu          0000011   100       immediate[11:0]
//   lhu          0000011   101       immediate[11:0]
//   jalr         1100111   000       immediate[11:0]
// S Type
//   sb           0100011   000       immediate[11:5]
//   sh           0100011   001       immediate[11:5]
//   sw           0100011   010       immediate[11:5]
// B Type
//   beq          1100011   000       immediate
//   bne          1100011   001       0000000
//   blt          1100011   100       0000000
//   bge          1100011   101       0000000
//   bltu         1100011   110       0000000
//   bgeu         1100011   111       0000000
// U Type
//   auipc        0010111   immediate immediate
//   lui          0000000   000       0000000
// J Type
//   jal          1101111   immediate immediate







module testbench();

   logic        clk;
   logic        reset;

   logic [31:0] WriteData;
   logic [31:0] DataAdr;
   logic        MemWrite;

   // instantiate device to be tested
   top dut(clk, reset, WriteData, DataAdr, MemWrite);

   initial
     begin
	string memfilename;
        memfilename = {"../riscvtest/riscvtest.memfile"};
        $readmemh(memfilename, dut.imem.RAM);
     end

   
   // initialize test
   initial
     begin
	reset <= 1; # 22; reset <= 0;
     end

   // generate clock to sequence tests
   always
     begin
	clk <= 1; # 5; clk <= 0; # 5;
     end

   // check results
   always @(negedge clk)
     begin
	if(MemWrite) begin
           if(DataAdr === 100 & WriteData === 25) begin
              $display("Simulation succeeded");
              $stop;
           end else if (DataAdr !== 96) begin
              $display("Simulation failed");
              $stop;
           end
	end
     end
     endmodule // testbench

module riscvsingle (input  logic        clk, reset,
		    output logic [31:0] PC,
		    input  logic [31:0] Instr,
		    output logic 	MemWrite,
		    output logic [31:0] ALUResult, WriteData,
		    input  logic [31:0] ReadData);
   
   logic 				RegWrite, Jump, Zero;
   logic [1:0] 				ResultSrc, ALUSrc;
   logic [2:0]        ImmSrc;
   logic [2:0] 				ALUControl;
   
   controller c (Instr[6:0], Instr[14:12], Instr[30], Zero,
		 ResultSrc, ALUSrc, MemWrite, PCSrc,
		 RegWrite, Jump,
		 ImmSrc, ALUControl);
   datapath dp (clk, reset, ResultSrc, ALUSrc, PCSrc,
		RegWrite,
		ImmSrc, ALUControl,
		Zero, PC, Instr,
		ALUResult, WriteData, ReadData);
    endmodule // riscvsingle

module controller (input  logic [6:0] op,
		   input  logic [2:0] funct3,
		   input  logic       funct7b5,
		   input  logic       Zero,
		   output logic [1:0] ResultSrc, ALUSrc,
		   output logic       MemWrite,
		   output logic       PCSrc, 
		   output logic       RegWrite, Jump,
		   output logic [2:0] ImmSrc,
		   output logic [2:0] ALUControl);
   
   logic [2:0] 			      ALUOp;
   logic 			      Branch;
   
   maindec md (op, ResultSrc, ALUSrc, MemWrite, Branch, RegWrite, Jump, ImmSrc, ALUOp);
   aludec ad (op[5], funct3, funct7b5, ALUOp, ALUControl);
   assign PCSrc = Branch & (Zero ^ funct3[0]) | Jump;
   endmodule // controller

module maindec (input  logic [6:0] op,
		output logic [1:0] ResultSrc, ALUSrc,
		output logic 	   MemWrite,
		output logic 	   Branch, 
		output logic 	   RegWrite, Jump,
		output logic [2:0] ImmSrc,
		output logic [2:0] ALUOp);
   
   logic [13:0] 		   controls;
   
   assign {RegWrite, ImmSrc, ALUSrc, MemWrite,
	   ResultSrc, Branch, ALUOp, Jump} = controls;
   
   always_comb
     case(op)
       // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUOp_Jump
       //                        RW_ImS_AS_M_RS_B_AOp_J
       7'b0000011: controls = 14'b1_000_10_0_01_0_000_0; // Loads(lw, )
       7'b0010011: controls = 14'b1_000_10_0_00_0_010_0; // I–type ALU
       7'b0110111: controls = 14'b1_100_11_0_00_0_100_0; // ~auipc
       7'b0100011: controls = 14'b0_001_10_1_00_0_000_0; // Stores(sw, )
       7'b0110011: controls = 14'b1_xxx_00_0_00_0_010_0; // R–type()
       7'b0110111: controls = 14'b1_100_10_0_00_0_100_0; // lui
       7'b1100011: controls = 14'b0_010_00_0_00_1_001_0; // B-type(beq, ~bge)
       7'b1100111: controls = 14'b1_100_10_0_00_0_100_0; // ~jalr
       7'b1101111: controls = 14'b1_011_00_0_10_0_000_1; // jal
       
       
       default: controls = 13'bx_xxx_x_x_xx_x_xxx_x; // ???
     endcase // case (op)
    endmodule // maindec

module aludec (input  logic       opb5,
	       input  logic [2:0] funct3,
	       input  logic 	  funct7b5,
	       input  logic [2:0] ALUOp,
	       output logic [2:0] ALUControl);
   
   logic 			  RtypeSub;
   
   assign RtypeSub = funct7b5 & opb5; // TRUE for R–type subtract
   always_comb
     case(ALUOp)
       3'b000: ALUControl = 3'b000; // addition
       3'b001: ALUControl = 3'b001; // subtraction
       3'b010: ALUControl = 3'b010; // and
       3'b010: ALUControl = 3'b011; // or
       3'b010: ALUControl = 3'b101; // slt
       3'b011: ALUControl = 3'b100; // xor
       3'b100: ALUControl = 3'b110; // set B
      default: case(funct3) // R–type or I–type ALU

		  3'b000: if (RtypeSub)
		    ALUControl = 3'b001; // sub

		  else
		    ALUControl = 3'b000; // add, addi
		  3'b010: ALUControl = 3'b101; // slt, slti
		  3'b110: ALUControl = 3'b011; // or, ori
		  3'b111: ALUControl = 3'b010; // and, andi
      
		  3'b100: ALUControl = 3'b100; // xor, xori
      
		  default: ALUControl = 3'bxxx; // ???
		endcase // case (funct3)       
     endcase // case (ALUOp)
     endmodule // aludec

module datapath (input  logic        clk, reset,
		 input  logic [1:0]  ResultSrc, ALUSrc,
		 input  logic 	     PCSrc,
		 input  logic 	     RegWrite,
		 input  logic [2:0]  ImmSrc,
		 input  logic [2:0]  ALUControl,
		 output logic 	     Zero,
		 output logic [31:0] PC,
		 input  logic [31:0] Instr,
		 output logic [31:0] ALUResult, WriteData,
		 input  logic [31:0] ReadData);
   
   logic [31:0] 		     PCNext, PCPlus4, PCTarget;
   logic [31:0] 		     ImmExt;
   logic [31:0] 		     SrcA, SrcB, SrcAMuxout;
   logic [31:0] 		     Result;
   
   // next PC logic
   flopr #(32) pcreg (clk, reset, PCNext, PC);
   adder  pcadd4 (PC, 32'd4, PCPlus4);
   adder  pcaddbranch (PC, ImmExt, PCTarget);
   mux2 #(32)  pcmux (PCPlus4, PCTarget, PCSrc, PCNext);
   // register file logic
   regfile  rf (clk, RegWrite, Instr[19:15], Instr[24:20], // rs1 and rs2 19:15, 24:20
	       Instr[11:7], Result, SrcA, WriteData); // write data == rD2 :|
   extend  ext (Instr[31:7], ImmSrc, ImmExt);
   // ALU logic
   mux2 #(32)  srcbmuxA (SrcA, PC, ALUSrc[0], SrcAMuxout);
   mux2 #(32)  srcbmuxB (WriteData, ImmExt, ALUSrc[1], SrcB);
   alu  alu (SrcAMuxout, SrcB, ALUControl, ALUResult, Zero);
   mux3 #(32) resultmux (ALUResult, ReadData, PCPlus4, ResultSrc, Result);
   endmodule // datapath

module adder (input  logic [31:0] a, b,
	      output logic [31:0] y);
   
   assign y = a + b;
   endmodule

module extend (input  logic [31:7] instr,
	       input  logic [2:0]  immsrc,
	       output logic [31:0] immext);
   
   always_comb
     case(immsrc)
       // I−type
       3'b000:  immext = {{20{instr[31]}}, instr[31:20]};
       // S−type (stores)
       3'b001:  immext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
       // B−type (branches)
       3'b010:  immext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};       
       // J−type (jal)
       3'b011:  immext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
       // U−type
       3'b100:  immext = {instr[31:12],12'b0};
       
       default: immext = 32'bx; // undefined
     endcase // case (immsrc)
   endmodule // extend

module flopr #(parameter WIDTH = 8)
   (input  logic             clk, reset,
    input logic [WIDTH-1:0]  d,
    output logic [WIDTH-1:0] q);
   
   always_ff @(posedge clk, posedge reset)
     if (reset) q <= 0;
     else  q <= d;
   endmodule // flopr

module flopenr #(parameter WIDTH = 8)
   (input  logic             clk, reset, en,
    input logic [WIDTH-1:0]  d,
    output logic [WIDTH-1:0] q);
   
   always_ff @(posedge clk, posedge reset)
     if (reset)  q <= 0;
     else if (en) q <= d;
   endmodule // flopenr

module mux2 #(parameter WIDTH = 8)
   (input  logic [WIDTH-1:0] d0, d1,
    input logic 	     s,
    output logic [WIDTH-1:0] y);
   
  assign y = s ? d1 : d0;
   endmodule // mux2

module mux3 #(parameter WIDTH = 8)
   (input  logic [WIDTH-1:0] d0, d1, d2,
    input logic [1:0] 	     s,
    output logic [WIDTH-1:0] y);
   
  assign y = s[1] ? d2 : (s[0] ? d1 : d0);
   endmodule // mux3


module top (input  logic        clk, reset,
	    output logic [31:0] WriteData, DataAdr,
	    output logic 	MemWrite);
   
   logic [31:0] 		PC, Instr, ReadData;
   
   // instantiate processor and memories
   riscvsingle rv32single (clk, reset, PC, Instr, MemWrite, DataAdr,
			   WriteData, ReadData);
   imem imem (PC, Instr);
   dmem dmem (clk, MemWrite, DataAdr, WriteData, ReadData);
   endmodule

module imem (input  logic [31:0] a,
	     output logic [31:0] rd);
   
   logic [31:0] 		 RAM[63:0];
   
   assign rd = RAM[a[31:2]]; // word aligned
   endmodule // imem

module dmem (input  logic        clk, we,
	     input  logic [31:0] a, wd,
	     output logic [31:0] rd);
   
   logic [31:0] 		 RAM[255:0];
   
   assign rd = RAM[a[31:2]]; // word aligned
   always_ff @(posedge clk)
     if (we) RAM[a[31:2]] <= wd;
   endmodule // dmem

module alu (input  logic [31:0] a, b,
            input  logic [2:0] 	alucontrol,
            output logic [31:0] result,
            output logic 	zero);


   logic [31:0] 	       condinvb, sum;
   logic 		       v;              // overflow
   logic 		       isAddSub;       // true when is add or subtract operation

   assign condinvb = alucontrol[0] ? ~b : b;
   assign sum = a + condinvb + alucontrol[0];
   assign isAddSub = ~alucontrol[2] & ~alucontrol[1] |
                     ~alucontrol[1] & alucontrol[0];   
    

   always_comb
     case (alucontrol)
       3'b000:  result = sum;         // add
       3'b001:  result = sum;         // subtract
       3'b010:  result = a & b;       // and
       3'b011:  result = a | b;       // or
       3'b101:  result = sum[31] ^ v; // slt       
       3'b100:  result = a ^ b;       // xor
       3'b110:  result = b;           // set B
       default: result = 32'bx;
     endcase

   assign zero = (result == 32'b0);
   assign v = ~(alucontrol[0] ^ a[31] ^ b[31]) & (a[31] ^ sum[31]) & isAddSub;
   endmodule // alu

module regfile (input  logic        clk, 
		input  logic 	    we3, 
		input  logic [4:0]  a1, a2, a3, 
		input  logic [31:0] wd3, 
		output logic [31:0] rd1, rd2);

   logic [31:0] 		    rf[31:0];

   // three ported register file
   // read two ports combinationally (A1/RD1, A2/RD2)
   // write third port on rising edge of clock (A3/WD3/WE3)
   // register 0 hardwired to 0

   always_ff @(posedge clk)
     if (we3) rf[a3] <= wd3;	

   assign rd1 = (a1 != 0) ? rf[a1] : 0;
   assign rd2 = (a2 != 0) ? rf[a2] : 0;
   endmodule // regfile

