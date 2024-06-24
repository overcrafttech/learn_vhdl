library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alarm_1p is
  port
   (clk       : in  std_logic;
    reset     : in  std_logic;
    go        : in  std_logic;
    door_open : in  std_logic;
    validate  : in  std_logic;
    alarm     : out  std_logic
   );
end alarm_1p;

architecture behavioral of alarm_1p is

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

signal load_pcu       :  std_logic; 
signal jump_pcu       :  std_logic; 
signal stop_pcu       :  std_logic;            
signal loadvalue_pcu  :  std_logic_vector (15 downto 0);
signal pc_pcu         :  std_logic_vector (15 downto 0);

--interner Signale deklarieren
type states is (off, idle, run, alarm_state ,door_close);
signal state : states; -- 5 zustände
--Konstanten deklarieren

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

  process (clk)
  begin
    if rising_edge(clk) then
      if reset = '1' then
        state  <= off;

        alarm  <= '0';
        -- PCU Befehl
        loadvalue_pcu <= x"0000";
        load_pcu <= '0';
        jump_pcu <= '0';
        stop_pcu <= '0';

      else

      case state is
        when off => -- Off
          -- Ausgabe
          alarm <= '0';
          stop_pcu <= '0';

          -- Zustandsübergang
          if go = '1' then 
            state <= idle; 
            end if;

        when idle => -- Idle
          -- Ausgabe
          alarm <= '0';
          stop_pcu <= '1';
          -- PCU Befehl
          load_pcu <= '1';
          stop_pcu <= '0';

          -- Zustandsübergang
          if door_open = '1' then 
            state <= run; 
            end if;

        when run => -- Run
          -- Ausgabe
          alarm <= '0';
          load_pcu <= '0';
          stop_pcu <= '0';

          -- Zustandsübergang
          if validate = '1' then 
            state <= door_close;
          elsif pc_pcu = std_logic_vector(to_unsigned(28, pc_pcu'length)) then
            state <= alarm_state;
            end if;

        when alarm_state => -- Alarm
          -- Ausgabe
          alarm <= '1';
          stop_pcu <= '0';

          -- Zustandsübergang
          if validate = '1' and go = '0' then 
            state <= off;
            end if;

        when door_close => -- Door Close
          -- Ausgabe
          alarm <= '0';
          stop_pcu <= '0';
          

          -- Zustandsübergang
          if door_open = '0' then 
            state <= idle;
            end if;

        when others =>
          
        end case;
        end if;
      end if;
    end process;



end behavioral;
