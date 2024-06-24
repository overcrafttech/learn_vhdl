--------------------------------------------------------------------------------
-- $Revision$
-- $Date$
-- -----------------------------------------------------------------------------
-- Beschreibung : Generisches Dual-Port RAM; ein Port (a)  nur mit Write
--                und Enable; ein Port (b) nur mit Read und Enable
-- Modulname    : gen_dp_bram_aew_ber.vhd
-- Projekt      : Herakles
-- Autoren      : Uwe Wasenmueller
--                TU Kaiserslautern
--
-- COPYRIGHT (c) TU Kaiserslautern 2008

--------------------------------------------------------------------------------
-- Das ist von Xilinx das Beispiel rams_14 der RAMS aus V9 staerker modifziert

-- Modifikationen:
-- vergleichbar einem Simple Dual Port RAM
-- Init mit 0 fuer den RAM-Inhalt; entspricht Xilinx Default fuer Konfigurationsdaten
-- Init mit 0 fuer "registered" Leseadresse (read_addrb)
-- generische Adresstiefe und Wortbreite

-- Kurzbeschreibung
--
-- Dual-Port Block RAM:
-- Beide Ports mit Enable
-- Port a nur Write
-- Port b nur Read
-- Konfiguration (#Adressen x #Datenbits) beider Ports ist identisch
-- Port a Write before Read Mode lt. Synthese
-- Adresstiefe (in 2 Potenzen) generisch (G_BW_ADDR)
-- Wortbreite generisch (G_BW_DATA)
-- Port b Read First Modus lt. Synthese
-- Init mit 0 fuer den RAM-Inhalt; entspricht Xilinx Default fuer Konfigurationsdaten
-- Init mit 0 fuer "registered" Leseadresse (read_addrb)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity gen_dp_bram_aew_ber is
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
end gen_dp_bram_aew_ber;

architecture syn of gen_dp_bram_aew_ber is
	type ram_type is array (2**G_BW_ADDR - 1 downto 0) of std_logic_vector(G_BW_DATA - 1 downto 0);
	signal ram_bram_aew_ber : ram_type                                 := (others => (others => '0'));
	signal read_addrb       : std_logic_vector(G_BW_ADDR - 1 downto 0) := (others => '0');
begin

	process(clk)
	begin
		if (clk'event and clk = '1') then

			if (ena = '1') then
				if (wea = '1') then
					ram_bram_aew_ber(conv_integer(addra)) <= dia;
				end if;
			end if;

			if (enb = '1') then
				read_addrb <= addrb;
			end if;

		end if;
	end process;

	dob <= ram_bram_aew_ber(conv_integer(read_addrb));

end syn;

