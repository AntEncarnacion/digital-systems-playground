----------------------------------------------------------------------------------
-- Company: COE 3302-20
-- Engineer: Anthony Y. Encarnacion Torres
-- Student Number: 113862
-- Create Date: 03/24/2021 12:08:08 PM
-- Design Name: 
-- Module Name: FullAdder - Behavioral
-- Project Name: 4-Bit Registered Full Adder 
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

ENTITY Full_Adder IS
    PORT (
        X_H : IN STD_LOGIC;
        Y_H : IN STD_LOGIC;
        Cin_H : IN STD_LOGIC;
        Cout_H : OUT STD_LOGIC;
        S_H : OUT STD_LOGIC);
END Full_Adder;

ARCHITECTURE Behavioral OF Full_Adder IS

BEGIN
    S_H <= (X_H AND NOT Y_H AND NOT Cin_H) OR (NOT X_H AND Y_H AND NOT Cin_H) OR
        (NOT X_H AND NOT Y_H AND Cin_H) OR
        (X_H AND Y_H AND Cin_H) AFTER 2 ns;

    Cout_H <= (X_H AND NOT Y_H AND Cin_H) OR
        (X_H AND Y_H AND NOT Cin_H) OR
        (NOT X_H AND Y_H AND Cin_H) OR
        (X_H AND Y_H AND Cin_H) AFTER 2 ns;

END Behavioral;