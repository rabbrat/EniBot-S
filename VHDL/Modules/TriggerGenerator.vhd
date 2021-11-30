library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TriggerGenerator is
	Port(
		clk : in  STD_LOGIC;
		enable : in  STD_LOGIC;
		trig : out  STD_LOGIC
	);
end TriggerGenerator;

architecture Behavioral of TriggerGenerator is
	
component Counter is 
	generic(n : positive := 10);
	Port (
		clk : in STD_LOGIC;
		enable : in STD_LOGIC;
		reset : in STD_LOGIC;          
		output : out STD_LOGIC_VECTOR(n-1 downto 0)
	);
end component;
	signal output_signal : STD_LOGIC_VECTOR(23 downto 0);
	signal reset_signal : STD_LOGIC;
begin
	nanoseconds : Counter generic map(24) port map(clk, enable, reset_signal, output_signal);
	process(clk, enable, output_signal)
	constant ms100 : STD_LOGIC_VECTOR(23 downto 0) := "010011000100101101000000";
	constant ms100And20us : STD_LOGIC_VECTOR(23 downto 0) := "010011000100110100110011";
	begin
		if enable = '1' then
			if(output_signal > ms100  and output_signal < ms100And20us) then
				trig <= '1';
			else
				trig <= '0';
			end if;
				
			if(output_signal = ms100And20us or output_signal="XXXXXXXXXXXXXXXXXXXXXXXX") then
				reset_signal <= '0';
			else
				reset_signal <= '1';
			end if;
		end if;
	end process;
	
end Behavioral;