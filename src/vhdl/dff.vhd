-------------------------------------------------------------------------------
--
-- File Name: dff.vhd
-- Author: Leon Hiemstra
--
-- Title: flipflop
--
-- License: MIT
--
-- Description: 
--
-- D flip-flop like the CD4013
--
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;



ENTITY d_ff IS
  PORT (
    clk    : IN  STD_LOGIC;
    r      : IN  STD_LOGIC := '0';
    s      : IN  STD_LOGIC := '0';

    d      : IN  STD_LOGIC;
    q      : OUT STD_LOGIC;
    nq     : OUT STD_LOGIC
  );
END d_ff;


ARCHITECTURE str OF d_ff IS

SIGNAL q_tmp : STD_LOGIC;


BEGIN
  p_dff : PROCESS(clk, r, s, d)
  BEGIN
      IF s = '1' THEN
          q_tmp <= '1';
      ELSIF r = '1' THEN
          q_tmp <= '0';
      ELSIF rising_edge(clk) THEN
          q_tmp <= d;
      END IF;
  END PROCESS;

  -- connect
  q <= q_tmp;
  nq <= NOT q_tmp;

END str;
