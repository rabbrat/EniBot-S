library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ServoPWM is
	Port (
		clk : in  STD_LOGIC;
		reset : in  STD_LOGIC;
		posicion : in  STD_LOGIC_VECTOR (6 downto 0);
		servo : out  STD_LOGIC
);			  
end ServoPWM;

architecture Behavioral of ServoPWM is
	signal count : unsigned (10 downto 0);
	signal pwm : unsigned (7 downto 0);
begin
	pwm <= unsigned('0' & posicion) + 16;
	counter : process (reset, clk) 
		 begin
			  if (reset = '1') then
				  count <= (others => '0');
			  elsif rising_edge(clk) then
					if (count = 1280) then
						 count <= (others => '0');
					else
						 count <=count + 1;
					end if;
			  end if;
    end process;
    servo <= '1' when (count < pwm) else '0';
end Behavioral;