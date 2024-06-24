-- Gruppe 301

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
  port (
        operation    : in  std_logic_vector(2 downto 0) := "000";
        a,b          : in  std_logic_vector(7 downto 0) := "00000000"; -- 7 bis 0 fuer 8 Bit
        resultat     : out std_logic_vector(8 downto 0) := "000000000"
        );
end alu;

architecture verhalten of alu is
signal a_s   : signed(8 downto 0) := "000000000";
signal b_s   : signed(8 downto 0) := "000000000";
begin
  process (operation, a, b, b_s, a_s)
  begin
          resultat <= "000000000";
          if a(7) = '1' then
            a_s <= '1' & signed(a);
          end if;
          
          if a(7) = '0' then
            a_s <= '0' & signed(a);
          end if;
          
          if b(7) = '1' then
            b_s <= '1' & signed(b);
          end if;
          
          if b(7) = '0' then
            b_s <= '0' & signed(b);
          end if;

    case operation is
      when "000" =>
        resultat <= "000000000";
      when "001" =>  
        resultat <= '0' & (a and b);
      when "010" => 
        resultat <= '0' & (a or b);
      when "011" => 
        resultat <= '0' & (a xnor b);

      when "100" => -- Addition

        resultat <= std_logic_vector(a_s + b_s);

      when "101" => -- Subtraktion

        resultat <= std_logic_vector(a_s - b_s);

      when others =>
          resultat <= "XXXXXXXXX";
    end case;
  end process;
end verhalten;