----------------------------------------------------------------------------------
-- Company: COE3302-20
-- Engineer: Anthony Y. Encarnacion Torres
-- 
-- Create Date: 05/13/2021 05:08:36 PM
-- Design Name: 
-- Module Name: PumpAlternation - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY PumpAlternation IS
    PORT (
        ActivatePump_H : IN STD_LOGIC;
        Pump_1_On_H : INOUT STD_LOGIC;
        Pump_2_On_H : INOUT STD_LOGIC;
        Rst_L : IN STD_LOGIC);
END PumpAlternation;

ARCHITECTURE Behavioral OF PumpAlternation IS

    SIGNAL Q_Pump_1_On_H : STD_LOGIC := '1';
    SIGNAL Q_Pump_2_On_H : STD_LOGIC := '0';

BEGIN

    PROCESS (ActivatePump_H, Rst_L) IS

    BEGIN
        IF (Rst_L = '0')
            THEN
            Q_Pump_1_On_H <= '1';
            Q_Pump_2_On_H <= '0';
        ELSIF (ActivatePump_H'Event AND ActivatePump_H = '1') -- detect rising edge of ActivatePump_H signal
            THEN
            Q_Pump_1_On_H <= NOT Q_Pump_1_On_H;
            Q_Pump_2_On_H <= NOT Q_Pump_2_On_H;
        END IF;
    END PROCESS;

    Pump_1_On_H <= Q_Pump_1_On_H AND ActivatePump_H;
    Pump_2_On_H <= Q_Pump_2_On_H AND ActivatePump_H;

END Behavioral;