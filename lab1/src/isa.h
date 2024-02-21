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
#define SIGNEXT(v, sb) ((v & (1 << (sb - 1)) )?((~0)<<sb)|v:v)

int ADD (int Rd, int Rs1, int Rs2) {
  int cur = 0;
  cur = CURRENT_STATE.REGS[Rs1] + CURRENT_STATE.REGS[Rs2];
  if(Rd){
    NEXT_STATE.REGS[Rd] = cur;
  }
  return 0;

}

int SUB (int Rd, int Rs1, int Rs2) {
  int cur = 0;
  cur = CURRENT_STATE.REGS[Rs1] - CURRENT_STATE.REGS[Rs2];
  if(Rd){
    NEXT_STATE.REGS[Rd] = cur;  
  }
  return 0;

}

int SLL (int Rd, int Rs1, int Rs2) {
  if(Rd){
    NEXT_STATE.REGS[Rd] = CURRENT_STATE.REGS[Rs1] & 0x1f << CURRENT_STATE.REGS[Rs2] ;
  }
  return 0;

}

int SLT (int Rd, int Rs1, int Rs2) {
  if(Rd){
    if((signed)CURRENT_STATE.REGS[Rs1] < (signed)CURRENT_STATE.REGS[Rs2]){
      NEXT_STATE.REGS[Rd] = 1;
    }
  }
  return 0;

}

int SLTU (int Rd, int Rs1, int Rs2) {
  if(Rd){
    if((unsigned)CURRENT_STATE.REGS[Rs1] < (unsigned)CURRENT_STATE.REGS[Rs2]){
      NEXT_STATE.REGS[Rd] = 1;
    }
  }
  return 0;

}

int XOR (int Rd, int Rs1, int Rs2) {
  if(Rd){
    NEXT_STATE.REGS[Rd] = (CURRENT_STATE.REGS[Rs1] ^ CURRENT_STATE.REGS[Rs2]);
  }
  return 0;

}
int SRL (int Rd, int Rs1, int Rs2) {
  if(Rd){
    NEXT_STATE.REGS[Rd] = CURRENT_STATE.REGS[Rs1] >> CURRENT_STATE.REGS[Rs2] ;
  }
  return 0;
}


int SRA (int Rd, int Rs1, int Rs2) {
    if(Rd){
    NEXT_STATE.REGS[Rd] = CURRENT_STATE.REGS[Rs1] >> CURRENT_STATE.REGS[Rs2] ;
    NEXT_STATE.REGS[Rd] = (int)((unsigned int)CURRENT_STATE.REGS[Rs1] >> CURRENT_STATE.REGS[Rs2]);
  }
  return 0;
}

int OR (int Rd, int Rs1, int Rs2) {
  if(Rd){
      NEXT_STATE.REGS[Rd] = CURRENT_STATE.REGS[Rs1] | CURRENT_STATE.REGS[Rs2];
  }
  return 0;
    

  }

int AND (int Rd, int Rs1, int Rs2) {
  if(Rd){
    NEXT_STATE.REGS[Rd] = CURRENT_STATE.REGS[Rs1] & CURRENT_STATE.REGS[Rs2];
  }
  return 0;
}

int ADDI(int Rd, int Rs1, int Imm) {
  if(Rd){
    NEXT_STATE.REGS[Rd] = CURRENT_STATE.REGS[Rs1] + SIGNEXT(Imm,12);;
  }
  return 0;
}



int SLLI(int Rd, int Rs1, int Imm) {
  if(Rd){
    NEXT_STATE.REGS[Rd] = (CURRENT_STATE.REGS[Rs1]) << (Imm & 0x1F);
  } 
  return 0;

}

int SLTI(int Rd, int Rs1, int Imm) {
  if(Rd){
    NEXT_STATE.REGS[Rd] = ((signed)CURRENT_STATE.REGS[Rs1] < (signed)SIGNEXT(Imm,12));
  }
  return 0;

}

int SLTIU(int Rd, int Rs1, int Imm) {
  if(Rd){
    NEXT_STATE.REGS[Rd] = ((unsigned)CURRENT_STATE.REGS[Rs1] < (unsigned)SIGNEXT(Imm,12));
  }
  return 0;

}

int XORI(int Rd, int Rs1, int Imm) {
  if(Rd){
    NEXT_STATE.REGS[Rd] = (CURRENT_STATE.REGS[Rs1] ^ SIGNEXT(Imm,12));
  }
  return 0;

}

int SRLI(int Rd, int Rs1, int Imm) {
  if(Rd){
    NEXT_STATE.REGS[Rd] = (unsigned)(CURRENT_STATE.REGS[Rs1]) >> (unsigned)(Imm & 0x1F);
  } 
  return 0;

}

int SRAI(int Rd, int Rs1, int Imm) {
  if(Rd){
    NEXT_STATE.REGS[Rd] = (signed)(CURRENT_STATE.REGS[Rs1]) >> (signed)(Imm & 0x1F);
  } 
  return 0;

}


int ORI(int Rd, int Rs1, int Imm) {
  if(Rd){
    NEXT_STATE.REGS[Rd] = (CURRENT_STATE.REGS[Rs1]) | (Imm & 0x1F);
  } 
  return 0;

}

int ANDI(int Rd, int Rs1, int Imm) {
  if(Rd){
    NEXT_STATE.REGS[Rd] = (CURRENT_STATE.REGS[Rs1]) & (Imm & 0x1F);
  } 
  return 0;

}


int  BEQ(int Rs1, int Rs2, int Imm){
  if(CURRENT_STATE.REGS[Rs1] == CURRENT_STATE.REGS[Rs2]){
    NEXT_STATE.PC = CURRENT_STATE.PC+SIGNEXT(Imm<<1,13)-4;
  }
  return 0;
}

int  BNE(int Rs1, int Rs2, int Imm){
  if(CURRENT_STATE.REGS[Rs1] != CURRENT_STATE.REGS[Rs2]){
    NEXT_STATE.PC = CURRENT_STATE.PC+SIGNEXT(Imm<<1,13)-4;
  }
  return 0;
}

int  BLT(int Rs1, int Rs2, int Imm){
  if((signed)CURRENT_STATE.REGS[Rs1] < (signed)CURRENT_STATE.REGS[Rs2]){
    NEXT_STATE.PC = CURRENT_STATE.PC+SIGNEXT(Imm<<1,13)-4;
  }
  return 0;
}

int  BGE(int Rs1, int Rs2, int Imm){
  if((signed)CURRENT_STATE.REGS[Rs1] >= (signed)CURRENT_STATE.REGS[Rs2]){
    NEXT_STATE.PC = CURRENT_STATE.PC+SIGNEXT(Imm<<1,13)-4;
  }
  return 0;
}

int BLTU(int Rs1, int Rs2, int Imm){
  if((unsigned)CURRENT_STATE.REGS[Rs1] < (unsigned)CURRENT_STATE.REGS[Rs2]){
    NEXT_STATE.PC = CURRENT_STATE.PC+SIGNEXT(Imm<<1,13)-4;
  }
  return 0;
}

int BGEU(int Rs1, int Rs2, int Imm){
  if((unsigned)CURRENT_STATE.REGS[Rs1] >= (unsigned)CURRENT_STATE.REGS[Rs2]){
    NEXT_STATE.PC = CURRENT_STATE.PC+SIGNEXT(Imm<<1,13)-4;
  }
  return 0;
}

int JAL(int Rd, int Imm){
    NEXT_STATE.PC = CURRENT_STATE.PC + SIGNEXT(Imm<<1,21)-4;
    if(Rd){
      NEXT_STATE.REGS[Rd] = CURRENT_STATE.PC + 4;
    }  return 0;
}

int JALR(int Rd, int Rs1, int Imm){
    NEXT_STATE.PC = CURRENT_STATE.REGS[Rs1] + SIGNEXT(Imm,12)-4;
    if(Rd){
      NEXT_STATE.REGS[Rd] = CURRENT_STATE.PC + 4;
    }
  return 0;
}

int AUIPC(int Rd, int UpImm){
  if(Rd){
    NEXT_STATE.REGS[Rd] = (UpImm << 12) + CURRENT_STATE.PC;
  }
  return 0;
}

int LB(int Rs2, int Rs1, int Imm){
  if(Rd){
    int effectiveAddress = CURRENT_STATE.REGS[Rs1] + SIGNEXT(Imm, 12);
    int mask = ~0x3;
    int off = mem_read_32(effectiveAddress) & ~mask;
    int RD = ((CURRENT_STATE.REGS[Rd] >> (off * 8)) & 0xFF);
    NEXT_STATE.REGS[Rd] = SIGNEXT(RD, 8);
  }
  return 0;
}

int LBU(int Rs2, int Rs1, int Imm){
  if(Rd){
    int effectiveAddress = CURRENT_STATE.REGS[Rs1] + SIGNEXT(Imm, 12);
    int mask = ~0x3;
    int off = mem_read_32(effectiveAddress) & ~mask;
    int RD = ((CURRENT_STATE.REGS[Rd] >> (off * 8)) & 0xFF);
    NEXT_STATE.REGS[Rd] = RD;
  }
  return 0;
}

int LH(int Rs2, int Rs1, int Imm){
  if(Rd){
    int effectiveAddress = CURRENT_STATE.REGS[Rs1] + SIGNEXT(Imm, 12);
    int mask = ~0x3;
    int off = mem_read_32(effectiveAddress) & ~mask;
    int RD = ((CURRENT_STATE.REGS[Rd] >> (off * 16)) & 0xFFFF);
    NEXT_STATE.REGS[Rd] = SIGNEXT(RD, 16);
  }
  return 0;
}

int LHU(int Rs2, int Rs1, int Imm){
  if(Rd){
    int effectiveAddress = CURRENT_STATE.REGS[Rs1] + SIGNEXT(Imm, 12);
    int mask = ~0x3;
    int off = mem_read_32(effectiveAddress) & ~mask;
    int RD = ((CURRENT_STATE.REGS[Rd] >> (off * 16)) & 0xFFFF);
    NEXT_STATE.REGS[Rd] = RD;// check this
  }
  return 0;
}

int LW(int Rd, int Rs1, int Imm){
  if(Rd){
    int effectiveAddress = CURRENT_STATE.REGS[Rs1] + SIGNEXT(Imm, 12);
    NEXT_STATE.REGS[Rd] = mem_read_32(effectiveAddress);
  }
  return 0;
}

int LUI(int Rd, int UpImm){

  return 0;
}

int SB(int Rs2, int Rs1, int Imm){
  int effectiveAddress = CURRENT_STATE.REGS[Rs1] + SIGNEXT(Imm, 12);
  int mask = ~0x3;
  int off = effectiveAddress & ~mask;
  int RD = ((CURRENT_STATE.REGS[Rs2] >> (off * 8)) & 0xFF);
  int RD = ((mem_read_32(effectiveAddress) >> (off * 8)) & 0xFF);
  mem_write_32(effectiveAddress, RD ^ );

  return 0;
}

int SH(int Rs2, int Rs1, int Imm){
  int effectiveAddress = CURRENT_STATE.REGS[Rs1] + SIGNEXT(Imm, 12);
  
  mem_write_32(effectiveAddress, CURRENT_STATE.REGS[Rs2]);
  return 0;
}


int SW(int Rs2, int Rs1, int Imm){
  int effectiveAddress = CURRENT_STATE.REGS[Rs1] + SIGNEXT(Imm, 12);
  mem_write_32(effectiveAddress, CURRENT_STATE.REGS[Rs2]);
  return 0;
}



#endif
