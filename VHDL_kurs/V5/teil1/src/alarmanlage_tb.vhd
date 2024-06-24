library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alarmanlage_tb is
end alarmanlage_tb;

architecture sim of alarmanlage_tb is

-- Deklaration der zu testenden Komponente alarm
component alarm_1p
    port
   (clk       : in  std_logic;
    reset     : in  std_logic;
    go        : in  std_logic;
    door_open : in  std_logic;
    validate  : in  std_logic;
    alarm     : out std_logic
   );
end component; -- alarm
component alarm_mp
    port
   (clk       : in  std_logic;
    reset     : in  std_logic;
    go        : in  std_logic;
    door_open : in  std_logic;
    validate  : in  std_logic;
    alarm     : out std_logic
   );
end component; -- alarm

-- Interne Signale der Testbench
signal clk_tb        :  std_logic;  
signal rst_tb        :  std_logic; 
signal go_tb         :  std_logic; 
signal door_open_tb  :  std_logic; 
signal validate_tb   :  std_logic; 
signal alarm_tb_1p      :  std_logic; 
signal alarm_tb_mp      :  std_logic; 

begin

   single_process: alarm_1p 
   port map (
      clk       => clk_tb,  -- Taktsignal
      reset     => rst_tb,
      go        => go_tb,
      door_open => door_open_tb,
      validate  => validate_tb,
      alarm     => alarm_tb_1p  -- synchrones Resetsignal
      );
   multi_process: alarm_mp 
   port map (
      clk       => clk_tb,  -- Taktsignal
      reset     => rst_tb,
      go        => go_tb,
      door_open => door_open_tb,
      validate  => validate_tb,
      alarm     => alarm_tb_mp  -- synchrones Resetsignal
      );

   rst_gen : process
   begin
      rst_tb <= transport '1' after 1005 ms , '0' after 2005 ms;
      wait; 
   end process rst_gen;
	
   clk_gen : process
   begin
      clk_tb <= transport '1' after 500 ms , '0' after 1000 ms; 
      wait for 1000 ms;
   end process clk_gen;
	
   check: process
   begin
      go_tb <= '0';
      door_open_tb <= '0';
      validate_tb <= '0';

      wait until rst_tb = '1'; -- danach ist der reset '1'
      wait until rst_tb = '0';
      wait for 1 sec;

      -- Beginn Test off State
      report "*** Begin Test state off ***" severity note;

      go_tb <= '0';
      door_open_tb <= '1';
      validate_tb <= '1';
      wait for 2 sec;
   
      assert alarm_tb_mp = '0' and alarm_tb_1p = '0' 
          report "falscher Alarm"
          severity error;
          
      door_open_tb <= '0';
      validate_tb <= '0';
      wait for 1 sec;
      go_tb <= '1';
      wait for 1 sec;
      
      assert alarm_tb_mp = '0' and alarm_tb_1p = '0' 
          report "falscher Alarm"
          severity error;

      -- Beginn Test idle State
      report "*** Begin Test state idle ***" severity note;

      go_tb <= '0';
      door_open_tb <= '0';
      validate_tb <= '1';
      wait for 2 sec;
   
      assert alarm_tb_mp = '0' and alarm_tb_1p = '0'  
          report "falscher Alarm"
          severity error;
          
      go_tb <= '1';
      door_open_tb <= '1';
      validate_tb <= '0';
      wait for 1 sec;
      
      assert alarm_tb_mp = '0' and alarm_tb_1p = '0'  
          report "falscher Alarm"
          severity error;


-- Beginn Test run State
      report "*** Begin Test state run ***" severity note;

      go_tb <= '0';
      door_open_tb <= '0';
      validate_tb <= '0';
      wait for 2 sec;
   
      assert alarm_tb_mp = '0' and alarm_tb_1p = '0'  
          report "falscher Alarm"
          severity error;
          
      door_open_tb <= '0';
      validate_tb <= '1';
      wait for 2 sec;

      assert alarm_tb_mp = '0' and alarm_tb_1p = '0'  
          report "falscher Alarm"
          severity error;

-- Beginn Test alarm State
      report "*** Begin Test state alarm ***" severity note;

      go_tb <= '0';
      door_open_tb <= '1';
      validate_tb <= '0';
      wait for 28 sec;
   
      assert alarm_tb_1p = '1' 
          report "1p: kein Alarm ausgegeben +0 sec"
          severity warning;
      assert alarm_tb_mp = '1' 
          report "mp: kein Alarm ausgegeben +0 sec"
          severity warning;
      
      wait for 1 sec;

      assert alarm_tb_1p = '1' 
          report "1p: kein Alarm ausgegeben +1 sec"
          severity warning;
      assert alarm_tb_mp = '1' 
          report "mp: kein Alarm ausgegeben +1 sec"
          severity warning;

      wait for 1 sec;

      assert alarm_tb_1p = '1' 
          report "1p: kein Alarm ausgegeben +2 sec"
          severity warning;
      assert alarm_tb_mp = '1' 
          report "mp: kein Alarm ausgegeben +2 sec"
          severity warning;

      wait for 1 sec;

      assert alarm_tb_1p = '1' 
          report "1p: kein Alarm ausgegeben +3 sec"
          severity warning;
      assert alarm_tb_mp = '1' 
          report "mp: kein Alarm ausgegeben +3 sec"
          severity warning;

      wait for 1 sec;

      assert alarm_tb_1p = '1' 
          report "1p: kein Alarm ausgegeben +4 sec"
          severity error;
      assert alarm_tb_mp = '1' 
          report "mp: kein Alarm ausgegeben +4 sec"
          severity error;

      wait for 2 sec;
      report "*** Rueckkehr zu off state ***" severity note;
      go_tb <= '0';
      validate_tb <= '1';
      wait for 2 sec;

      assert alarm_tb_mp = '0' and alarm_tb_1p = '0' 
          report "falscher Alarm, erwarteter Zustand off"
          severity error;

   wait for 10 sec;

    assert false report "Simulation beendet" severity failure; -- Simulation beenden	
   end process check;
	
end sim;