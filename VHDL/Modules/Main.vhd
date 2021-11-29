----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:00:33 11/28/2021 
-- Design Name: 
-- Module Name:    Main - Behavioral 
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

entity Main is
    Port ( clk : in  STD_LOGIC;
           hbridge_out : out  STD_LOGIC_VECTOR );
end Main;

architecture Behavioral of Main is
	constant moveForward STD_LOGIC_VECTOR : "110101";
	
	signal direction STD_LOGIC_VECTOR (5 DOWNTO 0);
	signal counter positive;
begin
	hbridge HBRIDGE port map direction, counter
	
	hbridge_out <= direction
end Behavioral;

