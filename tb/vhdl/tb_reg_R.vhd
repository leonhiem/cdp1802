-------------------------------------------------------------------------------
--
-- File Name: tb_reg_R.vhd
-- Author: Leon Hiemstra
--
-- Title: reg_R testbench
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


ENTITY tb_reg_R IS
END tb_reg_R; 

ARCHITECTURE tb OF tb_reg_R IS

  CONSTANT clk_period   : TIME := 250 ns; -- 4 MHz

  SIGNAL rst   : STD_LOGIC;
  SIGNAL clk   : STD_LOGIC := '0';

  SIGNAL d_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL d_in  : STD_LOGIC_VECTOR(15 DOWNTO 0);

  SIGNAL addr  : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL mask  : STD_LOGIC_VECTOR(1 DOWNTO 0);

  SIGNAL wr    : STD_LOGIC := '0';
  SIGNAL rd    : STD_LOGIC := '0';

  SIGNAL tb_end : STD_LOGIC := '0';

BEGIN

  clk <= NOT clk OR tb_end AFTER clk_period/2;
  rst <= '1', '0' AFTER clk_period*3;

  -- run 1 us
  p_in_stimuli : PROCESS
  BEGIN
    tb_end <= '0';
    d_in <= (OTHERS => '0');
    addr <= (OTHERS => '0');
    mask <= (OTHERS => '0');

    WAIT UNTIL rst = '0';

    FOR I IN 0 TO 3 LOOP
      WAIT UNTIL rising_edge(clk);
    END LOOP;

    d_in <= x"1234";
    addr <= x"3";
    mask <= "11";
    wr <= '1';

    WAIT UNTIL rising_edge(clk);

    wr <= '0';
    d_in <= x"0000";

    WAIT UNTIL rising_edge(clk);

    rd <= '0';

    WAIT UNTIL rising_edge(clk);



    d_in <= x"ABCD";
    addr <= x"4";
    mask <= "10";
    wr <= '1';

    WAIT UNTIL rising_edge(clk);

    wr <= '0';
    d_in <= x"0000";
    WAIT UNTIL rising_edge(clk);

    rd <= '1';
    WAIT UNTIL rising_edge(clk);
    rd <= '0';

    WAIT UNTIL rising_edge(clk);

    mask <= "11";
    rd <= '1';
    WAIT UNTIL rising_edge(clk);
    rd <= '0';


    tb_end <= '1';
    WAIT;
  END PROCESS;


  -- device under test
  u_dut : ENTITY work.reg_R
  PORT MAP (
    clk    => clk,
    rst    => rst,

    d_out  => d_out,
    d_in   => d_in,
    addr   => addr,
    mask   => mask,
    wr     => wr,
    rd     => rd
  );

END tb;

