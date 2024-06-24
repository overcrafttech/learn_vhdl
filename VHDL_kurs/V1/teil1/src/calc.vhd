entity calc is 
  port ( 
    a, b, c : in integer := 0;
    d : out integer := 0
  );
end calc;

architecture behav of calc is
  signal temp, erg : integer;
begin 
  p1 : process
  begin
    temp <= a + b after 5 ns;
    wait on a, b;
  end process p1;

  p2 : process
  begin
    erg <= temp * c after 25 ns;
    wait on temp, c;
  end process p2;

  p3 : process
  begin
    d <= erg;
    wait on erg;
  end process p3;
end behav;
