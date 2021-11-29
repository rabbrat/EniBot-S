----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:29:20 11/28/2021 
-- Design Name: 
-- Module Name:    div_frec - clock_181kHz 
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
---DIVISOR DE FRECUENCIA
entity clock_181kHz is
    Port ( entrada : in  STD_LOGIC;
           reset : in  STD_LOGIC;
				salida : out  STD_LOGIC);
end clock_181kHz;

architecture Behavioral of clock_181kHz is

SIGNAL TEMP: STD_LOGIC;
SIGNAL CONTADOR : INTEGER RANGE 0 TO 780:= 0;--ESCALA (Fin\Fout )\2

begin
	divisor : PROCESS (reset, entrada)
	BEGIN
		IF (reset = '1') THEN
		TEMP <= '0';
		CONTADOR <= 0;
		
		ELSIF RISING_EDGE (entrada) THEN
			IF (CONTADOR =780) THEN
			TEMP <= NOT(TEMP);
			CONTADOR <=0;
			ELSE 
			CONTADOR <= CONTADOR + 1;
			END IF;
		END IF;
		END PROCESS;
	salida <= TEMP;
end Behavioral;


