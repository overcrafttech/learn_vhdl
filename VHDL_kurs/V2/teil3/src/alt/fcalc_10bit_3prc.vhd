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
    signal mul    : signed(9 downto 0);
    signal zahler : signed(9 downto 0);

    begin
        multiplikation: process (a)
        begin 
            if a(7) = '1' then
                mul <= '1' & a & '0';
            else
                mul <= '0' & a & '0';
            end if;
        end process multiplikation;

        subtraktion: process (b, mul)
        begin
            if b(7) = '1' then
                zahler <= mul - ("11" & b);
            else
                zahler <= mul - ("00" & b);
            end if;
        end process subtraktion;

        division: process (zahler)
        begin
            if zahler(9) = '1' then
                c <= zahler(9 downto 1);
            else
                c <= zahler(9 downto 1);
            end if;
        end process division;
    end verhalten;




