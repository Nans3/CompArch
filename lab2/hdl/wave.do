onerror {resume}
radix define Instructions {
    "32'b?????????????????????????0110111" "LUI",
    "32'b?????????????????????????0010111" "AUIPC",
    "32'b????????????????????000001101111" "J",
    "32'b?????????????????????????1101111" "JAL",
    "32'b?????????????????000?????1100111" "JALR",
    "32'b?????????????????000?????1100011" "BEQ",
    "32'b?????????????????001?????1100011" "BNE",
    "32'b?????????????????100?????1100011" "BLT",
    "32'b?????????????????101?????1100011" "BGE",
    "32'b?????????????????110?????1100011" "BLTU",
    "32'b?????????????????111?????1100011" "BGEU",
    "32'b?????????????????000?????0000011" "LB",
    "32'b?????????????????001?????0000011" "LH",
    "32'b?????????????????010?????0000011" "LW",
    "32'b?????????????????100?????0000011" "LBU",
    "32'b?????????????????101?????0000011" "LHU",
    "32'b?????????????????000?????0100011" "SB",
    "32'b?????????????????001?????0100011" "SH",
    "32'b?????????????????010?????0100011" "SW",
    "32'b?????????????????000?????0010011" "ADDI",
    "32'b?????????????????010?????0010011" "SLTI",
    "32'b?????????????????011?????0010011" "SLTIU",
    "32'b?????????????????100?????0010011" "XORI",
    "32'b?????????????????110?????0010011" "ORI",
    "32'b?????????????????111?????0010011" "ANDI",
    "32'b0000000??????????001?????0010011" "SLLI",
    "32'b0000000??????????101?????0010011" "SRLI",
    "32'b0100000??????????101?????0010011" "SRAI",
    "32'b0000000??????????000?????0110011" "ADD",
    "32'b0100000??????????000?????0110011" "SUB",
    "32'b0000000??????????001?????0110011" "SLL",
    "32'b0000000??????????010?????0110011" "SLT",
    "32'b0000000??????????011?????0110011" "SLTU",
    "32'b0000000??????????100?????0110011" "XOR",
    "32'b0000000??????????101?????0110011" "SRL",
    "32'b0100000??????????101?????0110011" "SRA",
    "32'b0000000??????????110?????0110011" "OR",
    "32'b0000000??????????111?????0110011" "AND",
    "32'b0000000??????????000?????0001111" "FENCE",
    "32'b00000000000000000000000001110011" "ECALL",
    "32'b00000000000100000000000001110011" "EBREAK",
    "32'b?????????????????001?????1110011" "CSRRW",
    "32'b?????????????????010?????1110011" "CSRRS",
    "32'b?????????????????011?????1110011" "CSRRC",
    "32'b?????????????????101?????1110011" "CSRRWI",
    "32'b?????????????????110?????1110011" "CSRRSI",
    "32'b?????????????????111?????1110011" "CSRRCI",
    "32'b00000000001000000000000001110011" "URET",
    "32'b00010000001000000000000001110011" "SRET",
    "32'b00110000001000000000000001110011" "MRET",
    "32'b00010000010100000000000001110011" "WFI",
    "32'b0001001??????????000000001110011" "SFENCE.VMA",
    "32'b0010001??????????000000001110011" "HFENCE.BVMA",
    "32'b1010001??????????000000001110011" "HFENCE.GVMA",
    -default hexadecimal
}
radix define Functions {
    "16#00000000#" "_start" -color "SpringGreen",
    "16#00000090#" "_start_end" -color "SpringGreen",
    "16#000005AC#" "__addi" -color "SpringGreen",
    "16#00000840#" "__and" -color "SpringGreen",
    "16#00000D34#" "__andi" -color "SpringGreen",
    "16#00000F00#" "__beq" -color "SpringGreen",
    "16#000011A0#" "__bge" -color "SpringGreen",
    "16#000014A0#" "__bgeu" -color "SpringGreen",
    "16#000017D4#" "__blt" -color "SpringGreen",
    "16#00001A74#" "__bltu" -color "SpringGreen",
    "16#00001D48#" "__bne" -color "SpringGreen",
    "16#00001FEC#" "fail" -color "Goldenrod",
    "16#00002008#" "pass" -color "Goldenrod",
    "16#00002034#" "write_gpo" -color "Goldenrod",
    "16#0000203C#" "fib" -color "MediumSpringGreen",
    "16#00002120#" "zero" -color "MediumSpringGreen",
    "16#00002178#" "fib_helper" -color "MediumSpringGreen",
    "16#0000228C#" "__jal" -color "SpringGreen",
    "16#000022BC#" "__jalr" -color "SpringGreen",
    "16#00002368#" "__lui" -color "SpringGreen",
    "16#000023D4#" "__lw" -color "SpringGreen",
    "16#0000264C#" "main" -color "MediumSpringGreen",
    "16#000026E4#" "check" -color "MediumSpringGreen",
    "16#00002714#" "__or" -color "SpringGreen",
    "16#00002C14#" "__ori" -color "SpringGreen",
    "16#00002DFC#" "__sll" -color "SpringGreen",
    "16#00003388#" "__slli" -color "SpringGreen",
    "16#00003618#" "__slt" -color "SpringGreen",
    "16#00003B1C#" "__slti" -color "SpringGreen",
    "16#00003D9C#" "__sltiu" -color "SpringGreen",
    "16#0000401C#" "__sltu" -color "SpringGreen",
    "16#00004520#" "__sra" -color "SpringGreen",
    "16#00004AF8#" "__srai" -color "SpringGreen",
    "16#00004DBC#" "__srl" -color "SpringGreen",
    "16#0000537C#" "__srli" -color "SpringGreen",
    "16#00005628#" "__sub" -color "SpringGreen",
    "16#00005B24#" "__sw" -color "SpringGreen",
    "16#00005F58#" "__test_csr" -color "Goldenrod",
    "16#00005F7C#" "test_fib" -color "MediumSpringGreen",
    "16#00005FF8#" "highestBit" -color "MediumSpringGreen",
    "16#0000608C#" "test_josephus" -color "MediumSpringGreen",
    "16#00006110#" "test_store" -color "MediumSpringGreen",
    "16#000065A4#" "_halt" -color "green",
    -default hexadecimal
}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 32 ANGY
add wave -noupdate -radix decimal /testbench/DataAdr
add wave -noupdate -divider -height 32 Top
add wave -noupdate -radix hexadecimal /testbench/dut/clk
add wave -noupdate -radix hexadecimal /testbench/dut/reset
add wave -noupdate -radix hexadecimal /testbench/dut/WriteData
add wave -noupdate -radix hexadecimal /testbench/dut/DataAdr
add wave -noupdate -radix hexadecimal /testbench/dut/MemWrite
add wave -noupdate -radix hexadecimal /testbench/dut/PC
add wave -noupdate -radix hexadecimal /testbench/dut/Instr
add wave -noupdate -radix hexadecimal /testbench/dut/ReadData
add wave -noupdate -divider -height 32 Instructions
add wave -noupdate -expand -group Instructions /testbench/dut/rv32single/reset
add wave -noupdate -expand -group Instructions -color {Orange Red} /testbench/dut/rv32single/PC
add wave -noupdate -expand -group Instructions -color Orange /testbench/dut/rv32single/Instr
add wave -noupdate -expand -group Instructions -color Orange -radix Instructions /testbench/dut/rv32single/Instr
add wave -noupdate -expand -group Instructions -color Orange /testbench/dut/rv32single/dp/Instr
add wave -noupdate -expand -group Instructions -color Orange -radix Instructions /testbench/dut/rv32single/dp/Instr
add wave -noupdate -divider -height 32 Datapath
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/clk
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/reset
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/ResultSrc
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/ALUSrc
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/PCSrc
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/RegWrite
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/ImmSrc
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/ALUControl
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/Zero
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/PC
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/Instr
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/ALUResult
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/WriteData
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/ReadData
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/PCNext
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/PCPlus4
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/PCTarget
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/ImmExt
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/SrcA
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/SrcB
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/SrcAMuxout
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/Result
add wave -noupdate -divider -height 32 Control
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/op
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/funct3
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/funct7b5
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/Zero
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/ResultSrc
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/ALUSrc
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/MemWrite
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/PCSrc
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/RegWrite
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/Jump
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/ImmSrc
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/ALUControl
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/ALUOp
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/Branch
add wave -noupdate -divider -height 32 {Main Decoder}
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/md/op
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/md/ResultSrc
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/md/ALUSrc
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/md/MemWrite
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/md/Branch
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/md/RegWrite
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/md/Jump
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/md/ImmSrc
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/md/ALUOp
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/md/controls
add wave -noupdate -divider -height 32 {ALU Decoder}
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/ad/opb5
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/ad/funct3
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/ad/funct7b5
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/ad/ALUOp
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/ad/ALUControl
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/c/ad/RtypeSub
add wave -noupdate -divider -height 32 {Data Memory}
add wave -noupdate -radix hexadecimal /testbench/dut/dmem/clk
add wave -noupdate -radix hexadecimal /testbench/dut/dmem/we
add wave -noupdate -radix hexadecimal /testbench/dut/dmem/a
add wave -noupdate -radix hexadecimal /testbench/dut/dmem/wd
add wave -noupdate -radix hexadecimal /testbench/dut/dmem/rd
add wave -noupdate -divider -height 32 {Instruction Memory}
add wave -noupdate -radix hexadecimal /testbench/dut/imem/a
add wave -noupdate -radix hexadecimal /testbench/dut/imem/rd
add wave -noupdate -divider -height 32 {Register File}
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/rf/clk
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/rf/we3
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/rf/a1
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/rf/a2
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/rf/a3
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/rf/wd3
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/rf/rd1
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/rf/rd2
add wave -noupdate -radix hexadecimal /testbench/dut/rv32single/dp/rf/rf
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {46 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 142
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {202 ns}
