-------------------------------------------------------------------------------
--
-- File Name: io_inp.vhd
-- Author: Leon Hiemstra
--
-- Title: CDP18 IO input
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


ENTITY io_inp IS
  PORT (
    data    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    input   : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    nCS     : IN STD_LOGIC
  );
END io_inp;

ARCHITECTURE str OF io_inp IS

BEGIN
  data <= input WHEN nCS = '0' ELSE (OTHERS => 'Z');
END str;
