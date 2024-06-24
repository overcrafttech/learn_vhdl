library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alarm_mp is
  port
   (clk       : in  std_logic;
    reset     : in  std_logic;
    go        : in  std_logic;
    door_open : in  std_logic;
    validate  : in  std_logic;
    alarm     : out  std_logic
   );
end alarm_mp;


architecture behavioral of alarm_mp is

component pcu
  port(   
      clk        : in  std_logic;  
      reset      : in  std_logic; 
      load       : in  std_logic; 
      jump       : in  std_logic; 
      stop       : in  std_logic;            
      loadvalue  : in  std_logic_vector (15 downto 0);
      pc         : out std_logic_vector (15 downto 0)
  ); 
end component; -- pcu

signal load_pcu, load_pcu_nxt            :  std_logic; 
signal jump_pcu, jump_pcu_nxt            :  std_logic; 
signal stop_pcu, stop_pcu_nxt            :  std_logic;            
signal loadvalue_pcu, loadvalue_pcu_nxt  :  std_logic_vector (15 downto 0);
signal pc_pcu, pc_pcu_nxt                :  std_logic_vector (15 downto 0);

signal alarm_nxt                         :  std_logic;

type states is (off, idle, run, alarm_state ,door_close);
signal state, state_nxt                  : states; -- 5 zustände

begin

  pcu_component: pcu port map (
    clk        => clk,  -- Taktsignal
    reset      => reset,  -- synchrones Resetsignal
    load       => load_pcu,
    jump       => jump_pcu,
    stop       => stop_pcu,
    loadvalue  => loadvalue_pcu,
    pc         => pc_pcu
    );
--Concurrent Assignments
--Steuerwerk Alarmanlage

  state_register : process (clk)-- Register
  begin
    if rising_edge(clk) then
      if reset = '1' then
        -- PCU Befehl
        loadvalue_pcu <= x"0000";
        state <= off;
        stop_pcu <= '0';
        jump_pcu <= '0';
      else
        --alarm  <= alarm_nxt;
        --loadvalue_pcu <= loadvalue_pcu_nxt;
        --load_pcu <= load_pcu_nxt;
        state <= state_nxt;
      end if;
    end if;
  end process state_register;

  transfer : process (state, go, door_open, validate, pc_pcu) -- Transferfunktion
  begin
    state_nxt <= state;
    case state is
      when off =>
        if go = '1' then 
          state_nxt <= idle; 
          end if;
      when idle =>
        if door_open = '1' then 
          state_nxt <= run; 
          end if;
      when run => 
        if validate = '1' then 
          state_nxt <= door_close;
        elsif pc_pcu = std_logic_vector(to_unsigned(28, pc_pcu'length)) then
          state_nxt <= alarm_state;
          end if;
      when door_close =>
        if door_open = '0' then 
          state_nxt <= idle;
          end if;
      when alarm_state =>
        if validate = '1' and go = '0' then 
          state_nxt <= off;
          end if;
    end case;
  end process transfer;

  output : process (state) -- Output-Funktion //_nxt entfernt
  begin
    if state = idle then
      alarm <= '0';
      load_pcu <= '1';
      --stop_pcu <= '0';
    elsif state = run then
      alarm <= '0';
      load_pcu <= '0';
      --stop_pcu <= '0';
    elsif state = alarm_state then
      alarm <= '1';
      load_pcu <= '0';
      --stop_pcu <= '0';
    else
      alarm <= '0';
      load_pcu <= '0';
      --stop_pcu <= '0';
      end if; 
  end process output;
end behavioral;
