----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2021 07:41:14 PM
-- Design Name: 
-- Module Name: ClockScaler - Behavioral
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



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ClockScaler is
    Port ( Clk_12_MHz_H : in STD_LOGIC;
              Clk_1_Hz_H : out STD_LOGIC
          );
end ClockScaler;

architecture Behavioral of ClockScaler is

signal counter_1_Hz: integer := 0;  -- integers in VHDL are 32 bits wide so and integer can count 2^32 = 2^10 * 2^10 * 2^10 * 2^2 = 4 Billion counts

begin
    process(Clk_12_MHz_H) 
    begin
     if( (Clk_12_MHz_H'event) AND (Clk_12_MHz_H = '1') ) -- detect rising edge of clock
       then  -- detect rising edge of input clock and increment counter
       
            counter_1_Hz <= counter_1_Hz + 1;     -- increment 1 Hertz period counter
                  
            if (counter_1_Hz =  6000000-1 )-- detect mid-cycle transition point 
            then
                Clk_1_Hz_H <= '0';
            elsif (counter_1_Hz =  12000000-1 )-- detect end-cycle transition point
            then
                Clk_1_Hz_H <= '1';
                counter_1_Hz <= 0; -- reset counter at end of cycle to count next 1_Hertz cycle
            end if;
      end if;
    end process;

end Behavioral;
