library ieee;
use ieee.std_logic_1164.all;


entity rom1 is
    port( clk      : in  std_logic;             
          address  : in  std_logic_vector (2 downto 0);
          data     : out std_logic_vector (7 downto 0)
     );  
  end rom1;
  
   architecture verhalten of rom1 is
      signal data_intern : std_logic_vector(7 downto 0);
      begin

      speicher: process (address)
         begin
         
         case address is
            when "000" =>
               data_intern <= "00000001";
            when "001" =>
               data_intern <= "00000100";
            when "010" =>
               data_intern <= "00001001";
            when "011" =>
               data_intern <= "00010000";
            when "100" =>
               data_intern <= "00011001";
            when "101" =>
               data_intern <= "00100100";
            when "110" =>
               data_intern <= "00110001";
            when others =>
               data_intern <= "00000000";
         end case;

      end process speicher;

      flipflop: process (clk)
         begin

         if rising_edge(clk) then
            data <= data_intern;
         end if;

      end process flipflop;
      
   end;