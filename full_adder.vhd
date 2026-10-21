library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- 1-bit full adder built from basic gates
entity full_adder is
  port (A, B, CIN : in  std_logic;
        S, COUT   : out std_logic);
end full_adder;

architecture gate_level of full_adder is
  signal x1, a1, a2 : std_logic;
begin
  x1   <= A xor B;
  S    <= x1 xor CIN;
  a1   <= A and B;
  a2   <= x1 and CIN;
  COUT <= a1 or a2;
end gate_level;
