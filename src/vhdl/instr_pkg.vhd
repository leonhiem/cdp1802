-------------------------------------------------------------------------------
--
-- File Name: instr_pkg.vhd
-- Author: Leon Hiemstra
--
-- Title: CDP1802 instruction set
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


PACKAGE instr_pkg IS

  CONSTANT c_IDL  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"00";

  CONSTANT c_INC_0  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"10";
  CONSTANT c_INC_1  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"11";
  CONSTANT c_INC_2  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"12";
  CONSTANT c_INC_3  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"13"; -- tested
  CONSTANT c_INC_4  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"14";
  CONSTANT c_INC_5  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"15";
  CONSTANT c_INC_6  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"16";
  CONSTANT c_INC_7  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"17";
  CONSTANT c_INC_8  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"18";
  CONSTANT c_INC_9  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"19";
  CONSTANT c_INC_A  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"1A";
  CONSTANT c_INC_B  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"1B";
  CONSTANT c_INC_C  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"1C";
  CONSTANT c_INC_D  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"1D";
  CONSTANT c_INC_E  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"1E";
  CONSTANT c_INC_F  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"1F";

  CONSTANT c_DEC_0  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"20";
  CONSTANT c_DEC_1  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"21";
  CONSTANT c_DEC_2  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"22";
  CONSTANT c_DEC_3  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"23"; -- tested
  CONSTANT c_DEC_4  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"24";
  CONSTANT c_DEC_5  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"25";
  CONSTANT c_DEC_6  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"26";
  CONSTANT c_DEC_7  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"27";
  CONSTANT c_DEC_8  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"28";
  CONSTANT c_DEC_9  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"29";
  CONSTANT c_DEC_A  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"2A";
  CONSTANT c_DEC_B  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"2B";
  CONSTANT c_DEC_C  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"2C";
  CONSTANT c_DEC_D  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"2D";
  CONSTANT c_DEC_E  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"2E";
  CONSTANT c_DEC_F  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"2F";

  CONSTANT c_BR     : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"30"; -- tested
  CONSTANT c_BQ     : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"31";
  CONSTANT c_BZ     : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"32"; -- tested
  CONSTANT c_BDF    : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"33";
  CONSTANT c_BPZ    : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"33";
  CONSTANT c_BGE    : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"33";
  CONSTANT c_B1     : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"34"; -- tested
  CONSTANT c_B2     : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"35"; -- tested
  CONSTANT c_B3     : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"36";
  CONSTANT c_B4     : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"37";
  CONSTANT c_SKP    : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"38";
  CONSTANT c_NBR    : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"38";
  CONSTANT c_BNQ    : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"39"; -- tested
  CONSTANT c_BNZ    : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"3A"; -- tested
  CONSTANT c_BNF    : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"3B";
  CONSTANT c_BM     : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"3B";
  CONSTANT c_BL     : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"3B";
  CONSTANT c_BN1    : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"3C"; -- tested
  CONSTANT c_BN2    : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"3D";
  CONSTANT c_BN3    : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"3E";
  CONSTANT c_BN4    : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"3F";

  CONSTANT c_IRX    : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"60"; -- tested

  CONSTANT c_OUT_1  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"61";
  CONSTANT c_OUT_2  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"62";
  CONSTANT c_OUT_3  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"63";
  CONSTANT c_OUT_4  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"64";
  CONSTANT c_OUT_5  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"65"; -- tested
  CONSTANT c_OUT_6  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"66";
  CONSTANT c_OUT_7  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"67";

  CONSTANT c_INP_9  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"69";
  CONSTANT c_INP_A  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"6A";
  CONSTANT c_INP_B  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"6B";
  CONSTANT c_INP_C  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"6C";
  CONSTANT c_INP_D  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"6D"; -- tested
  CONSTANT c_INP_E  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"6E";
  CONSTANT c_INP_F  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"6F";

  CONSTANT c_GLO_0  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"80";
  CONSTANT c_GLO_1  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"81";
  CONSTANT c_GLO_2  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"82";
  CONSTANT c_GLO_3  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"83"; -- tested
  CONSTANT c_GLO_4  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"84";
  CONSTANT c_GLO_5  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"85";
  CONSTANT c_GLO_6  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"86";
  CONSTANT c_GLO_7  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"87";
  CONSTANT c_GLO_8  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"88";
  CONSTANT c_GLO_9  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"89";
  CONSTANT c_GLO_A  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"8A";
  CONSTANT c_GLO_B  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"8B";
  CONSTANT c_GLO_C  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"8C";
  CONSTANT c_GLO_D  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"8D";
  CONSTANT c_GLO_E  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"8E";
  CONSTANT c_GLO_F  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"8F";

  CONSTANT c_PLO_0  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"A0";
  CONSTANT c_PLO_1  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"A1"; -- tested
  CONSTANT c_PLO_2  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"A2"; -- tested
  CONSTANT c_PLO_3  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"A3"; -- tested
  CONSTANT c_PLO_4  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"A4";
  CONSTANT c_PLO_5  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"A5";
  CONSTANT c_PLO_6  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"A6";
  CONSTANT c_PLO_7  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"A7";
  CONSTANT c_PLO_8  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"A8";
  CONSTANT c_PLO_9  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"A9"; -- tested
  CONSTANT c_PLO_A  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"AA";
  CONSTANT c_PLO_B  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"AB";
  CONSTANT c_PLO_C  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"AC";
  CONSTANT c_PLO_D  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"AD";
  CONSTANT c_PLO_E  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"AE";
  CONSTANT c_PLO_F  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"AF";

  CONSTANT c_GHI_0  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"90"; -- tested
  CONSTANT c_GHI_1  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"91";
  CONSTANT c_GHI_2  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"92";
  CONSTANT c_GHI_3  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"93"; -- tested
  CONSTANT c_GHI_4  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"94";
  CONSTANT c_GHI_5  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"95";
  CONSTANT c_GHI_6  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"96";
  CONSTANT c_GHI_7  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"97";
  CONSTANT c_GHI_8  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"98";
  CONSTANT c_GHI_9  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"99";
  CONSTANT c_GHI_A  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"9A";
  CONSTANT c_GHI_B  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"9B";
  CONSTANT c_GHI_C  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"9C";
  CONSTANT c_GHI_D  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"9D";
  CONSTANT c_GHI_E  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"9E";
  CONSTANT c_GHI_F  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"9F";

  CONSTANT c_PHI_0  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"B0";
  CONSTANT c_PHI_1  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"B1"; -- tested
  CONSTANT c_PHI_2  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"B2"; -- tested
  CONSTANT c_PHI_3  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"B3"; -- tested
  CONSTANT c_PHI_4  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"B4";
  CONSTANT c_PHI_5  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"B5";
  CONSTANT c_PHI_6  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"B6";
  CONSTANT c_PHI_7  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"B7";
  CONSTANT c_PHI_8  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"B8";
  CONSTANT c_PHI_9  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"B9"; -- tested
  CONSTANT c_PHI_A  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"BA";
  CONSTANT c_PHI_B  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"BB";
  CONSTANT c_PHI_C  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"BC";
  CONSTANT c_PHI_D  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"BD";
  CONSTANT c_PHI_E  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"BE";
  CONSTANT c_PHI_F  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"BF";

  CONSTANT c_LDN_1  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"01";
  CONSTANT c_LDN_2  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"02";
  CONSTANT c_LDN_3  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"03"; -- tested
  CONSTANT c_LDN_4  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"04";
  CONSTANT c_LDN_5  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"05";
  CONSTANT c_LDN_6  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"06";
  CONSTANT c_LDN_7  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"07";
  CONSTANT c_LDN_8  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"08";
  CONSTANT c_LDN_9  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"09";
  CONSTANT c_LDN_A  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"0A";
  CONSTANT c_LDN_B  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"0B";
  CONSTANT c_LDN_C  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"0C";
  CONSTANT c_LDN_D  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"0D";
  CONSTANT c_LDN_E  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"0E";
  CONSTANT c_LDN_F  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"0F";

  CONSTANT c_LDA_0  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"40";
  CONSTANT c_LDA_1  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"41";
  CONSTANT c_LDA_2  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"42";
  CONSTANT c_LDA_3  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"43"; -- tested
  CONSTANT c_LDA_4  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"44";
  CONSTANT c_LDA_5  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"45";
  CONSTANT c_LDA_6  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"46";
  CONSTANT c_LDA_7  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"47";
  CONSTANT c_LDA_8  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"48";
  CONSTANT c_LDA_9  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"49";
  CONSTANT c_LDA_A  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"4A";
  CONSTANT c_LDA_B  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"4B";
  CONSTANT c_LDA_C  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"4C";
  CONSTANT c_LDA_D  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"4D";
  CONSTANT c_LDA_E  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"4E";
  CONSTANT c_LDA_F  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"4F";

  CONSTANT c_LDX    : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"F0"; -- tested
  CONSTANT c_LDXA   : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"72"; -- tested
  CONSTANT c_LDI    : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"F8"; -- tested

  CONSTANT c_STR_0  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"50";
  CONSTANT c_STR_1  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"51";
  CONSTANT c_STR_2  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"52"; -- tested
  CONSTANT c_STR_3  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"53"; -- tested
  CONSTANT c_STR_4  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"54";
  CONSTANT c_STR_5  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"55";
  CONSTANT c_STR_6  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"56";
  CONSTANT c_STR_7  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"57";
  CONSTANT c_STR_8  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"58";
  CONSTANT c_STR_9  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"59";
  CONSTANT c_STR_A  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"5A";
  CONSTANT c_STR_B  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"5B";
  CONSTANT c_STR_C  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"5C";
  CONSTANT c_STR_D  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"5D";
  CONSTANT c_STR_E  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"5E";
  CONSTANT c_STR_F  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"5F";

  CONSTANT c_STXD   : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"73"; -- tested

  CONSTANT c_OR   : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"F1"; -- tested
  CONSTANT c_ORI  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"F9"; -- tested
  CONSTANT c_XOR  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"F3"; -- tested
  CONSTANT c_XRI  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"FB"; -- tested
  CONSTANT c_AND  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"F2"; -- tested
  CONSTANT c_ANI  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"FA"; -- tested
  CONSTANT c_SHR  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"F6"; -- tested
  CONSTANT c_RSHR : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"76"; -- tested
  CONSTANT c_SHL  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"FE"; -- tested
  CONSTANT c_RSHL : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"7E"; -- tested

  CONSTANT c_ADD  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"F4"; -- tested
  CONSTANT c_ADI  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"FC"; -- tested
  CONSTANT c_ADC  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"74"; -- tested
  CONSTANT c_ADCI : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"7C"; -- tested
  CONSTANT c_SD   : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"F5"; -- tested
  CONSTANT c_SDI  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"FD"; -- tested
  CONSTANT c_SM   : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"F7"; -- tested
  CONSTANT c_SMI  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"FF"; -- tested
  CONSTANT c_SDB  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"75"; -- tested
  CONSTANT c_SMB  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"77"; -- tested
  CONSTANT c_SDBI : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"7D"; -- tested
  CONSTANT c_SMBI : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"7F"; -- tested

  CONSTANT c_SAV  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"78"; -- tested
  CONSTANT c_MARK : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"79";
  CONSTANT c_RET  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"70"; -- tested
  CONSTANT c_DIS  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"71"; -- tested

  CONSTANT c_REQ  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"7A"; -- tested
  CONSTANT c_SEQ  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"7B"; -- tested
  --

  CONSTANT c_LBR  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"C0"; -- tested
  CONSTANT c_LBQ  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"C1"; -- tested
  CONSTANT c_LBZ  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"C2"; -- tested
  CONSTANT c_LBDF : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"C3"; -- tested
  CONSTANT c_NOP  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"C4"; -- tested
  CONSTANT c_LSNQ : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"C5"; -- tested
  CONSTANT c_LSNZ : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"C6";
  CONSTANT c_LSNF : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"C7";
  CONSTANT c_NLBR : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"C8";
  CONSTANT c_LSKP : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"C8"; -- tested
  CONSTANT c_LBNQ : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"C9"; -- tested
  CONSTANT c_LBNZ : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"CA"; -- tested
  CONSTANT c_LBNF : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"CB";
  CONSTANT c_LSIE : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"CC";
  CONSTANT c_LSQ  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"CD";
  CONSTANT c_LSZ  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"CE";
  CONSTANT c_LSDF : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"CF"; -- tested

  CONSTANT c_SEP_0  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"D0";
  CONSTANT c_SEP_1  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"D1";
  CONSTANT c_SEP_2  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"D2";
  CONSTANT c_SEP_3  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"D3"; -- tested
  CONSTANT c_SEP_4  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"D4";
  CONSTANT c_SEP_5  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"D5";
  CONSTANT c_SEP_6  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"D6";
  CONSTANT c_SEP_7  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"D7";
  CONSTANT c_SEP_8  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"D8";
  CONSTANT c_SEP_9  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"D9";
  CONSTANT c_SEP_A  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"DA";
  CONSTANT c_SEP_B  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"DB";
  CONSTANT c_SEP_C  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"DC";
  CONSTANT c_SEP_D  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"DD";
  CONSTANT c_SEP_E  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"DE";
  CONSTANT c_SEP_F  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"DF";

  CONSTANT c_SEX_0  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"E0";
  CONSTANT c_SEX_1  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"E1";
  CONSTANT c_SEX_2  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"E2"; -- tested
  CONSTANT c_SEX_3  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"E3"; -- tested
  CONSTANT c_SEX_4  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"E4";
  CONSTANT c_SEX_5  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"E5";
  CONSTANT c_SEX_6  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"E6";
  CONSTANT c_SEX_7  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"E7";
  CONSTANT c_SEX_8  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"E8";
  CONSTANT c_SEX_9  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"E9"; -- tested
  CONSTANT c_SEX_A  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"EA";
  CONSTANT c_SEX_B  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"EB";
  CONSTANT c_SEX_C  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"EC";
  CONSTANT c_SEX_D  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"ED";
  CONSTANT c_SEX_E  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"EE";
  CONSTANT c_SEX_F  : STD_LOGIC_VECTOR(7 DOWNTO 0) := X"EF";


  --
END instr_pkg;

PACKAGE BODY instr_pkg IS
END instr_pkg;

