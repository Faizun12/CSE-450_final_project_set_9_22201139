library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- D flip-flop, rising edge, synchronous active-high reset (priority) and enable
entity dff_sr is
  generic (RESET_VAL : std_logic := '0');
  port (CLK, RST, EN, D : in  std_logic;
        Q               : out std_logic);
end dff_sr;

architecture rtl of dff_sr is
  signal q_r : std_logic := RESET_VAL;
begin
  process(CLK)
  begin
    if rising_edge(CLK) then
      if RST = '1' then
        q_r <= RESET_VAL;
      elsif EN = '1' then
        q_r <= D;
      end if;
    end if;
  end process;
  Q <= q_r;
end rtl;
