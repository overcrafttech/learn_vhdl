-- Gruppe 301

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_tb is
end alu_tb;

architecture sim of alu_tb is
    component alu
        port(
            operation    : in  std_logic_vector(2 downto 0):= "000";
            a,b          : in  std_logic_vector(7 downto 0):= "00000000"; -- 7 bis 0 für 8 Bit
            resultat     : out std_logic_vector(8 downto 0):= "000000000"
            );
    end component;
    signal t_op         : std_logic_vector(2 downto 0); 
    signal t_a          : std_logic_vector(7 downto 0);
    signal t_b          : std_logic_vector(7 downto 0);
    signal t_res        : std_logic_vector(8 downto 0);
    
begin
    dut: alu port map (operation => t_op, a => t_a, b => t_b, resultat => t_res);
    
    stimuli: process
    begin
        report "*** Beginn Test ALU ***" severity note;
        t_op <= "000"; -- operation auf 0
        wait for 10 ns;

    -- Test Addition, res = (-2) + 2 = 0
        t_a  <= std_logic_vector(to_signed(-2, t_a'length));
        t_b  <= std_logic_vector(to_signed(2, t_b'length));
        t_op <= "100"; -- addition
        wait for 10 ns;
        assert t_res = std_logic_vector(to_signed(0, t_res'length))
            report "res hat nicht den erwarteten wert 0" 
            severity error; 

    -- Test Subtraktion, res = (-2) - 2 = (-4)
        t_a  <= std_logic_vector(to_signed(-2, t_a'length));
        t_b  <= std_logic_vector(to_signed(2, t_b'length));
        t_op <= "101"; -- subtraktion
        wait for 10 ns;
        assert t_res = std_logic_vector(to_signed(-4, t_res'length))
            report "res hat nicht den erwarteten wert -4" 
            severity error;

    -- Test Subtraktion, res = 127 - (-128) = 255
        t_a  <= std_logic_vector(to_signed(127, t_a'length)); 
        t_b  <= std_logic_vector(to_signed(-128, t_b'length));
        t_op <= "101"; -- subtraktion
        wait for 10 ns;
        assert t_res = std_logic_vector(to_signed(255, t_res'length))
            report "res hat nicht den erwarteten wert 255" 
            severity error;

        assert false              -- Simulation beenden	
            report "Simulation beendet" 
            severity failure;

    end process stimuli;
end sim;
