LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;


ENTITY dmux IS
  PORT (
    float  : IN  STD_LOGIC;
    rst    : IN  STD_LOGIC;
   
    d_src  : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
    d_snk  : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
    data   : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END dmux;


ARCHITECTURE str OF dmux IS

  SIGNAL d : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

  data   <= (OTHERS => 'Z') WHEN float = '1' ELSE d;
  d      <= (OTHERS => '0') WHEN rst = '1'   ELSE d_src;
  d_snk  <= data;

END str;
