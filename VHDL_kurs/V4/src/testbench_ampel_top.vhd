-- Testbench Ampel
-- during simulation clock is 10 ms and divider is 100
-- so sec_puls is still every second, but simulation is
-- 1 000 000 times faster
-- otherwise 1 sec simulation time takes 2 minutes real time

--Libraries
library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.std_logic_arith.all;
use IEEE.numeric_std.all;

entity testbench_ampel_top is
--port(
--      --keine IOs in Testbench
--    );
end testbench_ampel_top;

architecture sim of testbench_ampel_top is

--Deklaration Signale, Konstante

signal clk_tb     :  std_logic;  
signal rst_n_tb   :  std_logic; 

--Folgende Werte fuer eine schnellere Simulation anpassen. 
--clk_divide_value wird dann als Generic an die zu simulierende
--Schaltung ampel_top weitergegeben
  constant c_divide_value : integer := 99;       --fast simulation parmeters
  constant clk_period     : time    := 10 ms;    --statt 100 MHz nur 100 Hz
--
--Deklaration der Komponenten
  
component ampel_top
  generic(
    divide_value : integer  --100MHz clock Default fuer Hardware
    );
  port(
    clk_100mhz: in  std_logic; --100 MHz Systemclock auf NEXYS4 Board (Quarz)
    rst_n     : in  std_logic; --active low
    led_out   : out std_logic_vector(8 downto 0); --LEDs auf NEXYS4 Board Gruppennummer 0 bis 511
    haupt1    : out std_logic_vector(2 downto 0);
    haupt2    : out std_logic_vector(2 downto 0);
    neben3    : out std_logic_vector(2 downto 0);
    neben4    : out std_logic_vector(2 downto 0)
   );
end component; -- ampel_top

begin
--Instanziierung Komponenten

ampel_top_component: ampel_top 
  generic map(
    divide_value => c_divide_value
    )
  port map (
    clk_100mhz   => clk_tb,  -- Taktsignal
    rst_n        => rst_n_tb  -- synchrones Resetsignal
    );

--Prozess Testbench
rst_gen : process
begin
    rst_n_tb <= transport '0' after 6 ms , '1' after 11 ms, '0' after 6000 ms, '1' after 6003 ms; --reset nach drei takten über den vierten takt
    wait; 
   end process rst_gen;

clk_gen : process
begin
  clk_tb <= transport '1' after clk_period/2 , '0' after clk_period; --100Hz
  wait for clk_period;
end process clk_gen;

end architecture sim;
