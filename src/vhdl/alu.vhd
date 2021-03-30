LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
--USE IEEE.std_logic_arith.ALL;
USE work.cdp1802_pkg.ALL;


ENTITY alu IS
  PORT (
    oper    : IN  STD_LOGIC_vector(3 DOWNTO 0);
   
    alu_in  : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
    alu_out : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);

    d_in    : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
    d_out   : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);

    carry_out : OUT STD_LOGIC;
    carry_in  : IN  STD_LOGIC
  );
END alu;


ARCHITECTURE str OF alu IS

  SIGNAL tmp : STD_LOGIC_VECTOR(8 DOWNTO 0);

BEGIN

  p_alu : PROCESS(oper, alu_in, d_in, carry_in)
  BEGIN

    d_out <= (OTHERS => 'Z');

    CASE oper IS
      -- logic operations:
      WHEN c_ALU_OR =>
        tmp <= "0" & (d_in OR alu_in);
      WHEN c_ALU_XOR =>
        tmp <= "0" & (d_in XOR alu_in);
      WHEN c_ALU_AND =>
        tmp <= "0" & (d_in AND alu_in);
      WHEN c_ALU_SHR => -- >>
        tmp <= alu_in(0) & "0" & alu_in(7 DOWNTO 1);
      WHEN c_ALU_SHL => -- <<
        tmp <= alu_in & "0";
      WHEN c_ALU_RSHR => -- >>
        tmp <= alu_in(0) &  alu_in(0) & alu_in(7 DOWNTO 1);
      WHEN c_ALU_RSHL => -- <<
        tmp <= alu_in & alu_in(7);

      -- arithmetic operations:
      WHEN c_ALU_U_ADD => -- unsigned addition
        tmp <= std_logic_vector(unsigned('0' & d_in) + unsigned('0' & alu_in));

      WHEN OTHERS => -- c_ALU_NOP
        tmp <= "0" & d_in;
        d_out <= alu_in;
    END CASE;

  END PROCESS;

  alu_out   <= tmp(7 DOWNTO 0);
  carry_out <= tmp(8);

END str;
