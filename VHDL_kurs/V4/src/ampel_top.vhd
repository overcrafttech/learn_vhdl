----------------------------------------------------------------------------------
-- Company: Lehrstuhl Entwurf Mikroelektronischer Systeme
--          TU Kaiserslautern
-- Engineer: Goldhammer
-- 
-- Create Date:    01.11.2021 
-- Design Name:    Ampel (traffic light) DIGILAB 1
-- Module Name:    ampel_top.vhd
-- Project Name: 
-- Target Devices: 
-- Tool versions:  Vivado 2018.2 / Modelsim 2019
-- Description: Modulem instatiates all modules

--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
-- Revision 0.02: adaptation Nexys Board
-- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity ampel_top is
  generic(
    divide_value : integer := 99999999  --100MHz clock Default fuer Hardware
    );
  port
   (clk_100mhz: in  std_logic; --100 MHz Systemclock auf NEXYS4 Board (Quarz)
    rst_n     : in  std_logic; --active low
    led_out   : out std_logic_vector(8 downto 0); --LEDs auf NEXYS4 Board Gruppennummer 0 bis 511
    haupt1    : out std_logic_vector(2 downto 0);
    haupt2    : out std_logic_vector(2 downto 0);
    neben3    : out std_logic_vector(2 downto 0);
    neben4    : out std_logic_vector(2 downto 0)
   );
end ampel_top;

architecture ampel_top_arch of ampel_top is
--declaration of internal signals
  signal reset      : std_logic; --active high
  signal sec_puls   : std_logic;

--Deklaration der Komponenten

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

component ampel_sm
    port
    ( clk_100mhz: in  std_logic; --100 MHz Systemclock (Quarz)
      reset     : in  std_logic;
      sec_puls  : in  std_logic;
      haupt1    : out std_logic_vector(2 downto 0);
      haupt2    : out std_logic_vector(2 downto 0);
      neben3    : out std_logic_vector(2 downto 0);
      neben4    : out std_logic_vector(2 downto 0) 
    );
end component; -- ampel


begin

  --Reset Taster auf dem Board ist normal auf high, gedrueckt auf low, also für uns falsch herum
  reset <= not(rst_n);  --notwendige Anpassung an Taster auf NEXYS4 Hardware 
  led_out <= std_logic_vector(to_unsigned(301, led_out'length));  --hier die Gruppennummer einfuegen

--Instanziierung der Komponenten
  timer_component: timer 
  generic map(
    divide_value => divide_value) -- für zähler
  port map (
    clk_100mhz  => clk_100mhz,  -- Taktsignal
    reset       => reset,  -- synchrones Resetsignal
    sec_puls    => sec_puls 
  );

  ampel_sm_component: ampel_sm 
  port map (
    clk_100mhz  => clk_100mhz,
    reset    => reset,
    sec_puls => sec_puls,  -- Taktsignal
    haupt1   => haupt1,
    haupt2   => haupt2,
    neben3   => neben3,
    neben4   => neben4 
  );

end ampel_top_arch;