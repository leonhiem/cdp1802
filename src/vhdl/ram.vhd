LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;


ENTITY ram IS
  PORT (
    address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    data    : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    nWE, nCS, nOE: IN STD_LOGIC
  );
END ram;

ARCHITECTURE str OF ram IS

TYPE ram_type IS ARRAY (0 to 104) OF std_logic_vector(7 DOWNTO 0);

SIGNAL ram1 : ram_type:= (
---- Testprogram 1 (addr 0 to 28)
---- instr    addr mnemonic  description
--  X"E2", -- 0x0: SEX_2
--  X"F8", -- 0x1: LDI : M(R(P)) -> D ; R(P)+1
--  X"05", -- 0x2: 0x05 (will be loaded into D)
--  X"C4", -- 0x3: NOP
--  X"7B", -- 0x4: SEQ : Q=1
--  X"C4", -- 0x5: NOP
--  X"7A", -- 0x6: REQ : Q=0
--  X"E8", -- 0x7: SEX_8
--  X"80", -- 0x8: GLO_0 : R(N).0 -> D  (N=0)
--  X"A3", -- 0x9: PLO_3 : D -> R(N).0  (N=3)
--  X"90", -- 0xA: GHI_0 : R(N).1 -> D  (N=0)
--  X"B3", -- 0xB: PHI_3 : D -> R(N).1  (N=3)
--  X"03", -- 0xC: LDN_3 : M(R(N)) -> D (N=3)
--  X"40", -- 0xD: LDA_0 : M(R(N)) -> D ; R(N)+1 (N=0)
--  X"7A", -- 0xE: REQ : Q=0 (will be skipped)
--  X"53", -- 0xF: STR_3 : D -> M(R(N)) (N=3)
--  X"10", -- 0x10: INC_0 : R(N)+1  (skip)
--  X"C4", -- 0x11: NOP (will be skipped)
--  X"E3", -- 0x12: SEX_3
--  X"60", -- 0x13: IRX : R(X)+1
--  X"72", -- 0x14: LDXA : M(R(X)) -> D ; R(X)+1
--  X"F0", -- 0x15: LDX : M(R(X)) -> D
--  X"F8", -- 0x16: LDI
--  X"1C", -- 0x17: (address to be overwritten)
--  X"A3", -- 0x18: PLO_3 : D -> R(N).0  (N=3)
--  X"73", -- 0x19: STXD : D -> M(R(X)) ; R(X)-1
--  X"7B", -- 0x1A: SEQ : Q=1
--  X"20", -- 0x1B: DEC_0 : R(N)-1  (repeating forever)
--  X"00"  -- 0x1C: (will be overwritten by STXD)

-- Testprogram 2
-- instr    addr mnemonic  description
  X"E2", -- 0x00: SEX_2
  X"7B", -- 0x01: SEQ
  X"90", -- 0x02: GHI_0 : R(N).1->D (N=0) : D will be 0
  X"B3", -- 0x03: PHI_3 : D->R(N).1 (N=3) : R(3).1 will be 0
  X"F8", -- 0x04: LDI   : M(R(P))->D; R(P)+1 : D will be 0x1C
  X"1C", -- 0x05: 0x1C
  X"A3", -- 0x06: PLO_3 : D->R(N).0 (N=3) : R(3).0 will be 0x1C
  X"53", -- 0x07: STR_3 : D->M(R(N))(N=3) : addr 0x1C will be 0x1C
  X"13", -- 0x08: INC_3 : R(N)+1          : R(3) will be 0x001D
  X"E3", -- 0x09: SEX_3
  X"73", -- 0x0A: STXD  : D->M(R(X)); R(X)-1 : addr 0x1D will be 0x1C, R(3) will be 0x001C
  X"60", -- 0x0B: IRX   : R(X)+1          : R(3) will be 0x001D
  X"60", -- 0x0C: IRX   : R(X)+1          : R(3) will be 0x001E
  X"83", -- 0x0D: GLO_3 : R(N).0->D (N=3) : D will be 0x1E
  X"53", -- 0x0E: STR_3 : D->M(R(N))(N=3) : addr 0x1E will be 0x1E
  X"C4", -- 0x0F: NOP
  X"43", -- 0x10: LDA_3 : M(R(N))->D; R(N)+1 (N=3) : D will be 0x1E, R(3) will be 0x001F
  X"53", -- 0x11: STR_3 : D->M(R(N))(N=3) : addr 0x1F will be 0x1E
  X"03", -- 0x12: LDN_3 : M(R(N))->D(N=3) : D will be 0x1E
  X"13", -- 0x13: INC_3 : R(N)+1          : R(3) will be 0x0020
  X"53", -- 0x14: STR_3 : D->M(R(N))(N=3) : addr 0x20 will be 0x1E
  X"72", -- 0x15: LDXA  : M(R(X))->D ; R(X)+1 : D will be 0x1E, R(3) will be 0x0021
  X"53", -- 0x16: STR_3 : D->M(R(N))(N=3) : addr 0x21 will be 0x1E
  X"F0", -- 0x17: LDX   : M(R(X))->D      : D will be 0x1E
  X"13", -- 0x18: INC_3 : R(N)+1          : R(3) will be 0x0022
  X"53", -- 0x19: STR_3 : D->M(R(N))(N=3) : addr 0x22 will be 0x1E
  X"13", -- 0x1A: INC_3 : R(N)+1          : R(3) will be 0x0023
  X"D3", -- 0x1B: SEP_3 : N->P : switch PC to R(3); jumping to address 0x0023
  X"00", -- 0x1C: 0x00 : will be 0x1C
  X"00", -- 0x1D: 0x00 : will be 0x1C
  X"00", -- 0x1E: 0x00 : will be 0x1E
  X"00", -- 0x1F: 0x00 : will be 0x1E
  X"00", -- 0x20: 0x00 : will be 0x1E
  X"00", -- 0x21: 0x00 : will be 0x1E
  X"00", -- 0x22: 0x00 : will be 0x1E
  X"E2", -- 0x23: SEX_2 : X=2
  X"93", -- 0x24: GHI_3 : R(N).1->D (N=3) : D will be 0
  X"B2", -- 0x25: PHI_2 : D->R(N).1 (N=2) : R(2).1 will be 0

  X"F8", -- 0x26: LDI 0x5E : M(R(P))->D; R(P)+1 : D will be 0x5E
  X"5E", -- 0x27:
  X"A2", -- 0x28: PLO_2 : D->R(N).0 (N=2)
  X"F8", -- 0x29: M(R(P))->D; R(P)+1 : D will be 0x92
  X"92", -- 0x2A:
  X"F1", -- 0x2B: OR : M(R(X)) OR D -> D
  X"52", -- 0x2C: STR_2 : D->M(R(N))(N=2) : addr M(R(2)) will be result of OR = 0xD7
  X"12", -- 0x2D: INC_2 : R(N)+1
  X"F9", -- 0x2E: ORI 0x28 : M(R(P)) OR D -> D; R(P)+1 : result is 0xFF
  X"28", -- 0x2F:
  X"52", -- 0x30: STR_2 : D->M(R(N))(N=2) : addr M(R(2)) will be result of ORI = 0xFF
  X"F8", -- 0x31: LDI 0x33 : M(R(P))->D; R(P)+1 : D will be 0x33
  X"33", -- 0x32:
  X"F3", -- 0x33: XOR : M(R(X)) XOR D -> D
  X"12", -- 0x34: INC_2 : R(N)+1
  X"52", -- 0x35: STR_2 : D->M(R(N))(N=2) : addr M(R(2)) will be result of XOR = 0xCC
  X"12", -- 0x36: INC_2 : R(N)+1
  X"FB", -- 0x37: XRI 0x28 : M(R(P)) OR D -> D; R(P)+1 : result is 0xE4
  X"28", -- 0x38:
  X"52", -- 0x39: STR_2 : D->M(R(N))(N=2) : addr M(R(2)) will be result of XRI = 0xE4
  X"F8", -- 0x3A: LDI 0x04 : M(R(P))->D; R(P)+1 : D will be 0x04
  X"04", -- 0x3B:
  X"F2", -- 0x3C: AND : M(R(X)) AND D -> D
  X"12", -- 0x3D: INC_2 : R(N)+1
  X"52", -- 0x3E: STR_2 : D->M(R(N))(N=2) : addr M(R(2)) will be result of AND = 0x04
  X"12", -- 0x3F: INC_2 : R(N)+1
  X"FA", -- 0x40: ANI 0xFF : M(R(P)) OR D -> D; R(P)+1 : result is 0x04
  X"FF", -- 0x41:
  X"52", -- 0x42: STR_2 : D->M(R(N))(N=2) : addr M(R(2)) will be result of ANI = 0x04
  X"12", -- 0x43: INC_2 : R(N)+1
  X"F8", -- 0x44: LDI 0x85 : M(R(P))->D; R(P)+1
  X"85", -- 0x45:
  X"F6", -- 0x46: SHR : D >>= 1; LSB(D)->DF; 0->MSB(D)
  X"52", -- 0x47: STR_2 : D->M(R(N))(N=2) : addr M(R(2)) will be result of SHR
  X"12", -- 0x48: INC_2 : R(N)+1
  X"F8", -- 0x49: LDI 0x85 : M(R(P))->D; R(P)+1
  X"85", -- 0x4A:
  X"FE", -- 0x4B: SHL : D <<= 1; MSB(D)->DF; 0->LSB(D)
  X"52", -- 0x4C: STR_2 : D->M(R(N))(N=2) : addr M(R(2)) will be result of SHL
  X"12", -- 0x4D: INC_2 : R(N)+1
  X"F8", -- 0x4E: LDI 0x85 : M(R(P))->D; R(P)+1
  X"85", -- 0x4F:
  X"76", -- 0x50: RSHR : D >>= 1; LSB(D)->DF; DF->MSB(D)
  X"52", -- 0x51: STR_2 : D->M(R(N))(N=2) : addr M(R(2)) will be result of RSHR
  X"12", -- 0x52: INC_2 : R(N)+1
  X"F8", -- 0x53: LDI 0x1D : M(R(P))->D; R(P)+1
  X"1D", -- 0x54:
  X"7E", -- 0x55: RSHL : D <<= 1; MSB(D)->DF; DF->LSB(D)
  X"52", -- 0x56: STR_2 : D->M(R(N))(N=2) : addr M(R(2)) will be result of RSHL
  X"F8", -- 0x57: LDI 0xF0
  X"F0", -- 0x58:
  X"F4", -- 0x59: ADD : M(R(X))+D -> DF, D : 0x3A + 0xF0 = 0x12A
  X"12", -- 0x5A: INC_2 : R(N)+1
  X"52", -- 0x5B: STR_2 : D->M(R(N))(N=2) : addr M(R(2)) will be result of ADD


  X"7A", -- 0x5C: REQ
  X"23", -- 0x5D: DEC_3 : R(N)-1          : (repeating forever)

  X"57", -- 0x5E: 1st argument for OR = 0x57. will be 0xD7 after
  X"00", -- 0x5F: 0x00 : will be 0xFF after ORI
  X"00", -- 0x60: 0x00 : will be 0xCC after XOR
  X"00", -- 0x61: 0x00 : will be 0xE4 after XRI
  X"00", -- 0x62: 0x00 : will be 0x04 after AND
  X"00", -- 0x63: 0x00 : will be 0x04 after ANI
  X"00", -- 0x64: 0x00 : will be 0x42 after SHR
  X"00", -- 0x65: 0x00 : will be 0x0A after SHL
  X"00", -- 0x66: 0x00 : will be 0xC2 after RSHR
  X"00", -- 0x67: 0x00 : will be 0x3A after RSHL
  X"00"  -- 0x68: 0x00 : will be 0x2A after ADD

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
