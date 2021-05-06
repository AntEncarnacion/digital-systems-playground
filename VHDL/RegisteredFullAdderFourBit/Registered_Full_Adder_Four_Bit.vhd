----------------------------------------------------------------------------------
-- Company: COE 3302-20
-- Engineer: Anthony Y. Encarnacion Torres
-- Student Number: 113862
-- Create Date: 03/25/2021 12:39:52 AM
-- Design Name: 
-- Module Name: Registered_Full_Adder_Four_Bit - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY Registered_Full_Adder_Four_Bit IS
    PORT (
        X_H : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Y_H : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        myClk_H : IN STD_LOGIC;
        Set_L : IN STD_LOGIC;
        Rst_L : IN STD_LOGIC;
        S_H : INOUT STD_LOGIC_VECTOR(4 DOWNTO 0)
    );
END Registered_Full_Adder_Four_Bit;

ARCHITECTURE Behavioral OF Registered_Full_Adder_Four_Bit IS

    COMPONENT Full_Adder_Four_Bit
        PORT (
            A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            S : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            Cout : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT DFF_Four_Bit
        PORT (
            D_H : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            Q_H : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            myClk_H : IN STD_LOGIC;
            Set_L : IN STD_LOGIC;
            Rst_L : IN STD_LOGIC
        );
    END COMPONENT;
    COMPONENT DFF_Five_Bit
        PORT (
            D_H : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Q_H : INOUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            myClk_H : IN STD_LOGIC;
            Set_L : IN STD_LOGIC;
            Rst_L : IN STD_LOGIC
        );
    END COMPONENT;
    SIGNAL wQA_H, wQB_H : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL wS : STD_LOGIC_VECTOR(4 DOWNTO 0);

BEGIN

    FBFF1 : DFF_Four_Bit PORT MAP(
        D_H => X_H,
        Q_H => wQA_H,
        myClk_H => myClk_H,
        Set_L => Set_L,
        Rst_L => Rst_L);
    FBFF2 : DFF_Four_Bit PORT MAP(
        D_H => Y_H,
        Q_H => wQB_H,
        myClk_H => myClk_H,
        Set_L => Set_L,
        Rst_L => Rst_L);

    FA : Full_Adder_Four_Bit PORT MAP(
        A => wQA_H,
        B => wQB_H,
        S(0) => wS(0),
        S(1) => wS(1),
        S(2) => wS(2),
        S(3) => wS(3),
        Cout => wS(4));

    FBFF_OUT : DFF_Five_Bit PORT MAP(
        D_H => wS,
        Q_H => S_H,
        myClk_H => myClk_H,
        Set_L => Set_L,
        Rst_L => Rst_L);
END Behavioral;