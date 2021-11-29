library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Radar is
    Port ( 
			clk : in  STD_LOGIC;
			echo : in  STD_LOGIC;
			trig : out  STD_LOGIC
	 );
end Radar;

architecture Behavioral of Radar is
component HCSR04 is
		Port ( 
			clk : in  STD_LOGIC;
			echo : in  STD_LOGIC;
			trig : out  STD_LOGIC;
			obstacle : out STD_LOGIC
		);
end component;
begin
	ultrasonic : HCSR04 port map(clk, echo, trig, obstacle);
	servo : Servo port map(clk);
end Behavioral;