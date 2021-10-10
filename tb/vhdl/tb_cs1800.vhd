-------------------------------------------------------------------------------
--
-- File Name: tb_cs1800.vhd
-- Author: Leon Hiemstra
--
-- Title: CDP18 testbench
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


ENTITY tb_cs1800 IS
END tb_cs1800; 

ARCHITECTURE tb OF tb_cs1800 IS

  CONSTANT clk_period   : TIME := 250 ns; -- 4 MHz

  SIGNAL clk    : STD_LOGIC := '0';
  SIGNAL tb_end : STD_LOGIC := '0';
  SIGNAL reset  : STD_LOGIC := '1';
  SIGNAL halt : STD_LOGIC := '0';
  SIGNAL single : STD_LOGIC := '0';
  SIGNAL run : STD_LOGIC := '0';
  SIGNAL LC      : STD_LOGIC := '0';
  SIGNAL Q      : STD_LOGIC;
  SIGNAL nEF    : STD_LOGIC_VECTOR(2 DOWNTO 0) := "110";

BEGIN

  clk <= NOT clk OR tb_end AFTER clk_period/2;
  LC <= NOT LC OR tb_end AFTER clk_period*200;

  p_in_stimuli : PROCESS
  BEGIN


    -- RESET:
    reset <= '1';

    FOR I IN 0 TO 20 LOOP
      WAIT UNTIL rising_edge(clk);
    END LOOP;

    -- RUN:
    reset <= '0';
    run  <= '1';

    FOR I IN 0 TO 200 LOOP
      WAIT UNTIL rising_edge(clk);
    END LOOP;

    -- PAUSE:
    run <= '0';
    halt  <= '1';

    FOR I IN 0 TO 20 LOOP
      WAIT UNTIL rising_edge(clk);
    END LOOP;

    -- RUN:
    halt <= '0';
    run  <= '1';

    FOR I IN 0 TO 4000 LOOP
      WAIT UNTIL rising_edge(clk);
    END LOOP;

    tb_end <= '1';
    WAIT;
  END PROCESS;


  -- device under test
  u_dut : ENTITY work.cs1800
  PORT MAP (
    CLOCK    => clk,
    LC       => LC,
    Q        => Q,
    nEF      => nEF,

    reset => reset,
    halt  => halt,
    single => single,
    run => run
  );

END tb;

