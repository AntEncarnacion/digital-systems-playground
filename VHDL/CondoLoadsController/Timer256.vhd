----------------------------------------------------------------------------------
-- Company: COE3302-20
-- Engineer: Anthony Y. Encarnacion Torres
-- 
-- Create Date: 05/13/2021 05:27:51 PM
-- Design Name: 
-- Module Name: Timer256 - Behavioral
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

ENTITY Timer256 IS
       PORT (
              Clk_H : IN STD_LOGIC;
              TimerEn_H : IN STD_LOGIC; -- timer resets when Enable is 
              TimeOut_H : OUT STD_LOGIC);
END Timer256;

ARCHITECTURE Behavioral OF Timer256 IS

       COMPONENT FourBitBinaryCounter IS
              PORT (
                     T_H : IN STD_LOGIC; -- Carry in from previous counter stage
                     P_H : IN STD_LOGIC; -- Counter Enable 
                     Q_H : INOUT STD_LOGIC_VECTOR (3 DOWNTO 0); -- Counter count bit
                     D_H : IN STD_LOGIC_VECTOR (3 DOWNTO 0); -- value to be loaded 
                     COUT_H : OUT STD_LOGIC; -- Carry out asserted hight
                     RST_L : IN STD_LOGIC; -- Reset asserted low
                     LD_H : IN STD_LOGIC; -- load an initial count into the counter when high
                     CLK_H : IN STD_LOGIC
              );
       END COMPONENT;

       SIGNAL wQ_3_0_H, wQ_7_4_H : STD_LOGIC_VECTOR(3 DOWNTO 0);
       SIGNAL wD_3_0_H, wD_7_4_H : STD_LOGIC_VECTOR(3 DOWNTO 0);
       SIGNAL wCOUT_H : STD_LOGIC;
       SIGNAL wLD_H : STD_LOGIC := '0';

BEGIN

       Counter0 : FourBitBinaryCounter PORT MAP
       (
              T_H => TimerEn_H,
              P_H => TimerEn_H,
              Q_H => wQ_3_0_H,
              D_H => wD_3_0_H,
              COUT_H => wCOUT_H,
              RST_L => TimerEn_H,
              LD_H => wLD_H,
              CLK_H => Clk_H
       );

       Counter1 : FourBitBinaryCounter PORT MAP
       (
              T_H => wCOUT_H,
              P_H => TimerEn_H,
              Q_H => wQ_7_4_H,
              D_H => wD_7_4_H,
              COUT_H => TimeOut_H,
              RST_L => TimerEn_H,
              LD_H => wLD_H,
              CLK_H => Clk_H
       );

END Behavioral;