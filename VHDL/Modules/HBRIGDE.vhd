----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:48:49 11/28/2021 
-- Design Name: 
-- Module Name:    HBRIGDE - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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

