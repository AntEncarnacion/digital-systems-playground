----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2020 05:00:14 PM
-- Design Name: Test Bench to Exercise DoorControllerModel
-- Module Name: TB_DoorControllerModel - Behavioral
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

ENTITY TB_DoorControllerModel IS
    --  Port ( );
END TB_DoorControllerModel;

ARCHITECTURE Behavioral OF TB_DoorControllerModel IS
    -- Declare as a component here before the Architecture Begin block the Model Under Test (MUT)
    COMPONENT DoorControllerModel IS
        PORT (
            AT_H : IN STD_LOGIC;
            AB_H : IN STD_LOGIC;
            PB_IN_H : IN STD_LOGIC;
            MotorOnUp_H : OUT STD_LOGIC;
            MotorOnDwn_H : OUT STD_LOGIC;
            Clk_H : IN STD_LOGIC;
            Rst_L : IN STD_LOGIC;
            PresentState_H : OUT STD_LOGIC_VECTOR (2 DOWNTO 0)
        );
    END COMPONENT;

    -- Declare wiring signals to observe the MUT outputs and to drive the MUT inputs 
    SIGNAL wAT_H, wAB_H, wPB_IN_H : STD_LOGIC := '0'; -- initalize inputs   
    SIGNAL wMotorOnUp_H, wMotorOnDwn_H : STD_LOGIC; -- outputs are not initialized
    SIGNAL wClk_H, wRst_L : STD_LOGIC := '0'; -- Note that the controller will be receiving a reset from the beginning.
    SIGNAL wPresentState_H : STD_LOGIC_VECTOR(2 DOWNTO 0); -- outputs are not initialized
    CONSTANT CLOCK_PERIOD : TIME := 20 ns;
    CONSTANT OUTPUT_DECODER_DELAY : TIME := 2 ns;
    CONSTANT NEXT_STATE_DECODER_DELAY : TIME := 2 ns;
    CONSTANT FF_CLK_TO_Q_DELAY : TIME := 1 ns;
BEGIN
    Controller0 : DoorControllerModel PORT MAP(-- map associates the model port signals with external wiring signals.
        AT_H => wAT_H,
        AB_H => wAB_H,
        PB_IN_H => wPB_IN_H,
        MotorOnUp_H => wMotorOnUp_H,
        MotorOnDwn_H => wMotorOnDwn_H,
        Clk_H => wClk_H,
        Rst_L => wRst_L,
        PresentState_H => wPresentState_H
    );
    --- Now once the MUT is wired to the signals we can proceed to assign values to the inputs of the MUT by using the signals wired to the inputs
    -- list of states to be verified
    -- type state_type is ( st1_DoorOpened, st2_DoorClosed, st3_DoorClosing, st4_DoorOpening, st5_StoppedClosing, st6_StoppedOpening ); 
    stimulus : PROCESS -- ( No sensitivity list ), this process will be triggered continuously after each execution of this begin-end block.
    BEGIN
        -- we need to synchronize to the clock the assignment of values to the other input signals 
        WAIT UNTIL rising_edge(wClk_H); -- detect first rising edge of clock 
        WAIT FOR CLOCK_PERIOD; -- again at the next rising edge
        WAIT FOR CLOCK_PERIOD/5; -- let's offset a few ns after the rising clock edge to avoid violation of FF Data set-up or of Data hold  -times. 
        -- Test cases that seek to exercise all the FSM transitions.        

        -- Test 0: Verify Controller resets to the St3_DoorClosing state
        -- Reset must cause transition into st3_DoorClosing, 
        wRst_L <= '0';
        WAIT FOR CLOCK_PERIOD; -- again at the next rising edge
        ASSERT (wPresentState_H = "011") AND (wMotorOnUp_H = '0') AND (wMotorOnDwn_H = '1')
        REPORT "Failed to reset to the St3_DoorClosing state"
            SEVERITY FAILURE;
        --  Test 1: Verify holding pattern around st3, if the AB_H signal is not asserted, and the PB_IN_H signal is not asserted
        wRst_L <= '1'; -- remove reset, to allow the FSM to transition depending on the other three inputs
        wAB_H <= '0';
        wPB_IN_H <= '0'; -- These were already initialized as un-asserted at 0
        WAIT FOR CLOCK_PERIOD; -- because we are already offset by CLOCK_PERIOD/5 from the rising clock edge, 
        -- waiting for an integer number of full clock cycle gets us to the same offset from the rising edge on a future clock period
        ASSERT (wPresentState_H = "011") AND (wMotorOnUp_H = '0') AND (wMotorOnDwn_H = '1')
        REPORT "Failed to remain at St3_DoorClosing state due to PB and AB not asserted OR did not turned-on down the motor"
            SEVERITY FAILURE;
        --  Test 2: Verify transition from ST3_Doorclosing to St5_StoppedClosing
        wAB_H <= '0';
        wAT_H <= '0';
        wPB_IN_H <= '1';
        WAIT FOR CLOCK_PERIOD; -- after this clock period the rising clock edge will have caused the FSM to transition to the state St5_StoppedClosing
        ASSERT (wPresentState_H = "101") AND (wMotorOnUp_H = '0') AND (wMotorOnDwn_H = '0')
        REPORT "Failed to transition to St5_StoppedClosing state due to PB asserted and AB not asserted OR did not turned-off the down motor direction"
            SEVERITY FAILURE;
        --  Test 3: Verify holding pattern around St5_StoppedClosing, if the PB_IN_H signal is not asserted
        wAB_H <= '0';
        wAT_H <= '0';
        wPB_IN_H <= '0';
        WAIT FOR CLOCK_PERIOD; -- 
        ASSERT (wPresentState_H = "101") AND (wMotorOnUp_H = '0') AND (wMotorOnDwn_H = '0')
        REPORT "Failed to remain at St5_StoppedClosing due to PB not asserted OR did not turned-off the motor "
            SEVERITY FAILURE;
        --  Test 4: Verify transition from St5_StoppedClosing to St4_DoorOpening
        wAB_H <= '0';
        wAT_H <= '0';
        wPB_IN_H <= '1';
        WAIT FOR CLOCK_PERIOD; -- 
        ASSERT (wPresentState_H = "100") AND (wMotorOnUp_H = '1') AND (wMotorOnDwn_H = '0')
        REPORT "Failed to transition to St4_DoorOpening due to PB assertion or  failed to turn on the upward motor signal "
            SEVERITY FAILURE;
        --  Test 5: Verify transition from St4_DoorOppening to St1_DoorOpened
        wAB_H <= '0';
        wAT_H <= '1';
        wPB_IN_H <= '0';
        WAIT FOR CLOCK_PERIOD; -- 
        ASSERT (wPresentState_H = "001") AND (wMotorOnUp_H = '0') AND (wMotorOnDwn_H = '0')
        REPORT "Failed to transition to st1_DoorOpened due to reaching the Top or failed to turn off the motor signals "
            SEVERITY FAILURE;
        --  Test 6: Verify holding pattern around St1_DoorOpened
        wAB_H <= '0';
        wAT_H <= '1';
        wPB_IN_H <= '0';
        WAIT FOR CLOCK_PERIOD; -- 
        ASSERT (wPresentState_H = "001") AND (wMotorOnUp_H = '0') AND (wMotorOnDwn_H = '0')
        REPORT "Failed to remain in st1_DoorOpened due to PB not asserted, or failed to keep motor off "
            SEVERITY FAILURE;
        --  Test 7: Verify transition from St1_DoorOpened to st3_DoorClosing
        wAB_H <= '0';
        wAT_H <= '0';
        wPB_IN_H <= '1';
        WAIT FOR CLOCK_PERIOD; -- 
        ASSERT (wPresentState_H = "011") AND (wMotorOnUp_H = '0') AND (wMotorOnDwn_H = '1')
        REPORT "Failed to transition to St3_DoorOpening or failed to assert motor down control signal"
            SEVERITY FAILURE;
        -- Please complet the seven remain test of transitions
        --  Test 8: 
        wAB_H <= '1';
        wAT_H <= '0';
        wPB_IN_H <= '0';
        WAIT FOR CLOCK_PERIOD; -- 
        ASSERT (wPresentState_H = "010") AND (wMotorOnUp_H = '0') AND (wMotorOnDwn_H = '0')
        REPORT "Failed to transition to "
            SEVERITY FAILURE;
        --  Test 9: 
        wAB_H <= '1'; wAT_H <= '0'; wPB_IN_H <= '0';
        wait for CLOCK_PERIOD;
        assert (wPresentState_H = "010") AND (wMotorOnUp_H = '0') AND (wMotorOnDwn_H = '0')
        report "Failed to " 
            severity FAILURE;
        --  Test 10:
        wAB_H <= '0';
        wAT_H <= '0';
        wPB_IN_H <= '1';
        WAIT FOR CLOCK_PERIOD; -- 
        ASSERT (wPresentState_H = "100") AND (wMotorOnUp_H = '1') AND (wMotorOnDwn_H = '0')
        REPORT "Failed to transition to "
            SEVERITY FAILURE;
        --  Test 11:
        wAB_H <= '0';
        wAT_H <= '0';
        wPB_IN_H <= '0';
        WAIT FOR CLOCK_PERIOD; -- 
        ASSERT (wPresentState_H = "100") AND (wMotorOnUp_H = '1') AND (wMotorOnDwn_H = '0')
        REPORT "Failed to transition to "
            SEVERITY FAILURE;
        -- TEST 12:
        wAB_H <= '0'; wAT_H <= '0'; wPB_IN_H <= '1';
        wait for CLOCK_PERIOD;
        assert (wPresentState_H = "110") AND (wMotorOnUp_H = '0') AND (wMotorOnDwn_H = '0')
        report "Failed to transition to st6_StoppedOpening" 
            severity FAILURE;
        -- TEST 13:
        wAB_H <= '0'; wAT_H <= '0'; wPB_IN_H <= '0';
        wait for CLOCK_PERIOD;
        assert (wPresentState_H = "110") AND (wMotorOnUp_H = '0') AND (wMotorOnDwn_H = '0')
        report "Failed to transition to st6_StoppedOpening" 
            severity FAILURE;
        -- TEST 14:
        wAB_H <= '0'; wAT_H <= '0'; wPB_IN_H <= '1';
        wait for CLOCK_PERIOD;
        assert (wPresentState_H = "011") AND (wMotorOnUp_H = '0') AND (wMotorOnDwn_H = '1')
        report "Failed to transition to st3_DoorClosing" 
            severity FAILURE;
        


    END PROCESS; -- end of stimulus  process

    clock : PROCESS (wClk_H) -- simulates a clock oscillator thar runs continously...
    BEGIN
        wClk_H <= NOT wClk_H AFTER CLOCK_PERIOD/2; -- program a future event on the clock when we leave this process
    END PROCESS;
END Behavioral;