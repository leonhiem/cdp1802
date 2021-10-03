-------------------------------------------------------------------------------
--
-- File Name: io_out.vhd
-- Author: Leon Hiemstra
--
-- Title: CDP18 RAM including test program
--
-- License: MIT
--
-- Description: 
--
--
--
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;


ENTITY io_out IS
  PORT (
    clk     : IN STD_LOGIC;
    data    : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    output  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    nWE     : IN STD_LOGIC;
    nCS     : IN STD_LOGIC
  );
END io_out;

ARCHITECTURE str OF io_out IS

SIGNAL outp : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN
  PROCESS (clk, data, nCS, nWE) IS
  BEGIN
    IF rising_edge(clk) THEN
      IF nCS = '0' AND nWE = '0' THEN
        outp <= data;
      END IF;
    END IF;
  END PROCESS; 

  output <= outp;
END str;
