library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pcu_tb is
end pcu_tb;

architecture sim of pcu_tb is

-- Deklaration der zu testenden Komponente pcu
component pcu
    port(   
        clk        : in  std_logic;  
        reset      : in  std_logic; 
        load       : in  std_logic; 
        jump       : in  std_logic; 
        stop       : in  std_logic;            
        loadvalue  : in  std_logic_vector (15 downto 0);
        pc         : out std_logic_vector (15 downto 0)
    ); 
end component; -- pcu

-- Interne Signale der Testbench
-- Man haette auch auf die Verwendung des Suffix _tb verzichten koennen!
signal clk_tb        :  std_logic;  
signal rst_tb        :  std_logic; 
signal load_tb       :  std_logic; 
signal jump_tb       :  std_logic; 
signal stop_tb       :  std_logic;            
signal loadvalue_tb  :  std_logic_vector (15 downto 0);
signal pc_tb         :  std_logic_vector (15 downto 0);

signal count_tb      :  integer := 0;


begin --Instanziierung der zu testenden Komponente pcu

   testobjekt: pcu port map (
      clk        => clk_tb,  -- Taktsignal
      reset      => rst_tb,  -- synchrones Resetsignal
      load       => load_tb,
      jump       => jump_tb,
      stop       => stop_tb,
      loadvalue  => loadvalue_tb,
      pc         => pc_tb
      );
   rst_gen : process
      -- Sorgt einmalig daf�r, dass der Wert von rst_tb (bzw. rst) 
      -- nach 120ns auf 1 und nach 160ns wieder zur�ck auf 0 gesetzt wird
      -- In der Initialisierungsphase werden folgende 2 Transaktionen erzeugt:
      -- (rst, 1, 120 + 0 delta)  und (rst, 0, 160ns + 0 delta)
      -- Nach der Initialisierungsphase ist rst_gen stets inaktiv
   begin
      rst_tb <= transport '1' after 32 ns , '0' after 42 ns; --reset nach drei takten über den vierten takt
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
      clk_tb <= transport '1' after 5 ns , '0' after 10 ns; --100MHz
      count_tb <= transport count_tb + 1 after 10 ns;
      wait for 10 ns;
   end process clk_gen;
	
   check: process
   begin

        wait until rst_tb = '1'; -- danach ist der reset '1'

        load_tb <= '0';
        jump_tb <= '0';
        stop_tb <= '1';
        loadvalue_tb <= x"0000";

        wait until rst_tb = '0';
        --count_tb <= 0;

        assert pc_tb = x"0000" -- reset überprüfen
            report "pc hat nach Reset nicht den erwarteten Wert (0)"
            severity error;

    -- Beginn Stop Test
        report "*** Beginn Stop Test ***" severity note;
        stop_tb <= '1';

        -- Überprüft ob nach drei Takten noch immer "0" im pc steht. (stop 1) 
        report "Test: count 5, stop 1" severity note;
        wait until count_tb = 5; 
        assert pc_tb = x"0000"
            report "pc hat nicht den erwarteten Wert (0), count 5, stop 1"
            severity error;

        -- Überprüft ob nach einem Takt weiterhin "0" im pc steht. (load 1)
        report "Test: count 6, stop 1, load 1" severity note;
        loadvalue_tb <= x"01F4";
        load_tb <= '1';
        wait until count_tb = 6;
        assert pc_tb = x"0000" 
            report "pc hat nicht den erwarteten Wert (0), stop 1, load 1, jump 0"
            severity error;

        -- Überprüft ob nach einem Takt weiterhin "0" im pc steht. (jump 1)
        report "Test: count 7, stop 1, jump 1" severity note;
        load_tb <= '0';
        jump_tb <= '1';
        wait until count_tb = 7;
        assert pc_tb = x"0000" 
            report "pc hat nicht den erwarteten Wert (0), stop 1, load 0, jump 1"
            severity error;

        -- Überprüft ob nach einem Takt weiterhin "0" im pc steht. (jump 1)
        report "Test: count 8, stop 1, load 1, jump 1" severity note;
        load_tb <= '1';
        jump_tb <= '1';
        wait until count_tb = 8;
        assert pc_tb = x"0000" 
            report "pc hat nicht den erwarteten Wert (0), stop 1, load 1, jump 1"
            severity error;
        report "*** Ende Stop Test ***" severity note;

    -- Beginn Load Test
        report "*** Beginn Load/Jump Test ***" severity note;

        --Überprüft das laden von loadvalue in den pc
        report "Test: count 9, s0, l1, j0" severity note;
        loadvalue_tb    <= x"01F4";
        stop_tb         <= '0';
        load_tb         <= '1';
        jump_tb         <= '0';
        wait until count_tb = 9;
        assert pc_tb = x"01F4" 
            report "pc hat nicht den erwarteten Wert (500), stop 0, load 1, jump 0"
            severity error;

        --Überprüft jump
        report "Test: count 10, s0, l0, j1" severity note;
        loadvalue_tb    <= x"01F4";
        stop_tb         <= '0';
        load_tb         <= '0';
        jump_tb         <= '1';
        wait until count_tb = 10;
        assert pc_tb = x"03E8" 
            report "pc hat nicht den erwarteten Wert (1000), stop 0, load 0, jump 1"
            severity error;

        --Überprüft Grenzwert
        report "Test: count 11-12, s0, l0, j1" severity note;
        loadvalue_tb    <= x"FFFF";
        stop_tb         <= '0';
        load_tb         <= '1';
        jump_tb         <= '0';
        wait until count_tb = 11;
        loadvalue_tb    <= x"0002";
        stop_tb         <= '0';
        load_tb         <= '0';
        jump_tb         <= '1';
        wait until count_tb = 12;
        assert pc_tb = x"0001" 
            report "pc hat nicht den erwarteten Wert (1), stop 0, load 0, jump 1"
            severity error;

        
        --wait until count_tb = x"0004";
        report "*** Ende Load/Jump Test ***" severity note;
        
        


      assert false report "Simulation beendet" severity failure; -- Simulation beenden	
   
   end process check;
	
end sim;