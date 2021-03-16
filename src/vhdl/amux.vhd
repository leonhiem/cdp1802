LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;


ENTITY amux IS
  PORT (
    input  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    sel    : IN  STD_LOGIC;
    output : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END amux;


ARCHITECTURE str OF amux IS

BEGIN

  output <= input(7 DOWNTO 0) WHEN sel = '0' ELSE
            input(15 DOWNTO 8) WHEN sel = '1';

END str;
