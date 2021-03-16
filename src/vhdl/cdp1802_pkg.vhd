LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;


PACKAGE cdp1802_pkg IS

  TYPE t_mode IS RECORD
    LOAD  : STD_LOGIC_VECTOR(1 DOWNTO 0);
    RESET : STD_LOGIC_VECTOR(1 DOWNTO 0);
    PAUSE : STD_LOGIC_VECTOR(1 DOWNTO 0);
    RUN   : STD_LOGIC_VECTOR(1 DOWNTO 0);
  END RECORD;

  CONSTANT c_mode : t_mode := ( "00", "01", "10", "11" );


  TYPE t_state IS RECORD
    S0_FETCH     : STD_LOGIC_VECTOR(3 DOWNTO 0);
    S1_RESET     : STD_LOGIC_VECTOR(3 DOWNTO 0);
    S1_INIT      : STD_LOGIC_VECTOR(3 DOWNTO 0);
    S1_EXEC      : STD_LOGIC_VECTOR(3 DOWNTO 0);
    S1_IDLE      : STD_LOGIC_VECTOR(3 DOWNTO 0);
    S2_DMA       : STD_LOGIC_VECTOR(3 DOWNTO 0);
    S3_INTERRUPT : STD_LOGIC_VECTOR(3 DOWNTO 0);
  END RECORD;

  CONSTANT c_state : t_state := ( "0000",
                                  "0100",
                                  "0101",
                                  "0110",
                                  "0111",
                                  "1000",
                                  "1100");
--                                 ^^
--                                 |+-> SC0
--                                 +--> SC1

END cdp1802_pkg;

PACKAGE BODY cdp1802_pkg IS
END cdp1802_pkg;

