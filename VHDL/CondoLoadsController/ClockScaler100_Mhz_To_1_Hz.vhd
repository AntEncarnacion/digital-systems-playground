----------------------------------------------------------------------------------
-- Company: COE3302-20
-- Engineer: Anthony Y. Encarnacion Torres
-- 
-- Create Date: 05/16/2021 07:21:27 PM
-- Design Name: 
-- Module Name: ClockScaler100_Mhz_To_1_Hz - Behavioral
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

ENTITY ClockScaler100_Mhz_To_1_Hz IS
    PORT (
        Clk_100_MHz_H : IN STD_LOGIC;
        Clk_1_Hz_H : OUT STD_LOGIC
    );
END ClockScaler100_Mhz_To_1_Hz;

ARCHITECTURE Behavioral OF ClockScaler100_Mhz_To_1_Hz IS

    SIGNAL counter_1_Hz : INTEGER := 0; -- integers in VHDL are 32 bits wide so and integer can count 2^32 = 2^10 * 2^10 * 2^10 * 2^2 = 4 Billion counts

BEGIN
    PROCESS (Clk_100_Mhz_H)
    BEGIN
        IF ((Clk_100_Mhz_H'event) AND (Clk_100_Mhz_H = '1')) -- detect rising edge of clock
            THEN -- detect rising edge of input clock and increment counter

            counter_1_Hz <= counter_1_Hz + 1; -- increment 1 Hertz period counter

            IF (counter_1_Hz = 50000000 - 1)-- detect mid-cycle transition point 
                THEN
                Clk_1_Hz_H <= '0';
            ELSIF (counter_1_Hz = 100000000 - 1)-- detect end-cycle transition point
                THEN
                Clk_1_Hz_H <= '1';
                counter_1_Hz <= 0; -- reset counter at end of cycle to count next 1_Hertz cycle
            END IF;
        END IF;
    END PROCESS;

END Behavioral;