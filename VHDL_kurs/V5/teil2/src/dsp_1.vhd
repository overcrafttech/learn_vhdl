library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dsp_1 is
port (
    clk             : in std_logic;
    rst             : in std_logic;
    data_re         : in signed(3 downto 0);
    data_im         : in signed(3 downto 0);
    data_valid      : in std_logic;
    start           : in std_logic;
    result          : out unsigned(6 downto 0)
    );
end dsp_1;

architecture behavioral of dsp_1 is
signal i_result : unsigned(6 downto 0);
begin

process (clk, rst)
begin
    if rst = '1' then
        -- Reset
        i_result <= "0000000";

    elsif rising_edge(clk) then
        if start = '1' then
            i_result <= "0000000";
        elsif data_valid = '1' then
            i_result <= i_result + ("00" & (unsigned(abs(data_re(3) & data_re)) + unsigned(abs(data_im(3) & data_im))));
        else
        end if;

    end if;
end process;
result <= i_result;
end;

        
