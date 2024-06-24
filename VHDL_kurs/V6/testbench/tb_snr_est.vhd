-- ====================================================================
--
--  Transferstelle fuer Mikroelektronik
--  Dipl. Math. Uwe Wasenmueller
--  Universitaet Kaiserslautern
-- 
--  (C) COPYRIGHT TU Kaiserslautern 2007
-- 
-- ====================================================================
-- 
-- Projekt:     Einfuehrung in die Hardware- Beschreibungssprache VHDL
-- 
-- Zeitraum:    12.03.2007 - 15.03.2007; Januar 2017
-- 
-- Autor(en):   Goldhammer
-- 
-- ====================================================================
-- 
-- Modulname:   tb_snr_est.vhd
--              Testbench zur Schaltung snr_est.vhd
-- ====================================================================
-- 
-- Instanziiert das DUT (Device Under Test) snr_est.vhd und
-- legt entsprechende Testparameter an den Eingaengen an. Diese Test-
-- parameter werden aus den angegebenen Dateien gelesen. 
-- Somit wird eine automatische Simulation/Validierung durchgeführt, deren Ergebnisse 
-- dann noch auf Richtigkeit ueberprueft werden muessen.
-- Die Referenzdaten dazu wurden in diesem Fall mit Tabellenkalulation
-- berechnet
-- ====================================================================
-- gr 16.12.2009 - vor Beginn Datentransfer rfd pruefen
-- UW: 05.01.2017, Neues Interface


--------------------------------------
--Libraries to be used in the entity--
--------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;  -- text- and file-handling
use ieee.math_real.all;         -- fuer Logarithmus erforderlich
use std.textio.all;             -- fuer Textausgabe



-------------------------------------
-- ENTITY DECLARATION OF TESTBENCH --
-------------------------------------
entity tb_snr_est is
  --no inputs/outputs
end entity tb_snr_est;


-------------------------------
-- ARCHITECTURE OF TESTBENCH --
-------------------------------
architecture sim of tb_snr_est is

-----------------------------------
-- DECLARE COMPONENTS TO BE USED --
-----------------------------------

component snr_est is
port(
   clk            : in  std_logic;   -- Clock signal, rising edge active
   rst            : in  std_logic;   -- Asynchronous Reset active with '1'
   rfd            : out std_logic;   -- Output to tell the environment whether 
                                      -- device is ready to receive new data
   -- Input parameter will be valid with the start signal
   start          : in  std_logic;  -- Impulse shows validness of following parameter
   out_reverse    : in  std_logic;  -- How to send received values 
                                     -- ('1':reverse order, '0':normal order)
    --Input data will be valid if the data_valid_in signal is '1'
   data_valid_in  : in  std_logic;  -- '1' data on input are valid
   data_last_in   : in  std_logic;  -- '1' marks the last input data (symbol)
   data_i_in      : in  std_logic_vector(7 downto 0);  -- real part of symbol
   data_q_in      : in  std_logic_vector(7 downto 0);  -- imaginary part of symbol
    --output parameters will be valid when result_valid signal is high 
   result_valid   : out std_logic;  -- Impulse indicates valid result parameters
   num_symbols    : out std_logic_vector( 7 downto 0);  -- Number of received symbols
   psf            : out std_logic_vector(15 downto 0);  -- Estimated signal power 
   prf            : out std_logic_vector(22 downto 0);  -- Estimated received power
    --output data will be valid when data_valid_out signal is '1'
   data_valid_out : out std_logic;  -- '1' indicates the data on outputs are still valid 
   data_i_out     : out std_logic_vector(7 downto 0);  -- Real Part of the symbol 
   data_q_out     : out std_logic_vector(7 downto 0)   -- Imaginary part of the symbol
);
end component snr_est;

--this is the period of the clock
constant CLK_PERIOD : time := 100 ns;


------------------------
-- SIGNALS TO BE USED --
------------------------
signal clk            : std_logic;  --signal for the clock input
signal rst            : std_logic;  --signal for the asynchronous reset input
signal rfd            : std_logic;  --signal for the ready for data output
signal start          : std_logic;  --signal for the start input
signal out_reverse    : std_logic;  --signal for the out reverse input
signal data_valid_in  : std_logic;  --signal for the data valid input
signal data_last_in   : std_logic;  --signal for the last data symbol
signal data_i_in      : std_logic_vector(7 downto 0);  --signal for data in(real part)
signal data_q_in      : std_logic_vector(7 downto 0);  --signal for data in(imaginary part)
signal data_valid_out : std_logic;  -- signal for the data valid out
signal data_i_out     : std_logic_vector(7 downto 0);  --signal for data out(real part)
signal data_q_out     : std_logic_vector(7 downto 0);  --signal for data out(imaginary part)
signal result_valid   : std_logic;  -- signal for result valid
signal psf            : std_logic_vector(15 downto 0);  --signal for signal power
signal prf            : std_logic_vector(22 downto 0);  --signal for received power
signal num_symbols    : std_logic_vector(7 downto 0); --signal for the number of symbols

shared variable num_symbols_calc : real; --signal for the number of symbols input

signal num_symbols_tbintern : std_logic_vector(7 downto 0); --signal for the number of symbols input

--begin the test bench architecture

begin


dut: snr_est 
port map(
   clk            => clk, -- : in  std_logic;   -- Clock signal, rising edge active
   rst            => rst, -- : in  std_logic;   -- Asynchronous Reset active with '1'
   rfd            => rfd, -- : out std_logic;   -- Output to tell the environment whether 
                                      -- device is ready to receive new data
   -- Input parameter will be valid with the start signal
   start          => start, -- : in  std_logic;  -- Impulse shows validness of following parameter
   out_reverse    => out_reverse, -- : in  std_logic;  -- How to send received values 
                                     -- ('1':reverse order, '0':normal order)
    --Input data will be valid if the data_valid_in signal is '1'
   data_valid_in  => data_valid_in, -- : in  std_logic;  -- '1' data on input are valid
   data_last_in   => data_last_in, -- : in  std_logic;  -- '1' marks the last input data (symbol)
   data_i_in      => data_i_in, -- : in  std_logic_vector(7 downto 0);  -- real part of symbol
   data_q_in      => data_q_in, -- : in  std_logic_vector(7 downto 0);  -- imaginary part of symbol
    --output parameters will be valid when result_valid signal is high 
   result_valid   => result_valid, -- : out std_logic;  -- Impulse indicates valid result parameters
   num_symbols    => num_symbols, -- : out std_logic_vector( 7 downto 0);  -- Number of received symbols
   psf            => psf, -- : out std_logic_vector(15 downto 0);  -- Estimated signal power 
   prf            => prf, -- : out std_logic_vector(22 downto 0);  -- Estimated received power
    --output data will be valid when data_valid_out signal is '1'
   data_valid_out => data_valid_out, -- : out std_logic;  -- '1' indicates the data on outputs are still valid 
   data_i_out     => data_i_out, -- : out std_logic_vector(7 downto 0);  -- Real Part of the symbol 
   data_q_out     => data_q_out  -- : out std_logic_vector(7 downto 0)   -- Imaginary part of the symbol
);

-------------------------------
-- PROCESS TO GENERATE CLOCK --
-------------------------------
clock : process
begin
  wait for CLK_PERIOD/2;
  clk <= '0';
  wait for CLK_PERIOD/2;
  clk <= '1';
end process clock;


-------------------------------------
-- PROCESS TO SIMULATE THE CIRCUIT --
-------------------------------------
simulation : process

variable num_symbols_tbintern : natural;

--------------------------------
-- Procedure to read in files --
--------------------------------
procedure read_file(filename : in string; anzahl : in natural; luecke : in boolean) is
-- Lesen der Symbole aus Datei filename und fuer Interface aufbereiten 
-- bzgl. data_last_in und data_valid_in
-- anzahl = Anzahl er erwarteten Symbole in Datei
-- luecke: false kontinuierlicher Datenstrom (data_valid_in immer = 1; 
-- true Datenstrom unterbroche mit data_valid_in = 0
  file quelledatei        : text open read_mode is filename;
  variable input_line     : line;
  --local variables
  variable data_i         : std_logic_vector(7 downto 0);
  variable data_q         : std_logic_vector(7 downto 0);
  variable real_part      : integer;
  variable imaginary_part : integer;
  variable i              : natural; -- Zaehler fuer Symbolanzahl

begin
   i := 1;

   while not endfile(quelledatei) loop
      readline(quelledatei, input_line); -- read the whole line
      read(input_line, real_part); --read the real part of the data
      read(input_line, imaginary_part);  --read the imaginary part of the data
      data_i := std_logic_vector(to_signed(real_part, 8)); --convert the integer to std_logic
      data_q := std_logic_vector(to_signed(imaginary_part, 8)); --convert the integer to std_logic

      if luecke then
       -- Die Wahl vor jedem dritten Symbol eine Takt kein Symbol zu uebertragen ist beliebig
         if i mod 3 = 0 then
            data_i_in     <= (others => 'X');
            data_q_in     <= (others => 'X');
            data_valid_in <= '0';
            wait for CLK_PERIOD; 
            data_i_in     <= data_i;
            data_q_in     <= data_q; 
            data_valid_in <= '1';        
         else
            data_i_in     <= data_i;
            data_q_in     <= data_q;      
         end if;
      else
         data_i_in     <= data_i;
         data_q_in     <= data_q;
      end if;

      if i = anzahl then
         data_last_in <= '1';
      else
         data_last_in <= '0';
         i            := i + 1;
      end if;

      wait for CLK_PERIOD;
   end loop;

   data_valid_in <= '0';
   data_last_in  <= '0';
   data_i_in     <= (others => 'X');
   data_q_in     <= (others => 'X');
   wait until rfd = '1' for 1 ms;
   if rfd = '0' then
    --Abbruch wenn dieser Fehler auftritt
      assert false
      report "TESTBENCH => FEHLER in snr_est! Signal rfd geht nicht auf logisch 1! Simulation wird irregulaer beendet!"        severity failure;
   end if;
   wait for CLK_PERIOD;
end procedure read_file;


begin
-- Start testing Device
-- Actions: initialize Device and inputs

 --wait before initializing signals 
   wait for 4 * CLK_PERIOD;
   wait until clk='0'; --Forces auf fallende Flanke synchronisieren
  
 --Initialize Input-Signals
   rst           <= '0';
   start         <= '0';
   out_reverse   <= '0'; --normal order
  
 --Always reset the circuit before testing
   wait for 2 * CLK_PERIOD + CLK_PERIOD / 4; -- Reset not at clock edges to verify correct behaviour
   rst           <= '1';  --activate
   wait for 5 * CLK_PERIOD;
   rst           <= '0';
  
 --kurz warten ob rfd auf 1 geht, sonst Fehler in DUT --Meldung ausgeben
   wait until clk = '0';
   wait for 3 * CLK_PERIOD;
   if rfd = '0' then
    -- Abbruch wenn dieser Fehler auftritt
      assert false
      report "TESTBENCH => FEHLER in snr_est! Signal rfd geht nicht auf logisch 1 nachdem snr_est im Startzustand sein soll! Simulation wird irregulaer beendet!"
      severity failure;
   end if;

   wait until clk='0'; --Forces auf fallende Flanke synchronisieren

-------------------------------------------------------------------
-- 1. Datenblock
-- generische Daten
-- koninuierliche Eingabe ab 1. Takt nach Start
-- Ausgabereihenfolge wie Eingabe
-- 8 Symbole
-- prf = 408
-- psf =  72
-------------------------------------------------------------------

   report "TESTBENCH => 1. Block wird an snr_est gesendet";

   start         <= '1';  
   out_reverse   <= '0'; --in normal order
   wait for CLK_PERIOD;

   start         <= '0';
   out_reverse   <= 'X';
   data_valid_in <= '1';

   num_symbols_tbintern   :=  8;  --8 input samples (i/q)
   num_symbols_calc       := real(num_symbols_tbintern);

   read_file("./testdata/file_8_inc_testdata.txt",8, false);
  
   wait until clk = '0'; --Forces auf fallende Flanke synchronisieren 


-------------------------------------------------------------------
-- 2. Datenblock
-- generische Daten (positiv, neagativ, min, max)
-- koninuierliche Eingabe ab 1. Takt nach Start
-- Ausgabereihenfolge wie Eingabe
-- 16 Symbole
-- prf = 195222
-- psf =   1574
-------------------------------------------------------------------

   report "TESTBENCH => 2. Block wird an snr_est gesendet";

   start         <= '1';  
   out_reverse   <= '0'; --in normal order
   wait for CLK_PERIOD;

   start         <= '0';
   out_reverse   <= 'X';
   data_valid_in <= '1';

   num_symbols_tbintern   := 16;  --16 input samples (i/q)
   num_symbols_calc       := real(num_symbols_tbintern);

   read_file("./testdata/file_16_testdata.txt",16, false);

   wait until clk='0'; --Forces auf fallende Flanke synchronisieren

-------------------------------------------------------------------
-- 3. Datenblock
-- generische Daten max => re = +127 im = +127
-- koninuierliche Eingabe ab 1. Takt nach Start
-- Ausgabereihenfolge wie Eingabe
-- 255 Symbole
-- prf = kann mit Tabelle aus Versuch 6 ueberprueft werden
-- psf = kann mit Tabelle aus Versuch 6 ueberprueft werden
-------------------------------------------------------------------
   
   report "TESTBENCH => 3. Block wird an snr_est gesendet";
   
   start         <= '1';  
   out_reverse   <= '0'; --in normal order
   wait for CLK_PERIOD;

   start         <= '0';
   out_reverse   <= 'X';
   data_valid_in <= '1';

   num_symbols_tbintern   := 255; --for 255 different samples
   num_symbols_calc       := real(num_symbols_tbintern);

   read_file("./testdata/file_255_maxwert.txt",255, false);

   wait for 10 * CLK_PERIOD;

   wait until clk='0'; --Forces auf fallende Flanke synchronisieren

-------------------------------------------------------------------
-- 4. Datenblock
-- generische Daten min =>  re = -128 im = -128
-- koninuierliche Eingabe ab 1. Takt nach Start
-- Ausgabereihenfolge wie Eingabe
-- 255 Symbole
-- prf = kann mit Tabelle aus Versuch 6 ueberprueft werden
-- psf = kann mit Tabelle aus Versuch 6 ueberprueft werden
-------------------------------------------------------------------

   report "TESTBENCH => 4. Block wird an snr_est gesendet";

   start         <= '1';  
   out_reverse   <= '0'; --in normal order
   wait for CLK_PERIOD;

   start         <= '0';
   out_reverse   <= 'X';
   data_valid_in <= '1';

   num_symbols_tbintern   := 255; --for 255 different samples
   num_symbols_calc       := real(num_symbols_tbintern);

   read_file("./testdata/file_255_minwert.txt",255, false);

   wait for 10 * CLK_PERIOD;

   wait until clk='0'; --Forces auf fallende Flanke synchronisieren

-------------------------------------------------------------------
-- 5. Datenblock
-- generische Daten
-- koninuierliche Eingabe ab 1. Takt nach Start
-- Ausgabe umgekehrt wie Eingabe
-- 8 Symbole
-- prf = 408
-- psf =  72
-------------------------------------------------------------------

   report "TESTBENCH => 5. Block wird an snr_est gesendet";
 
   start         <= '1';  
   out_reverse   <= '1'; --in reverse order
   wait for CLK_PERIOD;

   start         <= '0';
   out_reverse   <= 'X';
   data_valid_in <= '1';

   num_symbols_tbintern   := 8; --8 input samples (i/q)
   num_symbols_calc       := real(num_symbols_tbintern);

   read_file("./testdata/file_8_inc_testdata.txt",8, false);

   wait until clk='0'; --Forces auf fallende Flanke synchronisieren


-------------------------------------------------------------------
-- 6. Datenblock
-- "echte" Daten 
-- koninuierliche Eingabe ab 1. Takt nach Start
-- Ausgabe umgekehrt wie Eingabe
-- 255 Symbole
-- prf = 3026277
-- psf =   35351
-------------------------------------------------------------------

   report "TESTBENCH => 6. Block wird an snr_est gesendet";

   start         <= '1';  
   out_reverse   <= '1'; --in normal order
   wait for CLK_PERIOD;

   start         <= '0';
   out_reverse   <= 'X';
   data_valid_in <= '1';

   num_symbols_tbintern   := 255;  -- 255 input samples (i/q)
   num_symbols_calc       := real(num_symbols_tbintern);

   read_file("./testdata/file_255_lin_snr_2.txt",255, false);


   wait until clk='0'; --Forces auf fallende Flanke synchronisieren

-------------------------------------------------------------------
-- 7. Datenblock
-- generische Daten
-- Kontinuierliche Eingabe ab 3. (DRITTEM!!!) Takt nach Start
-- Ausgabe umgekehrt wie Eingabe
-- 8 Symbole
-- prf = 408
-- psf =  72
-------------------------------------------------------------------

   report "TESTBENCH => 7. Block wird an snr_est gesendet";
 
   start         <= '1';  
   out_reverse   <= '1'; --in reverse order
   wait for CLK_PERIOD;

   start         <= '0';
   out_reverse   <= 'X';
   data_valid_in <= '0';
   wait for 2*CLK_PERIOD;

   data_valid_in <= '1';

   num_symbols_tbintern   := 8; --8 input samples (i/q)
   num_symbols_calc       := real(num_symbols_tbintern);

   read_file("./testdata/file_8_inc_testdata.txt",8, false);

   wait until clk='0'; --Forces auf fallende Flanke synchronisieren

-------------------------------------------------------------------
-- 8. Datenblock
-- generische Daten
-- UNTERBROCHENE Eingabe ab 2. (ZWEITEN!!!) Takt nach Start
-- Ausgabe umgekehrt wie Eingabe
-- 8 Symbole
-- prf = 408
-- psf =  72
-------------------------------------------------------------------

   report "TESTBENCH => 8. Block wird an snr_est gesendet";
 
   start         <= '1';  
   out_reverse   <= '1'; --in reverse order
   wait for CLK_PERIOD;

   start         <= '0';
   out_reverse   <= 'X';
   data_valid_in <= '0';
   wait for 1*CLK_PERIOD;

   data_valid_in <= '1';

   num_symbols_tbintern   := 8; --8 input samples (i/q)
   num_symbols_calc       := real(num_symbols_tbintern);

   read_file("./testdata/file_8_inc_testdata.txt",8, true);

   wait until clk='0'; --Forces auf fallende Flanke synchronisieren

-------------------------------------------------------------------
-- 9. Datenblock
-- "echte" Daten 
-- Unterbrochene Eingabe ab 1. Takt nach Start
-- Ausgabereihenfolge wie Eingabe
-- 86 Symbole
-- prf = 1196431
-- psf =   13113 
-------------------------------------------------------------------


   report "TESTBENCH => 9. Block wird an snr_est gesendet";

   start         <= '1';  
   out_reverse   <= '0'; --in normal order
   wait for CLK_PERIOD;

   start         <= '0';
   out_reverse   <= 'X';
   data_valid_in <= '1';

   num_symbols_tbintern   := 86;  --86 input samples (i/q)
   num_symbols_calc       := real(num_symbols_tbintern);

   read_file("./testdata/file_86_lin_snr_3.txt",86, true);

   wait until clk='0'; --Forces auf fallende Flanke synchronisieren

   wait for CLK_PERIOD;




 --End simulation with message in transcript
 --------------------------------------------
   assert false
      report "TESTBENCH => Simulation planmaessig beendet! Alle Resultate sind noch zu ueberpruefen"
         severity failure;

end process simulation;  --end testing the component

------------------------------------------------------------
-- PROCESS TO CALCULATE SNR in dB by results of psf & prf --
------------------------------------------------------------

calc_snr: process
  variable psf_real        : real; -- psf als Typ real
  variable prf_real        : real; -- prf als typ real
  variable snr_real        : real; -- Signalrauschverhaeltnis (SNR) in Dezibel (dB)
  variable ps_real         : real; -- Wert fuer Ps
  variable pr_real         : real; -- Wert fuer Pr
  variable value_plausible : boolean; -- true psf_real & prf-real kann gebildet werden
  variable outzeiger       : line; -- fuer Textausgabe
begin
  -- die als gueltig markierten Werte von psf und prf auswerten
  wait until result_valid'event and result_valid = '1';
  wait for CLK_PERIOD/2;

  -- grober Check von psf und prf; nur '0' und '1' erlaubt in allen Elementen der Arrays
  value_plausible := true;
  for i in 0 to psf'length - 1 loop
     if not (psf(i) = '0' or psf(i) = '1') then
        value_plausible := false;        
     end if;
  end loop;
  for i in 0 to prf'length - 1 loop
     if not (prf(i) = '0' or prf(i) = '1') then
        value_plausible := false;
     end if;
  end loop;
  
  -- Falls moeglich, aus psf und prf die Werte fuer ps und pr berechnen
  if value_plausible then
    
     psf_real  := real(to_integer(unsigned(psf)));
     prf_real  := real(to_integer(unsigned(prf)));
--  ps_real   := (psf_real/(sqrt(2.0)*num_symbols_calc))*(psf_real/(sqrt(2.0)*num_symbols_calc));
     ps_real   := (psf_real * psf_real) / ( 2.0 * num_symbols_calc * num_symbols_calc);
     pr_real   := prf_real / num_symbols_calc;
  end if;
  
  -- Ausgabe der ermittelten Ergebnisse
  if not value_plausible then
     report "TESTBENCH => Berechnung SNR-Verhaeltnis nicht moeglich: FEHLER: PSF oder PRF enthaelt nicht nur '0' und '1' wenn result_valid  = '1'"; 
  elsif ps_real = 0.0 then 
     report "TESTBENCH => Berechnung SNR-Verhaeltnis nicht moeglich, weil Ps = 0. FEHLER: das kann bei den Testdaten nicht sein"; 
  elsif pr_real = ps_real then
    snr_real  := 99.9;
    report "TESTBENCH => Berechnung SNR-Verhaeltnis nicht moeglich (Division durch 0 d.h. Pr = Ps). Das ist korrekt beim 2. und 3. Block der Testdaten";
    write (outzeiger, string'(" ========================="));
    writeline (output, outzeiger);
  else
    snr_real  := 10.0*log10(ps_real/(pr_real-ps_real));

    write (outzeiger, string'("TESTBENCH => Berechneter SNR-Wert: "));
    write (outzeiger, snr_real);
    write (outzeiger, string'(" dB"));
    writeline (output, outzeiger);
    write (outzeiger, string'(" ========================="));
    writeline (output, outzeiger);
  end if;
end process;

end sim;--end the architecture of test bench
