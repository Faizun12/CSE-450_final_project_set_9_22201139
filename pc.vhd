library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- 4-bit program counter: 4 D flip-flops + incrementer (ripple adder) + 2:1 mux (gates)
entity pc is
  port (CLK, RESET : in  std_logic;
        LOAD       : in  std_logic;                     -- 1 = jump (JZ taken)
        ADDR       : in  std_logic_vector(3 downto 0);  -- jump target
        PC_OUT     : out std_logic_vector(3 downto 0));
end pc;

architecture structural of pc is
  signal cur, inc, nxt : std_logic_vector(3 downto 0);
begin
  -- PC + 1
  INCR : entity work.ripple_adder
    generic map (N => 4)
    port map (A => cur, B => "0001", CIN => '0', SUM => inc, COUT => open);

  -- 2:1 mux: LOAD = 0 -> PC + 1, LOAD = 1 -> jump address
  gen : for i in 0 to 3 generate
    nxt(i) <= (inc(i) and (not LOAD)) or (ADDR(i) and LOAD);
    FF : entity work.dff_sr
      generic map (RESET_VAL => '0')
      port map (CLK => CLK, RST => RESET, EN => '1', D => nxt(i), Q => cur(i));
  end generate;

  PC_OUT <= cur;
end structural;
