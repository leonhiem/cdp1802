LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.cdp1802_pkg.ALL;


ENTITY cdp1802 IS
  PORT (
    CLOCK    : IN    STD_LOGIC;
    nWAIT    : IN    STD_LOGIC;
    nCLEAR   : IN    STD_LOGIC;
    Q        : OUT   STD_LOGIC;
    SC       : OUT   STD_LOGIC_VECTOR(1 DOWNTO 0);
    nMRD     : OUT   STD_LOGIC;
    DATA     : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    N        : OUT   STD_LOGIC_VECTOR(2 DOWNTO 0);
    nEF      : IN    STD_LOGIC_VECTOR(3 DOWNTO 0);
    ADDR     : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
    TPA      : OUT   STD_LOGIC;
    TPB      : OUT   STD_LOGIC;
    nMWR     : OUT   STD_LOGIC;
    nINT     : IN    STD_LOGIC;
    nDMA_OUT : IN    STD_LOGIC;
    nDMA_IN  : IN    STD_LOGIC
  );
END cdp1802;


ARCHITECTURE str OF cdp1802 IS

  SIGNAL rst       : STD_LOGIC;
  SIGNAL addr_lohi : STD_LOGIC;
  SIGNAL A_sel_lohi : STD_LOGIC_VECTOR(1 DOWNTO 0);

  SIGNAL float_DATA : STD_LOGIC;
  SIGNAL reset_DATA : STD_LOGIC;

  SIGNAL preset_IE : STD_LOGIC;
  SIGNAL IE_out    : STD_LOGIC;

  SIGNAL wr_T      : STD_LOGIC;
  SIGNAL T_in      : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL T_out     : STD_LOGIC_VECTOR(7 DOWNTO 0);


  SIGNAL wr_P      : STD_LOGIC;
  SIGNAL preset_P  : STD_LOGIC;
  SIGNAL P_in      : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL P_out     : STD_LOGIC_VECTOR(3 DOWNTO 0);

  SIGNAL XtoR      : STD_LOGIC;
  SIGNAL wr_X      : STD_LOGIC;
  SIGNAL preset_X  : STD_LOGIC;
  SIGNAL X_in      : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL X_out     : STD_LOGIC_VECTOR(3 DOWNTO 0);

  SIGNAL NtoR      : STD_LOGIC;
  SIGNAL wr_N      : STD_LOGIC;
  SIGNAL N_in      : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL N_out     : STD_LOGIC_VECTOR(3 DOWNTO 0);

  SIGNAL wr_I      : STD_LOGIC;
  SIGNAL I_in      : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL I_out     : STD_LOGIC_VECTOR(3 DOWNTO 0);

  SIGNAL wr_D      : STD_LOGIC;
  SIGNAL rd_D      : STD_LOGIC;
  SIGNAL D_in      : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL D_out     : STD_LOGIC_VECTOR(7 DOWNTO 0);

  SIGNAL wr_R      : STD_LOGIC;
  SIGNAL addr_R    : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL mask_R    : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL R_in      : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL R_out     : STD_LOGIC_VECTOR(15 DOWNTO 0);

  SIGNAL wr_A      : STD_LOGIC;
  SIGNAL A_in      : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL A_out     : STD_LOGIC_VECTOR(15 DOWNTO 0);

  SIGNAL wr_Q      : STD_LOGIC;
  SIGNAL Q_in      : STD_LOGIC;

  SIGNAL wr_IE     : STD_LOGIC;
  SIGNAL IE_in     : STD_LOGIC;

  SIGNAL DMA_IN    : STD_LOGIC;
  SIGNAL DMA_OUT   : STD_LOGIC;
  SIGNAL INT       : STD_LOGIC;
  SIGNAL Go_Idle   : STD_LOGIC;
  SIGNAL Do_MRD    : STD_LOGIC;
  SIGNAL Do_MWR    : STD_LOGIC;

  SIGNAL state     : STD_LOGIC_VECTOR(3 DOWNTO 0);
  SIGNAL clk_cnt   : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN

  DMA_IN  <= NOT nDMA_IN;
  DMA_OUT <= NOT nDMA_OUT;
  INT     <= NOT nINT;

  u_control : ENTITY work.control
  PORT MAP (
    clk       => CLOCK,
    nwait     => nWAIT,
    nclear    => nCLEAR,
    dma_in    => DMA_IN,
    dma_out   => DMA_OUT,
    interrupt => INT,
    rst       => rst,
    sc        => SC,
    tpa       => TPA,
    tpb       => TPB,
    nMRD      => nMRD,
    nMWR      => nMWR,
    addr_lohi => addr_lohi,
    ie        => IE_out,
    wr_T      => wr_T,
    preset_P  => preset_P,
    preset_X  => preset_X,
    preset_IE => preset_IE,
    reset_DATA => reset_DATA,
    state      => state,
    clk_cnt_out => clk_cnt,
    Go_Idle    => Go_Idle,
    Do_MRD     => Do_MRD,
    Do_MWR     => Do_MWR
  );

  u_instr : ENTITY work.instr
  PORT MAP (
    clk       => CLOCK,
    state     => state,
    clk_cnt   => clk_cnt,
    NtoR      => NtoR,
    XtoR      => XtoR,
    wr_A      => wr_A,
    A_out     => A_out,
    wr_I      => wr_I,
    wr_N      => wr_N,
    mask_R    => mask_R,
    N_out     => N_out,
    I_out     => I_out,
    Go_Idle   => Go_Idle,
    Do_MRD    => Do_MRD,
    Do_MWR    => Do_MWR,
    Q_in      => Q_in,
    wr_Q      => wr_Q,
    float_DATA => float_DATA,
    A_sel_lohi => A_sel_lohi,
    D_out     => D_out,
    wr_D      => wr_D,
    rd_D      => rd_D,
    X_in      => X_in,
    wr_X      => wr_X,
    P_in      => P_in,
    wr_P      => wr_P,
    wr_R      => wr_R,
    R_in      => R_in
  );

  u_Q : ENTITY work.ff
  PORT MAP (
    clk => CLOCK,
    rst => rst,
    wr  => wr_Q,
    d   => Q_in,
    q   => Q
  );

  u_IE : ENTITY work.ff
  GENERIC MAP (
    g_init   => '1',
    g_preset => '0'
  )
  PORT MAP (
    clk    => CLOCK,
    rst    => rst,
    preset => preset_IE,
    wr     => wr_IE,
    d      => IE_in,
    q      => IE_out
  );


  T_in(3 DOWNTO 0) <= P_out;
  T_in(7 DOWNTO 4) <= X_out;
  addr_R <= X_out WHEN XtoR = '1' ELSE N_out WHEN NtoR = '1' ELSE P_out;

  u_reg_T : ENTITY work.reg
  GENERIC MAP (
    g_width => 8
  )
  PORT MAP (
    clk => CLOCK,
    -- no reset

    d_out => T_out,
    d_in  => T_in,

    wr    => wr_T
  );


  u_reg_P : ENTITY work.reg
  GENERIC MAP (
    g_width => 4,
    g_preset => "XXXXXXXXXXXX0001" -- Set at interrupt
  )
  PORT MAP (
    clk => CLOCK,
    rst => rst,
    preset => preset_P,

    d_out => P_out,
    d_in  => P_in,

    wr    => wr_P
  );


  u_reg_X : ENTITY work.reg
  GENERIC MAP (
    g_width => 4,
    g_preset => "XXXXXXXXXXXX0010" -- Set at interrupt
  )
  PORT MAP (
    clk => CLOCK,
    rst => rst,
    preset => preset_X,

    d_out => X_out,
    d_in  => X_in,

    wr    => wr_X
  );


  u_reg_N : ENTITY work.reg
  GENERIC MAP (
    g_width => 4
  )
  PORT MAP (
    clk => CLOCK,
    rst => rst,

    d_out => N_out,
    d_in  => N_in,

    wr    => wr_N
  );
  N <= N_out(2 DOWNTO 0);
  N_in <= D_in(3 DOWNTO 0);



  u_reg_I : ENTITY work.reg
  GENERIC MAP (
    g_width => 4
  )
  PORT MAP (
    clk => CLOCK,
    rst => rst,

    d_out => I_out,
    d_in  => I_in,

    wr    => wr_I
  );
  I_in <= D_in(7 DOWNTO 4);


  u_reg_D : ENTITY work.reg
  GENERIC MAP (
    g_width => 8
  )
  PORT MAP (
    clk => CLOCK,
    -- no reset

    d_out => D_out,
    d_in  => D_in,

    wr    => wr_D,
    rd    => rd_D
  );


  u_reg_R : ENTITY work.reg_R
  PORT MAP (
    clk => CLOCK,
    rst => rst,

    d_out => R_out,
    d_in  => R_in,

    addr  => addr_R,
    mask  => mask_R,

    wr    => wr_R
  );

  u_reg_A : ENTITY work.reg
  GENERIC MAP (
    g_width => 16
  )
  PORT MAP (
    clk => CLOCK,
    rst => rst,

    d_out => A_out,
    d_in  => R_out,

    wr    => wr_A
  );

  u_amux_A : ENTITY work.amux
  PORT MAP (
    input   => A_out,
    selA    => addr_lohi,
    outputA => ADDR,
    selD    => A_sel_lohi,
    outputD => D_in
  );

  u_dmux_D : ENTITY work.dmux
  PORT MAP (
    float   => float_DATA,
    rst     => reset_DATA,
    d_in    => D_out,
    d_out   => D_in,
    data    => DATA
  );

END str;
