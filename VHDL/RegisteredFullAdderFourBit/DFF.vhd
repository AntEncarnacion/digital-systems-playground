----------------------------------------------------------------------------------
-- Company: COE 3302-20
-- Engineer: Anthony Y. Encarnacion Torres
-- Student Number: 113862
-- Create Date: 03/24/2021 12:08:08 PM
-- Design Name: 
-- Module Name: FF_Model - Eqn
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
-- These two dashes mean that what follows is a comment
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;
LIBRARY work;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY DFF IS
    PORT (
        D_H : IN STD_LOGIC; -- port declaration defines the signals that will interface the model to the outside world.
        Q_H : INOUT STD_LOGIC; -- Signal name, followed by mode (in, out, inout, buf) and followed by signal type
        myClk_H : IN STD_LOGIC; -- clock signal
        Set_L : IN STD_LOGIC; -- Set signal asserted low, it is asynchronous, thus should cause Setting the FF to Q_H =1 when asserted to Low
        Rst_L : IN STD_LOGIC); -- Reset signal asserted low, is asynchronous, has higher precedence than Set_L 
END DFF;

ARCHITECTURE behavior OF DFF IS

BEGIN
    proc1 : PROCESS (myClk_H, Set_L, Rst_L) -- any transition on any of the signals in this  "sensitivity list" will cause entrance into the process
        -- simulation time does not advance within a Process block, unless we issue WAIT FOR, WAIT UNTIL, 
        -- here it is the only place where we can declare variables for use only within the process block.
    BEGIN
        IF (Rst_L = '0') -- Reset has precedence over Set_L, note the "=" is a comparison for equality operator that results in a TRUE or FALSE value
            THEN
            Q_H <= '0' AFTER 1 ns; -- future events on signal Q_H will take effect after the process block is exit
        ELSIF (Set_L = '0') -- 
            THEN
            Q_H <= '1' AFTER 1 ns; -- This assignment statement is no longer concurrent as it was when outside the process, now it is a sequential assignment
            -- that only creates an event on the output signal if the flow of control executes that assignment, 
            -- and then the event on the output signal will be scheduled on that signal after the process is completed        
        ELSIF (myClk_H = '1') AND (myClk_H'event) -- detect positive-going edge of clock signal, 'event property true means last event being simulated occured in this signal
            THEN -- all next assignments after this transition test being true will cause a FLIP-FLOP to be used in the synthesis 
            Q_H <= D_H AFTER 1 ns;
        ELSE
            Q_H <= Q_H;
        END IF;

    END PROCESS; -- once we leave the process block the events proposed will be scheduled for occurance in the future.

END behavior;