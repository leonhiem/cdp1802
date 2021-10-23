-------------------------------------------------------------------------------
--
-- File Name: cs1800_cpu.vhd
-- Author: Leon Hiemstra
--
-- Title: CS1800 Microprocessor System
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
USE work.cdp1802_pkg.ALL;


ENTITY cs1800_cpu IS
  PORT (
    CLOCK    : IN    STD_LOGIC;

    LC       : IN    STD_LOGIC;
    Q        : OUT   STD_LOGIC;
    nINT     : IN    STD_LOGIC;
    nEF      : IN    STD_LOGIC_VECTOR(2 DOWNTO 0);
    ADDR     : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
    DATA     : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    N        : OUT   STD_LOGIC_VECTOR(2 DOWNTO 0);
    TPA      : OUT   STD_LOGIC;
    TPB      : OUT   STD_LOGIC;
    nMRD     : OUT   STD_LOGIC;
    nMWR     : OUT   STD_LOGIC;

    led_Q     : OUT   STD_LOGIC;
    led_fetch : OUT   STD_LOGIC;
    led_exec  : OUT   STD_LOGIC;
    led_dma_ack   : OUT   STD_LOGIC;
    led_int_ack   : OUT   STD_LOGIC;

    reset : IN STD_LOGIC;
    halt  : IN STD_LOGIC;
    single : IN STD_LOGIC;
    run : IN STD_LOGIC
  );
END cs1800_cpu;


ARCHITECTURE str OF cs1800_cpu IS

  SIGNAL  nWAIT    : STD_LOGIC;
  SIGNAL  nCLEAR   : STD_LOGIC;
  SIGNAL  SC       : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL  nDMA_OUT : STD_LOGIC;
  SIGNAL  nDMA_IN  : STD_LOGIC;
  SIGNAL  Q_i  : STD_LOGIC;
  SIGNAL  TPA_i  : STD_LOGIC;
  SIGNAL  nINT_i  : STD_LOGIC;
  SIGNAL  nINT_tmp  : STD_LOGIC;
  SIGNAL  nEF4_tmp  : STD_LOGIC;
  SIGNAL  nEF_i  : STD_LOGIC_VECTOR(3 DOWNTO 0);

  SIGNAL int_ack : STD_LOGIC;
  SIGNAL int_ack_tmp1 : STD_LOGIC;
  SIGNAL int_ack_tmp2 : STD_LOGIC;
  SIGNAL int_ack_tmp3 : STD_LOGIC;

BEGIN

  Q <= Q_i;
  led_Q <= Q_i;

  led_fetch <= '1' WHEN SC="00" ELSE '0';
  led_exec  <= '1' WHEN SC="01" ELSE '0';
  led_dma_ack <= '1' WHEN SC="10" ELSE '0';

  int_ack <= '1' WHEN SC="11" ELSE '0';

  nDMA_OUT <= '1';
  nDMA_IN <= '1';

  TPA <= TPA_i;


  -- FIXME, (doesnt work, need counter to extend int_ack pulse):
  p_led_int_ack : PROCESS(CLOCK, int_ack, int_ack_tmp1, int_ack_tmp2, int_ack_tmp3, reset)
  BEGIN
    IF rising_edge(CLOCK) THEN
      IF int_ack = '1' THEN
        int_ack_tmp1 <= '1';
      END IF;
      IF int_ack_tmp1 = '1' THEN
        int_ack_tmp2 <= '1';
      END IF;
      IF int_ack_tmp2 = '1' THEN
        int_ack_tmp3 <= '1';
      END IF;
      IF int_ack_tmp3 = '1' OR reset = '1' THEN
        int_ack_tmp3 <= '0';
        int_ack_tmp2 <= '0';
        int_ack_tmp1 <= '0';
      END IF;
    END IF;
  END PROCESS;
  led_int_ack <= int_ack OR int_ack_tmp1 OR int_ack_tmp2 OR int_ack_tmp3;



  p_lc_int : PROCESS(LC, int_ack, Q_i, reset)
  BEGIN
    IF reset = '1' OR LC = '1' OR int_ack = '1' THEN
      nINT_tmp <= '1';
    ELSIF falling_edge(LC) THEN
      nINT_tmp <= '0';
    END IF;
  END PROCESS;

  nEF4_tmp <= NOT Q_i;

  nINT_i <= '0' WHEN (nINT_tmp = '0' OR nINT = '0') ELSE '1';

  nEF_i(2 DOWNTO 0) <= nEF;
  nEF_i(3) <= nEF4_tmp;


  p_mode : PROCESS(single, halt, reset, run, TPA_i)
  BEGIN
    IF run = '1' THEN
      nWAIT <= '1';
      nCLEAR <= '1';
    ELSIF halt = '1' THEN
      nWAIT <= '0';
      nCLEAR <= '1';
    ELSE -- reset
      nWAIT <= '1';
      nCLEAR <= '0';
--      IF single = '1' THEN
--        nWAIT <= '1';
--        nCLEAR <= '1';
--        IF falling_edge(TPA_i) THEN
--          nWAIT <= '0';
--          nCLEAR <= '1';
--        END IF;
    END IF;
  END PROCESS;
  
  u_cdp1802 : ENTITY work.cdp1802
  PORT MAP (
    CLOCK    => CLOCK,
    nWAIT    => nWAIT,
    nCLEAR   => nCLEAR,
    Q        => Q_i,
    SC       => SC,
    nMRD     => nMRD,
    DATA     => DATA,
    N        => N,
    nEF      => nEF_i,
    ADDR     => ADDR,
    TPA      => TPA_i,
    TPB      => TPB,
    nMWR     => nMWR,
    nINT     => nINT_i,
    nDMA_OUT => nDMA_OUT,
    nDMA_IN  => nDMA_IN
  );


END str;
