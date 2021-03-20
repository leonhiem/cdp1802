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

TYPE ram_type IS ARRAY (0 to 23) OF std_logic_vector(7 DOWNTO 0);

SIGNAL ram1 : ram_type:= (
-- instr    addr mnemonic  description
  X"E2", -- 0x0: SEX_2
  X"E3", -- 0x1: SEX_3
  X"E4", -- 0x2: SEX_4
  X"C4", -- 0x3: NOP
  X"7B", -- 0x4: SEQ : Q=1
  X"C4", -- 0x5: NOP
  X"7A", -- 0x6: REQ : Q=0
  X"E8", -- 0x7: SEX_8
  X"80", -- 0x8: GLO_0 : R(N).0 -> D  (N=0)
  X"A3", -- 0x9: PLO_3 : D -> R(N).0  (N=3)
  X"90", -- 0xA: GHI_0 : R(N).1 -> D  (N=0)
  X"B3", -- 0xB: PHI_3 : D -> R(N).1  (N=3)
  X"03", -- 0xC: LDN_3 : M(R(N)) -> D (N=3)
  X"40", -- 0xD: LDA_0 : M(R(N)) -> D ; R(N)+1 (N=0)
  X"7A", -- 0xE: REQ : Q=0 (will be skipped)
  X"C4", -- 0xF: NOP
  X"10", -- 0x10: INC_0 : R(N)+1  (skip)
  X"C4", -- 0x11: NOP (will be skipped)
  X"E3", -- 0x12: SEX_3
  X"60", -- 0x13: IRX : R(X)+1
  X"72", -- 0x14: LDXA : M(R(X)) -> D ; R(X)+1
  X"F0", -- 0x15: LDX : M(R(X)) -> D
  X"7B", -- 0x16: SEQ : Q=1
  X"20"  -- 0x17: DEC_0 : R(N)-1  (repeating forever)
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
