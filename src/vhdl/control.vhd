LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.cdp1802_pkg.ALL;

ENTITY control IS
  PORT (
    clk        : IN  STD_LOGIC;
    nwait      : IN STD_LOGIC;
    nclear     : IN STD_LOGIC;
    dma_in     : IN STD_LOGIC;
    dma_out    : IN STD_LOGIC;
    interrupt  : IN STD_LOGIC;

    rst        : OUT STD_LOGIC;

    sc         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    tpa        : OUT STD_LOGIC;
    tpb        : OUT STD_LOGIC;
    nMRD       : OUT STD_LOGIC;
    nMWR       : OUT STD_LOGIC;
    addr_lohi  : OUT STD_LOGIC;

    ie         : IN  STD_LOGIC;
    wr_T       : OUT STD_LOGIC;
    preset_P   : OUT STD_LOGIC;
    preset_X   : OUT STD_LOGIC;
    preset_IE  : OUT STD_LOGIC;
    reset_DATA : OUT STD_LOGIC;
    state      : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    clk_cnt_out: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    Go_Idle    : IN  STD_LOGIC
  );
END control;


ARCHITECTURE str OF control IS

  TYPE t_reg IS RECORD
    mode       : STD_LOGIC_VECTOR(1 DOWNTO 0);
    state      : STD_LOGIC_VECTOR(3 DOWNTO 0);
    rst        : STD_LOGIC;
    tpa        : STD_LOGIC;
    nMRD       : STD_LOGIC;
    nMWR       : STD_LOGIC;
    wr_T       : STD_LOGIC;
    preset_P   : STD_LOGIC;
    preset_X   : STD_LOGIC;
    preset_IE  : STD_LOGIC;
    reset_DATA : STD_LOGIC;
    clk_cnt    : NATURAL RANGE 0 TO 7;
  END RECORD;

  TYPE f_reg IS RECORD
    tpb    : STD_LOGIC;
  END RECORD;

  SIGNAL mode_in  : STD_LOGIC_VECTOR(1 DOWNTO 0);
  SIGNAL clk_cnt  : STD_LOGIC_VECTOR(2 DOWNTO 0);
  SIGNAL r, nxt_r : t_reg;
  SIGNAL f, nxt_f : f_reg;

BEGIN


  p_control_comb : PROCESS(mode_in, r, dma_in, dma_out, interrupt, ie, Go_Idle)
    VARIABLE v : t_reg;
    VARIABLE w : f_reg;
  BEGIN
      v := r;
      w := f;
      v.rst := '0';
      v.tpa := '0';
      w.tpb := '0';
      v.wr_T := '0';
      v.preset_P := '0';
      v.preset_X := '0';
      v.preset_IE := '0';
      v.reset_DATA := '0';


      IF r.mode = c_PAUSE THEN
          -- pause
      ELSE

          IF r.clk_cnt = 7 THEN
              v.clk_cnt := 0;
          ELSE
              v.clk_cnt := r.clk_cnt + 1;
          END IF;


          IF r.clk_cnt = 0 THEN
              v.tpa := '1';
          ELSIF r.clk_cnt = 6 THEN
              w.tpb := '1';
          END IF;


          CASE r.state IS
            WHEN c_S0_FETCH =>
                IF r.clk_cnt = 0 THEN
                    v.nMRD := '0';
                ELSIF r.clk_cnt = 7 THEN
                    v.state := c_S1_EXEC;
                    v.nMRD  := '1';
                END IF;
            WHEN c_S1_RESET =>
                v.tpa := '0';
                w.tpb := '0';
                v.rst  := '1';
                v.nMRD := '1';
                v.nMWR := '1';
                v.clk_cnt := 0;
                v.reset_DATA := '1';
                v.state := c_S1_INIT;
            WHEN c_S1_INIT =>
                v.reset_DATA := '1';
                IF r.clk_cnt = 7 THEN
                    IF dma_in = '1' OR dma_out = '1' THEN 
                        v.state := c_S2_DMA;
                    ELSE
                        v.state := c_S0_FETCH;
                    END IF;
                END IF;
            WHEN c_S1_EXEC =>
                IF r.clk_cnt = 7 THEN
                    IF dma_in = '1' OR dma_out = '1' THEN
                        v.state := c_S2_DMA;
                    ELSIF interrupt = '1' THEN 
                        v.state := c_S3_INTERRUPT;
                    ELSIF Go_Idle = '1' THEN 
                        v.state := c_S1_IDLE;
                    ELSE
                        v.state := c_S0_FETCH;
                    END IF;
                END IF;
            WHEN c_S1_IDLE =>
                v.tpa := '0'; -- suppressed
                IF r.clk_cnt = 7 THEN
                    IF dma_in = '1' OR dma_out = '1' THEN
                        v.state := c_S2_DMA;
                    ELSIF interrupt = '1' THEN 
                        v.state := c_S3_INTERRUPT;
                    END IF;
                END IF;
            WHEN c_S2_DMA =>
                IF r.clk_cnt = 7 THEN
                    IF dma_in = '1' OR dma_out = '1' THEN
                        v.state := c_S2_DMA;
                    ELSIF interrupt = '1' THEN 
                        v.state := c_S3_INTERRUPT;
                    ELSE
                        v.state := c_S0_FETCH;
                    END IF;
                END IF;
            WHEN c_S3_INTERRUPT =>
                IF r.clk_cnt = 0 THEN
                    IF ie = '1' THEN
                        v.wr_T := '1';
                    END IF;
                ELSIF r.clk_cnt = 1 THEN
                    IF ie = '1' THEN
                        v.preset_P := '1';
                    END IF;
                ELSIF r.clk_cnt = 2 THEN
                    IF ie = '1' THEN
                        v.preset_X := '1';
                    END IF;
                ELSIF r.clk_cnt = 3 THEN
                    v.preset_IE := '1';
                ELSIF r.clk_cnt = 7 THEN
                    IF dma_in = '1' OR dma_out = '1' THEN
                        v.state := c_S2_DMA;
                    ELSE
                        v.state := c_S0_FETCH;
                    END IF;
                END IF;
            WHEN OTHERS =>
                v.state := c_S1_RESET;
          END CASE;

      END IF;

      CASE mode_in IS
        WHEN c_RESET => 
            v.state := c_S1_RESET;
            v.mode  := c_RESET;
        WHEN c_LOAD  => 
            IF r.mode = c_RESET THEN
                v.mode  := c_LOAD;
                v.clk_cnt := 0;
                v.state := c_S1_IDLE;
            END IF;
        WHEN c_PAUSE => 
            v.mode  := c_PAUSE;
        WHEN c_RUN   =>
            IF r.mode = c_PAUSE THEN
                v.mode  := c_RUN;
            ELSIF r.mode = c_RESET THEN
                v.mode  := c_RUN;
                v.clk_cnt := 0;
                v.state := c_S1_INIT;
            END IF;
        WHEN OTHERS =>
      END CASE;


      nxt_r <= v; -- update
      nxt_f <= w; -- update

  END PROCESS;

  p_control : PROCESS(clk)
  BEGIN
      IF falling_edge(clk) THEN
          r <= nxt_r;
      END IF;
      IF rising_edge(clk) THEN
          f <= nxt_f;
      END IF;
  END PROCESS;

  -- connect
  mode_in(0) <= nwait;
  mode_in(1) <= nclear;
  sc(0) <= r.state(2);
  sc(1) <= r.state(3);
  state <= r.state;
  clk_cnt <= std_logic_vector(to_unsigned(r.clk_cnt, clk_cnt'length));
  clk_cnt_out <= clk_cnt;
  addr_lohi <= '1' WHEN (clk_cnt = "000" OR clk_cnt = "001") ELSE '0';
  rst   <= r.rst;
  tpa   <= r.tpa;
  tpb   <= f.tpb;
  nMRD  <= r.nMRD;
  nMWR  <= r.nMWR;
  wr_T  <= r.wr_T;
  preset_P  <= r.preset_P;
  preset_X  <= r.preset_X;
  preset_IE <= r.preset_IE;
  reset_DATA <= r.reset_DATA;

END str;
