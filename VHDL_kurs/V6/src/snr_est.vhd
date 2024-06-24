-- =============================================================================
--
--  Transferstelle fuer Mikroelektronik
--  Dipl. Math. Uwe Wasenmueller
--  Universitaet Kaiserslautern
-- 
--  (C) COPYRIGHT TU Kaiserslautern 2007 - 2017
-- 
-- =============================================================================
-- 
-- Projekt:     Einfuehrung in die Hardware- Beschreibungssprache VHDL
-- 
-- Autor(en):   
-- 
-- =============================================================================
-- 
-- Modulname:   snr_est
--              
-- Sch�tzung des Signalrauschabstandes bei QPSK modulierten Empfanssymbolen
--
-- =============================================================================
--
-- Die eingehenden Signale out_reverse, komplexe Abtastwerte (Symbole) bestehend
-- aus data_i_in und data_q_in werden abgespeichert.
-- Die Werte psf (Signalleistung FPGA) und prf (Gesamtleistung FPGA) werden 
-- w�hrend des Symbolabspeicherns berechnet
-- Sind alle Daten empfangen, werden die berechneten Werte psf und prf und 
-- die Anzhal der empfangenen Symbole ausgegeben. 
-- Anschliessend werden die empfangenen Symbole (komplexe Abtastwerte) 
-- ebenfalls ausgegeben. Dies geschieht entweder in der Reihenfolge wie sie 
-- empfangen wurden oder in umgedrehter Reihenfolge (abh�ngig von dem 
-- Wert des gespeicherten Signals out_reverse).
--
-- Fuer eingehende Symbole wird Interface mit data_valid & data_last verwendet
-- d.h Datenstrom darf "unterbrochen" sein
-- Fuer auszugebende Symbole wird Interface mit data_valid verwendet, d.h.
-- Datenstrom muss kontinuierlich ausgegben werden

-- Das benoetigte RAM wird mit dem Xilinx Core-Generator erzeugt.
-- Diese Komponenten muss deklariert werden und in der architecture 
-- instantiiert werden
-- 
-- =============================================================================


--------------------------------------
-- Used libraries                    
--------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 


-- =============================================================================
----------------------
--ENTITY DECLERATION--
----------------------
entity snr_est is
port(
   clk            : in  std_logic;   -- Clock signal, rising edge active
   rst            : in  std_logic;   -- Asynchronous Reset active with '1'
   rfd            : out std_logic;   -- Output to tell the environment whether -- //mux idle state
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
end entity snr_est;



-------------------------------------------
--ARCHITECTURE OF THE snr_est--
-------------------------------------------
architecture rtl of snr_est is

---------------------------------------
-- COMPONENTS TO BE USED IN THE DESIGN
---------------------------------------
--RAM to store the symbols

component ram_samples_255x16 
   port (
	clka 	   : in std_logic;                      -- Takt fuer PORT A
	wea  	   : in std_logic;                      -- Write Enable Signal fuer Port A
	ena  	   : in std_logic;                      -- Enable Signal fuer Port A
	addra 	: in std_logic_vector(7 downto 0);   -- Adresse fuer PORT A
	dina  	: in std_logic_vector(15 downto 0);  -- Dateneingang fuer Port A
	clkb 	   : in std_logic;                      -- Takt fuer PORT B
	enb   	: in std_logic;                      -- Enable Signal fuer Port B (Speicherung der unten angegebenen Adresse)
	addrb 	: in std_logic_vector(7 downto 0);   -- Adresse fuer PORT B
	doutb  	: out std_logic_vector(15 downto 0)  -- Datenausgang fuer Port B
	);
end component;

------------------------------------
-- Declare Types used             --
------------------------------------

type states is (ready_for_data, data_in, result_out, data_out);
signal state : states; -- 4 zustände

----------------------------------------
-- Declare Signals used in the design --
----------------------------------------
	--signal wea  	         : std_logic;                      -- Write Enable Signal fuer Port A //Eingespart
	signal ena  	         : std_logic;                      -- Enable Signal fuer Port A
	signal addra 	         : std_logic_vector(7 downto 0);   -- Adresse fuer PORT A
	signal dina  	         : std_logic_vector(15 downto 0);  -- Dateneingang fuer Port A
	signal enb   	         : std_logic;                      -- Enable Signal fuer Port B (Speicherung der unten angegebenen Adresse)
	signal addrb 	         : std_logic_vector(7 downto 0);   -- Adresse fuer PORT B
	signal doutb  	         : std_logic_vector(15 downto 0); 
   signal i_out_reverse    : std_logic;

   signal i_psf            : unsigned(15 downto 0);  -- Estimated signal power 
   signal i_prf            : unsigned(22 downto 0);  -- Estimated received power

   signal sum_absre_absim  : unsigned(8 downto 0);
   signal sum_qre_qim      : unsigned(15 downto 0); 
   
   --signal i_prf   : out std_logic_vector(22 downto 0);
   --signal i_psf   : out std_logic_vector(15 downto 0);  -- Estimated signal power 
   signal i_num_symbols    : unsigned(7 downto 0);  -- Number of received symbols
   signal max_num_symbols  : unsigned(7 downto 0);  -- Number of received symbols

   signal i_data_i_in      :  signed(7 downto 0);  -- real part of symbol
   signal i_data_q_in      :  signed(7 downto 0);  -- imaginary part of symbol


--------------------------------
-- Begin the rtl architecture --
--------------------------------

begin    
	

--================================================
--Concurrent Signal assignments (if any)
--================================================
data_i_out  <= doutb(15 downto 8);
data_q_out  <= doutb(7 downto 0);

psf         <= std_logic_vector(i_psf);
prf         <= std_logic_vector(i_prf);

num_symbols <= std_logic_vector(i_num_symbols);  -- Number of received symbols

i_data_i_in <= signed(data_i_in);
i_data_q_in <= signed(data_q_in);-- keine Register

--======================================
--Instatiation of Components 
--======================================
ram_component: ram_samples_255x16 port map (
   clka     => clk,  -- Taktsignal
	wea  	   => ena, 
	ena  	   => ena, 
	addra 	=> addra,
	dina  	=> dina, 
	clkb 	   => clk, 
	enb   	=> enb, 
	addrb 	=> addrb, 
	doutb    => doutb
   );

--==============================================================
-- Process(es) Proposal: 1 process describing FSM with datapath
--==============================================================
process (clk)
begin
   if rising_edge(clk) then
      if rst = '1' then

         --State Register
         state             <= ready_for_data;
         
         --Results and Sums
         sum_absre_absim   <= to_unsigned(0, sum_absre_absim'length);
         sum_qre_qim       <= x"0000";
         i_psf             <= x"0000";
         i_prf             <= to_unsigned(0, i_prf'length);
         i_num_symbols     <= x"00";

         -- Interface Signals
         data_valid_out    <= '0';
         result_valid      <= '0';
         rfd               <= '0';

         -- RAM
	      ena  	            <= '0';
	      addra 	         <= x"00";
	      dina  	         <= x"0000";
	      enb   	         <= '0';
	      addrb 	         <= x"00";

         --Internal Registers
         i_out_reverse     <= '0';
         max_num_symbols   <= x"00";

      else

      case state is
         when ready_for_data =>
            -- Interface-Signale
            data_valid_out    <= '0';
            result_valid      <= '0';
            rfd               <= '1';

            -- Results uns Summen auf Ausgangswert
            i_num_symbols     <= x"00";
            i_psf             <= x"0000";
            i_prf             <= to_unsigned(0, i_prf'length);
            sum_absre_absim   <= to_unsigned(0, sum_absre_absim'length);
            sum_qre_qim       <= x"0000";

            -- RAM auf Ausgangswert
	         ena  	            <= '0';
	         addra 	         <= x"00";
	         dina  	         <= x"0000";
	         enb   	         <= '0';
	         addrb 	         <= x"00";

            if start = '1' then 
               -- Zustandsuebergang
               i_out_reverse  <= out_reverse;
               state          <= data_in; 
               rfd            <= '0';
            else
            
            end if;

         when data_in => -- Idle
            -- Interface-Signale
            result_valid      <= '0';
            data_valid_out    <= '0';
            rfd               <= '0';

            if data_valid_in = '1' then
               -- RAM-PORTA aktivieren
	            ena  	            <= '1';
	            addra 	         <= std_logic_vector(i_num_symbols);
	            dina  	         <= data_i_in & data_q_in; -- daten schreiben

               sum_absre_absim   <= unsigned(abs(i_data_i_in(7) & i_data_i_in)) + unsigned(abs(i_data_q_in(7) & i_data_q_in));
               sum_qre_qim       <= unsigned((i_data_q_in * i_data_q_in) + (i_data_i_in * i_data_i_in));

               i_psf             <= i_psf + sum_absre_absim;
               i_prf             <= i_prf + sum_qre_qim;

               i_num_symbols     <= i_num_symbols + x"01"; -- Anzahl der Eingangswerte mitzählen
            else

            end if;
            
            if data_last_in = '1' then 
               -- Zustandsuebergang
               state    <= result_out; 
            else
               
            end if;

         when result_out => --nur einmal
            -- Interface-Signale
            result_valid      <= '1';
            data_valid_out    <= '0';
            rfd               <= '0';



            -- RAM-PORTA deaktivieren
            ena      <= '0';
            addra    <= x"00";
            dina     <= x"0000";

            -- RAM-PORTB aktivieren
	         enb   	         <= '1';

            -- Result, letzte Addition
            i_psf             <= i_psf + sum_absre_absim;
            i_prf             <= i_prf + sum_qre_qim;

            -- Interne Werte zum Zählen
            max_num_symbols   <= i_num_symbols - x"01"; 

            -- RAM-Adressen Anwählen
            if i_out_reverse = '0' then
	            addrb          <= x"00";
            else
	            addrb          <= std_logic_vector(i_num_symbols - x"01"); -- da num symbols bei 1 anfängt zu zählen
            end if;

            -- Zustandsübergang
            state <= data_out;

         when data_out =>
            -- Interface-Signale
            result_valid      <= '0';
            data_valid_out    <= '1';
            rfd               <= '0';

            if i_num_symbols = x"01" then -- da num symbols bei 1 anfängt zu zählen
               -- RAM-PORTB deaktivieren
               enb            <= '0'; -- wichitg fuer korrektes Timing

               -- Zustandsuebergang
               state          <= ready_for_data; 
            else
               -- RAM-Adresse fuer Datenausgabe anlegen (vor- oder rückwärts)
               if i_out_reverse = '0' then
	               addrb          <= std_logic_vector(max_num_symbols - (i_num_symbols - x"02"));
                  i_num_symbols  <= i_num_symbols - x"01";
               else
	               addrb          <= std_logic_vector(i_num_symbols - x"02");
                  i_num_symbols  <= i_num_symbols - x"01";
               end if;
            end if;

         when others =>
          
      end case;
      end if;
   end if;
end process;
											
end rtl;--end of architecture 
