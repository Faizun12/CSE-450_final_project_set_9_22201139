library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- 8-bit ALU: ripple-carry adder + NOT gates + shift wiring + AND-OR output selector
entity alu is
  port (ACC     : in  std_logic_vector(7 downto 0);
        IMM     : in  std_logic_vector(7 downto 0);
        SEL_LDI : in  std_logic;
        SEL_ADD : in  std_logic;
        SEL_NOT : in  std_logic;
        SEL_SHL : in  std_logic;
        RESULT  : out std_logic_vector(7 downto 0));
end alu;

architecture structural of alu is
  signal sum_s, not_s, shl_s : std_logic_vector(7 downto 0);
begin
  -- ADD: ACC + IMM, carry out discarded
  ADDER : entity work.ripple_adder
    generic map (N => 8)
    port map (A => ACC, B => IMM, CIN => '0', SUM => sum_s, COUT => open);

  -- NOT: eight inverters
  not_s <= not ACC;

  -- SHL: shift left by 1, 0 enters the LSB
  shl_s <= ACC(6 downto 0) & '0';

  -- Output selector (AND-OR, one-hot selects from the control unit)
  gen : for i in 0 to 7 generate
    RESULT(i) <= (IMM(i)   and SEL_LDI) or
                 (sum_s(i) and SEL_ADD) or
                 (not_s(i) and SEL_NOT) or
                 (shl_s(i) and SEL_SHL);
  end generate;
end structural;
