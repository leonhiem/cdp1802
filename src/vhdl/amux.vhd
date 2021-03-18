LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;


ENTITY amux IS
  PORT (
    input   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);

    selA    : IN  STD_LOGIC;
    outputA : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);

    selD    : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
    outputD : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END amux;


ARCHITECTURE str OF amux IS

BEGIN

  -- Connection to Addressbus:
  outputA <= input(7 DOWNTO 0) WHEN selA = '0' ELSE
             input(15 DOWNTO 8) WHEN selA = '1';

  -- Connection to Databus:
  outputD <= input(7 DOWNTO 0) WHEN selD = "01" ELSE
             input(15 DOWNTO 8) WHEN selD = "10" ELSE
             (OTHERS => 'Z');

END str;
