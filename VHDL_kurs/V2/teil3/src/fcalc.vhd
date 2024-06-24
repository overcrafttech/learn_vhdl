library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fcalc is
    port (
        a,b    : in  signed(7 downto 0);
        c      : out signed(8 downto 0);
        en     : in std_logic
        );
end fcalc;

architecture verhalten of fcalc is
    signal div : signed(8 downto 0);
 
    begin
        division: process (b)
        begin 
            if b(7) = '1' then                         -- ist b negativ? ja:
                if b(0) = '1' then                     -- wäre b/2 ungerade? --> wird eine '1' (lsb) abgeschnitten?
                    div <= ("11" & b(7 downto 1)) - 1; -- falls ja
                else                            
                    div <= "11" & b(7 downto 1);       -- falls nein
                end if;
            else                                       -- ist b negativ? nein:
                if b(0) = '1' then                     -- wäre das b/2 ungerade? --> wird eine '1' (lsb) abgeschnitten?
                    div <= ("00" & b(7 downto 1)) + 1; -- falls ja
                else                                   
                    div <= "00" & b(7 downto 1);       -- falls nein
                end if;
            end if;

        end process division;

        subtraktion: process (a, div, en)
        begin
            if en = '1' then
                if a(7) = '1' then                         -- ist b negativ? ja:
                    c <= ('1' & a) - div;
                else                                       -- ist b negativ? nein:
                    c <= ('0' & a) - div;
                end if;
            else
                c <= "000000000";
            end if;
        end process subtraktion;

    end verhalten;




