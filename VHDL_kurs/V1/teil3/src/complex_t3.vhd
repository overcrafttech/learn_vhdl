
entity complex is 
port (
	re1, re2, im1, im2 : in integer range -128 to 127 :=0;
	re_o, im_o : out integer range -128 to 127);
end complex;

architecture abstract of complex is
	signal a, b, c : integer range -128 to 127 := 0; 
begin

	p1 : process (re1, im1, re2, im2)
	begin
		a <= (re1 + im1)*(re2 - im2);
		
	end process p1; 

	p2 : process  (re1, im2)
	begin
		b <= re1 * im2;
		
	end process p2;

	p3 : process  (re2, im1)
	begin
		c <= re2 * im1;
		
	end process p3;

	p4 : process  (a, b, c)
	begin
		
		im_o <= b + c;
		
	end process p4;

	p5 : process  (b, c)
	begin
		re_o <= a + b - c ;
		
	end process p5;
	
end abstract; 
