----------------------------------------------------------------------------------
-- Company: COE 3302-20
-- Engineer: Anthony Y. Encarnacion Torres
-- Student Number: 113862
-- Create Date: 03/24/2021 01:13:49 PM
-- Design Name: 
-- Module Name: Four_Bit_Adder - Behavioral
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
ENTITY DFF_Four_Bit IS
      PORT (
            D_H : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            Q_H : INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            myClk_H : IN STD_LOGIC;
            Set_L : IN STD_LOGIC;
            Rst_L : IN STD_LOGIC);
END DFF_Four_Bit;

ARCHITECTURE behavior OF DFF_Four_Bit IS

      COMPONENT DFF
            PORT (
                  D_H : IN STD_LOGIC;
                  Q_H : INOUT STD_LOGIC;
                  myClk_H : IN STD_LOGIC;
                  Set_L : IN STD_LOGIC;
                  Rst_L : IN STD_LOGIC);
      END COMPONENT;
BEGIN
      FF1 : DFF PORT MAP(
            D_H => D_H(0),
            Q_H => Q_H(0),
            myClk_H => myClk_H,
            Set_L => Set_L,
            Rst_L => Rst_L
      );

      FF2 : DFF PORT MAP(
            D_H => D_H(1),
            Q_H => Q_H(1),
            myClk_H => myClk_H,
            Set_L => Set_L,
            Rst_L => Rst_L
      );

      FF3 : DFF PORT MAP(
            D_H => D_H(2),
            Q_H => Q_H(2),
            myClk_H => myClk_H,
            Set_L => Set_L,
            Rst_L => Rst_L
      );

      FF4 : DFF PORT MAP(
            D_H => D_H(3),
            Q_H => Q_H(3),
            myClk_H => myClk_H,
            Set_L => Set_L,
            Rst_L => Rst_L
      );

END;