----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:51:05 11/28/2021 
-- Design Name: 
-- Module Name:    ServoF - Behavioral 
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

entity ServoF is
	PORT(
	clk : IN STD_LOGIC;
	reset : IN STD_LOGIC;
	posicion : IN STD_LOGIC_VECTOR (6 DOWNTO 0);
	servo : OUT STD_LOGIC);
end ServoF;

architecture Behavioral of ServoF is
	COMPONENT clock_181kHz
	PORT ( 
	entrada: IN STD_LOGIC;
	reset : IN STD_LOGIC;
	salida : OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT servo_pwm
	    Port ( clk : in  STD_LOGIC;-- clock de fpga
           reset : in  STD_LOGIC;
           posicion : in  STD_LOGIC_VECTOR (6 downto 0);--control de posicion
           servo : out  STD_LOGIC);
			  	END COMPONENT;

	SIGNAL clk_out : STD_LOGIC := '0';
BEGIN
	clock_181kHz_map: clock_181kHz 
	PORT MAP (clk, reset, clk_out);
	
	servo_pwm_map: servo_pwm 
	PORT MAP(clk_out, reset, posicion, servo);
end Behavioral;

