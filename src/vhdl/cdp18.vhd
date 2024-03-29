-------------------------------------------------------------------------------
--
-- File Name: cdp18.vhd
-- Author: Leon Hiemstra
--
-- Title: CDP18 Microprocessor System
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


ENTITY cdp18 IS
  PORT (
    CLOCK    : IN    STD_LOGIC;
    nWAIT    : IN    STD_LOGIC;
    nCLEAR   : IN    STD_LOGIC;
    Q        : OUT   STD_LOGIC;
    SC       : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
    nEF      : IN    STD_LOGIC_VECTOR(3 DOWNTO 0);
    nINT     : IN    STD_LOGIC;
    nDMA_OUT : IN    STD_LOGIC;
    nDMA_IN  : IN    STD_LOGIC;
    io_output : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
    io_input_ptrn : IN   STD_LOGIC_VECTOR(7 DOWNTO 0);
    dma_input_ptrn : IN   STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END cdp18;


ARCHITECTURE str OF cdp18 IS

  SIGNAL nmrd : STD_LOGIC;
  SIGNAL nmwr : STD_LOGIC;
  SIGNAL tpa  : STD_LOGIC;
  SIGNAL tpb  : STD_LOGIC;
  SIGNAL data  : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL addr  : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL addr_high  : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL ram_addr  : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL n     : STD_LOGIC_VECTOR(2 DOWNTO 0);

  SIGNAL n_memsel   : STD_LOGIC;
  SIGNAL n_io_out_sel : STD_LOGIC;
  SIGNAL n_io_in_sel : STD_LOGIC;
  SIGNAL n_dma_in_sel : STD_LOGIC;

BEGIN

  u_cdp1802 : ENTITY work.cdp1802
  PORT MAP (
    CLOCK    => CLOCK,
    nWAIT    => nWAIT,
    nCLEAR   => nCLEAR,
    Q        => Q,
    SC       => SC,
    nMRD     => nmrd,
    DATA     => data,
    N        => n,
    nEF      => nEF,
    ADDR     => addr,
    TPA      => tpa,
    TPB      => tpb,
    nMWR     => nmwr,
    nINT     => nINT,
    nDMA_OUT => nDMA_OUT,
    nDMA_IN  => nDMA_IN
  );

  p_reg_high_addr : PROCESS(tpa, addr)
  BEGIN
    IF rising_edge(tpa) THEN
      addr_high <= addr;
    END IF;
  END PROCESS;

  ram_addr(7 DOWNTO 0) <= addr;
  ram_addr(15 DOWNTO 8) <= addr_high;

  n_memsel <= '0';


  u_ram : ENTITY work.ram
  PORT MAP (
    address => ram_addr,
    data    => data,
    nWE     => nmwr,
    nCS     => n_memsel,
    nOE     => nmrd
  );

  n_io_out_sel <= '0' WHEN n = "101" ELSE '1';
  n_io_in_sel <= '0' WHEN (n = "101" AND nmrd = '1') ELSE '1';
  n_dma_in_sel <= '0' WHEN nDMA_IN = '0' ELSE '1';

  u_io_out : ENTITY work.io_out
  PORT MAP (
    clk => tpb,
    data => data,
    output => io_output,
    nWE => nmrd,
    nCS => n_io_out_sel
  );

  u_io_inp : ENTITY work.io_inp
  PORT MAP (
    data => data,
    input => io_input_ptrn,
    nCS => n_io_in_sel
  );

  u_dma_in : ENTITY work.io_inp
  PORT MAP (
    data => data,
    input => dma_input_ptrn,
    nCS => n_dma_in_sel
  );


END str;
