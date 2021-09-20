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
    Do_MWR     : OUT STD_LOGIC;
    Q_in       : OUT STD_LOGIC;
    Q_out      : IN  STD_LOGIC;
    wr_Q       : OUT STD_LOGIC;
    float_DATA : OUT STD_LOGIC;
    A_sel_lohi : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    D_out      : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    D_in       : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
    DF_out     : IN  STD_LOGIC;
    alu_oper   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    wr_D       : OUT STD_LOGIC;
    rd_D       : OUT STD_LOGIC;
    wr_DF      : OUT STD_LOGIC;
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
    Do_MWR   : STD_LOGIC;
    Q_in     : STD_LOGIC;
    wr_Q     : STD_LOGIC;
    float_DATA : STD_LOGIC;
    A_sel_lohi : STD_LOGIC_VECTOR(1 DOWNTO 0);
    alu_oper   : STD_LOGIC_VECTOR(3 DOWNTO 0);
    wr_D     : STD_LOGIC;
    rd_D     : STD_LOGIC;
    wr_DF    : STD_LOGIC;
    X_in     : STD_LOGIC_VECTOR(3 DOWNTO 0);
    wr_X     : STD_LOGIC;
    P_in     : STD_LOGIC_VECTOR(3 DOWNTO 0);
    wr_P     : STD_LOGIC;
    wr_R     : STD_LOGIC;
    R_in     : STD_LOGIC_VECTOR(15 DOWNTO 0);
  END RECORD;

  SIGNAL r, nxt_r : t_reg;

BEGIN

  p_instr_comb : PROCESS(state, r, N_out, I_out, A_out, clk_cnt, D_out, D_in, Q_out, DF_out)
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
      v.Do_MWR  := '0';
      v.wr_Q := '0';
      v.float_DATA := '1';
      v.A_sel_lohi := "00";
      v.alu_oper   := c_ALU_NOP;
      v.wr_D := '0';
      v.rd_D := '0';
      v.wr_DF := '0';
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
              WHEN "0011" => -- 0x3N
                  IF N_out = "0000" THEN -- 0x30 : BR : M(R(P)) -> R(P).0
                      -- select R(P)
                      v.mask_R := "01"; -- select R(P).0
                      v.Do_MRD := '1';
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(P) -> A
                      ELSIF clk_cnt = "010" THEN
                          v.R_in(7 DOWNTO 0) := D_in; -- connect M(R(P))
                      ELSIF clk_cnt = "011" THEN
                          v.wr_R := '1';
                      END IF;
                  ELSIF N_out = "0001" THEN    -- 0x31 : BQ : IF Q=1, M(R(P))->R(P).0 ELSE R(P)+1
                      -- select R(P)
                      v.Do_MRD := '1';
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(P) -> A
                      ELSIF clk_cnt = "010" THEN
                          IF Q_out = '1' THEN
                              v.mask_R := "01"; -- select R(P).0
                              v.R_in(7 DOWNTO 0) := D_in; -- connect M(R(P))
                          ELSE
                              v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                          END IF;
                      ELSIF clk_cnt = "011" THEN
                          v.wr_R := '1';
                      END IF;
                  ELSIF N_out = "0010" THEN    -- 0x32 : BZ : IF D=0, M(R(P))->R(P).0 ELSE R(P)+1
                      -- select R(P)
                      v.Do_MRD := '1';
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(P) -> A
                      ELSIF clk_cnt = "010" THEN
                          IF D_out = "00000000" THEN
                              v.mask_R := "01"; -- select R(P).0
                              v.R_in(7 DOWNTO 0) := D_in; -- connect M(R(P))
                          ELSE
                              v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                          END IF;
                      ELSIF clk_cnt = "011" THEN
                          v.wr_R := '1';
                      END IF;
                  ELSIF N_out = "0011" THEN    -- 0x33 : BDF : IF DF=1, M(R(P))->R(P).0 ELSE R(P)+1
                      -- select R(P)
                      v.Do_MRD := '1';
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(P) -> A
                      ELSIF clk_cnt = "010" THEN
                          IF DF_out = '1' THEN
                              v.mask_R := "01"; -- select R(P).0
                              v.R_in(7 DOWNTO 0) := D_in; -- connect M(R(P))
                          ELSE
                              v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                          END IF;
                      ELSIF clk_cnt = "011" THEN
                          v.wr_R := '1';
                      END IF;
                  ELSIF N_out = "1000" THEN    -- 0x38 : SKP : R(P)+1
                      -- select R(P)
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(P) -> A
                      ELSIF clk_cnt = "010" THEN
                          v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                      ELSIF clk_cnt = "011" THEN
                          v.wr_R := '1';
                      END IF;
                  ELSIF N_out = "1001" THEN    -- 0x39 : BNQ : IF Q=0, M(R(P))->R(P).0 ELSE R(P)+1
                      -- select R(P)
                      v.Do_MRD := '1';
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(P) -> A
                      ELSIF clk_cnt = "010" THEN
                          IF Q_out = '0' THEN
                              v.mask_R := "01"; -- select R(P).0
                              v.R_in(7 DOWNTO 0) := D_in; -- connect M(R(P))
                          ELSE
                              v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                          END IF;
                      ELSIF clk_cnt = "011" THEN
                          v.wr_R := '1';
                      END IF;
                  ELSIF N_out = "1010" THEN    -- 0x3A : BNZ : IF D NOT 0, M(R(P))->R(P).0 ELSE R(P)+1
                      -- select R(P)
                      v.Do_MRD := '1';
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(P) -> A
                      ELSIF clk_cnt = "010" THEN
                          IF D_out /= "00000000" THEN
                              v.mask_R := "01"; -- select R(P).0
                              v.R_in(7 DOWNTO 0) := D_in; -- connect M(R(P))
                          ELSE
                              v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                          END IF;
                      ELSIF clk_cnt = "011" THEN
                          v.wr_R := '1';
                      END IF;
                  ELSIF N_out = "1011" THEN    -- 0x3B : BNF : IF DF=0, M(R(P))->R(P).0 ELSE R(P)+1
                      -- select R(P)
                      v.Do_MRD := '1';
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(P) -> A
                      ELSIF clk_cnt = "010" THEN
                          IF DF_out = '0' THEN
                              v.mask_R := "01"; -- select R(P).0
                              v.R_in(7 DOWNTO 0) := D_in; -- connect M(R(P))
                          ELSE
                              v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                          END IF;
                      ELSIF clk_cnt = "011" THEN
                          v.wr_R := '1';
                      END IF;
                  END IF;
              WHEN "0100" => -- 0x4N : LDA : M(R(N)) -> D ; R(N)+1
                  v.NtoR := '1'; -- Select R(N)
                  v.Do_MRD := '1';
                  IF clk_cnt = "000" THEN
                      v.wr_A := '1'; -- R(N) -> A
                  ELSIF clk_cnt = "010" THEN
                      v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                  ELSIF clk_cnt = "011" THEN
                      v.wr_D := '1'; -- M(R(N)) -> D
                      v.wr_R := '1';
                  END IF;
              WHEN "0101" => -- 0x5N : STR : D -> M(R(N))
                  v.NtoR := '1'; -- Select R(N)
                  v.float_DATA := '0';
                  v.rd_D := '1'; -- D -> M(R(N))
                  IF clk_cnt = "000" THEN
                      v.wr_A := '1'; -- R(N) -> A
                  ELSIF clk_cnt = "010" THEN
                      v.Do_MWR := '1';
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
                  IF N_out = "0010" THEN -- 0x72 : LDXA : M(R(X)) -> D ; R(X)+1
                      v.XtoR := '1'; -- Select R(X)
                      v.Do_MRD := '1';
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(X) -> A
                      ELSIF clk_cnt = "010" THEN
                          v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                      ELSIF clk_cnt = "011" THEN
                          v.wr_D := '1'; -- M(R(X)) -> D
                          v.wr_R := '1';
                      END IF;
                  ELSIF N_out = "0011" THEN    -- 0x73 : STXD : D -> M(R(X)) ; R(X)-1
                      v.XtoR := '1'; -- Select R(X)
                      v.float_DATA := '0';
                      v.rd_D := '1'; -- D -> M(R(X))
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(X) -> A
                      ELSIF clk_cnt = "010" THEN
                          v.R_in := std_logic_vector(unsigned(A_out) - 1); -- A--
                      ELSIF clk_cnt = "011" THEN
                          v.Do_MWR := '1';
                          v.wr_R := '1';
                      END IF;
                  ELSIF N_out = "0100" THEN -- 0x74 : ADC : M(R(X)) + D + DF -> DF, D
                      v.XtoR := '1'; -- Select R(X)
                      v.Do_MRD := '1';
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_U_ADC;
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(X) -> A
                      ELSIF clk_cnt = "011" THEN
                          v.wr_D := '1'; -- M(R(X)) -> D
                          v.wr_DF := '1'; -- carry -> DF
                      END IF;
                  ELSIF N_out = "0101" THEN -- 0x75 : SDB : M(R(X)) - D - (NOT DF) -> DF, D
                      v.XtoR := '1'; -- Select R(X)
                      v.Do_MRD := '1';
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_S_SUBB;
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(X) -> A
                      ELSIF clk_cnt = "011" THEN
                          v.wr_D := '1'; -- M(R(X)) -> D
                          v.wr_DF := '1'; -- carry -> DF
                      END IF;
                  ELSIF N_out = "0110" THEN -- 0x76 : RSHR : D >>= 1; LSB(D)->DF; DF->MSB(D)
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_RSHR;
                      IF clk_cnt = "011" THEN
                          v.wr_D  := '1'; -- alu_out -> D
                          v.wr_DF := '1'; -- carry -> DF
                      END IF;
                  ELSIF N_out = "0111" THEN -- 0x77 : SMB : D - M(R(X)) - (NOT DF) -> DF, D
                      v.XtoR := '1'; -- Select R(X)
                      v.Do_MRD := '1';
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_S_SUBB_REV;
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(X) -> A
                      ELSIF clk_cnt = "011" THEN
                          v.wr_D := '1'; -- M(R(X)) -> D
                          v.wr_DF := '1'; -- carry -> DF
                      END IF;
                  ELSIF N_out = "1011" THEN    -- 0x7B : SEQ
                      v.Q_in  := '1';       -- Q=1
                      IF clk_cnt = "011" THEN
                          v.wr_Q  := '1';
                      END IF;
                  ELSIF N_out = "1010" THEN -- 0x7A : REQ
                      v.Q_in  := '0';       -- Q=0
                      IF clk_cnt = "011" THEN
                          v.wr_Q  := '1';
                      END IF;
                  ELSIF N_out = "1100" THEN -- 0x7C : ADI : M(R(P)) + D +DF -> DF,D; R(P)+1
                      v.Do_MRD := '1';
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_U_ADC;
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(P) -> A
                      ELSIF clk_cnt = "010" THEN
                          v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                      ELSIF clk_cnt = "011" THEN
                          v.wr_D := '1'; -- M(R(P)) -> D
                          v.wr_DF := '1'; -- carry -> DF
                          v.wr_R := '1';
                      END IF;
                  ELSIF N_out = "1101" THEN -- 0x7D : SDBI : M(R(P)) - D - (NOT DF) -> DF,D; R(P)+1
                      v.Do_MRD := '1';
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_S_SUBB;
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(P) -> A
                      ELSIF clk_cnt = "010" THEN
                          v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                      ELSIF clk_cnt = "011" THEN
                          v.wr_D := '1'; -- M(R(P)) -> D
                          v.wr_DF := '1'; -- carry -> DF
                          v.wr_R := '1';
                      END IF;
                  ELSIF N_out = "1110" THEN -- 0x7E : RSHL : D >>= 1; MSB(D)->DF; DF->LSB(D)
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_RSHL;
                      IF clk_cnt = "011" THEN
                          v.wr_D  := '1'; -- alu_out -> D
                          v.wr_DF := '1'; -- carry -> DF
                      END IF;
                  ELSIF N_out = "1111" THEN -- 0x7F : SMBI : D - M(R(P)) - (NOT DF) -> DF,D; R(P)+1
                      v.Do_MRD := '1';
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_S_SUBB_REV;
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(P) -> A
                      ELSIF clk_cnt = "010" THEN
                          v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                      ELSIF clk_cnt = "011" THEN
                          v.wr_D := '1'; -- M(R(P)) -> D
                          v.wr_DF := '1'; -- carry -> DF
                          v.wr_R := '1';
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
                  ELSIF N_out = "0001" THEN -- 0xF1 : OR : M(R(X)) OR D -> D
                      v.XtoR := '1'; -- Select R(X)
                      v.Do_MRD := '1';
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_OR;
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(X) -> A
                      ELSIF clk_cnt = "001" THEN
                          v.wr_D := '1'; -- M(R(X)) -> D
                      END IF;
                  ELSIF N_out = "0010" THEN -- 0xF2 : AND : M(R(X)) AND D -> D
                      v.XtoR := '1'; -- Select R(X)
                      v.Do_MRD := '1';
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_AND;
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(X) -> A
                      ELSIF clk_cnt = "001" THEN
                          v.wr_D := '1'; -- M(R(X)) -> D
                      END IF;
                  ELSIF N_out = "0011" THEN -- 0xF3 : XOR : M(R(X)) XOR D -> D
                      v.XtoR := '1'; -- Select R(X)
                      v.Do_MRD := '1';
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_XOR;
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(X) -> A
                      ELSIF clk_cnt = "001" THEN
                          v.wr_D := '1'; -- M(R(X)) -> D
                      END IF;
                  ELSIF N_out = "0100" THEN -- 0xF4 : ADD : M(R(X)) + D -> DF, D
                      v.XtoR := '1'; -- Select R(X)
                      v.Do_MRD := '1';
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_U_ADD;
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(X) -> A
                      ELSIF clk_cnt = "011" THEN
                          v.wr_D := '1'; -- M(R(X)) -> D
                          v.wr_DF := '1'; -- carry -> DF
                      END IF;
                  ELSIF N_out = "0101" THEN -- 0xF5 : SD : M(R(X)) - D -> DF, D
                      v.XtoR := '1'; -- Select R(X)
                      v.Do_MRD := '1';
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_S_SUB;
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(X) -> A
                      ELSIF clk_cnt = "011" THEN
                          v.wr_D := '1'; -- M(R(X)) -> D
                          v.wr_DF := '1'; -- carry -> DF
                      END IF;
                  ELSIF N_out = "0110" THEN -- 0xF6 : SHR : D >>= 1; LSB(D)->DF; 0->MSB(D)
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_SHR;
                      IF clk_cnt = "011" THEN
                          v.wr_D  := '1'; -- alu_out -> D
                          v.wr_DF := '1'; -- carry -> DF
                      END IF;
                  ELSIF N_out = "0111" THEN -- 0xF7 : SM : D - M(R(X)) -> DF, D
                      v.XtoR := '1'; -- Select R(X)
                      v.Do_MRD := '1';
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_S_SUB_REV;
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(X) -> A
                      ELSIF clk_cnt = "011" THEN
                          v.wr_D := '1'; -- M(R(X)) -> D
                          v.wr_DF := '1'; -- carry -> DF
                      END IF;
                  ELSIF N_out = "1000" THEN -- 0xF8 : LDI : M(R(P)) -> D; R(P)+1
                      v.Do_MRD := '1';
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(P) -> A
                      ELSIF clk_cnt = "010" THEN
                          v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                      ELSIF clk_cnt = "011" THEN
                          v.wr_D := '1'; -- M(R(P)) -> D
                          v.wr_R := '1';
                      END IF;
                  ELSIF N_out = "1001" THEN -- 0xF9 : ORI : M(R(P)) OR D -> D; R(P)+1
                      v.Do_MRD := '1';
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_OR;
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(P) -> A
                      ELSIF clk_cnt = "010" THEN
                          v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                      ELSIF clk_cnt = "011" THEN
                          v.wr_D := '1'; -- M(R(P)) -> D
                          v.wr_R := '1';
                      END IF;
                  ELSIF N_out = "1010" THEN -- 0xFA : ANI : M(R(P)) AND D -> D; R(P)+1
                      v.Do_MRD := '1';
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_AND;
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(P) -> A
                      ELSIF clk_cnt = "010" THEN
                          v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                      ELSIF clk_cnt = "011" THEN
                          v.wr_D := '1'; -- M(R(P)) -> D
                          v.wr_R := '1';
                      END IF;
                  ELSIF N_out = "1011" THEN -- 0xFB : XRI : M(R(P)) XOR D -> D; R(P)+1
                      v.Do_MRD := '1';
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_XOR;
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(P) -> A
                      ELSIF clk_cnt = "010" THEN
                          v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                      ELSIF clk_cnt = "011" THEN
                          v.wr_D := '1'; -- M(R(P)) -> D
                          v.wr_R := '1';
                      END IF;
                  ELSIF N_out = "1100" THEN -- 0xFC : ADI : M(R(P)) + D -> DF,D; R(P)+1
                      v.Do_MRD := '1';
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_U_ADD;
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(P) -> A
                      ELSIF clk_cnt = "010" THEN
                          v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                      ELSIF clk_cnt = "011" THEN
                          v.wr_D := '1'; -- M(R(P)) -> D
                          v.wr_DF := '1'; -- carry -> DF
                          v.wr_R := '1';
                      END IF;
                  ELSIF N_out = "1101" THEN -- 0xFD : SDI : M(R(P)) - D -> DF,D; R(P)+1
                      v.Do_MRD := '1';
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_S_SUB;
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(P) -> A
                      ELSIF clk_cnt = "010" THEN
                          v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                      ELSIF clk_cnt = "011" THEN
                          v.wr_D := '1'; -- M(R(P)) -> D
                          v.wr_DF := '1'; -- carry -> DF
                          v.wr_R := '1';
                      END IF;
                  ELSIF N_out = "1110" THEN -- 0xFE : SHL : D <<= 1; MSB(D)->DF; 0->LSB(D)
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_SHL;
                      IF clk_cnt = "011" THEN
                          v.wr_D  := '1'; -- alu_out -> D
                          v.wr_DF := '1'; -- carry -> DF
                      END IF;
                  ELSIF N_out = "1111" THEN -- 0xFF : SMI : D - M(R(P)) -> DF,D; R(P)+1
                      v.Do_MRD := '1';
                      v.rd_D := '1';
                      v.alu_oper := c_ALU_S_SUB_REV;
                      IF clk_cnt = "000" THEN
                          v.wr_A := '1'; -- R(P) -> A
                      ELSIF clk_cnt = "010" THEN
                          v.R_in := std_logic_vector(unsigned(A_out) + 1); -- A++
                      ELSIF clk_cnt = "011" THEN
                          v.wr_D := '1'; -- M(R(P)) -> D
                          v.wr_DF := '1'; -- carry -> DF
                          v.wr_R := '1';
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
  Do_MWR  <= r.Do_MWR;
  wr_Q    <= r.wr_Q;
  Q_in    <= r.Q_in;
  float_DATA <= r.float_DATA;
  A_sel_lohi <= r.A_sel_lohi;
  alu_oper   <= r.alu_oper;
  wr_D   <= r.wr_D;
  rd_D   <= r.rd_D;
  wr_DF  <= r.wr_DF;
  X_in   <= r.X_in;
  wr_X   <= r.wr_X;
  P_in   <= r.P_in;
  wr_P   <= r.wr_P;
  wr_R   <= r.wr_R;
  R_in   <= r.R_in;

END str;
