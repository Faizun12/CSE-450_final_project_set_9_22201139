library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- N-bit ripple-carry adder made of full adders (N = 8 in the ALU, N = 4 in the PC)
entity ripple_adder is
  generic (N : integer := 8);
  port (A, B : in  std_logic_vector(N-1 downto 0);
        CIN  : in  std_logic;
        SUM  : out std_logic_vector(N-1 downto 0);
        COUT : out std_logic);
end ripple_adder;

architecture structural of ripple_adder is
  signal c : std_logic_vector(N downto 0);
begin
  c(0) <= CIN;
  gen : for i in 0 to N-1 generate
    FA : entity work.full_adder
      port map (A => A(i), B => B(i), CIN => c(i), S => SUM(i), COUT => c(i+1));
  end generate;
  COUT <= c(N);
end structural;
