library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Main is
	Port (
		clk : in  STD_LOGIC;
		reset : in STD_LOGIC;
		echo : in  STD_LOGIC;
		trig : out  STD_LOGIC;
      led : out  STD_LOGIC;
		servo_pwm : out  STD_LOGIC
	);
end Main;

architecture Behavioral of Main is

component Radar is
    Port ( 
			clk : in STD_LOGIC;
			reset : in STD_LOGIC;
			echo : in STD_LOGIC;
			trig : out STD_LOGIC;
			pwm : out STD_LOGIC
	 );
end component;
	signal servo_pwm_signal : STD_LOGIC;
	signal trig_signal : STD_LOGIC;
begin
	detector_radar : Radar port map(clk, echo, trig_signal, servo_pwm_signal);
	trig <= trig_signal;
	servo_pwm <= servo_pwm_signal;
end Behavioral;