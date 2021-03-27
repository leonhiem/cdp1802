LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;


PACKAGE cdp1802_pkg IS

  CONSTANT c_LOAD  : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
  CONSTANT c_RESET : STD_LOGIC_VECTOR(1 DOWNTO 0) := "01";
  CONSTANT c_PAUSE : STD_LOGIC_VECTOR(1 DOWNTO 0) := "10";
  CONSTANT c_RUN   : STD_LOGIC_VECTOR(1 DOWNTO 0) := "11";

  CONSTANT c_S0_FETCH     : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
  CONSTANT c_S1_RESET     : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
  CONSTANT c_S1_INIT      : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
  CONSTANT c_S1_EXEC      : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";
  CONSTANT c_S1_IDLE      : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";
  CONSTANT c_S2_DMA       : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000";
  CONSTANT c_S3_INTERRUPT : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1100";
  --                                                     ^^
  --                                                     |+-> SC0
  --                                                     +--> SC1

  CONSTANT c_ALU_OR  : STD_LOGIC_VECTOR(1 DOWNTO 0) := "01";
  CONSTANT c_ALU_XOR : STD_LOGIC_VECTOR(1 DOWNTO 0) := "10";
  CONSTANT c_ALU_AND : STD_LOGIC_VECTOR(1 DOWNTO 0) := "11";

END cdp1802_pkg;

PACKAGE BODY cdp1802_pkg IS
END cdp1802_pkg;

