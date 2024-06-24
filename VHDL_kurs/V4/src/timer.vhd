----------------------------------------------------------------------------------
-- Company: Lehrstuhl Entwurf Mikroelektronischer Systeme
--          TU Kaiserslautern
-- Engineer: Goldhammer
-- 
-- Create Date:    01.11.2021 
-- Design Name:    Ampel (traffic light) DIGILAB 1
-- Module Name:    sek_puls.vhd
-- Project Name: 
-- Target Devices: 
-- Tool versions:  Vivado 2018.2 / Modelsim 2019

-- Description: Module generates every second one pulse of
--              one single clock length
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
-- Revision 0.02: new tool versions; comments updated
-- Revision 0.03: layout fully compliant to guidelines
-- Revision 0.04: adaptation Nexys Board
-- Revision 0.05: Zaehlerendwert wird vom Toplevel-VHDL-Code bestimmt
--                damit kann Simulation beschleunigt ablaufen

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity  timer is
  generic(
    divide_value : integer
    );   --Zaehlerendwert Hardware / Simulation
  port
   (clk_100mhz: in  std_logic; --100 MHz Systemclock (Quarz auf NEXYS4 )
    reset     : in  std_logic;
    sec_puls  : out std_logic
   );
end  timer;

architecture behavioral of  timer is
--Clock (100 MHz) teilen auf 1 Hz
--wie viele Bit sind noetig, um bis 100 Millionen zaehlen zu koennen ? -- 27
  signal count        : unsigned(27 downto 0);  --Bitbreite festlegen
--Deklaration interner Signale



begin
  process (clk_100mhz, reset)
  begin
    if reset = '1' then

      sec_puls <= '0';
      count <= to_unsigned(0, count'length);

    elsif rising_edge(clk_100mhz) then

      count <= count + 1;
      sec_puls <= '0';

      if count = to_unsigned(divide_value, count'length) then
        sec_puls <= '1';
        count <= to_unsigned(0, count'length);

        end if;
      end if;
    end process;


end;
