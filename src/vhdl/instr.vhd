LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.cdp1802_pkg.ALL;

ENTITY instr IS
  PORT (
    clk        : IN  STD_LOGIC;
    state      : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    clk_cnt    : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
    NtoR       : OUT STD_LOGIC;
    XtoR       : OUT STD_LOGIC;
    wr_A       : OUT STD_LOGIC;
    A_out      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
    wr_I       : OUT STD_LOGIC;
    wr_N       : OUT STD_LOGIC;
    mask_R     : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    N_out      : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    I_out      : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
    Go_Idle    : OUT STD_LOGIC;
    Do_MRD     : OUT STD_LOGIC;
    Q_in       : OUT STD_LOGIC;
    wr_Q       : OUT STD_LOGIC;
    float_DATA : OUT STD_LOGIC;
    A_sel_lohi : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    D_out      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    wr_D       : OUT STD_LOGIC;
    rd_D       : OUT STD_LOGIC;
    X_in       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    wr_X       : OUT STD_LOGIC;
    P_in       : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    wr_P       : OUT STD_LOGIC;
    wr_R       : OUT STD_LOGIC;
    R_in       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END instr;


ARCHITECTURE str OF instr IS

  TYPE t_reg IS RECORD
    NtoR     : STD_LOGIC;
    XtoR     : STD_LOGIC;
    wr_A     : STD_LOGIC;
    wr_I     : STD_LOGIC;
    wr_N     : STD_LOGIC;
    mask_R   : STD_LOGIC_VECTOR(1 DOWNTO 0);
    Go_Idle  : STD_LOGIC;
    Do_MRD   : STD_LOGIC;
    Q_in     : STD_LOGIC;
    wr_Q     : STD_LOGIC;
    float_DATA : STD_LOGIC;
    A_sel_lohi : STD_LOGIC_VECTOR(1 DOWNTO 0);
    wr_D     : STD_LOGIC;
    rd_D     : STD_LOGIC;
    X_in     : STD_LOGIC_VECTOR(3 DOWNTO 0);
    wr_X     : STD_LOGIC;
    P_in     : STD_LOGIC_VECTOR(3 DOWNTO 0);
    wr_P     : STD_LOGIC;
    wr_R     : STD_LOGIC;
    R_in     : STD_LOGIC_VECTOR(15 DOWNTO 0);
  END RECORD;

  SIGNAL r, nxt_r : t_reg;

BEGIN

  p_instr_comb : PROCESS(state, r, N_out, I_out, A_out, clk_cnt, D_out)
    VARIABLE v : t_reg;
  BEGIN
      v := r;
      v.XtoR := '0';
      v.NtoR := '0';
      v.wr_A := '0';
      v.wr_I := '0';
      v.wr_N := '0';
      v.mask_R := "11";
      v.Go_Idle := '0';
      v.Do_MRD  := '0';
      v.wr_Q := '0';
      v.float_DATA := '1';
      v.A_sel_lohi := "00";
      v.wr_D := '0';
      v.rd_D := '0';
      v.wr_X := '0';
      v.wr_P := '0';
      v.wr_R := '0';

      CASE state IS
        WHEN c_S0_FETCH =>
          IF clk_cnt = "000" THEN
              v.wr_A := '1'; -- R(P) -> A
          ELSIF clk_cnt = "001" THEN
              v.wr_I := '1'; -- M(R(P)) -> I
              v.wr_N := '1'; -- M(R(P)) -> N
          ELSIF clk_cnt = "010" THEN
              v.R_in := std_logic_vector(unsigned(A_out) + 1);
          ELSIF clk_cnt = "011" THEN -- 1 clk later is safer
              v.wr_R := '1';
          END IF;
        WHEN c_S1_RESET =>
        WHEN c_S1_INIT =>
          -- R(P)
        WHEN c_S1_EXEC =>
            -- Instruction decoding
            CASE I_out IS
              WHEN "0000" => -- 0x0N
                  IF N_out = "0000" THEN -- IDL
                      v.Go_Idle := '1';
                  ELSE -- LDN : M(R(N)) -> D; N!=0
                      v.NtoR := '1'; -- Select R(N)
                      v.Do_MRD := '1';
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(N) -> A
                      ELSIF clk_cnt = "001" THEN
                          v.wr_D := '1'; -- M(R(N)) -> D
                      END IF;
                  END IF;
              WHEN "0001" => -- 0x1N : INC : R(N)+1
                  v.NtoR := '1'; -- Select R(N)
                  IF clk_cnt = "000" THEN
                      v.wr_A := '1'; -- R(N) -> A
                  ELSIF clk_cnt = "010" THEN
                      v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                  ELSIF clk_cnt = "011" THEN
                      v.wr_R := '1';
                  END IF;
              WHEN "0010" => -- 0x2N : DEC : R(N)-1
                  v.NtoR := '1'; -- Select R(N)
                  IF clk_cnt = "000" THEN
                      v.wr_A := '1'; -- R(N) -> A
                  ELSIF clk_cnt = "010" THEN
                      v.R_in := std_logic_vector(unsigned(A_out) - 1); -- A--
                  ELSIF clk_cnt = "011" THEN
                      v.wr_R := '1';
                  END IF;
              WHEN "0110" =>
                  IF N_out = "0000" THEN -- 0x60 : IRX : R(X)+1
                      v.XtoR := '1'; -- Select R(X)
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(X) -> A
                      ELSIF clk_cnt = "010" THEN
                          v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                      ELSIF clk_cnt = "011" THEN
                          v.wr_R := '1';
                      END IF;
                  END IF;
              WHEN "0111" => -- 0x7N
                  IF N_out = "1011" THEN    -- 0x7B : SEQ
                      v.Q_in  := '1';       -- Q=1
                      IF clk_cnt = "011" THEN
                          v.wr_Q  := '1';
                      END IF;
                  ELSIF N_out = "1010" THEN -- 0x7A : REQ
                      v.Q_in  := '0';       -- Q=0
                      IF clk_cnt = "011" THEN
                          v.wr_Q  := '1';
                      END IF;
                  END IF;
              WHEN "1000" => -- 0x8N : GLO : R(N).0 -> D
                  v.NtoR := '1'; -- Select R(N)
                  v.A_sel_lohi := "01"; -- select A.0
                  IF clk_cnt = "000" THEN
                      v.wr_A := '1'; -- R(N) -> A
                  ELSIF clk_cnt = "011" THEN
                      v.wr_D := '1'; -- A.0 -> D
                  END IF;
              WHEN "1001" => -- 0x9N : GHI : R(N).1 -> D
                  v.NtoR := '1'; -- Select R(N)
                  v.A_sel_lohi := "10"; -- select A.1
                  IF clk_cnt = "000" THEN
                      v.wr_A := '1'; -- R(N) -> A
                  ELSIF clk_cnt = "011" THEN
                      v.wr_D := '1'; -- A.1 -> D
                  END IF;
              WHEN "1010" => -- 0xAN : PLO : D -> R(N).0
                  v.NtoR := '1'; -- Select R(N)
                  v.mask_R := "01"; -- select R(N).0
                  v.rd_D := '1';
                  IF clk_cnt = "010" THEN
                      v.R_in(7 DOWNTO 0) := D_out; -- connect D
                  ELSIF clk_cnt = "011" THEN
                      v.wr_R := '1';
                  END IF;
              WHEN "1011" => -- 0xBN : PHI : D -> R(N).1
                  v.NtoR := '1'; -- Select R(N)
                  v.mask_R := "10"; -- select R(N).1
                  v.rd_D := '1';
                  IF clk_cnt = "010" THEN
                      v.R_in(15 DOWNTO 8) := D_out; -- connect D
                  ELSIF clk_cnt = "011" THEN
                      v.wr_R := '1';
                  END IF;
              WHEN "1100" => -- 0xCN
                  IF N_out = "0100" THEN -- 0xC4 : NOP
                      -- NOP
                  END IF;
              WHEN "1101" => -- 0xDN : SEP
                  v.P_in := N_out;
                  IF clk_cnt = "011" THEN
                      v.wr_P  := '1'; -- P=N
                  END IF;
              WHEN "1110" => -- 0xEN : SEX
                  v.X_in  := N_out;
                  IF clk_cnt = "011" THEN
                      v.wr_X  := '1'; -- X=N
                  END IF;
              WHEN "1111" =>
                  IF N_out = "0000" THEN -- 0xF0 : LDX : M(R(X)) -> D
                      v.XtoR := '1'; -- Select R(X)
                      v.Do_MRD := '1';
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(X) -> A
                      ELSIF clk_cnt = "001" THEN
                          v.wr_D := '1'; -- M(R(X)) -> D
                      END IF;
                  END IF;
              WHEN OTHERS =>
            END CASE;
        WHEN c_S1_IDLE =>
        WHEN c_S2_DMA =>
        WHEN c_S3_INTERRUPT =>
        WHEN OTHERS =>
      END CASE;

      nxt_r <= v; -- update

  END PROCESS;

  p_instr : PROCESS(clk)
  BEGIN
      IF rising_edge(clk) THEN
          r <= nxt_r;
      END IF;
  END PROCESS;

  -- connect
  XtoR <= r.XtoR;
  NtoR <= r.NtoR;
  wr_A <= r.wr_A;
  wr_I <= r.wr_I;
  wr_N <= r.wr_N;
  mask_R <= r.mask_R;
  Go_Idle <= r.Go_Idle;
  Do_MRD  <= r.Do_MRD;
  wr_Q    <= r.wr_Q;
  Q_in    <= r.Q_in;
  float_DATA <= r.float_DATA;
  A_sel_lohi <= r.A_sel_lohi;
  wr_D   <= r.wr_D;
  rd_D   <= r.rd_D;
  X_in   <= r.X_in;
  wr_X   <= r.wr_X;
  P_in   <= r.P_in;
  wr_P   <= r.wr_P;
  wr_R   <= r.wr_R;
  R_in   <= r.R_in;

END str;
