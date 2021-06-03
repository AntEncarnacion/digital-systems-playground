library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- These two dashes mean that what follows is a comment
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;
library work;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DFlipFlop is
    Port ( D_H : in STD_LOGIC;       -- port declaration defines the signals that will interface the model to the outside world.
           Q_H : inout STD_LOGIC;    -- Signal name, followed by mode (in, out, inout, buf) and followed by signal type
           myClk_H : in STD_LOGIC;   -- clock signal
           Set_L : in STD_LOGIC;     -- Set signal asserted low, it is asynchronous, thus should cause Setting the FF to Q_H =1 when asserted to Low
           Rst_L : in STD_LOGIC  );  -- Reset signal asserted low, is asynchronous, has higher precedence than Set_L 
end DFlipFlop;

architecture Eqn of DFlipFlop is

begin
proc1: process( myClk_H, Set_L, Rst_L)   -- any transition on any of the signals in this  "sensitivity list" will cause entrance into the process
                                         -- simulation time does not advance within a Process block, unless we issue WAIT FOR, WAIT UNTIL, 
                                         -- here it is the only place where we can declare variables for use only within the process block.
    begin                                 
        if ( Rst_L = '0')  -- Reset has precedence over Set_L, note the "=" is a comparison for equality operator that results in a TRUE or FALSE value
        then
            Q_H <= '0' after 1 ns; -- future events on signal Q_H will take effect after the process block is exit
        elsif ( Set_L = '0' )       -- 
        then
            Q_H <= '1' after 1 ns;  -- This assignment statement is no longer concurrent as it was when outside the process, now it is a sequential assignment
                                    -- that only creates an event on the output signal if the flow of control executes that assignment, 
                                    -- and then the event on the output signal will be scheduled on that signal after the process is completed        
        elsif (myClk_H ='1') AND (myClk_H'event) -- detect positive-going edge of clock signal, 'event property true means last event being simulated occured in this signal
        then                                    -- all next assignments after this transition test being true will cause a FLIP-FLOP to be used in the synthesis 
            Q_H <= D_H after 1 ns;
        else 
            Q_H <= Q_H ;
        end if;
        
    End process;  -- once we leave the process block the events proposed will be scheduled for occurance in the future.

end Eqn;

