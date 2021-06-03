----------------------------------------------------------------------------------
-- Company: COE3302-20
-- Engineer: Anthony Y. Encarnacion Torres
-- 
-- Create Date: 05/16/2021 10:31:28 PM
-- Design Name: 
-- Module Name: TB_CondoLoadsController - Behavioral
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

ENTITY TB_CondoLoadsController IS
        --  Port ( );
END TB_CondoLoadsController;

ARCHITECTURE Behavioral OF TB_CondoLoadsController IS
        -- Declare as a component here before the Architecture Begin block the Model Under Test (MUT)
        COMPONENT CondoLoadsControllerWithTimer IS
                PORT (
                        HWL_H : IN STD_LOGIC;
                        LWL_H : IN STD_LOGIC;
                        HPress_H : IN STD_LOGIC;
                        LPress_H : IN STD_LOGIC;
                        Elev_1_Req_H : IN STD_LOGIC;
                        Elev_1_Down_H : IN STD_LOGIC;
                        Elev_2_Req_H : IN STD_LOGIC;
                        Elev_2_Down_H : IN STD_LOGIC;
                        Clk_100_MHz_H : IN STD_LOGIC;
                        Rst_L : IN STD_LOGIC;
                        TimeOut_H : OUT STD_LOGIC;
                        ActivePump_H : OUT STD_LOGIC;
                        ActiveCompressor_H : OUT STD_LOGIC;
                        Elevator1Enable_H : OUT STD_LOGIC;
                        Elevator2Enable_H : OUT STD_LOGIC;
                        TimerEnable_H : INOUT STD_LOGIC;
                        Clk_1_Hz_H : OUT STD_LOGIC;
                        Pump_1_On_H : INOUT STD_LOGIC;
                        Pump_2_On_H : INOUT STD_LOGIC;
                        PresentState_H : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
                );
        END COMPONENT;

        SIGNAL wHWL_H, wLWL_H, wHPress_H, wLPress_H, wElev_1_Req_H, wElev_1_Down_H, wElev_2_Req_H, wElev_2_Down_H, wTimeOut_H, wActivePump_H, wActiveCompressor_H, wElevator1Enable_H, wElevator2Enable_H, wTimerEnable_H : STD_LOGIC := '0'; -- outputs are not initialized
        SIGNAL wRst_L : STD_LOGIC := '0'; -- outputs are not initialized
        SIGNAL wClk_100_MHz_H, wPump_1_On_H, wPump_2_On_H, wClk_1_Hz_H : STD_LOGIC := '0';
        SIGNAL wPresentState_H : STD_LOGIC_VECTOR (3 DOWNTO 0) := "0000";
        CONSTANT CLOCK_PERIOD_1 : TIME := 10 ns;
        CONSTANT CLOCK_PERIOD_2 : TIME := CLOCK_PERIOD_1 * 100000000;
BEGIN
        Controller0 : CondoLoadsControllerWithTimer PORT MAP(-- map associates the model port signals with external wiring signals.
                HWL_H => wHWL_H,
                LWL_H => wLWL_H,
                HPress_H => wHPress_H,
                LPress_H => wLPress_H,
                Elev_1_Req_H => wElev_1_Req_H,
                Elev_1_Down_H => wElev_1_Down_H,
                Elev_2_Req_H => wElev_2_Req_H,
                Elev_2_Down_H => wElev_2_Down_H,
                Clk_100_MHz_H => wClk_100_MHz_H,
                Rst_L => wRst_L,
                TimeOut_H => wTimeOut_H,
                ActivePump_H => wActivePump_H,
                ActiveCompressor_H => wActiveCompressor_H,
                Elevator1Enable_H => wElevator1Enable_H,
                Elevator2Enable_H => wElevator2Enable_H,
                TimerEnable_H => wTimerEnable_H,
                Clk_1_Hz_H => wClk_1_Hz_H,
                Pump_1_On_H => wPump_1_On_H,
                Pump_2_On_H => wPump_2_On_H,
                PresentState_H => wPresentState_H
        );
        sync : PROCESS (wClk_100_MHz_H)
        BEGIN
                wClk_100_MHz_H <= NOT wClk_100_MHz_H AFTER CLOCK_PERIOD_1/2;
        END PROCESS;
        stimulus : PROCESS
        BEGIN
                -- we need to synchronize to the clock the assignment of values to the other input signals 
                WAIT UNTIL (wClk_1_Hz_H'event AND wClk_1_Hz_H = '1');
                -- Test cases that seek to exercise all the FSM transitions.        

                -- Test 0: Verify Controller resets to st11_CheckSafety
                wRst_L <= '0';
                WAIT FOR CLOCK_PERIOD_2; -- again at the next rising edge
                ASSERT (wPresentState_H = "1011") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '0')
                REPORT "Failed to reset to "
                        SEVERITY FAILURE;
                --  Test 1: Holding pattern around st11_CheckSafety
                wRst_L <= '1'; -- remove reset, to allow the FSM to transition depending on the other three inputs
                wElev_1_Down_H <= '0';
                wElev_2_Down_H <= '0';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "1011") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '0')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 2: Transition from st11_CheckSafety to st1_CheckWaterLevel
                WAIT UNTIL (wClk_1_Hz_H'event AND wClk_1_Hz_H = '0');
                wElev_1_Down_H <= '1';
                wElev_2_Down_H <= '1';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "0001") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '0')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 3: Transition from st1_CheckWaterLevel to st2_Pumping
                wLWL_H <= '1';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "0010") AND (wActivePump_H = '1') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '1')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 4: Holding pattern around st2_Pumping
                wHWL_H <= '0';
                wTimeOut_H <= '0';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "0010") AND (wActivePump_H = '1') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '1')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 5: Transition from st2_Pumping to st3_CheckTankPressure
                wHWL_H <= '1';
                wTimeOut_H <= '1';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "0011") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '0')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 6: Transition from st3_CheckTankPressure to st4_Compressing
                wLPress_H <= '1';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "0100") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '1') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '1')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 7: Holding pattern around st4_Compressing
                wHPress_H <= '0';
                wTimeOut_H <= '0';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "0100") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '1') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '1')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 8: Transition from st4_Compressing to st5_CheckElevator1
                wHPress_H <= '1';
                wTimeOut_H <= '1';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "0101") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '0')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 9: Transition from st5_CheckElevator1 to st6_OperateElevator1
                wElev_1_Req_H <= '1';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "0110") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '1') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '1')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 10: Holding pattern around st6_OperateElevator1
                wElev_1_Req_H <= '1';
                wTimeOut_H <= '0';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "0110") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '1') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '1')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 11: Transition from st6_OperateElevator1 to st7_WaitForDown1
                wElev_1_Req_H <= '0';
                wTimeOut_H <= '1';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "0111") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '0')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 12: Holding pattern around st7_WaitForDown1
                wElev_1_Down_H <= '0';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "0111") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '0')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 13: Transition from st7_WaitForDown1 to st8_CheckElevator2
                wElev_1_Down_H <= '1';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "1000") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '0')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 14: Transition from st8_CheckElevator2 to st1_CheckWaterLevel
                wElev_2_Req_H <= '0';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "0001") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '0')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 15: Transition from st1_CheckWaterLevel to st3_CheckTankPressure
                wLWL_H <= '0';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "0011") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '0')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 16: Transition from st3_CheckTankPressure to st5_CheckElevator1
                wLPress_H <= '0';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "0101") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '0')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 17: Transition from st5_CheckElevator1 to st8_CheckElevator2
                wElev_1_Req_H <= '0';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "1000") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '0')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 18: Transition from st8_CheckElevator2 to st9_OperateElevator2
                wElev_2_Req_H <= '1';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "1001") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '1') AND (wTimerEnable_H = '1')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 19: Holding pattern around st9_OperateElevator2
                wElev_2_Req_H <= '1';
                wTimeOut_H <= '0';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "1001") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '1') AND (wTimerEnable_H = '1')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 20: Transition from st9_OperateElevator2 to st10_WaitForDown2
                wElev_2_Req_H <= '0';
                wTimeOut_H <= '1';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "1010") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '0')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 21: Holding pattern around st10_WaitForDown2
                wElev_2_Down_H <= '0';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "1010") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '0')
                REPORT "Failed to "
                        SEVERITY FAILURE;
                --  Test 22: Transition from st10_WaitForDown2 to st1_CheckWaterLevel
                wElev_2_Down_H <= '1';
                WAIT FOR CLOCK_PERIOD_2;
                -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
                ASSERT (wPresentState_H = "0001") AND (wActivePump_H = '0') AND (wActiveCompressor_H = '0') AND (wElevator1Enable_H = '0') AND (wElevator2Enable_H = '0') AND (wTimerEnable_H = '0')
                REPORT "Failed to "
                        SEVERITY FAILURE;
        END PROCESS;

END Behavioral;