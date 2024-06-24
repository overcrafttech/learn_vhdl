entity Komplexen_Mux is
port( re1,re2,im1,im2:in integer range -128 to 127 :=0;
		im_o,re_0: out integer range -128 to 127);
end Komplexen_Mux;

architecture behav of Komplexen_Mux is
begin
signal a,b,c : integer range -128 to 127 :=0 ; 		--muss initializiert werden sonst sind die Werte von Re_o und Im_o  nicht im Definitionsbereich
assert (re1<-128 or re2<-128 or im1<-128 or im2<-128) report " der Wert von re1,re2,im1,im2 ist außerhalb der Definitionsbereich" severity error; --value checking
assert (re1>127 or re2>127 or im1>127 or im2>127) report " der Wert von re1,re2,im1,im2 ist außerhalb der Definitionsbereich" severity error;

	p1:process (re1,re2,im1,im2)	-- vollständige Sensitivy list
	begin
	a <= (re1 + im1 )*(re2 - im2 );
	end process p1;

	p2:process (re1,re2,im1,im2)
	begin
	b <= re1*im2;
	end process p2;

	p3 : process (re1,re2,im1,im2)
	begin
	c <= re2*im1;
	end process p3;

	Reel_Teil: process(a,b,c) -- weil Re_o direckt von a,b,c abhängig ist
	begin
	re_o <= a + b - c;
	end process Reel_Teil;

	Im_Teil : process(c,d)
	begin
	im_o <= c + b;
	end process Im_Teil;
end behav;


