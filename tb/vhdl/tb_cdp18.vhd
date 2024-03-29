-------------------------------------------------------------------------------
--
-- File Name: tb_cdp18.vhd
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


ENTITY tb_cdp18 IS
END tb_cdp18; 

ARCHITECTURE tb OF tb_cdp18 IS

  CONSTANT clk_period   : TIME := 250 ns; -- 4 MHz

  SIGNAL clk    : STD_LOGIC := '0';
  SIGNAL tb_end : STD_LOGIC := '0';
  SIGNAL nWAIT  : STD_LOGIC;
  SIGNAL nCLEAR : STD_LOGIC;
  SIGNAL Q      : STD_LOGIC;
  SIGNAL SC     : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL nEF    : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1110";
  SIGNAL nINT   : STD_LOGIC := '1';
  SIGNAL nDMA_OUT : STD_LOGIC := '1';
  SIGNAL nDMA_IN  : STD_LOGIC := '1';
  SIGNAL io_output   : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL io_input_ptrn   : STD_LOGIC_VECTOR(7 DOWNTO 0) := "11000101"; -- something to put in
  SIGNAL dma_input_ptrn   : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00001001"; -- something to put in

BEGIN

  clk <= NOT clk OR tb_end AFTER clk_period/2;

  p_in_stimuli : PROCESS
  BEGIN


    -- RESET:
    nCLEAR <= '0';
    nWAIT  <= '1';

    FOR I IN 0 TO 20 LOOP
      WAIT UNTIL rising_edge(clk);
    END LOOP;

    -- RUN:
    nCLEAR <= '1';
    nWAIT  <= '1';

    FOR I IN 0 TO 200 LOOP
      WAIT UNTIL rising_edge(clk);
    END LOOP;

    -- PAUSE:
    nCLEAR <= '1';
    nWAIT  <= '0';

    FOR I IN 0 TO 20 LOOP
      WAIT UNTIL rising_edge(clk);
    END LOOP;

    -- RUN:
    nCLEAR <= '1';
    nWAIT  <= '1';

    FOR I IN 0 TO 700 LOOP
      WAIT UNTIL rising_edge(clk);
    END LOOP;

    nINT <= '0';
    FOR I IN 0 TO 20 LOOP
      WAIT UNTIL rising_edge(clk);
    END LOOP;
    nINT <= '1';

    FOR I IN 0 TO 1000 LOOP
      WAIT UNTIL rising_edge(clk);
    END LOOP;

    nINT <= '0';
    FOR I IN 0 TO 20 LOOP
      WAIT UNTIL rising_edge(clk);
    END LOOP;
    nINT <= '1';

    FOR I IN 0 TO 800 LOOP
      WAIT UNTIL rising_edge(clk);
    END LOOP;

    nINT <= '0';
    FOR I IN 0 TO 20 LOOP
      WAIT UNTIL rising_edge(clk);
    END LOOP;
    nINT <= '1';

    FOR I IN 0 TO 1000 LOOP
      WAIT UNTIL rising_edge(clk);
    END LOOP;

    -- DMA out:
    nDMA_OUT  <= '0';
    FOR I IN 0 TO 1000 LOOP
      WAIT UNTIL rising_edge(clk);
    END LOOP;
    nDMA_OUT  <= '1';

    -- DMA in:
    nDMA_IN  <= '0';
    FOR I IN 0 TO 200 LOOP
      WAIT UNTIL rising_edge(clk);
    END LOOP;
    nDMA_IN  <= '1';

    tb_end <= '1';
    WAIT;
  END PROCESS;


  -- device under test
  u_dut : ENTITY work.cdp18
  PORT MAP (
    CLOCK    => clk,
    nWAIT    => nWAIT,
    nCLEAR   => nCLEAR,
    Q        => Q,
    SC       => SC,
    nEF      => nEF,
    nINT     => nINT,
    nDMA_OUT => nDMA_OUT,
    nDMA_IN  => nDMA_IN,
    io_output   => io_output,
    io_input_ptrn   => io_input_ptrn,
    dma_input_ptrn   => dma_input_ptrn
  );

END tb;

