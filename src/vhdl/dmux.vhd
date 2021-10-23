-------------------------------------------------------------------------------
--
-- File Name: dmux.vhd
-- Author: Leon Hiemstra
--
-- Title: Databus multiplexer
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


ENTITY dmux IS
  PORT (
    float0 : IN  STD_LOGIC;
    float1 : IN  STD_LOGIC;
    rst    : IN  STD_LOGIC;
   
    d_src0 : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
    d_src1 : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);

    d_snk  : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
    data   : INOUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END dmux;


ARCHITECTURE str OF dmux IS

  SIGNAL d0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL d1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL d_snk_i : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

  PROCESS(float0, float1, data, d_snk_i, d0, d1)
  BEGIN
    IF(float0 = '0' AND float1 = '1') THEN
      data <= d0;
      d_snk_i <= (OTHERS => 'Z');
    ELSIF(float0 = '1' AND float1 = '0') THEN
      data <= d1;
      d_snk_i <= (OTHERS => 'Z');
    ELSE
      data <= (OTHERS => 'Z');
      d_snk_i <= data;
    END IF;
  END PROCESS;



--  PROCESS(float1, data, d_snk_i)
--  BEGIN
--    IF(float1 = '1') THEN
--      data <= (OTHERS => 'Z');
--      d_snk_i <= data;
--    ELSE
--      data <= d_snk_i;
--      d_snk_i <= (OTHERS => 'Z');
--    END IF;
--  END PROCESS;

  d_snk <= d_snk_i;


  --data   <= --(OTHERS => 'Z') WHEN ((float0 = '1' AND float1 = '1') OR (float0 = '0' AND float1 = '0'))
            --ELSE 
				
				
				--d0 WHEN (float0 = '0' AND float1 = '1') 
            --ELSE d1 WHEN (float0 = '1' AND float1 = '0')
				--ELSE (OTHERS => 'Z');
  d0     <= (OTHERS => '0') WHEN rst = '1'   ELSE d_src0;
  d1     <= (OTHERS => '0') WHEN rst = '1'   ELSE d_src1;

END str;
