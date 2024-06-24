library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dsp_2 is
port (
    clk             : in std_logic;
    rst             : in std_logic;
    data_re         : in signed(3 downto 0);
    data_im         : in signed(3 downto 0);
    data_valid      : in std_logic;
    start           : in std_logic;
    result          : out unsigned(6 downto 0)
    );
end dsp_2;

architecture behavioral of dsp_2 is
signal sum_absre_absim : unsigned(4 downto 0);
signal i_result : unsigned(6 downto 0);
signal i_data_valid : std_logic;
begin

process (clk, rst)
begin
    if rst = '1' then
        -- Reset
        i_result <= "0000000";
        i_data_valid <= '0';
        sum_absre_absim <= "00000";

    elsif rising_edge(clk) then
        i_data_valid <= data_valid;
        sum_absre_absim <= unsigned(abs(data_re(3) & data_re)) + unsigned(abs(data_im(3) & data_im));
        if start = '1' then
            i_result <= "0000000";

        elsif i_data_valid = '1' then
            
            i_result <= i_result + ("00" & sum_absre_absim);
        else
        end if;
	
    end if;
end process;
result <= i_result;
end;
        
