library ieee;
use ieee.numeric_bit.all;

entity simdemo_tb is
end simdemo_tb;

architecture sim of simdemo_tb is

-- Deklaration der zu testenden Komponente simdemo
component simdemo
port(
   clk  : in  bit; -- Taktsignal
   rst  : in  bit; -- asynchrones Resetsignal
   out1	: out bit_vector (1 downto 0);   -- 1. Ausgangssignal
   out2	: out bit_vector (1 downto 0)    -- 2. Ausgangssignal
   );  
end component; -- simdemo

-- Interne Signale der Testbench
-- Man haette auch auf die Verwendung des Suffix _tb verzichten koennen!
signal clk_tb   : bit; -- Taktsignal der Testbench
signal rst_tb   : bit; -- asynchrones Resetsignal der Testbench
signal out1_tb  : bit_vector (1 downto 0);   -- 1. Ausgangssignal der Testbench
signal out2_tb  : bit_vector (1 downto 0);   -- 2. Ausgangssignal der Testbench
	
begin Instanziierung der zu testenden Komponente simdemo
   testobjekt: simdemo port map (
      clk  => clk_tb,  -- Taktsignal
      rst  => rst_tb,  -- asynchrones Resetsignal
      out1 => out1_tb, -- 1. Ausgangssignal
      out2 => out2_tb  -- 2. Ausgangssignal
      );

   rst_gen : process
      -- Sorgt einmalig daf�r, dass der Wert von rst_tb (bzw. rst) 
      -- nach 120ns auf 1 und nach 160ns wieder zur�ck auf 0 gesetzt wird
      -- In der Initialisierungsphase werden folgende 2 Transaktionen erzeugt:
      -- (rst, 1, 120 + 0 delta)  und (rst, 0, 160ns + 0 delta)
      -- Nach der Initialisierungsphase ist rst_gen stets inaktiv
   begin
      rst_tb <= transport '1' after 120 ns , '0' after 160 ns;
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
      clk_tb <= transport '1' after 50 ns , '0' after 100 ns;
      wait for 100 ns;
   end process clk_gen;
	
   check: process
   -- ueberprueft das Ergebnis out1_tb und out2_tb (bzw. out1 und out2) ab erfolgtem Reset 
   variable v_out1, v_out2 : integer; -- zur Typkonvertierung
   begin
      -- Ueberpruefen nach Reset
      wait until rst_tb = '1'; -- Zeitpunkt: Setzen des Reset
	                             -- Ausgaenge von simdemo werden sich erst spaeter aendern (Delta Delay)	  
      wait until rst_tb = '0'; -- Zeitpunkt: Ruecknahme des Reset
      assert out1_tb = "11" report "out1 hat nach Reset nicht den erwarteten Wert 11" severity error;
      assert out2_tb = "11" report "out2 hat nach Reset nicht den erwarteten Wert 11" severity error;

      -- Ueberpruefen nach aktiven Taktflanken      
      wait until clk_tb = '1'; -- Zeitpunkt: erste steigende Taktflanke nach Ruecknehme des Reset
	                             -- Ausgaenge von simdemo werden sich erst spaeter aendern (Delta Delay)
      for i in 3 downto 1 loop
         wait until clk_tb = '1'; -- Zeitpunkt: naechste steigende Taktflanke
         v_out1 := to_integer(unsigned(out1_tb));
         v_out2 := to_integer(unsigned(out2_tb));		  
         assert v_out1 = i-1 report "out1 hat nicht den erwarteten Wert" severity error;
         assert v_out2 = i   report "out2 hat nicht den erwarteten Wert" severity error;		  
      end loop;

      wait until clk_tb = '1'; -- Zeitpunkt: naechste steigende Taktflanke
      v_out1 := to_integer(unsigned(out1_tb));
      v_out2 := to_integer(unsigned(out2_tb));		  
      assert v_out1 = 3 report "out1 hat nicht den erwarteten Wert" severity error;
      assert v_out2 = 0 report "out2 hat nicht den erwarteten Wert" severity error;

      wait until clk_tb = '0';	
      assert false report "Simulation beendet" severity failure; -- Simulation beenden	
   
   end process check;
	
end sim;
