library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PulseIn is
    Port ( clk : in  STD_LOGIC;
           pulse : in  STD_LOGIC;
           pulseLength : out natural);
end PulseIn;

architecture Behavioral of PulseIn is

component Counter is 
	generic(n : positive := 10);
	Port(
		 clk : in STD_LOGIC;
		 enable : in STD_LOGIC;
		 reset : in STD_LOGIC;          
		 output : out STD_LOGIC_VECTOR(n-1 downto 0)
		);
end component;
	
	signal count : STD_LOGIC_VECTOR(14 downto 0);
	signal conversion : natural := 0;
begin
	microseconds : Counter generic map(15) port map(clk => clk, enable => pulse, reset => pulse, output => count);
	process(clk, pulse)
	begin
		if falling_edge(pulse) then
			conversion <= to_integer(unsigned(count)) / 58200;
		end if;
	end process;
	pulseLength <= conversion;
end Behavioral;