----------------------------------------------------------------------------------
-- Company: COE3302-20
-- Engineer: Anthony Y. Encarnacion Torres
-- 
-- Create Date: 05/16/2021 10:25:23 PM
-- Design Name: 
-- Module Name: CondoLoadsController - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY CondoLoadsController IS
   PORT (
      HWL_H : IN STD_LOGIC;
      LWL_H : IN STD_LOGIC;
      HPress_H : IN STD_LOGIC;
      LPress_H : IN STD_LOGIC;
      Elev_1_Req_H : IN STD_LOGIC;
      Elev_1_Down_H : IN STD_LOGIC;
      Elev_2_Req_H : IN STD_LOGIC;
      Elev_2_Down_H : IN STD_LOGIC;
      TimeOut_H : IN STD_LOGIC;
      Clk_H : IN STD_LOGIC;
      Rst_L : IN STD_LOGIC;
      ActivePump_H : OUT STD_LOGIC;
      ActiveCompressor_H : OUT STD_LOGIC;
      Elevator1Enable_H : OUT STD_LOGIC;
      Elevator2Enable_H : OUT STD_LOGIC;
      TimerEnable_H : OUT STD_LOGIC;
      PresentState_H : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
   );
END CondoLoadsController;

ARCHITECTURE Behavioral OF CondoLoadsController IS

   TYPE state_type IS (st1_CheckWaterLevel, st2_Pumping,
      st3_CheckTankPressure, st4_Compressing,
      st5_CheckElevator1, st6_OperateElevator1, st7_WaitForDown1,
      st8_CheckElevator2, st9_OperateElevator2, st10_WaitForDown2,
      st11_CheckSafety
   );

   SIGNAL state, next_state : state_type;

BEGIN -- begin of architecture block

   SYNC_PROC : PROCESS (Clk_H) -- this process models the operation (and will cause the synthesis) of the state FFs, 
   BEGIN -- next_state will go to D-inputs and state is the Q-outputs
      IF (Clk_H'event AND Clk_H = '1') THEN -- detect rising edge of clock 
         IF (Rst_L = '0') THEN
            state <= st11_CheckSafety; -- this is the state we go after a reset, to check if elevators were caught in-transit
         ELSE -- otherwise we load into the state FFs the already planned next state
            state <= next_state;
         END IF;
      END IF;
   END PROCESS;

   --MOORE State-Machine - Outputs based on state only
   OUTPUT_DECODE : PROCESS (state)
   BEGIN

      IF state = st1_CheckWaterLevel THEN -- checking and handling the pump load
         ActivePump_H <= '0';
         ActiveCompressor_H <= '0';
         Elevator1Enable_H <= '0';
         Elevator2Enable_H <= '0';
         TimerEnable_H <= '0';
         PresentState_H <= "0001";
      ELSIF state = st2_Pumping THEN
         ActivePump_H <= '1';
         ActiveCompressor_H <= '0';
         Elevator1Enable_H <= '0';
         Elevator2Enable_H <= '0';
         TimerEnable_H <= '1';
         PresentState_H <= "0010";
      ELSIF state = st3_CheckTankPressure THEN -- checking and handling the compressor load
         ActivePump_H <= '0';
         ActiveCompressor_H <= '0';
         Elevator1Enable_H <= '0';
         Elevator2Enable_H <= '0';
         TimerEnable_H <= '0';
         PresentState_H <= "0011";
      ELSIF state = st4_Compressing THEN
         ActivePump_H <= '0';
         ActiveCompressor_H <= '1';
         Elevator1Enable_H <= '0';
         Elevator2Enable_H <= '0';
         TimerEnable_H <= '1';
         PresentState_H <= "0100";
      ELSIF state = st5_CheckElevator1 THEN
         ActivePump_H <= '0';
         ActiveCompressor_H <= '0';
         Elevator1Enable_H <= '0';
         Elevator2Enable_H <= '0';
         TimerEnable_H <= '0';
         PresentState_H <= "0101";
      ELSIF state = st6_OperateElevator1 THEN
         ActivePump_H <= '0';
         ActiveCompressor_H <= '0';
         Elevator1Enable_H <= '1';
         Elevator2Enable_H <= '0';
         TimerEnable_H <= '1';
         PresentState_H <= "0110";
      ELSIF state = st7_WaitForDown1 THEN
         ActivePump_H <= '0';
         ActiveCompressor_H <= '0';
         Elevator1Enable_H <= '0';
         Elevator2Enable_H <= '0';
         TimerEnable_H <= '0';
         PresentState_H <= "0111";
      ELSIF state = st8_CheckElevator2 THEN
         ActivePump_H <= '0';
         ActiveCompressor_H <= '0';
         Elevator1Enable_H <= '0';
         Elevator2Enable_H <= '0';
         TimerEnable_H <= '0';
         PresentState_H <= "1000";
      ELSIF state = st9_OperateElevator2 THEN
         ActivePump_H <= '0';
         ActiveCompressor_H <= '0';
         Elevator1Enable_H <= '0';
         Elevator2Enable_H <= '1';
         TimerEnable_H <= '1';
         PresentState_H <= "1001";
      ELSIF state = st10_WaitForDown2 THEN
         ActivePump_H <= '0';
         ActiveCompressor_H <= '0';
         Elevator1Enable_H <= '0';
         Elevator2Enable_H <= '0';
         TimerEnable_H <= '0';
         PresentState_H <= "1010";
      ELSIF state = st11_CheckSafety THEN
         ActivePump_H <= '0';
         ActiveCompressor_H <= '0';
         Elevator1Enable_H <= '0';
         Elevator2Enable_H <= '0';
         TimerEnable_H <= '0';
         PresentState_H <= "1011";
      END IF;
   END PROCESS;

   NEXT_STATE_DECODE : PROCESS (state, HWL_H, LWL_H, HPress_H, LPress_H, Elev_1_Req_H, Elev_1_Down_H,
      Elev_2_Req_H, Elev_2_Down_H, TimeOut_H, Rst_L)
   BEGIN
      next_state <= state; --default is to stay in current state

      CASE (state) IS

            --    states that handle the pump load
         WHEN st1_CheckWaterLevel =>
            IF (LWL_H = '1') THEN
               next_state <= st2_Pumping;
            ELSE
               next_state <= st3_CheckTankPressure;
            END IF;
         WHEN st2_Pumping =>
            IF ((HWL_H = '0') AND (TimeOut_H = '0')) THEN
               next_state <= st2_Pumping;
            ELSE
               next_state <= st3_CheckTankPressure;
            END IF;

            -- states that handle the compressor load            
         WHEN st3_CheckTankPressure =>
            IF (LPress_H = '1') THEN
               next_state <= st4_Compressing;
            ELSE
               next_state <= st5_CheckElevator1;
            END IF;

         WHEN st4_Compressing =>
            IF ((HPress_H = '0') AND (TimeOut_H = '0')) THEN
               next_state <= st4_Compressing;
            ELSE -- the else is the opposite of the "if" so no need to write the DeMorgan opposite as "elsif( (HPress_H = '1') OR (TimeOut_H = '1') )"
               next_state <= st5_CheckElevator1;
            END IF;

            -- states that handle the Elevator_1 load               
         WHEN st5_CheckElevator1 =>
            IF (Elev_1_Req_H = '1') THEN
               next_state <= st6_OperateElevator1;
            ELSE
               next_state <= st8_CheckElevator2;
            END IF;
         WHEN st6_OperateElevator1 =>
            IF ((Elev_1_Req_H = '1') AND (TimeOut_H = '0')) THEN
               next_state <= st6_OperateElevator1;
            ELSE -- the else is the opposite of the "if" so no need to write the DeMorgan opposite "elsif( (Elev_1_Req_H = '0') OR (TimeOut_H = '1') )"
               next_state <= st7_WaitForDown1; -- we must wait for Elevator to come all the way Down, to assure its motor is Off, before next Elevator activated
            END IF;
         WHEN st7_WaitForDown1 =>
            IF (Elev_1_Down_H = '0') THEN
               next_state <= st7_WaitForDown1; -- Keep waiting until
            ELSE
               next_state <= st8_CheckElevator2;
            END IF;

            -- states that handle the Elevator_2 load         -- YOU HAVE TO COMPLETE THE REST OF THE FSM
         WHEN st8_CheckElevator2 =>
            IF (Elev_2_Req_H = '1') THEN
               next_state <= st9_OperateElevator2;
            ELSE
               next_state <= st1_CheckWaterLevel;
            END IF;
         WHEN st9_OperateElevator2 =>
            IF ((Elev_2_Req_H = '1') AND (TimeOut_H = '0')) THEN
               next_state <= st9_OperateElevator2;
            ELSE -- the else is the opposite of the "if" so no need to write the DeMorgan opposite "elsif( (Elev_1_Req_H = '0') OR (TimeOut_H = '1') )"
               next_state <= st10_WaitForDown2; -- we must wait for Elevator to come all the way Down, to assure its motor is Off, before next Elevator activated
            END IF;
         WHEN st10_WaitForDown2 =>
            IF (Elev_2_Down_H = '0') THEN
               next_state <= st10_WaitForDown2; -- Keep waiting until
            ELSE
               next_state <= st1_CheckWaterLevel;
            END IF;
            -- state that checks if returning from a power failure that caused the Rst_L to be asserted and 
            -- and an Elevator was caught in-transit when power failed, 
            -- so we must wait until the elevator is brought to a safe landing before continuing to check other loads 
            -- Note that this state is the reset state of the State Flip Flops, 
            -- thus it is synchronously set inside the FF modeling process (see SYNC_PROC above)           
         WHEN st11_CheckSafety =>
            IF ((Elev_1_Down_H = '0') OR (Elev_2_Down_H = '0')) THEN
               next_state <= st11_CheckSafety;
            ELSE
               next_state <= st1_CheckWaterLevel;
            END IF;

            -- because we are only using 11 of the 16 states possible with the minimum number (4)  of state flip-flops, 
            -- the accidental occurrence (perhaps due to metastability, or stuck-at-0, or stuck-at-1 failures) 
            -- of any of the other un-used states is SAFELY directed to the st11_CheckSafety,
            -- this helps to avoid hung states where the FSM might get stuck.       
         WHEN OTHERS =>
            next_state <= st11_CheckSafety;
      END CASE;
   END PROCESS;
END Behavioral;