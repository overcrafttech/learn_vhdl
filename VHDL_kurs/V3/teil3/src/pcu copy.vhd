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
                if stop = '1' then 
                                                                    -- stop signal, dann passiert nix
                else 
                    if load = '1' then
                        if jump = '1' then                             
                            report "load'n'jump" severity error;    -- load'n'jump; error. 
                        else
                            pci <= lvi;                       -- load;    pc <= loadvalue
                        end if;
                    else
                        if jump = '1' then
                            pci <= pci + lvi;                 -- jump;    loadvalue + pc
                        else
                            pci<= pci + x"0001";                    -- normal;  pc + 1
                        end if;
                    end if;
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