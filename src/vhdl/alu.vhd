LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.cdp1802_pkg.ALL;


ENTITY alu IS
  PORT (
    oper    : IN  STD_LOGIC_vector(2 DOWNTO 0);
   
    alu_in  : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
    alu_out : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);

    d_in    : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
    d_out   : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);

    carry   : OUT   STD_LOGIC
  );
END alu;


ARCHITECTURE str OF alu IS

BEGIN

  p_alu : PROCESS(oper, alu_in, d_in)
  BEGIN

    carry <= '0';
    d_out <= (OTHERS => 'Z');

    CASE oper IS
      WHEN c_ALU_OR =>
        alu_out <= d_in OR alu_in;
      WHEN c_ALU_XOR =>
        alu_out <= d_in XOR alu_in;
      WHEN c_ALU_AND =>
        alu_out <= d_in AND alu_in;
      WHEN c_ALU_SHR => -- >>
        alu_out <= "0" & alu_in(7 DOWNTO 1);
        carry <= alu_in(0);
      WHEN c_ALU_SHL => -- <<
        alu_out <= alu_in(6 DOWNTO 0) & "0";
        carry <= alu_in(7);
      WHEN c_ALU_RSHR => -- >>
        alu_out <= alu_in(0) & alu_in(7 DOWNTO 1);
        carry <= alu_in(0);
      WHEN c_ALU_RSHL => -- <<
        alu_out <= alu_in(6 DOWNTO 0) & alu_in(7);
        carry <= alu_in(7);
      WHEN OTHERS =>
        alu_out <= d_in;
        d_out <= alu_in;
    END CASE;

  END PROCESS;

END str;
