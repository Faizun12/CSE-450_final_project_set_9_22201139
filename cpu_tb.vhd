library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu_tb is end cpu_tb;

architecture sim of cpu_tb is
  signal CLK   : std_logic := '0';
  signal RESET : std_logic := '1';
  signal Q     : std_logic_vector(7 downto 0);
  signal Z     : std_logic;
  signal PC    : std_logic_vector(3 downto 0);
  type v8 is array (1 to 7) of std_logic_vector(7 downto 0);
  -- expected ACC / Z / next PC after cycles 1..7 (Appendix B, Set 9)
  constant EXP_ACC : v8 := (x"FF", x"00", x"00", x"11", x"22", x"22", x"44");
  constant EXP_Z   : std_logic_vector(1 to 7) := "0110000";
  type v4 is array (1 to 7) of std_logic_vector(3 downto 0);
  constant EXP_PC  : v4 := (x"1", x"2", x"5", x"6", x"7", x"8", x"9");
begin
  DUT : entity work.cpu_top port map (CLK, RESET, Q, Z, PC);

  CLK <= not CLK after 5 ns;

  stim : process
  begin
    wait until rising_edge(CLK);          -- cycle 0: RESET = 1
    wait for 1 ns;
    assert Q = x"00" and Z = '1' and PC = x"0" report "RESET FAIL" severity error;
    RESET <= '0';
    for i in 1 to 7 loop
      wait until rising_edge(CLK);
      wait for 1 ns;
      assert Q = EXP_ACC(i) and Z = EXP_Z(i) and PC = EXP_PC(i)
        report "MISMATCH at cycle " & integer'image(i) severity error;
    end loop;
    report "Simulation finished" severity note;
    wait;
  end process;
end sim;
