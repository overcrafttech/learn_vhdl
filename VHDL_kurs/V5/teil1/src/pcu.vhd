library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pcu is
    port(   
        clk        : in  std_logic;  
        reset      : in  std_logic; 
        load       : in  std_logic; 
        jump       : in  std_logic; 
        stop       : in  std_logic;            
        loadvalue  : in  std_logic_vector (15 downto 0);
        pc         : out std_logic_vector (15 downto 0)
    );  
end pcu;
  
architecture behavior of pcu is
signal pci : unsigned(15 downto 0);
signal lvi : unsigned(15 downto 0);
begin

    lvi <= unsigned(loadvalue);

    counter : process (clk) -- Getakteter Prozess nach 1076.6-99
    begin
        -- hier darf nix hin
        if clk'event and clk = '1' then -- rising_edge(clk)
            -- hier darf nix hin
            --
            --
            if reset = '1' then   --reset condition
                pci <= x"0000";                                     -- reset, befehlszähler auf 0
            else
                -- begin clocked behavior
                --assert stop = '1' or stop = '0' report "PCU: stop hat keinen zulässigen Wert (0|1)" severity warning;
                --assert load = '1' or load = '0' report "PCU: load hat keinen zulässigen Wert (0|1)" severity warning;
                --assert jump = '1' or jump = '0' report "PCU: jump hat keinen zulässigen Wert (0|1)" severity warning;
                --assert reset = '1' or reset = '0' report "PCU: reset hat keinen zulässigen Wert (0|1)" severity warning;
                assert (load and jump) /= '1' report "PCU: load'n'jump" severity error;

                if stop = '1'                               then    -- stop signal, dann passiert nix, könnte man auch weg lassen
                end if;
                if stop = '0' and load = '0' and jump = '0' then    -- normal;  pc + 1
                    pci <= pci + x"0001"; 
                end if;
                if stop = '0' and load = '1' and jump = '0' then    -- load;    pc <= loadvalue
                    pci <= lvi; 
                end if; 
                if stop = '0' and load = '0' and jump = '1' then    -- jump;    loadvalue + pc
                    pci <= pci + lvi; 
                end if;
                                                                    
            end if;
            --
            --
            -- hier darf nix hin
        end if;
        -- hier darf nix hin
    end process counter;

    pc <= std_logic_vector(pci);

end;