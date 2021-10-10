-------------------------------------------------------------------------------
--
-- File Name: cdp1802_pkg.vhd
-- Author: Leon Hiemstra
--
-- Title: CDP1802 constants
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


PACKAGE cdp1802_pkg IS

  CONSTANT c_LOAD  : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
  CONSTANT c_RESET : STD_LOGIC_VECTOR(1 DOWNTO 0) := "01";
  CONSTANT c_PAUSE : STD_LOGIC_VECTOR(1 DOWNTO 0) := "10";
  CONSTANT c_RUN   : STD_LOGIC_VECTOR(1 DOWNTO 0) := "11";
  --                                                  ^^
  --                                                  |+-> nWAIT
  --                                                  +--> nCLEAR

  CONSTANT c_S0_FETCH     : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
  CONSTANT c_S1_RESET     : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
  CONSTANT c_S1_INIT      : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
  CONSTANT c_S1_EXEC      : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";
  CONSTANT c_S1_IDLE      : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";
  CONSTANT c_S2_DMA       : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000";
  CONSTANT c_S3_INTERRUPT : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1100";
  --                                                         ^^
  --                                                         |+-> SC0
  --                                                         +--> SC1

  CONSTANT c_ALU_NOP  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
  CONSTANT c_ALU_OR   : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001";
  CONSTANT c_ALU_XOR  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010";
  CONSTANT c_ALU_AND  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011";
  CONSTANT c_ALU_SHR  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100";
  CONSTANT c_ALU_SHL  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101";
  CONSTANT c_ALU_RSHR : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110";
  CONSTANT c_ALU_RSHL : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111";
  CONSTANT c_ALU_U_ADD : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000";
  CONSTANT c_ALU_U_ADC : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1001";
  CONSTANT c_ALU_S_SUB : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1010";
  CONSTANT c_ALU_S_SUBB : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1011";
  CONSTANT c_ALU_S_SUB_REV  : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1100";
  CONSTANT c_ALU_S_SUBB_REV : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1101";

END cdp1802_pkg;

PACKAGE BODY cdp1802_pkg IS
END cdp1802_pkg;

