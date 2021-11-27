library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TriggerGenerator is
    Port ( clk : in  STD_LOGIC;
           trig : out  STD_LOGIC);
end TriggerGenerator;

architecture Behavioral of TriggerGenerator is
	
component Counter is 
	generic(n : positive := 10);
	Port(
		 clk : in STD_LOGIC;
		 enable : in STD_LOGIC;
		 reset : in STD_LOGIC;          
		 output : out STD_LOGIC_VECTOR(n-1 downto 0)
		);
end component;
	
	signal reset_counter : std_logic;
	signal output_counter : std_logic_vector(23 downto 0);
begin
	microseconds : Counter generic map(24) port map(clk, '1', reset_counter, output_counter);
	process(clk, output_counter)
	constant ms250 : std_logic_vector(23 downto 0) := "101111101011110000100000";
	constant ms250And100us : std_logic_vector(23 downto 0) := "101111101100111110101000";
	begin
		if(output_counter > ms250 and output_counter < ms250And100us) then
			trig <= '1';
		else
			trig <= '0';
		end if;
			
		if(output_counter = ms250And100us or output_counter="XXXXXXXXXXXXXXXXXXXXXXXX") then
			reset_counter <= '0';
		else
			reset_counter <= '1';
		end if;
	end process;
	
end Behavioral;

