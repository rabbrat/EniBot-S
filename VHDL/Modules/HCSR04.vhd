library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity HCSR04 is
    Port ( clk : in  STD_LOGIC;
           echo : in  STD_LOGIC;
           trig : out  STD_LOGIC;
			  distance : out positive);
end HCSR04;

architecture Behavioral of HCSR04 is
	
component PulseIn is
    Port ( clk : in  STD_LOGIC;
           pulse : in  STD_LOGIC;
           pulseLength : out positive);
end component;

component TriggerGenerator is
    Port ( clk : in  STD_LOGIC;
           trig : out  STD_LOGIC);
end component;
	
begin
	echoPulse : PulseIn port map(clk => clk, pulse => echo, pulseLength => distance);
	trigGen : TriggerGenerator port map(clk => clk, trig => trig);
end Behavioral;