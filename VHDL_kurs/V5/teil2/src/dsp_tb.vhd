 library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dsp_tb is
end dsp_tb;

architecture sim of dsp_tb is

-- Deklaration der zu testenden Komponente alarm
component dsp_1
    port (
    clk             : in std_logic;
    rst             : in std_logic;
    data_re         : in signed(3 downto 0);
    data_im         : in signed(3 downto 0);
    data_valid      : in std_logic;
    start           : in std_logic;
    result          : out unsigned(6 downto 0)
    );
end component; -- alarm
component dsp_2
    port (
    clk             : in std_logic;
    rst             : in std_logic;
    data_re         : in signed(3 downto 0);
    data_im         : in signed(3 downto 0);
    data_valid      : in std_logic;
    start           : in std_logic;
    result          : out unsigned(6 downto 0)
    );
end component; -- alarm

-- Interne Signale der Testbench
signal clk_tb         :  std_logic;  
signal rst_tb         :  std_logic; 
signal data_re_tb     :  signed(3 downto 0); 
signal data_im_tb     :  signed(3 downto 0); 
signal data_valid_tb  :  std_logic;
signal start_tb       :  std_logic; 
signal result_dsp_1   :  unsigned(6 downto 0); 
signal result_dsp_2   :  unsigned(6 downto 0);

begin

   comp_dsp_1   : dsp_1 
   port map (
      clk       => clk_tb,  -- Taktsignal
      rst     => rst_tb,
      data_re   => data_re_tb,
      data_im   => data_im_tb,
      data_valid => data_valid_tb,
      start     => start_tb,
      result    => result_dsp_1
      );
   comp_dsp_2  : dsp_2 
   port map (
    clk       => clk_tb,  -- Taktsignal
    rst     => rst_tb,
    data_re   => data_re_tb,
    data_im   => data_im_tb,
    data_valid => data_valid_tb,
    start     => start_tb,
    result    => result_dsp_2
    );

   rst_gen : process
   begin
      rst_tb <= transport '1' after 100 ns , '0' after 200 ns;
      wait; 
   end process rst_gen;
	
   clk_gen : process
   begin
      clk_tb <= transport '1' after 50 ns , '0' after 100 ns; 
      wait for 100 ns;
   end process clk_gen;
	
   check: process
   begin
      report "*** Beginn Test Zeitversatz ***" severity note;

        wait until rst_tb = '1'; -- danach ist der reset '1'
        wait until rst_tb = '0';

        start_tb <= '1';

        wait for 100 ns;

        start_tb <= '0';
        data_valid_tb <= '1';
        data_re_tb <= to_signed(2, data_re_tb'length);
        data_im_tb <= to_signed(2, data_re_tb'length);
        wait for 100 ns;
        data_re_tb <= to_signed(2, data_re_tb'length);
        data_im_tb <= to_signed(2, data_re_tb'length);
        wait for 100 ns;
        data_re_tb <= to_signed(2, data_re_tb'length);
        data_im_tb <= to_signed(2, data_re_tb'length);
        wait for 100 ns;

        data_valid_tb <= '0';
        wait for 100 ns;
	start_tb <= '1';

        wait for 100 ns;

        start_tb <= '0';
        data_valid_tb <= '1';
        data_re_tb <= to_signed(2, data_re_tb'length);
        data_im_tb <= to_signed(2, data_re_tb'length);
        wait for 100 ns;
        data_re_tb <= to_signed(2, data_re_tb'length);
        data_im_tb <= to_signed(2, data_re_tb'length);
        wait for 100 ns;
        data_re_tb <= to_signed(2, data_re_tb'length);
        data_im_tb <= to_signed(2, data_re_tb'length);
        wait for 100 ns;

        data_valid_tb <= '0';
        wait for 100 ns;

        report "*** Beginn Test oberer Grenzwert ***" severity note;
   start_tb <= '1';

        wait for 100 ns;

        start_tb <= '0';
        data_valid_tb <= '1';
        data_re_tb <= to_signed(-8, data_re_tb'length);
        data_im_tb <= to_signed(-8, data_re_tb'length);
        wait for 100 ns;

        data_valid_tb <= '0';
        wait for 100 ns;

        report "*** Beginn Test Grenzwert result ***" severity note;
   start_tb <= '1';

        wait for 100 ns;

        start_tb <= '0';
        data_valid_tb <= '1';
        data_re_tb <= to_signed(-8, data_re_tb'length);
        data_im_tb <= to_signed(-8, data_re_tb'length);
        wait for 100 ns;
        data_re_tb <= to_signed(-8, data_re_tb'length);
        data_im_tb <= to_signed(-8, data_re_tb'length);
        wait for 100 ns;
        data_re_tb <= to_signed(-8, data_re_tb'length);
        data_im_tb <= to_signed(-8, data_re_tb'length);
        wait for 100 ns;
        data_re_tb <= to_signed(-8, data_re_tb'length);
        data_im_tb <= to_signed(-8, data_re_tb'length);
        wait for 100 ns;
        data_re_tb <= to_signed(-8, data_re_tb'length);
        data_im_tb <= to_signed(-8, data_re_tb'length);
        wait for 100 ns;
        data_re_tb <= to_signed(-8, data_re_tb'length);
        data_im_tb <= to_signed(-8, data_re_tb'length);
        wait for 100 ns;
        data_re_tb <= to_signed(-8, data_re_tb'length);
        data_im_tb <= to_signed(-8, data_re_tb'length);
        wait for 100 ns;

        data_valid_tb <= '0';
        wait for 100 ns;

        wait for 500 ns;




    assert false report "Simulation beendet" severity failure; -- Simulation beenden	
   end process check;
	
end sim;