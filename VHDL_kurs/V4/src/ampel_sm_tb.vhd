library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ampel_sm_tb is
end ampel_sm_tb;

architecture sim of ampel_sm_tb is

-- Deklaration der zu testenden Komponente pcu
component ampel_sm
    port
    (--clk_100mhz: in  std_logic; --100 MHz Systemclock (Quarz)
    reset     : in  std_logic;
    sec_puls  : in  std_logic;
    haupt1    : out std_logic_vector(2 downto 0);
    haupt2    : out std_logic_vector(2 downto 0);
    neben3    : out std_logic_vector(2 downto 0);
    neben4    : out std_logic_vector(2 downto 0) 
   );
end component; -- ampel

-- Interne Signale der Testbench
-- Man haette auch auf die Verwendung des Suffix _tb verzichten koennen!
signal clk_tb        :  std_logic;  
signal rst_tb        :  std_logic; 



begin --Instanziierung der zu testenden Komponente pcu

   testobjekt: ampel_sm 
   port map (
      sec_puls  => clk_tb,  -- Taktsignal
      reset       => rst_tb  -- synchrones Resetsignal
      );
   rst_gen : process
      -- Sorgt einmalig daf�r, dass der Wert von rst_tb (bzw. rst) 
      -- nach 120ns auf 1 und nach 160ns wieder zur�ck auf 0 gesetzt wird
      -- In der Initialisierungsphase werden folgende 2 Transaktionen erzeugt:
      -- (rst, 1, 120 + 0 delta)  und (rst, 0, 160ns + 0 delta)
      -- Nach der Initialisierungsphase ist rst_gen stets inaktiv
   begin
      rst_tb <= transport '1' after 6 ms , '0' after 11 ms; --reset nach drei takten über den vierten takt
      wait; 
   end process rst_gen;
	
   clk_gen : process
      -- Erzeugt das Taktsignal mit einer Periodendauer von 100ns
      -- Folgende Transaktionen f�r das Signal clk_tb bzw. clk werden erzeugt
      -- Initialisierungsphase (Zeitpunkt 0 ns + 0 delta)
      -- (clk, 1, 50ns + 0 delta) und (clk, 0, 100ns + 0 delta)
      -- Erneute Aktivierung des process zum Zeitpunkt 100 ns + 0 delta
      -- Transaktionen: (clk, 1, 150ns + 0 delta) und (clk, 0, 200ns + 0 delta)
      -- weitere Aktivierungen zum Zeitpunkt 200 ns + 0 delta und so weiter ...	
   begin
      clk_tb <= transport '1' after 999 ms , '0' after 1000 ms; --100Hz
      wait for 1000 ms;
   end process clk_gen;
	
   check: process
   begin

        wait until rst_tb = '1'; -- danach ist der reset '1'

        wait until rst_tb = '0';

        --assert pc_tb = x"0000" -- reset überprüfen
            --report "pc hat nach Reset nicht den erwarteten Wert (0)"
            --severity error;
        wait for 100 sec;
      assert false report "Simulation beendet" severity failure; -- Simulation beenden	
   
   end process check;
	
end sim;