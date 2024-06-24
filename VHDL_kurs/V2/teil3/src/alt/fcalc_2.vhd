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
    signal mul    : signed(8 downto 0);
    --signal div  : signed(8 downto 0);
    signal zahler : signed(8 downto 0);

    begin
        --process (a)
        process (a, b, en, mul, zahler)
        begin
            if en = '0' then
                c <= "000000000";
            else
                -- multiplikation
                if a(7) = '1' then
                    mul <= a & '0';
                else
                    mul <= a & '0';
                end if;
                --subtraktion zaehler
                if b(7) = '1' then
                    zahler <= mul - ('1' & b);
                else
                    zahler <= mul - ('0' & b);
                end if;
                --division
                if zahler(8) = '1' then
                    c <= '1' & zahler(8 downto 1);
                else
                    c <= '0' & zahler(8 downto 1);
                end if;
            end if;
        end process;
    end verhalten;




