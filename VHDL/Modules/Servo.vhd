library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Servo is
	Port (
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		position : in STD_LOGIC_VECTOR (6 downto 0);
		servo : out STD_LOGIC
	);
end Servo;

architecture Behavioral of Servo is

component Timer
	generic(timeout : positive);
	Port ( 
		clk: in STD_LOGIC;
		reset : in STD_LOGIC;
		output : out STD_LOGIC
	);
end component;
	
component ServoPWM
	Port (
		clk : in STD_LOGIC;
		reset : in STD_LOGIC;
		posicion : in STD_LOGIC_VECTOR (6 downto 0);
		servo : out  STD_LOGIC
	);
end component;
	signal timer_output : STD_LOGIC := '0';
begin
	servo_pwm: ServoPWM port map(timer_output, reset, position, servo);
	timer: Timer generic map(780) port map(clk, reset, timer_output);
end Behavioral;