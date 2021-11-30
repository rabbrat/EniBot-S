library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity HCSR04 is
	Port (
		clk : in  STD_LOGIC;
		enable : in  STD_LOGIC;
		reset : in  STD_LOGIC;
		echo : in  STD_LOGIC;
		trig : out  STD_LOGIC;
		distance : out natural
	);
end HCSR04;

architecture Behavioral of HCSR04 is

component Counter is 
	generic(n : positive := 10);
	Port (
		clk : in STD_LOGIC;
		enable : in STD_LOGIC;
		reset : in STD_LOGIC;          
		output : out STD_LOGIC_VECTOR(n-1 downto 0)
	);
end component;

component TriggerGenerator is
	Port (
		clk : in  STD_LOGIC;
		enable : in  STD_LOGIC;
		trig : out  STD_LOGIC
	);
end component;

	signal echo_width : STD_LOGIC_VECTOR(21 downto 0);
	signal reset_pulse_in: STD_LOGIC;
	signal trig_signal: STD_LOGIC;
	signal echo_distance : natural;
begin
	pulse_in : Counter generic map(22) port map(clk, echo, reset_pulse_in, echo_width);
	trig_generator : TriggerGenerator port map(clk, enable, trig_signal);
	calculate : process(echo_width, echo_distance, reset)
		begin
			if reset = '1' then
				echo_distance <= 0;
			else
				echo_distance <= to_integer(unsigned(echo_width));
			end if;
	end process;
	distance <= echo_distance;
	trig <= trig_signal;
	reset_pulse_in <= not(trig_signal);
end Behavioral;