/***************************************************************/
/*                                                             */
/*   RISC-V RV32 Instruction Level Simulator                   */
/*                                                             */
/*   ECEN 4243                                                 */
/*   Oklahoma State University                                 */
/*                                                             */
/****************************************************************/


// OFFICE HOUR: ATRC 306 @ 1:30 PM Monday & try for whenever the rest of the week.

#ifndef _SIM_ISA_H_
#define _SIM_ISA_H_

#include <stdio.h>
#include <stdlib.h> 
#include <string.h>
#include "shell.h"

//
// MACRO: Check sign bit (sb) of (v) to see if negative
//   if no, just give number
//   if yes, sign extend (e.g., 0x80_0000 -> 0xFF80_0000)
//
#define SIGNEXT(v, sb) ((v) | (((v) & (1 << (sb))) ? ~((1 << (sb))-1) : 0))

int ADD (int Rd, int Rs1, int Rs2, int Funct3) {

  int cur = 0;
  cur = CURRENT_STATE.REGS[Rs1] + CURRENT_STATE.REGS[Rs2];
  NEXT_STATE.REGS[Rd] = cur;
  return 0;

}

int SUB (int Rd, int Rs1, int Rs2, int Funct3) {

  int cur = 0;
  cur = CURRENT_STATE.REGS[Rs1] - CURRENT_STATE.REGS[Rs2];
  NEXT_STATE.REGS[Rd] = cur;
  return 0;

}

int SLL (int Rd, int Rs1, int Rs2, int Funct3) {
// ?
  NEXT_STATE.REGS[Rd] = CURRENT_STATE.REGS[Rs1] & 0x1f;
  return 0;

}

int SLT (int Rd, int Rs1, int Rs2, int Funct3) {
// ?
  int cur = 0;
  cur = CURRENT_STATE.REGS[Rs1] < CURRENT_STATE.REGS[Rs2];
  NEXT_STATE.REGS[Rd] = cur;
  return 0;

}

int SLTU (int Rd, int Rs1, int Rs2, int Funct3) {
// ?
  int cur = 0;
  cur = CURRENT_STATE.REGS[Rs1] < CURRENT_STATE.REGS[Rs2];
  NEXT_STATE.REGS[Rd] = cur;
  return 0;

}

int XOR (int Rd, int Rs1, int Rs2, int Funct3) {
// ?
  int cur = 0;
  cur = CURRENT_STATE.REGS[Rs1] < CURRENT_STATE.REGS[Rs2];
  NEXT_STATE.REGS[Rd] = cur;
  return 0;

}

int SRL (int Rd, int Rs1, int Rs2, int Funct3) {
// ?
  int cur = 0;
  cur = CURRENT_STATE.REGS[Rs1] < CURRENT_STATE.REGS[Rs2];
  NEXT_STATE.REGS[Rd] = cur;
  return 0;

}

int SRA (int Rd, int Rs1, int Rs2, int Funct3) {
// ?
  int cur = 0;
  cur = CURRENT_STATE.REGS[Rs1] < CURRENT_STATE.REGS[Rs2];
  NEXT_STATE.REGS[Rd] = cur;
  return 0;

}

int OR (int Rd, int Rs1, int Rs2, int Funct3) {
// ?
  int cur = 0;
  cur = CURRENT_STATE.REGS[Rs1] < CURRENT_STATE.REGS[Rs2];
  NEXT_STATE.REGS[Rd] = cur;
  return 0;

}

int AND (int Rd, int Rs1, int Rs2, int Funct3) {
// ?
  int cur = 0;
  cur = CURRENT_STATE.REGS[Rs1] < CURRENT_STATE.REGS[Rs2];
  NEXT_STATE.REGS[Rd] = cur;
  return 0;

}

int ADDI(int Rd, int Rs1, int Imm, int Funct3) {

  int cur = 0;
  cur = CURRENT_STATE.REGS[Rs1] + SIGNEXT(Imm,12);
  NEXT_STATE.REGS[Rd] = cur;
  return 0;

}

// ***********

int SLLI(int Rd, int Rs1, int Imm, int Funct3) {

  int cur = 0;
  cur = CURRENT_STATE.REGS[Rs1] + SIGNEXT(Imm,12);
  NEXT_STATE.REGS[Rd] = cur;
  return 0;

}

int SLTI(int Rd, int Rs1, int Imm, int Funct3) {

  int cur = 0;
  cur = CURRENT_STATE.REGS[Rs1] + SIGNEXT(Imm,12);
  NEXT_STATE.REGS[Rd] = cur;
  return 0;

}

int SLTIU(int Rd, int Rs1, int Imm, int Funct3) {

  int cur = 0;
  cur = CURRENT_STATE.REGS[Rs1] + SIGNEXT(Imm,12);
  NEXT_STATE.REGS[Rd] = cur;
  return 0;

}

int XORI(int Rd, int Rs1, int Imm, int Funct3) {

  int cur = 0;
  cur = CURRENT_STATE.REGS[Rs1] + SIGNEXT(Imm,12);
  NEXT_STATE.REGS[Rd] = cur;
  return 0;

}

int SRLI(int Rd, int Rs1, int Imm, int Funct3) {

  int cur = 0;
  cur = CURRENT_STATE.REGS[Rs1] + SIGNEXT(Imm,12);
  NEXT_STATE.REGS[Rd] = cur;
  return 0;

}

int SRAI(int Rd, int Rs1, int Imm, int Funct3) {

  int cur = 0;
  cur = CURRENT_STATE.REGS[Rs1] + SIGNEXT(Imm,12);
  NEXT_STATE.REGS[Rd] = cur;
  return 0;

}

int ORI(int Rd, int Rs1, int Imm, int Funct3) {

  int cur = 0;
  cur = CURRENT_STATE.REGS[Rs1] + SIGNEXT(Imm,12);
  NEXT_STATE.REGS[Rd] = cur;
  return 0;

}

int ANDI(int Rd, int Rs1, int Imm, int Funct3) {

  int cur = 0;
  cur = CURRENT_STATE.REGS[Rs1] + SIGNEXT(Imm,12);
  NEXT_STATE.REGS[Rd] = cur;
  return 0;

}

// ***********

// int BNE (int Rs1, int Rs2, int Imm, int Funct3) {

//   int cur = 0;
//   Imm = Imm << 1;
//   if (CURRENT_STATE.REGS[Rs1] != CURRENT_STATE.REGS[Rs2])
//     NEXT_STATE.PC = (CURRENT_STATE.PC - 4) + (SIGNEXT(Imm,13));
//   return 0;

// }

int  BEQ(int Rs1, int Rs2, int Label){
  // FIL
  return 0;
}
int  BNE(int Rs1, int Rs2, int Label){
  // FIL
  return 0;
}
int  BLT(int Rs1, int Rs2, int Label){
  // FIL
  return 0;
}
int  BGE(int Rs1, int Rs2, int Label){
  // FIL
  return 0;
}
int BLTU(int Rs1, int Rs2, int Label){
  // FIL
  return 0;
}
int BGEU(int Rs1, int Rs2, int Label){
  // FIL
  return 0;
}

int JAL(int Rd, int Label){
  // FIL
  return 0;
}

int JALR(int Rd, int Rs1, int Imm){
  // FIL
  return 0;
}

int AUIPC(int Rd, int UpImm){
  // FIL
  return 0;
}

int LUI(int Rd, int UpImm){
  // FIL
  return 0;
}

int SB(int Rs2, int Rs1){
  //FIL
  return 0;
}
int SH(int Rs2, int Rs1){
  //FIL
  return 0;
}
int SW(int Rs2, int Rs1){
  //FIL
  return 0;
}

// I Instructions
int LB (char* i_);
int LH (char* i_);
int LW (char* i_);
int LBU (char* i_);
int LHU (char* i_);
int SLLI (char* i_);
int SLTI (char* i_);
int SLTIU (char* i_);
int XORI (char* i_);
int SRLI (char* i_);
int SRAI (char* i_);
int ORI (char* i_);
int ANDI (char* i_);

// U Instruction
int AUIPC (char* i_);
int LUI (char* i_);

// S Instruction
int SB (char* i_);
int SH (char* i_);
int SW (char* i_);

// R instruction
int SUB (char* i_);
int SLL (char* i_);
int SLT (char* i_);
int SLTU (char* i_);
int XOR (char* i_);
int SRL (char* i_);
int SRA (char* i_);
int OR (char* i_);
int AND (char* i_);

// B instructions
int BEQ (char* i_);
int BLT (char* i_);
int BGE (char* i_);
int BLTU (char* i_);
int BGEU (char* i_);

// I instruction
int JALR (char* i_);

// J instruction
int JAL (char* i_);

int ECALL (char* i_){return 0;}

#endif
