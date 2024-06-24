entity complex is 
port (
	re1, re2, im1, im2 : in integer range -128 to 127 :=0;
	re_o, im_o : out integer range -128 to 127);
end complex;

architecture abstract of complex is 
begin 
	add_complex : process(re1,  re2, im1, im2)
	begin 
		re_o <= re1 * re2 - im1 * im2 ;
		im_o <= re1 * im2 + re2 * im1 ;
	end process add_complex;
end abstract; 