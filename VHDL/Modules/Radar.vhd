library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Radar is
    Port ( 
			clk : in  STD_LOGIC;
			reset : in STD_LOGIC;
			echo : in  STD_LOGIC;
			trig : out  STD_LOGIC;
			pwm : out  STD_LOGIC
	 );
end Radar;

architecture Behavioral of Radar is

component HCSR04 is
	Port (
		clk : in  STD_LOGIC;
		enable : in  STD_LOGIC;
		reset : in  STD_LOGIC;
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
	constant degrees_0 : STD_LOGIC_VECTOR(6 downto 0) := "0000000";
	constant degrees_20 : STD_LOGIC_VECTOR(6 downto 0) := "0001000";
	constant degrees_45 : STD_LOGIC_VECTOR(6 downto 0) := "0010000";
	constant degrees_65 : STD_LOGIC_VECTOR(6 downto 0) := "0011000";
	constant degrees_90 : STD_LOGIC_VECTOR(6 downto 0) := "1111000";
	constant degrees_105 : STD_LOGIC_VECTOR(6 downto 0) := "0001100";
	constant degrees_135 : STD_LOGIC_VECTOR(6 downto 0) := "0010100";
	constant degrees_155 : STD_LOGIC_VECTOR(6 downto 0) := "0011100";
	constant degrees_180 : STD_LOGIC_VECTOR(6 downto 0) := "1111111";

	signal nearest : integer;
	signal distance : natural;
	signal trig_signal : STD_LOGIC;
	signal enable_ultrasonic : STD_LOGIC;
	signal reset_ultrasonic : STD_LOGIC;
	signal position : STD_LOGIC_VECTOR (6 downto 0);
	
	-- int vector
	type int_vector is array(natural range <>) of natural;
	signal distances : int_vector (8 downto 0);
begin
	ultrasonic : HCSR04 port map(clk, enable_ultrasonic, '1', echo, trig_signal, distance);
	servomotor : Servo port map(clk, reset, position, pwm);
	obstacle_detection : process
		variable index : integer;
	begin
		if rising_edge(reset) then
			for i in 0 to 8 loop
				case i is
					when 0 => position <= degrees_0;
					when 1 => position <= degrees_20;
					when 2 => position <= degrees_45;
					when 3 => position <= degrees_65;
					when 4 => position <= degrees_90;
					when 5 => position <= degrees_105;
					when 6 => position <= degrees_135;
					when 7 => position <= degrees_155;
					when 8 => position <= degrees_180;
					when others => position <= degrees_0;
				end case;
				reset_ultrasonic <= '1', '0' after 10ns;
				enable_ultrasonic <= '1', '0' after 10ns;
				enable_ultrasonic <= '0';
				distances(i) <= distance after 200us;
			end loop;
			
			nearest <= -1;
			index := -1;
			for i in 0 to 8 loop
				if nearest = -1 or distances(i) < nearest then
					nearest <= distances(i);
					index := i;
				end if;
			end loop;
		end if;
	end process;
	trig <= trig_signal;
end Behavioral;