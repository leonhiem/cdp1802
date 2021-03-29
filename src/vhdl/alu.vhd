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

    carry_out <= '0';
    d_out <= (OTHERS => 'Z');

    CASE oper IS
      -- logic operations:
      WHEN c_ALU_OR =>
        alu_out <= d_in OR alu_in;
      WHEN c_ALU_XOR =>
        alu_out <= d_in XOR alu_in;
      WHEN c_ALU_AND =>
        alu_out <= d_in AND alu_in;
      WHEN c_ALU_SHR => -- >>
        alu_out <= "0" & alu_in(7 DOWNTO 1);
        carry_out <= alu_in(0);
      WHEN c_ALU_SHL => -- <<
        alu_out <= alu_in(6 DOWNTO 0) & "0";
        carry_out <= alu_in(7);
      WHEN c_ALU_RSHR => -- >>
        alu_out <= alu_in(0) & alu_in(7 DOWNTO 1);
        carry_out <= alu_in(0);
      WHEN c_ALU_RSHL => -- <<
        alu_out <= alu_in(6 DOWNTO 0) & alu_in(7);
        carry_out <= alu_in(7);

      -- arithmetic operations:
      WHEN c_ALU_U_ADD => -- unsigned addition
        --tmp <= "0" & std_logic_vector(unsigned(d_in) + unsigned(alu_in));
        --alu_out <= tmp(7 DOWNTO 0);
        --tmp <= "0" & std_logic_vector(unsigned(d_in) + unsigned(alu_in));
        --carry_out <= tmp(8);

        alu_out <= std_logic_vector(unsigned(d_in) + unsigned(alu_in));

      WHEN OTHERS => -- c_ALU_NOP
        alu_out <= d_in;
        d_out <= alu_in;
    END CASE;

  END PROCESS;

END str;
