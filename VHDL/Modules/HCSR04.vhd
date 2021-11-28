library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity HCSR04 is
    Port ( clk : in  STD_LOGIC;
           echo : in  STD_LOGIC;
           trig : out  STD_LOGIC;
			  obstacle : out STD_LOGIC);
end HCSR04;

architecture Behavioral of HCSR04 is

component Counter is 
	generic(n : positive := 10);
	Port(
		 clk : in STD_LOGIC;
		 enable : in STD_LOGIC;
		 reset : in STD_LOGIC;          
		 output : out STD_LOGIC_VECTOR(n-1 downto 0)
		);
end component;

component TriggerGenerator is
    Port ( clk : in  STD_LOGIC;
           trig : out  STD_LOGIC);
end component;
	signal echo_width : STD_LOGIC_VECTOR(21 downto 0);
	signal trig_signal: STD_LOGIC;
	signal echo_distance : positive;
begin
	pulse_in : counter generic map(22) port map(clk, echo, not(trig_signal), echo_width);
	trig_generator : TriggerGenerator port map(clk, trig_signal);
	obstacle_detection : process(echo_width, echo_distance)
		begin
			echo_distance <= to_integer(unsigned(echo_width));
			if echo_distance < 55000 then
				obstacle <= '1';
			else
				obstacle <= '0';
			end if;
		end process;
		trig <= trig_signal;
end Behavioral;