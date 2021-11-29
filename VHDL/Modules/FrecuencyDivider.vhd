library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Timer is
    Port ( 
			entrada : in  STD_LOGIC;
         reset : in  STD_LOGIC;
			output : out  STD_LOGIC
	 );
end Timer;

architecture Behavioral of Timer is
	signal count : integer range 0 to 780:= 0;
	signal output_signal: STD_LOGIC;
begin
	divisor : process (reset, entrada)
	begin
		if reset = '1' then
			output_signal <= '0';
			count <= 0;
		elsif rising_edge(entrada) then
			if (count =780) then
				output_signal <= not(output_signal);
				count <=0;
			else 
				count <= count + 1;
			end if;
		end if;
	end process;
	output <= output_signal;
end Behavioral;