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
  SIGNAL nEF    : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111";
  SIGNAL nINT   : STD_LOGIC := '1';
  SIGNAL nDMA_OUT : STD_LOGIC := '1';
  SIGNAL nDMA_IN  : STD_LOGIC := '1';

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
    nDMA_IN  => nDMA_IN
  );

END tb;

