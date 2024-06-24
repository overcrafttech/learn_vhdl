-- Gruppe 301

library ieee;
use ieee.std_logic_1164.all;

entity blu_tb is
end blu_tb;

architecture sim of blu_tb is
    component blu
        port(
            operation    : in  std_logic_vector(1 downto 0);
            a,b          : in  std_logic_vector(7 downto 0); -- 7 bis 0 für 8 Bit
            result       : out std_logic_vector(7 downto 0)
            );
    end component;
    signal t_op         : std_logic_vector(1 downto 0); 
    signal t_a          : std_logic_vector(7 downto 0);
    signal t_b          : std_logic_vector(7 downto 0);
    signal t_res        : std_logic_vector(7 downto 0);

    
begin
    dut: blu port map (operation => t_op, a => t_a, b => t_b, result => t_res);
    
    stimuli: process
    begin
        t_op <= "00"; -- operation auf 0
        wait for 10 ns;
        t_a  <= "110--XXU";
        t_b  <= "10001011";
        t_op <= "01"; -- bitwise and
        wait for 10 ns;
        t_op <= "10"; -- bitwise or
        wait for 10 ns;
        t_op <= "11"; -- bitwise xnor
        wait for 10 ns;
    end process stimuli;

end sim;
