library ieee;
use ieee.std_logic_1164.all;

entity rom1rom2_tb is
end rom1rom2_tb;

architecture sim of rom1rom2_tb is

-- Deklaration der zu testenden Komponente simdemo
component rom1
port(
   clk      : in  std_logic;
   address  : in  std_logic_vector (2 downto 0);
   data     : out std_logic_vector (7 downto 0)
   );  
end component;

component rom2
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
signal data_2_tb   :  std_logic_vector (7 downto 0);
signal address_inc :  std_logic_vector (7 downto 0);

begin --Instanziierung der zu testenden Komponente rom1 und rom2
   testobjekt_1: rom1 port map (
      clk      => clk_tb,    -- Taktsignal
      address  => address_tb,
      data     => data_1_tb -- Ausgangssignal
      );
   testobjekt_2: rom2 port map (
      clk      => clk_tb,    -- Taktsignal
      address  => address_tb,
      data     => data_2_tb -- Ausgangssignal
      );
	
   clk_gen : process
   begin
      clk_tb <= transport '1' after 50 ns , '0' after 100 ns;
      wait for 100 ns;
   end process clk_gen;
	
   check: process
   begin
      -- Ueberpruefen nach Reset
      wait until falling_edge(clk_tb);
      address_tb <= "000";
      wait until falling_edge(clk_tb);
      address_tb <= "001";
      assert data_1_tb = "00000001" report "data_1 hat nach Reset nicht den erwarteten Wert 1" severity error;
      assert data_2_tb = "00000001" report "data_2 hat nach Reset nicht den erwarteten Wert 1" severity error;

      wait until falling_edge(clk_tb);
      address_tb <= "010";
      assert data_1_tb = "00000100" report "data_1 hat nach Reset nicht den erwarteten Wert 4" severity error;
      assert data_2_tb = "00000100" report "data_2 hat nach Reset nicht den erwarteten Wert 4" severity error;

      wait until falling_edge(clk_tb);
      address_tb <= "011";
      assert data_1_tb = "00001001" report "data_1 hat nach Reset nicht den erwarteten Wert 9" severity error;
      assert data_2_tb = "00001001" report "data_2 hat nach Reset nicht den erwarteten Wert 9" severity error;

      wait until falling_edge(clk_tb);
      address_tb <= "100";
      assert data_1_tb = "00010000" report "data_1 hat nach Reset nicht den erwarteten Wert 16" severity error;
      assert data_2_tb = "00010000" report "data_2 hat nach Reset nicht den erwarteten Wert 16" severity error;

      wait until falling_edge(clk_tb);
      address_tb <= "101";
      assert data_1_tb = "00011001" report "data_1 hat nach Reset nicht den erwarteten Wert 25" severity error;
      assert data_2_tb = "00011001" report "data_2 hat nach Reset nicht den erwarteten Wert 25" severity error;

      wait until falling_edge(clk_tb);
      address_tb <= "110";
      assert data_1_tb = "00100100" report "data_1 hat nach Reset nicht den erwarteten Wert 36" severity error;
      assert data_2_tb = "00100100" report "data_2 hat nach Reset nicht den erwarteten Wert 36" severity error;

      wait until falling_edge(clk_tb);
      address_tb <= "111";
      assert data_1_tb = "00110001" report "data_1 hat nach Reset nicht den erwarteten Wert 49" severity error;
      assert data_2_tb = "00110001" report "data_2 hat nach Reset nicht den erwarteten Wert 49" severity error;

      wait until falling_edge(clk_tb);
      assert data_1_tb = "00000000" report "data_1 hat nach Reset nicht den erwarteten Wert 0" severity error;
      assert data_2_tb = "00000000" report "data_2 hat nach Reset nicht den erwarteten Wert 0" severity error;
      	
      assert false report "Simulation beendet" severity failure; -- Simulation beenden	
   
   end process check;
	
end sim;
