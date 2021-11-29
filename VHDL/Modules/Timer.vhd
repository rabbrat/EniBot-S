library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Timer is
	generic(timeout : positive);
	Port (
		clk : in STD_LOGIC;
		reset : in  STD_LOGIC;
		output : out  STD_LOGIC
	);
end Timer;

architecture Behavioral of Timer is
	signal counter : natural range 0 to timeout := 0;
	signal output_signal: STD_LOGIC;
begin
	timer : process (clk, reset)
	begin
		if reset = '1' then
			output_signal <= '0';
			counter <= 0;
		elsif rising_edge(clk) then
			if (counter = timeout) then
				output_signal <= not(output_signal);
				counter <=0;
			else 
				counter <= counter + 1;
			end if;
		end if;
	end process;
	output <= output_signal;
end Behavioral;