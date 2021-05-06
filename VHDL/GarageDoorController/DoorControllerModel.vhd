----------------------------------------------------------------------------------
-- Company: Polytechnic University of Puerto Rico
-- Engineer: Othoniel Rodriguez Jimenez
-- 
-- Create Date: 03/12/2020 06:24:38 PM
-- Design Name: Behavioral Design for Garage Door Controller
-- Module Name: DoorControllerModel - Behavioral
-- Project Name: GarageDoorController
-- Target Devices: Spartan 7000 inside an Arty S7 board
-- Tool Versions: Vivado 2017.4
-- Description: the garage door controller will be implemented as a Finite State Machine 
-- thus it will not have a Data Path for storing, moving, or processing data.
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
-- use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DoorControllerModel is
    Port ( AT_H :       in STD_LOGIC;                   -- Input that when asserted high indicates that door is at top
           AB_H :       in STD_LOGIC;                   -- Input that when asserted high indicates that door is at bottom
           PB_IN_H :    in STD_LOGIC;                   -- Input that when asserted high indicates the user has pressed the remote control button
           MotorOnUp_H :    out STD_LOGIC;              -- Output that when asserted high causes the Motor to move the door up-ward
           MotorOnDwn_H :   out STD_LOGIC;              -- Output that when asserted high causes the Motor to move the door down-ward
           Clk_H :      in STD_LOGIC;                   -- every state machine has a clock that loads  the State Flip Flops with the next state value from the next state decoder
           Rst_L :      in STD_LOGIC;                   -- Reset signal that while asserted low will cause the system to move-to and remain-at the initial state.
           PresentState_H : out STD_LOGIC_VECTOR (2 downto 0)  -- Three bit vector that encodes the Present state of FSM controller
           );
end DoorControllerModel;

architecture Behavioral of DoorControllerModel is
-- Declare signals internal to the model and do not go to the outside like those on the Port() declaration
-- The only two signal bundles that do not go to the outside are the PresentState and the NextState
   type state_type is ( st1_DoorOpened, st2_DoorClosed, st3_DoorClosing, st4_DoorOpening, st5_StoppedClosing, st6_StoppedOpening ); 
   -- mnemonic enumeration of states to help you remember the roles of each state
   signal state, next_state : state_type;  -- Declare two state signals for next and present state.

begin -- of architecture

SYNC_PROC: process (Clk_H) -- this vhdl process() models the state flip-flops
   begin
      if ( Clk_H'event AND Clk_H = '1') then -- detects the rising edge of the clock 
         if (Rst_L = '0') then
            state <= st3_DoorClosing after 1 ns; -- default "secure" state that will assure door is not left open after say a power-down, power-up,
         else
            state <= next_state after 1 ns; -- recall next_state is equivalent to the D-inputs of FF, and state is equivalent to the Q-outputs of the state-storage FFs 
         end if;
      end if;
   end process;
----------------------------------------------------------------------------------
   --MOORE State-Machine - Outputs based on state only
   OUTPUT_DECODE: process (state)
   begin
      --insert statements to decode internal output signals
      --below is simple example
      if state = st1_DoorOpened then
        PresentState_H <= "001";
        MotorOnDwn_H <= '0' after 2 ns; -- make sure motor is off
        MotorOnUp_H  <= '0' after 2 ns;
      elsif (state = st2_DoorClosed ) then
        PresentState_H <= "010";
        MotorOnDwn_H <= '0'; -- make sure motor is off
        MotorOnUp_H  <= '0'; 
      elsif (state = st3_DoorClosing) then
        PresentState_H <= "011"; 
        MotorOnDwn_H <= '1'; -- turn ON and downward the motor
        MotorOnUp_H  <= '0'; 
      elsif (state = st4_DoorOpening) then 
        PresentState_H <= "100";
        MotorOnDwn_H <= '0'; 
        MotorOnUp_H  <= '1' ;  -- turn ON  and upward the motor
      elsif (state = st5_StoppedClosing) then 
        PresentState_H <= "101";
        MotorOnDwn_H <= '0'; 
        MotorOnUp_H  <= '0'; 
      elsif (state = st6_StoppedOpening) then 
        PresentState_H <= "110";
        MotorOnDwn_H <= '0'; 
        MotorOnUp_H  <= '0'; 
      end if;
   end process;

------------------------------------------------------------------------------------
   NEXT_STATE_DECODE: process (state, AT_H, AB_H, PB_IN_H) -- This combinational logic functions control de D-inputs of the state FFs, so determine the next state
   begin
      --declare default state for next_state to avoid latches
      next_state <= state;  --default is to stay in current state
      --insert statements to decode or calculate next_state
      case (state) is
         when st1_DoorOpened =>
            if (PB_IN_H = '1') then
               next_state <= st3_DoorClosing after 3 ns;
            else 
                next_state <= St1_DoorOpened after 3 ns;
            end if;
            
         when st2_DoorClosed =>
            if (PB_IN_H = '1') then
                next_state <= St4_DoorOpening after 3 ns;
            else 
                next_state <= St2_DoorClosed after 3 ns;
            end if; 
 -----You should complete the next state calculation from here on....                  
         when st3_DoorClosing =>
            if (PB_IN_H = '1' and AB_H = '0') then
                next_state <= st5_StoppedClosing after 3 ns;
            elsif (PB_IN_H = '0' and AB_H = '1') then
                next_state <= st2_DoorClosed after 3 ns;
            elsif (PB_IN_H = '0' and AB_H = '0') then
                next_state <= st3_DoorClosing after 3 ns;
            end if; 
         when st4_DoorOpening =>
            if (PB_IN_H = '0' and AT_H = '1') then
                next_state <= st1_DoorOpened after 3 ns;
            elsif (PB_IN_H = '0' and AT_H = '0') then
                next_state <= st4_DoorOpening after 3 ns;
            elsif (PB_IN_H = '1' and AT_H = '0') then
                next_state <= st6_StoppedOpening after 3 ns;
            end if;
        when st5_StoppedClosing =>
           if(PB_IN_H = '1') then
                next_state <= st4_DoorOpening after 3 ns; 
           elsif (PB_IN_H = '0') then
                next_state <= st5_StoppedClosing after 3 ns;
            end if;
        when st6_StoppedOpening =>
           if(PB_IN_H = '1') then
                next_state <= st3_DoorClosing after 3 ns; 
           elsif (PB_IN_H = '0') then
                next_state <= st6_StoppedOpening after 3 ns;
            end if;               
        when others =>
                next_state <= st3_DoorClosing after 3 ns; -- default state is closing for security reasons.
             
      end case;
   end process;

end Behavioral;