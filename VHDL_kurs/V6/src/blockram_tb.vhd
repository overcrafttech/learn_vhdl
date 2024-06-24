library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity blockram_tb is
    end blockram_tb;
    
architecture test of blockram_tb is

    component ram_samples_255x16
        port (
	        clka 	: in std_logic;                      -- Takt fuer PORT A
	        wea  	: in std_logic;                      -- Write Enable Signal fuer Port A
	        ena  	: in std_logic;                      -- Enable Signal fuer Port A
	        addra 	: in std_logic_vector(7 downto 0);   -- Adresse fuer PORT A
	        dina  	: in std_logic_vector(15 downto 0);  -- Dateneingang fuer Port A
	        clkb 	: in std_logic;                      -- Takt fuer PORT B
	        enb  	: in std_logic;                      -- Enable Signal fuer Port B (Speicherung der unten angegebenen Adresse)
	        addrb 	: in std_logic_vector(7 downto 0);   -- Adresse fuer PORT B
	        doutb  	: out std_logic_vector(15 downto 0)  -- Datenausgang fuer Port B
	    );
    end component;

    
    -- Interne Signale der Testbench
    signal clk_tb       : std_logic := '0';

    signal clka	        : std_logic := '0';                      -- Takt fuer PORT A
	signal wea  	    : std_logic;                      -- Write Enable Signal fuer Port A
	signal ena  	    : std_logic;                      -- Enable Signal fuer Port A
	signal addra 	    : std_logic_vector(7 downto 0);   -- Adresse fuer PORT A
	signal dina  	    : std_logic_vector(15 downto 0);  -- Dateneingang fuer Port A

	signal clkb 	    : std_logic := '0';                      -- Takt fuer PORT B
	signal enb  	    : std_logic;                      -- Enable Signal fuer Port B (Speicherung der unten angegebenen Adresse)
	signal addrb 	    : std_logic_vector(7 downto 0);   -- Adresse fuer PORT B
	signal doutb  	    : std_logic_vector(15 downto 0);  -- Datenausgang fuer Port B

    signal clk_inhibit  : std_logic := '1';               -- unterbricht den clk_gen process
    
    begin
    
        ram_component : ram_samples_255x16 
        port map (
            clka    => clka,  -- Taktsignal
            wea     => wea,
            ena     => ena,
            addra   => addra,
            dina    => dina,
            clkb    => clkb,
            enb     => enb,
            addrb   => addrb,
            doutb   => doutb
        );
            
        --rst_gen : process
        --begin
            --rst_tb <= transport '1' after 100 ns , '0' after 200 ns;
            --wait; 
        --end process rst_gen;
        
        clk_gen : process
        begin
            if clk_inhibit = '0' then
                clka <= not clk_tb;
                clkb <= not clk_tb;
                clk_tb <=  not clk_tb;
            else
                wait for 50 ns;
                clka <= '1';
                wait for 50 ns;
                clka <= '0';
                clkb <= '1';
                wait for 50 ns;
                clka <= '0';
                clkb <= '0';
            end if;
            
            wait for 50 ns;
        end process clk_gen;
        
        check: process
        begin

            wea     <=  '0';
            ena     <=  '0';
            addra   <=  x"00";
            dina    <=  X"0000";

            enb     <=  '0';
            addrb   <=  x"00";


            --wait until rst_tb = '1'; -- danach ist der reset '1'
            --wait until rst_tb = '0';
            report "*** Test 01: asynchrone Clocksignale ***" severity note;
            wait for 199 ns;
            clk_inhibit <= '0';
            wait for 150 ns;

            report "*** Test 02:  Gleiche Adresse R/W ***" severity note;
            
            ena <= '1';
            wea <= '1';
            enb <= '1';
            addra <= x"04";
            addrb <= x"04";
            wait for 100 ns;
            addra <= x"00";
            addrb <= x"00";
            ena <= '0';
            wea <= '0';
            enb <= '0';
            wait for 100 ns;

            report "*** Test 03:  Schreiben in Adresse 255 ***" severity note;
            
            ena <= '1';
            wea <= '1';
            addra <= x"FF";
            dina <= std_logic_vector(to_unsigned(2601, dina'length));

            wait for 100 ns;

            ena <= '0';
            wea <= '0';
            addra <= x"00";

            report "*** Test 04:  Lesen aus Adresse 255 ***" severity note;

            enb <= '1';
            addrb <= x"FF";

            wait for 100 ns;

            enb <= '0';
            addrb <= x"00";
    
            wait for 500 ns;

            report "*** Test 05:  Lesen aus verschiedenen Adressen ***" severity note;

            
            ena     <= '1';
            wea     <= '1';
            addra   <= x"01"; 
            dina    <= x"23FF"; 
            wait for 100 ns;
            addra   <= std_logic_vector(to_unsigned(2, addra'length)); 
            dina    <= std_logic_vector(to_unsigned(1002, dina'length)); 
            wait for 100 ns;
            addra   <= std_logic_vector(to_unsigned(3, addra'length)); 
            dina    <= std_logic_vector(to_unsigned(1003, dina'length)); 
            wait for 100 ns;
            addra   <= std_logic_vector(to_unsigned(5, addra'length)); 
            dina    <= std_logic_vector(to_unsigned(1005, dina'length)); 
            wait for 100 ns;
            ena     <= '0';
            wea     <= '0';

            enb     <= '1';
            addrb   <= x"01"; 
            wait for 100 ns;
            assert doutb = x"23FF"
                report "doutb hat nicht den erwartetne Wert x23FF" 
                severity error;	

            addrb   <= std_logic_vector(to_unsigned(2, addrb'length)); 
            wait for 100 ns;
            assert doutb = std_logic_vector(to_unsigned(1002, doutb'length))
                report "doutb hat nicht den erwartetne Wert 1002" 
                severity error;	

            addrb   <= std_logic_vector(to_unsigned(3, addrb'length)); 
            wait for 100 ns;
            assert doutb = std_logic_vector(to_unsigned(1003, doutb'length))
                report "doutb hat nicht den erwartetne Wert 1003" 
                severity error;	

            addrb   <= std_logic_vector(to_unsigned(5, addrb'length)); 
            wait for 100 ns;
            assert doutb = std_logic_vector(to_unsigned(1005, doutb'length))
                report "doutb hat nicht den erwartetne Wert 1005" 
                severity error;	
                



   
        assert false report "Simulation beendet" severity failure; -- Simulation beenden	
        end process check;
        
end test;