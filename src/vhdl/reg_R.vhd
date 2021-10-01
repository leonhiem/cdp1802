-------------------------------------------------------------------------------
--
-- File Name: reg_R.vhd
-- Author: Leon Hiemstra
--
-- Title: CDP1802 General purpose registerbank
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


ENTITY reg_R IS
  PORT (
    clk  : IN  STD_LOGIC;
    rst  : IN  STD_LOGIC;

    d_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    d_in  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);

    addr  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    mask  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);

    wr    : IN  STD_LOGIC;
    rd    : IN  STD_LOGIC := '1'
  );
END reg_R;


ARCHITECTURE str OF reg_R IS

type t_reg_arr is array (0 to 15) of std_logic_vector(15 downto 0);

TYPE t_reg IS RECORD
    reg : t_reg_arr;
END RECORD;

SIGNAL r, nxt_r : t_reg;

BEGIN

  p_regR_comb : PROCESS(rst, r, wr, addr, mask, d_in)
    VARIABLE v : t_reg;
    VARIABLE addr_natural : NATURAL RANGE 0 TO 15;
  BEGIN
      v   := r;
      addr_natural := to_integer(unsigned(addr));

      IF wr = '1' THEN
          IF mask = "01" THEN
              v.reg(addr_natural)(7 DOWNTO 0) := d_in(7 DOWNTO 0);
          ELSIF mask = "10" THEN
              v.reg(addr_natural)(15 DOWNTO 8) := d_in(15 DOWNTO 8);
          ELSIF mask = "11" THEN
              v.reg(addr_natural) := d_in;
          END IF;
      END IF;

      IF rst = '1' THEN
          v.reg(0) := (OTHERS => '0'); -- R(0) = "0000" starting point Program Counter
                                       -- The other registers will not reset
      END IF;

      nxt_r <= v; -- update

  END PROCESS;

  p_regR : PROCESS(clk)
  BEGIN
      IF rising_edge(clk) THEN
          r <= nxt_r;
      END IF;
  END PROCESS;



  p_regR_rd : PROCESS(rd, addr, mask, r)
      VARIABLE addr_natural : NATURAL RANGE 0 TO 15;
  BEGIN
      addr_natural := to_integer(unsigned(addr));
      IF rd = '1' THEN
          IF mask = "01" THEN
              d_out(7 DOWNTO 0) <= r.reg(addr_natural)(7 DOWNTO 0);
          ELSIF mask = "10" THEN
              d_out(15 DOWNTO 8) <= r.reg(addr_natural)(15 DOWNTO 8);
          ELSIF mask = "11" THEN
              d_out <= r.reg(addr_natural);
          END IF;
      END IF;
  END PROCESS;

END str;
