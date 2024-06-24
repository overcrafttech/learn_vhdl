------------------------------------------------------------------------------
-- RAM fuer Versuch 6 
--
-- PORT A ist zum Schreiben von Daten vorgesehen
-- PORT B ist nur zum Lesen von Daten vorgesehen
--
-- RAM hat 255 Adressen (0 bis 254), Adresse 255 existiert nicht
-- Die Datenbreite ist 16 Bit.
-- Dies gilt sowohl fuer PORT A as auch fuer PORT B
--
-- Zur Nutzung dieses RAMs ist es erforderlich, die entity gen_dp_bram_aew_ber
-- zu compilieren
--
-- Taktsignal fuer PORT A (clka) und Taktsignal fuer PORT B (clkb) muss identisch sein
-- Ersatz fuer das durch Xilinx IP generator erzeugte RAM
-- Seit WiSe 2021/22
-- Uwe Wasenmueller
------------------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;


entity ram_samples_255x16 is port (
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
end entity ram_samples_255x16;

architecture wrapper of ram_samples_255x16 is
	
	component gen_dp_bram_aew_ber is
	generic(
		G_BW_ADDR : positive := 13;
		G_BW_DATA : positive := 16
	);
	port(
		clk   : in  std_logic;
		ena   : in  std_logic;
		enb   : in  std_logic;
		wea   : in  std_logic;
		addra : in  std_logic_vector(G_BW_ADDR - 1 downto 0);
		addrb : in  std_logic_vector(G_BW_ADDR - 1 downto 0);
		dia   : in  std_logic_vector(G_BW_DATA - 1 downto 0);
		dob   : out std_logic_vector(G_BW_DATA - 1 downto 0)
	);
	end component;
	
	begin
	
	checkclk: process (clka, clkb)
	begin
		assert clka = clkb report "Takt fuer Port A und  Takt fuer Port B muss identisch sein" severity error;
	end process checkclk;
	
	checkadress: process (clka)
	begin
		if clka'event and clka = '1' then
			if ena = '1' and wea = '1' and enb = '1' then
				assert addra /= addrb report "Schreibadresse und Leseadresse muss unterschiedlich sein" severity error;
			end if;
			if ena = '1' and wea = '1' then
				assert addra /= "11111111" report "Schreiben in Adresse 255 ist nicht m�glich" severity error;
			end if;
			if enb = '1' then
				assert addrb /= "11111111" report "Lesen von Adresse 255 ist nicht m�glich" severity error;
			end if;			
		end if;
	end process checkadress;
	
	instgenram: gen_dp_bram_aew_ber
	generic map(
		G_BW_ADDR =>  8,
		G_BW_DATA => 16
	)
	port map(
		clk   => clka,
		ena   => ena,
		enb   => enb,
		wea   => wea,
		addra => addra,
		addrb => addrb,
		dia   => dina,
		dob   => doutb
	);
	
	end architecture;