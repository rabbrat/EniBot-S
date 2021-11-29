library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity HBRIGDE is
    Port ( INPUT : in  STD_LOGIC_VECTOR (5 downto 0);
         FORWARD : in  STD_LOGIC;
			BACKWARD : out  STD_LOGIC;
			BRAKE 	: out  STD_LOGIC;
			RIGHT 	: out  STD_LOGIC;
			LEFT		: out  STD_LOGIC);
end HBRIGDE;

architecture Behavioral of HBRIGDE is
begin
end Behavioral;