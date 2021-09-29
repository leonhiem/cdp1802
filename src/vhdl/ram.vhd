LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.instr_pkg.ALL;


ENTITY ram IS
  PORT (
    address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    data    : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    nWE, nCS, nOE: IN STD_LOGIC
  );
END ram;

ARCHITECTURE str OF ram IS

TYPE ram_type IS ARRAY (0 to 267) OF std_logic_vector(7 DOWNTO 0);

SIGNAL ram1 : ram_type:= (
-- Testprogram
-- instr    addr mnemonic  description
  c_SEX_2, -- 0x00: X=2
  c_SEQ,   -- 0x01: Q=1
  c_GHI_0, -- 0x02: R(N).1->D (N=0) : D will be 0
  c_PHI_3, -- 0x03: D->R(N).1 (N=3) : R(3).1 will be 0
  c_LDI,   -- 0x04: M(R(P))->D; R(P)+1 : D will be 0x1C
  X"1C",   -- 0x05: 0x1C
  c_PLO_3, -- 0x06: D->R(N).0 (N=3) : R(3).0 will be 0x1C
  c_STR_3, -- 0x07: D->M(R(N))(N=3) : addr 0x1C will be 0x1C
  c_INC_3, -- 0x08: R(N)+1          : R(3) will be 0x001D
  c_SEX_3, -- 0x09: X=3
  c_STXD,  -- 0x0A: D->M(R(X)); R(X)-1 : addr 0x1D will be 0x1C, R(3) will be 0x001C
  c_IRX,   -- 0x0B: R(X)+1          : R(3) will be 0x001D
  c_IRX,   -- 0x0C: R(X)+1          : R(3) will be 0x001E
  c_GLO_3, -- 0x0D: R(N).0->D (N=3) : D will be 0x1E
  c_STR_3, -- 0x0E: D->M(R(N))(N=3) : addr 0x1E will be 0x1E
  c_NOP,   -- 0x0F: NOP
  c_LDA_3, -- 0x10: M(R(N))->D; R(N)+1 (N=3) : D will be 0x1E, R(3) will be 0x001F
  c_STR_3, -- 0x11: D->M(R(N))(N=3) : addr 0x1F will be 0x1E
  c_LDN_3, -- 0x12: M(R(N))->D(N=3) : D will be 0x1E
  c_INC_3, -- 0x13: R(N)+1          : R(3) will be 0x0020
  c_STR_3, -- 0x14: D->M(R(N))(N=3) : addr 0x20 will be 0x1E
  c_LDXA,  -- 0x15: M(R(X))->D ; R(X)+1 : D will be 0x1E, R(3) will be 0x0021
  c_STR_3, -- 0x16: D->M(R(N))(N=3) : addr 0x21 will be 0x1E
  c_LDX,   -- 0x17: M(R(X))->D      : D will be 0x1E
  c_INC_3, -- 0x18: R(N)+1          : R(3) will be 0x0022
  c_STR_3, -- 0x19: D->M(R(N))(N=3) : addr 0x22 will be 0x1E
  c_INC_3, -- 0x1A: R(N)+1          : R(3) will be 0x0023
  c_SEP_3, -- 0x1B: N->P : switch PC to R(3); jumping to address 0x0023
  X"00",   -- 0x1C: 0x00 : will be 0x1C
  X"00",   -- 0x1D: 0x00 : will be 0x1C
  X"00",   -- 0x1E: 0x00 : will be 0x1E
  X"00",   -- 0x1F: 0x00 : will be 0x1E
  X"00",   -- 0x20: 0x00 : will be 0x1E
  X"00",   -- 0x21: 0x00 : will be 0x1E
  X"00",   -- 0x22: 0x00 : will be 0x1E
  c_SEX_2, -- 0x23: X=2
  c_GHI_3, -- 0x24: R(N).1->D (N=3) : D will be 0
  c_PHI_2, -- 0x25: D->R(N).1 (N=2) : R(2).1 will be 0

  -- OR
  c_LDI,   -- 0x26: M(R(P))->D; R(P)+1 : D will be:

  X"98",   -- 0x27: <------------- point to data <--------- !!!

  c_PLO_2, -- 0x28: D->R(N).0 (N=2)
  c_LDI,   -- 0x29: M(R(P))->D; R(P)+1 : D will be 0x92
  X"92",   -- 0x2A:
  c_OR,    -- 0x2B: M(R(X)) OR D -> D
  c_STR_2, -- 0x2C: D->M(R(N))(N=2) : addr M(R(2)) will be result of OR = 0xD7

  -- ORI
  c_INC_2, -- 0x2D: R(N)+1
  c_ORI,   -- 0x2E: M(R(P)) OR D -> D; R(P)+1 : result is 0xFF
  X"28",   -- 0x2F:
  c_STR_2, -- 0x30: D->M(R(N))(N=2) : addr M(R(2)) will be result of ORI = 0xFF

  -- XOR
  c_LDI,   -- 0x31: M(R(P))->D; R(P)+1 : D will be 0x33
  X"33",   -- 0x32:
  c_XOR,   -- 0x33: M(R(X)) XOR D -> D
  c_INC_2, -- 0x34: R(N)+1
  c_STR_2, -- 0x35: D->M(R(N))(N=2) : addr M(R(2)) will be result of XOR = 0xCC

  -- XRI
  c_INC_2, -- 0x36: R(N)+1
  c_XRI,   -- 0x37: M(R(P)) OR D -> D; R(P)+1 : result is 0xE4
  X"28",   -- 0x38:
  c_STR_2, -- 0x39: D->M(R(N))(N=2) : addr M(R(2)) will be result of XRI = 0xE4

  -- AND
  c_LDI,   -- 0x3A: M(R(P))->D; R(P)+1 : D will be 0x04
  X"04",   -- 0x3B:
  c_AND,   -- 0x3C: M(R(X)) AND D -> D
  c_INC_2, -- 0x3D: R(N)+1
  c_STR_2, -- 0x3E: D->M(R(N))(N=2) : addr M(R(2)) will be result of AND = 0x04

  -- ANI
  c_INC_2, -- 0x3F: R(N)+1
  c_ANI,   -- 0x40: M(R(P)) OR D -> D; R(P)+1 : result is 0x04
  X"FF",   -- 0x41:
  c_STR_2, -- 0x42: D->M(R(N))(N=2) : addr M(R(2)) will be result of ANI = 0x04

  -- SHR
  c_INC_2, -- 0x43: R(N)+1
  c_LDI,   -- 0x44: M(R(P))->D; R(P)+1
  X"85",   -- 0x45:
  c_SHR,   -- 0x46: D >>= 1; LSB(D)->DF; 0->MSB(D)
  c_STR_2, -- 0x47: D->M(R(N))(N=2) : addr M(R(2)) will be result of SHR

  -- SHL
  c_INC_2, -- 0x48: R(N)+1
  c_LDI,   -- 0x49: M(R(P))->D; R(P)+1
  X"85",   -- 0x4A:
  c_SHL,   -- 0x4B: D <<= 1; MSB(D)->DF; 0->LSB(D)
  c_STR_2, -- 0x4C: D->M(R(N))(N=2) : addr M(R(2)) will be result of SHL

  -- RSHR
  c_INC_2, -- 0x4D: R(N)+1
  c_LDI,   -- 0x4E: M(R(P))->D; R(P)+1
  X"85",   -- 0x4F:
  c_RSHR,  -- 0x50: D >>= 1; LSB(D)->DF; DF->MSB(D)
  c_STR_2, -- 0x51: D->M(R(N))(N=2) : addr M(R(2)) will be result of RSHR

  -- RSHL
  c_INC_2, -- 0x52: R(N)+1
  c_LDI,   -- 0x53: M(R(P))->D; R(P)+1
  X"1D",   -- 0x54:
  c_RSHL,  -- 0x55: D <<= 1; MSB(D)->DF; DF->LSB(D)
  c_STR_2, -- 0x56: D->M(R(N))(N=2) : addr M(R(2)) will be result of RSHL

  -- ADD
  c_LDI,   -- 0x57: M(R(P))->D; R(P)+1
  X"F0",   -- 0x58:
  c_ADD,   -- 0x59: M(R(X))+D -> DF, D : 0x3A + 0xF0 = 0x12A
  c_INC_2, -- 0x5A: R(N)+1
  c_STR_2, -- 0x5B: D->M(R(N))(N=2) : addr M(R(2)) will be result of ADD

  -- ADI
  c_INC_2, -- 0x5C: R(N)+1
  c_ADI,   -- 0x5D: M(R(P)) + D -> DF,D; R(P)+1 : result is 0x11A
  X"F0",   -- 0x5E:
  c_STR_2, -- 0x5F: D->M(R(N))(N=2) : addr M(R(2)) will be result of ADI

  -- ADC
  c_INC_2, -- 0x60: R(N)+1
  c_LDI,   -- 0x61: M(R(P))->D; R(P)+1
  X"2D",   -- 0x62:
  c_ADC,   -- 0x63: M(R(X))+D+DF -> DF, D : 0x3A + 0x2D + DF=1 = 0x68, DF=0
  c_STR_2, -- 0x64: D->M(R(N))(N=2) : addr M(R(2)) will be result of ADC

  -- ADCI
  c_INC_2, -- 0x65: R(N)+1
  c_ADCI,  -- 0x66: M(R(P))+D+DF -> DF,D; R(P)+1 : result is 0x58, DF=1 
  X"F0",   -- 0x67:
  c_STR_2, -- 0x68: D->M(R(N))(N=2) : addr M(R(2)) will be result of ADCI

  -- SD
  c_INC_2, -- 0x69: R(N)+1
  c_LDI,   -- 0x6A: M(R(P))->D; R(P)+1
  X"0E",   -- 0x6B:
  c_SD,    -- 0x6C: M(R(X))-D -> DF, D : 0x42 - 0x0E = 0x34, DF=1 (0x42 + 0xF1 + 1 = 0x134)
  c_STR_2, -- 0x6D: D->M(R(N))(N=2) : addr M(R(2)) will be result of SD

  -- SD
  c_INC_2, -- 0x6E: R(N)+1
  c_LDI,   -- 0x6F: M(R(P))->D; R(P)+1
  X"92",   -- 0x70:
  c_SD,    -- 0x71: M(R(X))-D -> DF, D : 0x57 - 0x92 = 0xC5, DF=0
  c_STR_2, -- 0x72: D->M(R(N))(N=2) : addr M(R(2)) will be result of SD

  -- SDB
  c_INC_2, -- 0x73: R(N)+1
  c_LDI,   -- 0x74: M(R(P))->D; R(P)+1
  X"20",   -- 0x75:
  c_SDB,   -- 0x76: M(R(X))-D-(NOT DF) -> DF, D : 0x40 - 0x20 (borrow=1) = 0x1F, DF=1 (borrow=0)
  c_STR_2, -- 0x77: D->M(R(N))(N=2) : addr M(R(2)) will be result of SDB

  -- SDI
  c_INC_2, -- 0x78: R(N)+1
  c_SDI,   -- 0x79: M(R(P)) - D -> DF,D; R(P)+1
  X"F0",   -- 0x7A:
  c_STR_2, -- 0x7B: D->M(R(N))(N=2) : addr M(R(2)) will be result of SDI. 0xF0 - 0x1F = 0xD1, DF=1

  -- SDBI
  c_INC_2, -- 0x7C: R(N)+1
  c_SDBI,  -- 0x7D: M(R(P)) - D - (NOT DF) -> DF,D; R(P)+1 : 0xF0 - 0xD1 (borrow=0) = 0x1F, DF=1 (borrow=0)
  X"F0",   -- 0x7E:
  c_STR_2, -- 0x7F: D->M(R(N))(N=2) : addr M(R(2)) will be result of SDI


  -- SM
  c_INC_2, -- 0x80: R(N)+1
  c_LDI,   -- 0x81: M(R(P))->D; R(P)+1
  X"92",   -- 0x82:
  c_SM,    -- 0x83: D-M(R(X)) -> DF, D : 0x92 - 0x57 = 0x3B, DF=1
  c_STR_2, -- 0x84: D->M(R(N))(N=2) : addr M(R(2)) will be result of SD

  -- SMBI
  c_INC_2, -- 0x85: R(N)+1
  c_LDI,   -- 0x86: M(R(P))->D; R(P)+1
  X"71",   -- 0x87:
  c_SMBI,  -- 0x88: D-M(R(P)) - (NOT DF) -> DF,D; R(P)+1 : 0x71 - 0xF2 - DF=1 (borrow=0) = 0x7F, DF=0 (borrow=1)
  X"F2",   -- 0x89:
  c_STR_2, -- 0x8A: D->M(R(N))(N=2) : addr M(R(2)) will be result of SMBI

  -- SMB
  c_INC_2, -- 0x8B: R(N)+1
  c_LDI,   -- 0x8C: M(R(P))->D; R(P)+1
  X"4A",   -- 0x8D:
  c_SMB,   -- 0x8E: D-M(R(X))-(NOT DF) -> DF, D : 0x4A - 0xC1 - DF=0 (borrow=1) = 0x88, DF=0 (borrow=1)
  c_STR_2, -- 0x8F: D->M(R(N))(N=2) : addr M(R(2)) will be result of SMB

  -- SMI
  c_INC_2, -- 0x90: R(N)+1
  c_LDI,   -- 0x91: M(R(P))->D; R(P)+1
  X"1B",   -- 0x92:
  c_SMI,   -- 0x93: D-M(R(P)) -> DF,D; R(P)+1 : 0x1B - 0x1A = 0x01, DF=1 (borrow=0)
  X"1A",   -- 0x94:
  c_STR_2, -- 0x95: D->M(R(N))(N=2) : addr M(R(2)) will be result of SMI


  c_BR,    -- 0x96: M(R(P))->R(P).0 : Unconditional short branch
  X"AF",   -- 0x97:

  -- data
  X"57", -- 0x98: 1st argument for OR = 0x57. will be 0xD7 after
  X"00", -- 0x99: 0x00 : will be 0xFF after ORI
  X"00", -- 0x9A: 0x00 : will be 0xCC after XOR
  X"00", -- 0x9B: 0x00 : will be 0xE4 after XRI
  X"00", -- 0x9C: 0x00 : will be 0x04 after AND
  X"00", -- 0x9D: 0x00 : will be 0x04 after ANI
  X"00", -- 0x9E: 0x00 : will be 0x42 after SHR
  X"00", -- 0x9F: 0x00 : will be 0x0A after SHL
  X"00", -- 0xA0: 0x00 : will be 0xC2 after RSHR
  X"00", -- 0xA1: 0x00 : will be 0x3A after RSHL
  X"00", -- 0xA2: 0x00 : will be 0x2A after ADD
  X"00", -- 0xA3: 0x00 : will be 0x1A after ADI
  X"3A", -- 0xA4: 0x00 : will be 0x68 after ADC
  X"00", -- 0xA5: 0x00 : will be 0x58 after ADCI

  X"42", -- 0xA6: 0x00 : will be 0x34 after SD
  X"57", -- 0xA7: 0x00 : will be 0xC5 after SD
  X"40", -- 0xA8: 0x00 : will be 0x1F after SDB
  X"00", -- 0xA9: 0x00 : will be 0xD1 after SDI
  X"00", -- 0xAA: 0x00 : will be 0x1F after SDBI
  X"57", -- 0xAB: 0x00 : will be 0x3B after SM
  X"00", -- 0xAC: 0x00 : will be 0x7F after SMBI
  X"C1", -- 0xAD: 0x00 : will be 0x88 after SMB
  X"00", -- 0xAE: 0x00 : will be 0x01 after SMI

  -- testing conditional branches
  c_BQ,  -- 0xAF: IF Q=1, M(R(P))->R(P).0 ELSE R(P)+1
  X"B3", -- 0xB0:
  c_BNZ, -- 0xB1: IF D NOT 0, M(R(P))->R(P).0 ELSE R(P)+1 : (D was 0x01, must jump)
  X"B6", -- 0xB2:
  c_REQ, -- 0xB3: Q=0
  c_BNQ, -- 0xB4: IF Q=0, M(R(P))->R(P).0 ELSE R(P)+1 : (must jump)
  X"B1", -- 0xB5:

  c_BN1, -- 0xB6: IF EF1=0, M(R(P))->R(P).0 ELSE R(P)+1 : (nEF is input as "1110", no jump)
  X"B1", -- 0xB7:
  c_B1,  -- 0xB8: IF EF1=1, M(R(P))->R(P).0 ELSE R(P)+1 : (nEF is input as "1110", jump)
  X"BC", -- 0xB9:
  c_B2,  -- 0xBA: IF EF2=1, M(R(P))->R(P).0 ELSE R(P)+1 : (should not even be here)
  X"B1", -- 0xBB:

  c_LSKP, -- 0xBC: R(P)+2
  c_NOP, -- 0xBD:
  c_NOP, -- 0xBE:
  c_LBR, -- 0xBF: M(R(P))->R(P).1; M(R(P+1))->R(P).0 : jump to next RAM page
  X"01", -- 0xC0: -- jump to address.hi
  X"00", -- 0xC1: -- jump to address.lo

  -- come back from next page (I):
  c_LSNQ, -- 0xC2: -- long skip if Q=0 (must long skip)
  X"00", -- 0xC3:
  X"00", -- 0xC4:
  c_LBNQ, -- 0xC5: -- long branch if Q=0 (must jump to next page)
  X"01", -- 0xC6:
  X"05", -- 0xC7:

  -- come back from next page (II):
  c_LSDF, -- 0xC8: long skip if DF=1 (DF was still 1 , so must long skip)
  X"00", -- 0xC9:
  X"00", -- 0xCA:
  c_LBDF, -- 0xCB: long branch if DF=1 (DF was still 1, so must long branch to next page)
  X"01", -- 0xCC:
  X"0A", -- 0xCD:

  X"00", -- 0xCE:
  X"00", -- 0xCF:
  X"00", -- 0xD0:
  X"00", -- 0xD1:
  X"00", -- 0xD2:
  X"00", -- 0xD3:
  X"00", -- 0xD4:
  X"00", -- 0xD5:
  X"00", -- 0xD6:
  X"00", -- 0xD7:
  X"00", -- 0xD8:
  X"00", -- 0xD9:
  X"00", -- 0xDA:
  X"00", -- 0xDB:
  X"00", -- 0xDC:
  X"00", -- 0xDD:
  X"00", -- 0xDE:
  X"00", -- 0xDF:
  X"00", -- 0xE0:
  X"00", -- 0xE1:
  X"00", -- 0xE2:
  X"00", -- 0xE3:
  X"00", -- 0xE4:
  X"00", -- 0xE5:
  X"00", -- 0xE6:
  X"00", -- 0xE7:
  X"00", -- 0xE8:
  X"00", -- 0xE9:
  X"00", -- 0xEA:
  X"00", -- 0xEB:
  X"00", -- 0xEC:
  X"00", -- 0xED:
  X"00", -- 0xEE:
  X"00", -- 0xEF:
  X"00", -- 0xF0:
  X"00", -- 0xF1:
  X"00", -- 0xF2:
  X"00", -- 0xF3:
  X"00", -- 0xF4:
  X"00", -- 0xF5:
  X"00", -- 0xF6:
  X"00", -- 0xF7:
  X"00", -- 0xF8:
  X"00", -- 0xF9:
  X"00", -- 0xFA:
  X"00", -- 0xFB:
  X"00", -- 0xFC:
  X"00", -- 0xFD:
  X"00", -- 0xFE:
  X"00", -- 0xFF:

  -- next page:
  c_LDI, -- 0x100: load D
  X"12", -- 0x101:
  c_LBNZ, -- 0x102: if D!=0 jump
  X"00",  -- 0x103:
  X"C2",  -- 0x104:

  c_LDI, -- 0x105: load D
  X"00", -- 0x106:
  c_LBZ, -- 0x107: long branch if D=0 (must long jump!)
  X"00", -- 0x108: pack to page 0
  X"C8", -- 0x109:
  -- end program
  c_SEQ,   -- 0x10A: Q=0
  c_DEC_3  -- 0x10B: R(N)-1          : (repeating forever)

);

BEGIN
  PROCESS (address, nCS, nWE, nOE) IS
    BEGIN
      data <= (OTHERS => 'Z'); -- chip is not selected
      IF (nCS = '0') THEN
        IF nWE = '0' THEN -- write
          ram1(to_integer(unsigned(address))) <= data;
        END IF;

        IF nWE = '1' AND nOE = '0' THEN -- read
          data <= ram1(to_integer(unsigned(address)));
        ELSE
          data <= (OTHERS => 'Z');
        END IF;
      END IF;
  END PROCESS; 
END str;
