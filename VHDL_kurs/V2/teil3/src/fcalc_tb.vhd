-- Gruppe 301

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fcalc_tb is
end fcalc_tb;

architecture sim of fcalc_tb is
    component fcalc
        port(
            a,b          : in  signed(7 downto 0);
            c            : out signed(8 downto 0);
            en           : in std_logic
            );
    end component;
    signal tb_a         : signed(7 downto 0); 
    signal tb_b         : signed(7 downto 0);
    signal tb_c         : signed(8 downto 0);
    signal tb_en        : std_logic;
    
begin
    dut: fcalc port map (a => tb_a, b => tb_b, c => tb_c, en => tb_en);
    
    stimuli: process
    begin
        
        report "Test unterer Grenzwert" severity note;
        tb_a <= "10000000";-- -128
        tb_b <= "01111111";--  127
        wait for 10 ns;
        tb_en <= '1';
        wait for 10 ns;
        assert tb_c = "101000000" report "tb_c hat nach Reset nicht den erwarteten Wert -192" severity error;
        tb_en <= '0';
        --wait for 10 ns;

        report "Test oberer Grenzwert" severity note;
        tb_a <= "01111111";--  127
        tb_b <= "10000000";-- -128
        wait for 10 ns;
        tb_en <= '1';
        wait for 10 ns;
        assert tb_c = "010111111" report "tb_c hat nach Reset nicht den erwarteten Wert 191" severity error;
        tb_en <= '0';
        --wait for 10 ns;

        report "Test Null" severity note;
        tb_a <= "00000001";-- 0
        tb_b <= "00000001";-- 0
        wait for 10 ns;
        tb_en <= '1';
        wait for 10 ns;
        assert tb_c = "000000000" report "tb_c hat nach Reset nicht den erwarteten Wert 0" severity error;
        tb_en <= '0';
        --wait for 10 ns;

        assert false report "Simulation finished!" severity failure;

    end process stimuli;
end sim;