-- Gruppe 301

library ieee;
use ieee.std_logic_1164.all;

entity blu is
  port (
        operation    : in  std_logic_vector(1 downto 0);
        a,b          : in  std_logic_vector(7 downto 0); -- 7 bis 0 fuer 8 Bit
        result       : out std_logic_vector(7 downto 0)
       );
end blu;

architecture verhalten of blu is
begin
  process (operation, a, b)
  begin
    case operation is
      when "00" =>                 -- 0b00 = 0
          result <= "00000000";
      when "01" =>                 -- 0b01 = 1
          result <= a and b;
      when "10" =>                 -- 0b10 = 2
          result <= a or b;
      when "11" =>                 -- 0b11 = 3
          result <= a xnor b;
      when others =>
          result <= "00000000";
    end case;
  end process;
end verhalten;