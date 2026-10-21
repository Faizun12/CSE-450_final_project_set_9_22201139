library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpu_top is
  port (CLK, RESET : in  std_logic;
        Q          : out std_logic_vector(7 downto 0);
        Z          : out std_logic;
        PC         : out std_logic_vector(3 downto 0));
end cpu_top;

architecture structural of cpu_top is
  signal pc_s                       : std_logic_vector(3 downto 0);
  signal instr                      : std_logic_vector(11 downto 0);
  signal acc_s, res_s               : std_logic_vector(7 downto 0);
  signal z_s                        : std_logic;
  signal s_ldi, s_add, s_not, s_shl : std_logic;
  signal acc_we, pc_load            : std_logic;
begin
  U_PC  : entity work.pc
    port map (CLK => CLK, RESET => RESET, LOAD => pc_load,
              ADDR => instr(3 downto 0), PC_OUT => pc_s);

  U_ROM : entity work.prog_rom
    port map (ADDR => pc_s, INSTR => instr);

  U_CU  : entity work.control_unit
    port map (OPCODE => instr(11 downto 8), Z => z_s,
              SEL_LDI => s_ldi, SEL_ADD => s_add, SEL_NOT => s_not, SEL_SHL => s_shl,
              ACC_WE => acc_we, PC_LOAD => pc_load);

  U_ALU : entity work.alu
    port map (ACC => acc_s, IMM => instr(7 downto 0),
              SEL_LDI => s_ldi, SEL_ADD => s_add, SEL_NOT => s_not, SEL_SHL => s_shl,
              RESULT => res_s);

  U_ACC : entity work.acc_z
    port map (CLK => CLK, RESET => RESET, WE => acc_we, D => res_s, ACC => acc_s, Z => z_s);

  Q <= acc_s;  Z <= z_s;  PC <= pc_s;
end structural;
