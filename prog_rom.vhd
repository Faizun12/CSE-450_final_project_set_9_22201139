library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity prog_rom is
  port (ADDR  : in  std_logic_vector(3 downto 0);
        INSTR : out std_logic_vector(11 downto 0));
end prog_rom;

architecture rtl of prog_rom is
  type rom_t is array (0 to 15) of std_logic_vector(11 downto 0);
  constant ROM : rom_t := (
    0      => x"1FF",  -- LDI 0xFF
    1      => x"700",  -- NOT
    2      => x"C05",  -- JZ  0x05
    3      => x"277",  -- ADD 0x77
    4      => x"277",  -- ADD 0x77
    5      => x"211",  -- ADD 0x11
    6      => x"800",  -- SHL
    7      => x"C00",  -- JZ  0x00
    8      => x"800",  -- SHL
    others => x"000"); -- NOP
begin
  INSTR <= ROM(to_integer(unsigned(ADDR)));
end rtl;
