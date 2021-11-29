library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Main is
	Port (
		clk : in  STD_LOGIC;
		echo : in  STD_LOGIC;
		trig : out  STD_LOGIC;
      led : out  STD_LOGIC
	);
end Main;

architecture Behavioral of Main is
	signal blink : STD_LOGIC;
	signal obstacle : STD_LOGIC;
begin
	radar : Radar port map(clk, trig, echo);
	process(obstacle)
	begin
		blink <= obstacle;
	end process;
	led <= blink;
end Behavioral;