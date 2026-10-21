library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Control unit: opcode decoder made of AND/OR/NOT gates
-- LDI 0001, ADD 0010, NOT 0111, SHL 1000, JZ 1100. Everything else = NOP.
entity control_unit is
  port (OPCODE  : in  std_logic_vector(3 downto 0);
        Z       : in  std_logic;
        SEL_LDI : out std_logic;
        SEL_ADD : out std_logic;
        SEL_NOT : out std_logic;
        SEL_SHL : out std_logic;
        ACC_WE  : out std_logic;   -- write ACC and update Z
        PC_LOAD : out std_logic);  -- JZ taken
end control_unit;

architecture gate_level of control_unit is
  signal ldi, add, inv, shl, jz : std_logic;
begin
  ldi <= (not OPCODE(3)) and (not OPCODE(2)) and (not OPCODE(1)) and OPCODE(0);
  add <= (not OPCODE(3)) and (not OPCODE(2)) and OPCODE(1) and (not OPCODE(0));
  inv <= (not OPCODE(3)) and OPCODE(2) and OPCODE(1) and OPCODE(0);
  shl <= OPCODE(3) and (not OPCODE(2)) and (not OPCODE(1)) and (not OPCODE(0));
  jz  <= OPCODE(3) and OPCODE(2) and (not OPCODE(1)) and (not OPCODE(0));

  SEL_LDI <= ldi;
  SEL_ADD <= add;
  SEL_NOT <= inv;
  SEL_SHL <= shl;
  ACC_WE  <= ldi or add or inv or shl;
  PC_LOAD <= jz and Z;
end gate_level;
