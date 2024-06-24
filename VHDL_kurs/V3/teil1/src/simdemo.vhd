entity  simdemo is
  port( clk   : in  bit; -- Taktsignal
        rst   : in  bit; -- asynchrones Resetsignal
        out1  : out bit_vector (1 downto 0);   -- 1. Ausgangssignal
        out2  : out bit_vector (1 downto 0)    -- 2. Ausgangssignal
   );  
end simdemo;

architecture rtl of  simdemo is

-- Register-Ausgänge reg1 und reg2
signal reg1, reg2 : bit_vector (1 downto 0);
-- Signal nreg1 zur Darstellung der Inkrementierung von reg1
signal nreg1      : bit_vector (1 downto 0); 

begin
    inc: process (reg1)
   -- kombinatorischer process, erhoeht den Wert von reg1 um 1
   begin
      --assert false report "inc ist aktiviert" severity warning;
      case reg1 is
      when "00" =>
         nreg1 <= "01";
      when "01" =>
         nreg1 <= "10";
      when "10" =>
         nreg1 <= "11";
      when "11" =>
         nreg1 <= "00";
      end case;
      --assert false report "inc wird DEaktiviert" severity warning;
   end process inc;
	
   inv: process (reg1,reg2)
   -- kombinatorischer process, invertiert Wert von reg1 und reg2
   begin
      -- assert false report "inv ist aktiviert" severity warning;     
      out1 <= not reg1;
      out2 <= not reg2;
      -- assert false report "inv wird DEaktiviert" severity warning;      
   end process inv;
	

regs: process (clk,rst)
   -- getaktakter process mit asynchronem Reset, Verhalten der Register
   begin
      -- assert false report "regs ist aktiviert" severity warning;
      if rst ='1' then
         reg1 <= "00";
         reg2 <= "00";
       elsif clk'event and clk='1' then
          reg1 <= nreg1; -- Inkrementierten Wert zuweisen
          reg2 <= reg1;  -- Schieben
       end if;
       -- assert false report "regs wird DEaktiviert" severity warning;
   end process regs;
	
end;
