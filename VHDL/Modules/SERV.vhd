----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:13:31 11/28/2021 
-- Design Name: 
-- Module Name:    servo_pwm - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
--PWM para el servo, para 180 posiciones, se ocupa una frecuencia de 181kHz
-- 1ms cada 181 interecciones
--181 x 20ms= 3620
--Usando un contador de 0 a 3619
entity servo_pwm is
    Port ( clk : in  STD_LOGIC;-- clock de fpga
           reset : in  STD_LOGIC;
           posicion : in  STD_LOGIC_VECTOR (6 downto 0);--control de posicion
           servo : out  STD_LOGIC); --salida de pwm senal para el servo
			  
end servo_pwm;

architecture Behavioral of servo_pwm is
---SIGNALs
	SIGNAL CNT : unsigned (10 DOWNTO 0);
	SIGNAL T_PWM : unsigned (7 DOWNTO 0);
	
begin
	
	T_PWM <= UNSIGNED ('0' & posicion)+32;
	
	 contador: PROCESS (reset, clk) begin
        if (reset = '1') then
           CNT <= (others => '0');
        elsif rising_edge(clk) then
            if (CNT = 1279) then
                CNT <= (others => '0');
            else
                CNT <= CNT + 1;
            end if;
        end if;
    end process;
    -- Señal de salida para el servomotor.
    servo <= '1' when (CNT < T_PWM) else '0';

end Behavioral;

