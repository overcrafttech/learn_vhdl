library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer_tb is
end timer_tb;

architecture sim of timer_tb is

-- Deklaration der zu testenden Komponente pcu
component timer
    generic(
        divide_value : integer
    );
    port(   
        clk_100mhz        : in  std_logic;  
        reset             : in  std_logic; 
        sec_puls          : out  std_logic 
    ); 
end component; -- timer

-- Interne Signale der Testbench
-- Man haette auch auf die Verwendung des Suffix _tb verzichten koennen!
signal clk_tb        :  std_logic;  
signal rst_tb        :  std_logic; 
signal sec_tb        :  std_logic;

signal count_tb      :  integer := 0;


begin --Instanziierung der zu testenden Komponente pcu

   testobjekt: timer 
   generic map(
      divide_value => 99) -- für zähler
   port map (
      clk_100mhz  => clk_tb,  -- Taktsignal
      reset       => rst_tb,  -- synchrones Resetsignal
      sec_puls    => sec_tb
      );
   rst_gen : process
      -- Sorgt einmalig daf�r, dass der Wert von rst_tb (bzw. rst) 
      -- nach 120ns auf 1 und nach 160ns wieder zur�ck auf 0 gesetzt wird
      -- In der Initialisierungsphase werden folgende 2 Transaktionen erzeugt:
      -- (rst, 1, 120 + 0 delta)  und (rst, 0, 160ns + 0 delta)
      -- Nach der Initialisierungsphase ist rst_gen stets inaktiv
   begin
      rst_tb <= transport '1' after 32 ms , '0' after 42 ms; --reset nach drei takten über den vierten takt
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
      clk_tb <= transport '1' after 5 ms , '0' after 10 ms; --100Hz
      count_tb <= transport count_tb + 1 after 10 ms;
      wait for 10 ms;
   end process clk_gen;
	
   check: process
   begin

        wait until rst_tb = '1'; -- danach ist der reset '1'

        wait until rst_tb = '0';

        --assert pc_tb = x"0000" -- reset überprüfen
            --report "pc hat nach Reset nicht den erwarteten Wert (0)"
            --severity error;
        wait until sec_tb = '1';
        wait until sec_tb = '0';
        wait until sec_tb = '1';
      assert false report "Simulation beendet" severity failure; -- Simulation beenden	
   
   end process check;
	
end sim;