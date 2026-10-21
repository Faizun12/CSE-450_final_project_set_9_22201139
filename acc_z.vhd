library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Accumulator (8 D flip-flops, reset 0x00) and Z flag (1 D flip-flop, reset 1)
-- Z flag input = NOR of all bits of the value being written to ACC
entity acc_z is
  port (CLK, RESET : in  std_logic;
        WE         : in  std_logic;
        D          : in  std_logic_vector(7 downto 0);
        ACC        : out std_logic_vector(7 downto 0);
        Z          : out std_logic);
end acc_z;

architecture structural of acc_z is
  signal zero_s : std_logic;
begin
  gen : for i in 0 to 7 generate
    FF : entity work.dff_sr
      generic map (RESET_VAL => '0')
      port map (CLK => CLK, RST => RESET, EN => WE, D => D(i), Q => ACC(i));
  end generate;

  zero_s <= not (D(7) or D(6) or D(5) or D(4) or D(3) or D(2) or D(1) or D(0));

  ZFF : entity work.dff_sr
    generic map (RESET_VAL => '1')
    port map (CLK => CLK, RST => RESET, EN => WE, D => zero_s, Q => Z);
end structural;
