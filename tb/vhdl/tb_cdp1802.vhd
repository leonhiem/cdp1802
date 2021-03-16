LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;


ENTITY tb_cdp1802 IS
END tb_cdp1802; 

ARCHITECTURE tb OF tb_cdp1802 IS

  CONSTANT clk_period   : TIME := 250 ns; -- 4 MHz

  SIGNAL clk    : STD_LOGIC := '0';
  SIGNAL tb_end : STD_LOGIC := '0';
  SIGNAL nWAIT  : STD_LOGIC;
  SIGNAL nCLEAR : STD_LOGIC;
  SIGNAL Q      : STD_LOGIC;
  SIGNAL SC     : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL nMRD   : STD_LOGIC;
  SIGNAL DATA   : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL N      : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL nEF    : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111";
  SIGNAL ADDR   : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL TPA    : STD_LOGIC;
  SIGNAL TPB    : STD_LOGIC;
  SIGNAL nMWR   : STD_LOGIC;
  SIGNAL nINT   : STD_LOGIC := '1';
  SIGNAL nDMA_OUT : STD_LOGIC := '1';
  SIGNAL nDMA_IN  : STD_LOGIC := '1';

BEGIN

  clk <= NOT clk OR tb_end AFTER clk_period/2;
  --rst <= '1', '0' AFTER clk_period*3;

  -- run 1 us
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

    FOR I IN 0 TO 20 LOOP
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

    FOR I IN 0 TO 20 LOOP
      WAIT UNTIL rising_edge(clk);
    END LOOP;

    -- LOAD:
    nCLEAR <= '0';
    nWAIT  <= '0';

    FOR I IN 0 TO 20 LOOP
      WAIT UNTIL rising_edge(clk);
    END LOOP;

    -- RESET:
    nCLEAR <= '0';
    nWAIT  <= '1';

    FOR I IN 0 TO 20 LOOP
      WAIT UNTIL rising_edge(clk);
    END LOOP;

    tb_end <= '1';
    WAIT;
  END PROCESS;


  -- device under test
  u_dut : ENTITY work.cdp1802
  PORT MAP (
    CLOCK    => clk,
    nWAIT    => nWAIT,
    nCLEAR   => nCLEAR,
    Q        => Q,
    SC       => SC,
    nMRD     => nMRD,
    DATA     => DATA,
    N        => N,
    nEF      => nEF,
    ADDR     => ADDR,
    TPA      => TPA,
    TPB      => TPB,
    nMWR     => nMWR,
    nINT     => nINT,
    nDMA_OUT => nDMA_OUT,
    nDMA_IN  => nDMA_IN
  );

END tb;

