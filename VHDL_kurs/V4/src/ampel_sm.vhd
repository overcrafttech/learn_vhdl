----------------------------------------------------------------------------------
-- Company: Lehrstuhl Entwurf Mikroelektronischer Systeme
--          TU Kaiserslautern
-- Engineer: Goldhammer
-- 
-- Create Date:    01.11.2021
-- Design Name:    Ampel (traffic light) Digilab1
-- Module Name:    ampel_sm.vhd
-- Project Name: 
-- Target Devices: 
-- Tool versions:  Vivado 2018.2 / Modelsim 2019
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
-- Revision 0.02: adaptation Nexys Board
----------------------------------------------------------------------------------
--
--
--                          |                  |
--                          |                  |
--                          |                  |
--                         O|                  |
--                         O|        H         | ampel neben4
--            ampel haupt2 O|        a         |OOO
--    ______________________+        u         +_________________________
--                                   p
--                                   t
--                                   s
--                                   t
--    ______________________+        r         +_________________________
--                     OOO  |        a         |O ampel haupt1
--             ampel neben3 |        s         |O
--                          |        s         |O
--                          |        e         |
--                          |                  |
--                          |                  |
--
--
--
--in unserem Beispiel laufen die beiden Ampeln HAUPTSTRASSE wie auch die beiden NEBENSTRASSE immer
--gleich (es w�rden also 6 IOs genuegen, man koennte aber auch z.B. fuer Linksabbieger die eine
--Ampel der Hauptstrasse frueher gruen machen und die andere laenger gruen lassen)

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;



entity ampel_sm is
  port
   (clk_100mhz: in  std_logic; --100 MHz Systemclock (Quarz)
    reset     : in  std_logic;
    sec_puls  : in  std_logic;
    haupt1    : out std_logic_vector(2 downto 0);
    haupt2    : out std_logic_vector(2 downto 0);
    neben3    : out std_logic_vector(2 downto 0);
    neben4    : out std_logic_vector(2 downto 0) 
   );
end ampel_sm;


architecture behavioral of ampel_sm is
--interner Signale deklarieren
signal state : std_logic_vector(2 downto 0);
signal timer : unsigned(2 downto 0);
--Konstanten deklarieren

begin

--Concurrent Assignments
--Steuerwerk Ampel

  process (clk_100mhz, reset)
  begin
    if reset = '1' then
      state  <= "000";
      timer  <= "000";

      haupt1 <= "001"; --alles auf rot
      haupt2 <= "001";
      neben3 <= "001";
      neben4 <= "001";

    elsif rising_edge(clk_100mhz) then

if sec_puls = '1' then
      timer <= timer + "001";

      case state is
        when "000" => --0
          --Zeitprüfiung für nächten Zustand
          if timer = "000" then 
            state <= "001"; 
            timer <= "000"; 
            end if;
          --Ausgang
          haupt1 <= "001"; --alles auf rot
          haupt2 <= "001";
          neben3 <= "001";
          neben4 <= "001";

        when "001" => --1
          --Zeitprüfiung für nächten Zustand
          if timer = "000" then 
            state <= "010"; 
            timer <= "000"; 
            end if;
          --Ausgang
          haupt1 <= "011";
          haupt2 <= "011";
          neben3 <= "001";
          neben4 <= "001";

        when "010" => --2
          --Zeitprüfiung für nächten Zustand
          if timer = "111" then 
            state <= "011"; 
            timer <= "000"; 
            end if;
          --Ausgang
          haupt1 <= "100";
          haupt2 <= "100";
          neben3 <= "001";
          neben4 <= "001";

        when "011" => --3
          --Zeitprüfiung für nächten Zustand
          if timer = "001" then 
            state <= "100"; 
            timer <= "000"; 
            end if;
          --Ausgang
          haupt1 <= "010";
          haupt2 <= "010";
          neben3 <= "001";
          neben4 <= "001";

        when "100" => --4
          --Zeitprüfiung für nächten Zustand
          if timer = "000" then 
            state <= "101"; 
            timer <= "000"; 
            end if;
          --Ausgang
          haupt1 <= "001";
          haupt2 <= "001";
          neben3 <= "001";
          neben4 <= "001";

        when "101" => --5
          --Zeitprüfiung für nächten Zustand
          if timer = "000" then 
            state <= "110"; 
            timer <= "000"; 
            end if;
          --Ausgang
          haupt1 <= "001";
          haupt2 <= "001";
          neben3 <= "011";
          neben4 <= "011";

        when "110" => --6
          --Zeitprüfiung für nächten Zustand
          if timer = "011" then 
            state <= "111"; 
            timer <= "000"; 
            end if;
          --Ausgang
          haupt1 <= "001";
          haupt2 <= "001";
          neben3 <= "100";
          neben4 <= "100";

        when "111" => --7
          --Zeitprüfiung für nächten Zustand
          if timer = "001" then 
            state <= "000"; 
            timer <= "000"; 
            end if;
          --Ausgang
          haupt1 <= "001";
          haupt2 <= "001";
          neben3 <= "010";
          neben4 <= "010";
        when others =>
          
        end case;
end if;
      end if;
    end process;



end behavioral;
