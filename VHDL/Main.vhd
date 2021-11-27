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

component HCSR04 is
    Port ( clk : in  STD_LOGIC;
           echo : in  STD_LOGIC;
           trig : out  STD_LOGIC;
			  distance : out positive);
end component;
	signal blink : STD_LOGIC;
	signal distance : positive;
begin
	ultrasonic : HCSR04 port map(clk => clk, echo => echo, trig => trig, distance => distance);
	process(distance)
	begin
		if distance > 5 then
			blink <= '1';
		else
			blink <= '0';
		end if;
	end process;
	led <= blink;
end Behavioral;