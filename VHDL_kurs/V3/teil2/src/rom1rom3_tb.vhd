library ieee;
use ieee.std_logic_1164.all;

entity rom1rom3_tb is
end rom1rom3_tb;

architecture sim of rom1rom3_tb is

-- Deklaration der zu testenden Komponente simdemo
component rom1
port(
   clk      : in  std_logic;
   address  : in  std_logic_vector (2 downto 0);
   data     : out std_logic_vector (7 downto 0)
   );  
end component;

component rom3
port(
   clk      : in  std_logic;
   address  : in  std_logic_vector (2 downto 0);
   data     : out std_logic_vector (7 downto 0)
   );  
end component;

-- Interne Signale der Testbench
-- Man haette auch auf die Verwendung des Suffix _tb verzichten koennen!
signal clk_tb      :  std_logic; -- Taktsignal der Testbench
signal address_tb  :  std_logic_vector (2 downto 0);
signal data_1_tb   :  std_logic_vector (7 downto 0); 
signal data_3_tb   :  std_logic_vector (7 downto 0);

begin --Instanziierung der zu testenden Komponente rom1 und rom2
   testobjekt_1: rom1 port map (
      clk      => clk_tb,   
      address  => address_tb,
      data     => data_1_tb 
      );
   testobjekt_3: rom3 port map (
      clk      => clk_tb,   
      address  => address_tb,
      data     => data_3_tb 
      );
	
   clk_gen : process
   begin
      clk_tb <= transport '1' after 50 ns , '0' after 100 ns;
      wait for 100 ns;
   end process clk_gen;
	
   check: process
   begin

      wait until falling_edge(clk_tb);
      address_tb <= "000";

      wait until falling_edge(clk_tb);
      address_tb <= "001";
   
      wait until falling_edge(clk_tb);
      address_tb <= "010";
      
      wait until falling_edge(clk_tb);
      address_tb <= "011";
      
      wait until falling_edge(clk_tb);
      address_tb <= "100";
      
      wait until falling_edge(clk_tb);
      address_tb <= "101";
      
      wait until falling_edge(clk_tb);
      address_tb <= "110";
      
      wait until falling_edge(clk_tb);
      address_tb <= "111";
     
      wait until falling_edge(clk_tb);
   
      assert false report "Simulation beendet" severity failure; -- Simulation beenden	
   
   end process check;
	
end sim;
