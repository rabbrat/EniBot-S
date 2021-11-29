library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Radar is
    Port ( 
			clk : in  STD_LOGIC;
			echo : in  STD_LOGIC;
			trig : out  STD_LOGIC;
			pwm : out  STD_LOGIC
	 );
end Radar;

architecture Behavioral of Radar is

component HCSR04 is
		Port ( 
			clk : in  STD_LOGIC;
			echo : in  STD_LOGIC;
			trig : out  STD_LOGIC;
			distance : out natural
		);
end component;

component Servo is
	Port (
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		position : in STD_LOGIC_VECTOR (6 downto 0);
		pwm : out STD_LOGIC
	);
end component;

	signal distance : natural := 0;
	signal reset : STD_LOGIC := '0';
	signal position : STD_LOGIC_VECTOR (6 downto 0) := "0000000";
begin
	ultrasonic : HCSR04 port map(clk, echo, trig, distance);
	servomotor : Servo port map(clk, reset, position, pwm);
end Behavioral;