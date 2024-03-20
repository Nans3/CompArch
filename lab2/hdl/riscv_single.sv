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
//   add          0110011   000       0000000
//   sub          0110011   000       0100000
//   and          0110011   111       0000000
//   or           0110011   110       0000000
//   slt          0110011   010       0000000
//   addi         0010011   000       immediate
//   andi         0010011   111       immediate
//   ori          0010011   110       immediate
//   slti         0010011   010       immediate
//   beq          1100011   000       immediate
//   lw	          0000011   010       immediate
//   sw           0100011   010       immediate
//   jal          1101111   immediate immediate

//              * Needed Doin *
//   auipc        0010111   immediate immediate 
//   bge          1100011   101       immediate 
//   bgeu         1100011   111       immediate  
//   blt          1100011   100       immediate  
//   bltu         1100011   110       immediate
//   bne          1100011   001       immediate  
//   jalr         1100111   000       immediate
//   lb           0000011   000       immediate  
//   lbu          0000011   100       immediate  
//   lh           0000011   001       immediate
//   lhu          0000011   101       immediate  
//   lui          0110111   immediate immediate  
//   sb           0100011   000       immediate 
//   sh           0100011   001       immediate 
//   sll          0110011   001       0000000   
//   slli         0010011   001       0000000*  
//   sltiu        0010011   011       immediate 
//   sltu         0110011   011       0000000   
//   sra          0110011   101       0100000   
//   srai         0010011   101       0100000*  
//   srl          0110011   101       0000000   
//   srli         0010011   101       0000000*  
//   xor          0110011   100       0000000   
//   xori         0010011   100       immediate 

module testbench();

   logic        clk;
   logic        reset;

   //****************
   // This is used to see if Ecall is the current instrcution
   // Main use is for exception handling, not sure if we will have time
   // to add of of that in or not
   logic [31:0] currentInstruction;

   // PC flag for exception
   logic PCException;
   //********************

   logic [31:0] WriteData;
   logic [31:0] DataAdr;
   logic MemWrite;

   //*************
  logic MemAccess;
   logic [31:0] Ecall = 32'b00000000000000000000000001110011;
  //************




   // instantiate device to be tested
   top dut(clk, reset, PCException, WriteData, DataAdr, MemWrite, currentInstruction, MemAccess);

   initial
     begin
	string memfilename;
        memfilename = {"../riscvtest/risc_vtest.memfile"};
        $readmemh(memfilename, dut.imem.RAM);
        // Added
        $readmemh(memfilename, dut.dmem.RAM);
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

    always @(negedge clk)
      begin
        if (Ecall == currentInstruction)
        begin
          $display("Simulation succeeded");
          $stop;
        end
      end

   // check results
  //  always @(negedge clk)
  //    begin
	// if(MemWrite) begin
  //          if(DataAdr === 100 & WriteData === 25) begin
  //             $display("Simulation succeeded");
  //             $stop;
  //          end else if (DataAdr !== 96) begin
  //             $display("Simulation failed");
  //             $stop;
  //          end
	// end
  //    end


  endmodule // testbench

module riscvsingle (
        input  logic clk, reset, PCException,
		    output logic [31:0] PC,
		    input  logic [31:0] Instr,
		    output logic 	MemWrite,
		    output logic [31:0] ALUResult, WriteData,
		    input  logic [31:0] ReadData,
        output logic MemAccess
        );
   logic [3:0] ALUControl;

  //***************
    logic [2:0] ImmSrc, branchctrl, loadctrl, storectrl;
    //*******************
   
   logic 				RegWrite, Jump, Zero, Load, Store, storeInstFlag;
   logic [1:0] 		ALUSrc, ResultSrc, upperImm;
   // Increased to 3 bits
   
   
   

   //Patrick really increased all controller logic
   //make sure you understall why and evrything he added
   controller c (Instr[6:0], Instr[14:12], Instr[30], Zero, 
		 ResultSrc, MemWrite, PCSrc, RegWrite, Jump, upperImm,
		 ImmSrc, ALUControl, 
     //****************************************************
     branchctrl, ALUSrc, Load, Store, loadctrl, 
     storectrl, storeInstFlag, MemAccess);
     //****************************************************

  // also expanded the datapath
   datapath dp (clk, reset, PCException, ALUSrc, ResultSrc, PCSrc,
		RegWrite, ImmSrc, ALUControl, Zero, PC, Instr,
		ALUResult, WriteData, ReadData, upperImm, branchctrl, Jump, loadctrl,
    storectrl, storeInstFlag);
   
  endmodule // riscvsingle

module controller (input  logic [6:0] op,
		   input  logic [2:0] funct3,
		   input  logic       funct7b5,
		   input  logic       Zero,
		   output logic [1:0] ResultSrc,
		   output logic       MemWrite,
		   output logic       PCSrc,
		   output logic       RegWrite, Jump,
       output logic [1:0] upperImm,
       // Immsrc, and alucontrole expanded
		   output logic [2:0] ImmSrc,
		   output logic [3:0] ALUControl,
       output logic [2:0] branchctrl,
       output logic [1:0] ALUSrc,
       output logic       Load, Store,
       output logic [2:0] loadctrl, storectrl,
       output logic       storeInstFlag,
       output logic       MemStrobe);
   
   logic [1:0] 			      ALUOp;
   logic 			      Branch;
   logic            Branchflag;
   
   maindec md (op, ResultSrc, MemWrite, Branch, RegWrite, Jump, 
   ImmSrc, ALUOp, ALUSrc, upperImm, Load, Store, MemAccess);

   aludec ad (op[5], funct3, funct7b5, ALUOp, ALUControl, storeInstFlag);
   loaddec loaddec(Load, funct3, loadctrl);
   storedec storedec(Store, funct3, storectrl);
   branchdec branchdec(Branch, funct3, branchctrl, branchflag);

   //assign PCSrc = Branch & (Zero ^ funct3[0]) | Jump;
   assign PCSrc = branchflag | Jump;
   
  endmodule // controller

module maindec (input  logic [6:0] op,
		output logic [1:0] ResultSrc,
		output logic 	   MemWrite,
		output logic 	   Branch,
		output logic 	   RegWrite, Jump,
    //ImmSrc expanded
		output logic [2:0] ImmSrc,
		output logic [1:0] ALUOp,
    output logic [1:0] ALUSrc, upperImm,
    output logic Load, Store,
    output logic MemAccess);

   // expanded
   logic [16:0] 		   controls;
   
   assign {RegWrite, ImmSrc, ALUSrc, MemWrite,
	   ResultSrc, Branch, ALUOp, Jump,
     upperImm, Load, Store, MemAccess} = controls;
   
   always_comb
     case(op)
       // Op codes or labels could be wrong
       7'b1100011: controls = 17'b0_010_00_0_00_1_01_0_00_0_0; // beq
       7'b0110011: controls = 17'b1_xxx_00_0_00_0_10_0_00_0_0; // R
       7'b0000011: controls = 17'b1_000_01_0_01_0_00_0_00_1_0; // loads
       7'b0100011: controls = 17'b0_001_01_1_00_0_00_0_00_0_1; // stores
       7'b0010011: controls = 17'b1_000_01_0_00_0_10_0_00_0_0; // I-type 
       7'b0110111: controls = 17'b1_100_01_0_00_0_00_0_01_0_0; // lui
       7'b0010111: controls = 17'b1_100_01_0_00_0_00_0_11_0_0; // auipc
       7'b1101111: controls = 17'b1_011_00_0_10_0_00_1_00_0_0; // jal
       7'b1100111: controls = 17'b1_000_01_0_11_0_10_1_00_0_0; // jalr
          default: controls = 17'bx_xxx_xx_x_xx_x_xx_x_xx_x_x; // ???
     endcase // case (op)
   
  endmodule // maindec

module aludec (input  logic       opb5,
	       input  logic [2:0] funct3,
	       input  logic 	  funct7b5,
	       input  logic [1:0] ALUOp,
         // expanded Alu control
	       output logic [3:0] ALUControl,
         output logic storeInstFlag);
   
   logic 			  RtypeSub, rightShift;
   
   assign RtypeSub = funct7b5 & opb5; // TRUE for R–type subtract
   assign rightShift = funct7b5 & (funct3 == 3'b101);

   always_comb
     case(ALUOp)
      2'b00: begin
        ALUControl = 4'b0000;   //addition
        storeInstFlag = 1'b0;   
        end
      2'b01: begin
        ALUControl = 4'b0001;   // subtraction
        storeInstFlag = 1'b0;
        end

      default: case(funct3) // works for R or I
        3'b000: begin
          if(RtypeSub)
          ALUControl = 4'b0001; // subtraction
          else
          ALUControl = 4'b0000; // add
          storeInstFlag = 1'b0; // set to low
        end
        3'b010: begin 
          ALUControl = 4'b0101; // slt, or imm
          storeInstFlag = 1'b0; // set to low
        end
        3'b110: begin 
          ALUControl = 4'b0011; // or, imm
          storeInstFlag = 1'b0; // set to low
        end
        3'b111: begin 
          ALUControl = 4'b0010; // and, imm
          storeInstFlag = 1'b0; // set to low
        end
        3'b001: begin
            ALUControl = 4'b0100; // sll, slli
            storeInstFlag = 1'b1;
        end
        3'b011: begin
            ALUControl = 4'b0110; // sltu, sltiu
            storeInstFlag = 1'b0;
        end
          3'b101: begin
            if(rightShift) ALUControl = 4'b0111; // sra, srai
            else ALUControl = 4'b1000; // srl, srli
            storeInstFlag = 1'b1;
        end
          3'b100: begin
            ALUControl = 4'b1001; 
            storeInstFlag = 1'b0;
        end
          default: begin
            ALUControl = 4'bxxxx; 
            storeInstFlag = 1'bx;
        end
        

      //  2'b00: ALUControl = 3'b000; // addition
      //  2'b01: ALUControl = 3'b001; // subtraction
      //  default: case(funct3) // R–type or I–type ALU
		  // 3'b000: if (RtypeSub)
		  //   ALUControl = 3'b001; // sub
		  // else
		  //   ALUControl = 3'b000; // add, addi
		  // 3'b010: ALUControl = 3'b101; // slt, slti
		  // 3'b110: ALUControl = 3'b011; // or, ori
		  // 3'b111: ALUControl = 3'b010; // and, andi
		  // default: ALUControl = 3'bxxx; // ???

		endcase // case (funct3)       
     endcase // case (ALUOp)
   
  endmodule // aludec

module loaddec (
       input logic Load, 
       input logic [2:0] funct3,
       output logic [2:0] loadctrl);

    //******************************************************************
    // Change the name of loadctrl and possibly the case statiement values here
    //******************************************************************

  always_comb
  if(Load) begin 
  case(funct3) 
    3'b000: loadctrl = 3'b000;
    3'b001: loadctrl = 3'b001;
    3'b010: loadctrl = 3'b010;
    3'b100: loadctrl = 3'b100;
    3'b101: loadctrl = 3'b101;
    default: loadctrl = 3'bxxx;
  endcase
  end
  else 
    loadctrl = 3'bx;

  endmodule

module storedec (
      input logic Store,
      input logic [2:0] funct3,
      output logic [2:0] storectrl
    );
    always_comb
      if(Store)begin 
      case(funct3) 
      3'b000: storectrl = 3'b000;
      3'b001: storectrl = 3'b001;
      3'b010: storectrl = 3'b010;
      default: storectrl = 3'bxxx;
      endcase
      end

      else 
      storectrl = 3'bxxx;

  endmodule

module branchdec (
  input logic Branch,
  input logic [2:0] funct3, 
  output logic [2:0] branchctrl, 
  output logic branchflag
      );
  always_comb
  if(Branch)begin
  case (funct3)
      3'b001: begin branchctrl = 3'b001;
              branchflag = 1'b1; end
      3'b000: begin branchctrl = 3'b000;
              branchflag = 1'b1; end
      3'b100: begin branchctrl = 3'b100;
              branchflag = 1'b1; end
      3'b101: begin branchctrl = 3'b101;
              branchflag = 1'b1; end
      3'b110: begin branchctrl = 3'b110;
              branchflag = 1'b1; end
      3'b111: begin branchctrl = 3'b111;
              branchflag = 1'b1; end
      default: branchctrl = 3'bx;
    endcase
  end
  else 
  branchflag = 1'b0;

  endmodule

module datapath(
     input  logic        clk, reset, PCException,
		 input  logic [1:0]  ALUSrc, ResultSrc,
		 input  logic 	     PCSrc, 
		 input  logic 	     RegWrite,
     // ImmSrc, and ALUctrl have been expanded
		 input  logic [2:0]  ImmSrc,
		 input  logic [3:0]  ALUControl,
		 output logic 	     Zero,
		 output logic [31:0] PC,
		 input  logic [31:0] Instr,
		 output logic [31:0] ALUResult, WriteData,
		 input  logic [31:0] ReadData,
     // additional
     input logic [1:0] upperImm,
     input logic [2:0] branchctrl, loadctrl, storectrl,
     input logic Jump,
     input logic storeInstFlag
     );
   
   logic [31:0] 		     PCNext, PCPlus4, PCTarget;
   logic [31:0] 		     ImmExt;
   // Add SrcC
   logic [31:0] 		     SrcA, SrcB, SrcC;
   logic [31:0] 		     Result;
   //update thest names*******************
   logic  PcSrc2;
   logic [31:0] PCTarget2, ReadData2, WriteData2;
   //update thest names*******************
   
   // next PC logic
   flopr #(32) pcreg (clk, reset, PCNext, PC);
   adder  pcadd4 (PC, 32'd4, PCPlus4);

   // changed to PCTarget2 and PCSrc 2not sure why
   adder  pcaddbranch (PC, ImmExt, PCTarget2);
   mux2 #(32)  pcmux (PCPlus4, PCTarget, PCSrc2, PCNext);

   // register file logic
   // changed to WriteData2
   regfile  rf (clk, RegWrite, Instr[19:15], Instr[24:20],
	       Instr[11:7], Result, SrcA, WriteData2);

   extend  ext (Instr[31:7], ImmSrc, ImmExt, storeInstFlag);

   // ALU logic 
   mux2 #(32)  srccmux (WriteData2, ImmExt, ALUSrc[0], SrcC);
   alu  alu (SrcA, SrcB, ALUControl, ALUResult, Zero, upperImm);
   mux3 #(32) resultmux (ALUResult, ReadData, PCPlus4,ResultSrc, Result);

   // Make sure to update names in these
   storealu storealu(storectrl, WriteData2, ALUResult, ReadData, WriteData);
   shift12 #(32) srcbmux(SrcC, Pc, upperImm, SrcB);
   loadalu loadalu(loadctrl, ReadData, ALUResult, ReadData2);

  endmodule // datapath

module adder (input  logic [31:0] a, b,
	      output logic [31:0] y);
   
   assign y = a + b;
   
  endmodule

module  PCadder(
  // flip order but it will need to change in other locations
      input logic Jump,
      input logic [31:0] a, b,
      output logic [31:0] y,
      input logic [1:0] ALUSrc);
  always_comb
  if(Jump & !ALUSrc[0] & b != 32'bx)
    y = a + b;
  else if(Jump & ALUSrc[0])
    y = b;
  else 
    y = a;

  endmodule


module extend (
         input  logic [31:7] instr,
          // extended immsrc
	       input  logic [2:0]  immsrc,

	       output logic [31:0] immext,
         input logic storeInstFlag);
   
   always_comb
     case(immsrc)
       // I−type
       3'b000: 
        begin
                  if(!storeInstFlag) 
                    immext = {{20{instr[31]}}, instr[31:20]};

                  else
                    immext = {{20{instr[31]}}, instr[24:20]};
        end

       // S−type (stores)
       3'b001:  immext = {{20{instr[31]}}, instr[31:25], instr[11:7]};

       // B−type (branches)
       3'b010:  immext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}; 

       // J−type (jal)
       3'b011:  immext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
       
       // U-type
       3'b100:  immext = {{12{instr[31:12]}}, instr[31:12]};

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

module shift12 #(parameter WIDTH = 8)
    //
    (input logic [WIDTH-1: 0] d0, d1,
    input logic [1:0] s,
    output logic [WIDTH-1:0] y);

    assign y = s[0] ? (s[1] ? (d0 << 12) + d1 : (d0 << 12)) : d0;


  endmodule


module top (
      input  logic clk, reset, PCException,
	    output logic [31:0] WriteData, DataAdr,
	    output logic 	MemWrite,
      // Added
      output logic [31:0] currentInstruction,
      output logic MemAccess);
   
   logic [31:0] 		PC, Instr, ReadData;
   
   // instantiate processor and memories
   riscvsingle rv32single (clk, reset, PCException, PC, Instr, MemWrite, DataAdr,
			   WriteData, ReadData, MemAccess);
   imem imem (PC, Instr);
   dmem dmem (clk, MemWrite, DataAdr, WriteData, ReadData);

   always_comb 
    begin
      currentInstruction = Instr;
    end
   
  endmodule // top

module imem (input  logic [31:0] a,
	     output logic [31:0] rd);
   // increased form 63 to 1500 maybe change to 1000
   logic [31:0] 		 RAM[1500:0];
   
   assign rd = RAM[a[31:2]]; // word aligned
   
  endmodule // imem

module dmem (input  logic        clk, we,
	     input  logic [31:0] a, wd,
	     output logic [31:0] rd);
   
   //Ram also increased here
   logic [31:0] 		 RAM[1500:0];
   
   assign rd = RAM[a[31:2]]; // word aligned
   always_ff @(posedge clk)
     if (we) RAM[a[31:2]] <= wd;
   
  endmodule // dmem

module alu (input  logic [31:0] a, b,
            // increased alucontrold 
            input  logic [3:0] 	alucontrol,
            output logic [31:0] result,
            output logic 	zero,
            input logic [1:0] upperImm);

   logic [31:0] 	       condinvb, sum, signop; // added signop maybe change name
   logic 		       v;              // overflow
   logic 		       isAddSub;       // true when is add or subtract operation

   assign condinvb = alucontrol[0] ? ~b : b;
   assign sum = a + condinvb + alucontrol[0];
   assign isAddSub = ~alucontrol[2] & ~alucontrol[1] |
                     ~alucontrol[1] & alucontrol[0];  

   assign signop = ~(32'hFFFFFFFF >> (b & 32'h1F)); 

   always_comb
     case (alucontrol)
       4'b0000: result = upperImm[0] ? (upperImm[1] ? sum : b) : sum; //add
       4'b0001: result = sum; // subtract
       4'b0010: result = a & b; // and
       4'b0011: result = a | b; // or
       4'b0100: result = a << (b & 32'h1f); //sll
       4'b0101: result = sum[31] ^ v; //slt
       4'b0110: result = (unsigned'(a) < b) ?1 : 0; // srl
       4'b0111: begin 
        if(a[31]) 
          result = a >> (b & 32'h1F) | signop;

        else
          result = a >> (b & 32'h1F);
       end // sra
       4'b1000: result = a >> (b & 32'h1f); // sltu
       4'b1001: result = a ^ b; // xor
       default: result = 32'bx;
     endcase

   assign zero = (result == 32'b0);
   assign v = ~(alucontrol[0] ^ a[31] ^ b[31]) & (a[31] ^ sum[31]) & isAddSub;
   
  endmodule // alu

module loadalu(
  input logic [2:0] loadctrl,
  output logic [31:0] write2Mem,
  input logic [31:0] readMem, byteAddr);

  logic [31:0] readMemShift;

  always_comb begin 
    readMemShift = readMem >> (byteAddr[1:0] * 8);
    case(loadctrl)
      3'b000: write2Mem = readMemShift[7] ? (readMemShift | 32'hFFFFFF00) : (readMemShift & 32'h000000FF);
      3'b001: write2Mem = readMemShift[15] ? (readMemShift | 32'hFFFF0000) : (readMemShift & 32'h0000FFFF);
      3'b010: write2Mem = readMem;
      3'b100: write2Mem = unsigned'(readMemShift) & 32'h000000FF;
      3'b101: write2Mem = unsigned'(readMemShift) & 32'h0000FFFF;
      default: write2Mem = 32'bx;

    endcase

  end


  endmodule



module storealu(
    input logic [2:0] storectrl,
    input logic [31:0] Regread, byteAddr, readMem,
    output logic [31:0] write2Mem
  );

  always_comb begin 
    case(storectrl)
    3'b000: begin 
      if(byteAddr[1:0] == 0) write2Mem = (readMem & 32'hFFFFFF00) | ((Regread & 32'h000000FF));
      if(byteAddr[1:0] == 1) write2Mem = (readMem & 32'hFFFF00FF) | ((Regread & 32'h000000FF) << 8);
      if(byteAddr[1:0] == 2) write2Mem = (readMem & 32'hFF00FFFF) | ((Regread & 32'h000000FF) << 16);
      if(byteAddr[1:0] == 3) write2Mem = (readMem & 32'h00FFFFFF) | ((Regread & 32'h000000FF) << 24);
    end
    3'b001: begin 
      if(byteAddr[1:0] == 0) write2Mem = (readMem & 32'hFFFF0000) | ((Regread & 32'h0000FFFF));
      if(byteAddr[1:0] == 2) write2Mem = (readMem & 32'h0000FFFF) | ((Regread & 32'h0000FFFF) << 16);
    end
    3'b010: write2Mem = Regread;
    default: write2Mem = 32'bx;
    endcase
  end


  endmodule


module branchalu(
    input logic Jump,
    input logic [31:0] a, b,
    input logic [2:0] branchctrl,
    input logic PCSource,
    output logic PCOut
    );
  always_comb
    if(PCSource & !Jump) begin 
      case(branchctrl)
        3'b001: begin
                  if(a != b) PCOut = 1'b1;
                  else PCOut = 1'b0;
                  end
          3'b000: begin
                  if(a == b) PCOut = 1'b1;
                  else PCOut = 1'b0;
                  end
          3'b100: begin
                  if(signed'(a) < signed'(b)) PCOut = 1'b1;
                  else PCOut = 1'b0;
                  end
          3'b101: begin
                  if(signed'(a) >= signed'(b)) PCOut = 1'b1;
                  else PCOut = 1'b0;
                  end
          3'b110: begin
                  if(unsigned'(a) < unsigned'(b)) PCOut = 1'b1;
                  else PCOut = 1'b0;
                  end
          3'b111: begin
                  if(unsigned'(a) >= unsigned'(b)) PCOut = 1'b1;
                  else PCOut = 1'b0;
                  end
          default: PCOut = 3'bx;
    endcase
    end
    else if(Jump) PCOut = 1'b1;
    else PCOut = 1'b0;

  endmodule


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