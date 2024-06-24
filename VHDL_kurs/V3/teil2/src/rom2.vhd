library ieee;
use ieee.std_logic_1164.all;

entity rom2 is
    port( clk      : in  std_logic;             
          address  : in  std_logic_vector (2 downto 0);
          data     : out std_logic_vector (7 downto 0)
     );  
  end rom2;
  
   architecture verhalten of rom2 is
      signal address_intern : std_logic_vector(2 downto 0);
      begin

      speicher: process (address_intern)
         begin
         
         case address is
            when "000" =>
               data <= "00000001";
            when "001" =>
               data <= "00000100";
            when "010" =>
               data <= "00001001";
            when "011" =>
               data <= "00010000";
            when "100" =>
               data <= "00011001";
            when "101" =>
               data <= "00100100";
            when "110" =>
               data <= "00110001";
            when others =>
               data <= "00000000";
         end case;

      end process speicher;

      flipflop: process (clk)
         begin

         if rising_edge(clk) then
           address_intern <= address;
         end if;

      end process flipflop;
      
   end;