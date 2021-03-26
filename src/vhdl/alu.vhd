LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.cdp1802_pkg.ALL;


ENTITY alu IS
  PORT (
    oper   : IN  STD_LOGIC_vector(0 DOWNTO 0);
   
    alu_in  : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
    alu_out : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);

    d_in    : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
    d_out   : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END alu;


ARCHITECTURE str OF alu IS

BEGIN

  p_alu : PROCESS(oper, alu_in, d_in)
  BEGIN

    CASE oper IS
      WHEN c_ALU_OR =>
        alu_out <= d_in OR alu_in;
        d_out <= (OTHERS => 'Z');
      WHEN OTHERS =>
        alu_out <= d_in;
        d_out <= alu_in;
    END CASE;

  END PROCESS;

END str;
