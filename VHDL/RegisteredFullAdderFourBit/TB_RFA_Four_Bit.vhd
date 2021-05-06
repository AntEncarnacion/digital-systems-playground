----------------------------------------------------------------------------------
-- Company: COE3302-20
-- Engineer: Anthony Y. Encarnacion Torres
-- 
-- Create Date: 04/19/2021 07:20:27 PM
-- Design Name: Testbench Registered Full Adder Four Bit
-- Module Name: TB_RFA_Four_Bit - Behavioral
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
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY TB_RFA_Four_Bit IS
    --  Port ( );
END TB_RFA_Four_Bit;

ARCHITECTURE Behavioral OF TB_RFA_Four_Bit IS
    COMPONENT Registered_Full_Adder_Four_Bit IS
        PORT (
            X_H : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            Y_H : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            myClk_H : IN STD_LOGIC;
            Set_L : IN STD_LOGIC;
            Rst_L : IN STD_LOGIC;
            S_H : INOUT STD_LOGIC_VECTOR(4 DOWNTO 0)
        );
    END COMPONENT;

    -- SIGNAL DEFINITIONS
    SIGNAL X_H, Y_H : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    SIGNAL S_H : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL Set_L, Rst_L : STD_LOGIC := '1';
    SIGNAL myClk_H : STD_LOGIC := '0';

    -- TIME CONSTANTS
    CONSTANT PERIOD : TIME := 20ns;

BEGIN
    uut : Registered_Full_Adder_Four_Bit PORT MAP(
        X_H => X_H,
        Y_H => Y_H,
        myClk_H => myClk_H,
        Set_L => Set_L,
        Rst_L => Rst_L,
        S_H => S_H);

    clockProcess : PROCESS (myClk_H)
    BEGIN
        myClk_H <= (NOT myClk_H) AFTER PERIOD/4;
    END PROCESS;

    stimusProcess : PROCESS
    BEGIN
        WAIT UNTIL rising_edge(myClk_H);
        WAIT FOR PERIOD/4;

        -- CASE 1
        X_H <= "0000";
        Y_H <= "0000";
        WAIT FOR PERIOD;
        ASSERT (S_H = "00000")
        REPORT "Sucessful"
            SEVERITY failure;

        -- CASE 2
        X_H <= "0000";
        Y_H <= "1111";
        WAIT FOR PERIOD;
        ASSERT (S_H = "01111")
        REPORT "Sucessful"
            SEVERITY failure;

        -- CASE 3
        X_H <= "0001";
        Y_H <= "1111";
        WAIT FOR PERIOD;
        ASSERT (S_H = "10000")
        REPORT "Sucessful"
            SEVERITY failure;

        -- CASE 4
        X_H <= "1010";
        Y_H <= "0101";
        WAIT FOR PERIOD;
        ASSERT (S_H = "01111")
        REPORT "Sucessful"
            SEVERITY failure;

        -- CASE 5
        X_H <= "1111";
        Y_H <= "1111";
        WAIT FOR PERIOD;
        ASSERT (S_H = "11110")
        REPORT "Sucessful"
            SEVERITY failure;

        -- CASE 6
        X_H <= "1100";
        Y_H <= "0011";
        WAIT FOR PERIOD;
        ASSERT (S_H = "01111")
        REPORT "Sucessful"
            SEVERITY failure;

        -- CASE 7
        X_H <= "1110";
        Y_H <= "0001";
        WAIT FOR PERIOD;
        ASSERT (S_H = "01111")
        REPORT "Sucessful"
            SEVERITY failure;

        -- CASE 8
        X_H <= "0010";
        Y_H <= "1101";
        WAIT FOR PERIOD;
        ASSERT (S_H = "01111")
        REPORT "Sucessful"
            SEVERITY failure;

        -- CASE 9
        X_H <= "0100";
        Y_H <= "1011";
        WAIT FOR PERIOD;
        ASSERT (S_H = "01111")
        REPORT "Sucessful"
            SEVERITY failure;

    END PROCESS;

END Behavioral;