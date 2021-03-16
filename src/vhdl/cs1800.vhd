LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.cdp1802_pkg.ALL;


ENTITY cs1800 IS
  PORT (
    CLOCK    : IN    STD_LOGIC;
    nWAIT    : IN    STD_LOGIC;
    nCLEAR   : IN    STD_LOGIC;
    Q        : OUT   STD_LOGIC;
    SC       : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
    nEF      : IN    STD_LOGIC_VECTOR(3 DOWNTO 0);
    nINT     : IN    STD_LOGIC;
    nDMA_OUT : IN    STD_LOGIC;
    nDMA_IN  : IN    STD_LOGIC
  );
END cs1800;


ARCHITECTURE str OF cs1800 IS

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

  u_reg_high_addr : ENTITY work.reg
  GENERIC MAP (
    g_width => 8
  )
  PORT MAP (
    clk => tpa,
    d_out => addr_high,
    d_in  => addr,
    wr    => '1'
  );

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

END str;
