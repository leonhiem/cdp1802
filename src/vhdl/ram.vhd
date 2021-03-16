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
  X"E2", -- 0x0:
  X"E3", -- 0x1:
  X"E4", -- 0x2:
  X"C4", -- 0x3: NOP
  X"7B", -- 0x4: SEQ
  X"C4", -- 0x5:
  X"7A", -- 0x6: REQ
  X"E8", -- 0x7:
  X"E2", -- 0x8:
  X"E3", -- 0x9:
  X"E4", -- 0xA:
  X"C4", -- 0xB: NOP
  X"7B", -- 0xC: SEQ
  X"C4", -- 0xD:
  X"7A", -- 0xE:
  X"C4", -- 0xF:
  X"10", -- 0x10: INC 0: R(N)+1
  X"C4", -- 0x11:
  X"20", -- 0x12: DEC 0: R(N)-1
  X"C4", -- 0x13:
  X"60", -- 0x14: IRX : R(X)+1
  X"C4", -- 0x15:
  X"C4", -- 0x16:
  X"C4"  -- 0x17:
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
