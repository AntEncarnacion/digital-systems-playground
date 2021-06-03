----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2021 06:02:54 PM
-- Design Name: 
-- Module Name: KeypadScannerController - Behavioral
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

ENTITY KeypadScannerController IS
    PORT (
        ColFlag_H : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        SyncTrailRow_L : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        SyncLeadRow_H : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        Clk_H : IN STD_LOGIC;
        Rst_L : IN STD_LOGIC;
        SetCol_L : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        ASCIICode_H : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        DataValid_H : OUT STD_LOGIC;
        ResetDB_L : OUT STD_LOGIC;
        PresentState_H : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
    );
END KeypadScannerController;

ARCHITECTURE Behavioral OF KeypadScannerController IS
    TYPE state_type IS (st1_ActiveCol1,
        st2_ActiveCol2,
        st3_ActiveCol3,
        st4_ActiveCol4,
        st5_WaitSync1,
        st6_WaitSync2,
        st7_CheckRow1,
        st8_CheckRow2,
        st9_CheckRow3,
        st10_CheckRow4,
        st11_OutputRow1,
        st12_OutputRow2,
        st13_OutputRow3,
        st14_OutputRow4,
        st15_WaitTrailRow1,
        st16_WaitTrailRow2,
        st17_WaitTrailRow3,
        st18_WaitTrailRow4,
        st19_NextCol);
    SIGNAL state, next_state : state_type;
BEGIN -- begin of architecture block
    SYNC_PROC : PROCESS (Clk_H) -- this process models the operation (and will cause the synthesis) of the state FFs,
    BEGIN -- next_state will go to D-inputs and state is the Q-outputs IF (Clk_H'event AND Clk_H = '1') THEN -- detect rising edge of clock
        IF (Rst_L = '0') THEN
            state <= st1_ActiveCol1; -- this is the state we go after a reset, to check if elevators were caught in-transit
        ELSE -- otherwise we load into the state FFs the already planned next state
            state <= next_state;
        END IF;
END PROCESS;
--MOORE State-Machine - Outputs based on state only
OUTPUT_DECODE : PROCESS (state)
BEGIN
    IF state = st1_ActiveCol1 THEN
        PresentState_H <= "00001";
        SetCol_L <= "1110";
        ResetDB_L <= '0';
    ELSIF state = st2_ActiveCol2 THEN
        PresentState_H <= "00010";
        SetCol_L <= "1101";
        ResetDB_L <= '0';
    ELSIF state = st3_ActiveCol3 THEN
        PresentState_H <= "00011";
        SetCol_L <= "1011";
        ResetDB_L <= '0';
    ELSIF state = st4_ActiveCol4 THEN
        PresentState_H <= "00100";
        SetCol_L <= "0111";
        ResetDB_L <= '0';
    ELSIF state = st5_WaitSync1 THEN
        PresentState_H <= "00101";
        SetCol_L <= "1111";
        ResetDB_L <= '1';
    ELSIF state = st6_WaitSync2 THEN
        PresentState_H <= "00110";
        SetCol_L <= "1111";
        ResetDB_L <= '1';
    ELSIF state = st7_CheckRow1 THEN
        PresentState_H <= "00111";
        SetCol_L <= "1111";
        ResetDB_L <= '1';
    ELSIF state = st8_CheckRow2 THEN
        PresentState_H <= "01000";
        SetCol_L <= "1111";
        ResetDB_L <= '1';
    ELSIF state = st9_CheckRow3 THEN
        PresentState_H <= "01001";
        SetCol_L <= "1111";
        ResetDB_L <= '1';
    ELSIF state = st10_CheckRow4 THEN
        PresentState_H <= "01010";
        SetCol_L <= "1111";
        ResetDB_L <= '1';
    ELSIF state = st11_OutputRow1 THEN
        PresentState_H <= "01011";
        SetCol_L <= "1111";
        ResetDB_L <= '1';
    ELSIF state = st12_OutputRow2 THEN
        PresentState_H <= "01100";
        SetCol_L <= "1111";
        ResetDB_L <= '1';
    ELSIF state = st13_OutputRow3 THEN
        PresentState_H <= "01101";
        SetCol_L <= "1111";
        ResetDB_L <= '1';
    ELSIF state = st14_OutputRow4 THEN
        PresentState_H <= "01110";
        SetCol_L <= "1111";
        ResetDB_L <= '1';
    ELSIF state = st15_WaitTrailRow1 THEN
        PresentState_H <= "01111";
        SetCol_L <= "1111";
        ResetDB_L <= '1';
    ELSIF state = st16_WaitTrailRow2 THEN
        PresentState_H <= "10000";
        SetCol_L <= "1111";
        ResetDB_L <= '1';
    ELSIF state = st17_WaitTrailRow3 THEN
        PresentState_H <= "10001";
        SetCol_L <= "1111";
        ResetDB_L <= '1';
    ELSIF state = st18_WaitTrailRow4 THEN
        PresentState_H <= "10010";
        SetCol_L <= "1111";
        ResetDB_L <= '1';
    ELSIF state = st19_NextCol THEN
        PresentState_H <= "10011";
        SetCol_L <= "1111";
        ResetDB_L <= '1';
    END IF;
END PROCESS;

NEXT_STATE_DECODE: process (state, ColFlag_H, SyncTrailRow_L, SyncLeadRow_H, Clk_H, Rst_L) -- This combinational logic functions control de D-inputs of the state FFs, so determine the next state
   begin
      --declare default state for next_state to avoid latches
      next_state <= state;  --default is to stay in current state
      --insert statements to decode or calculate next_state
      case (state) is
         when st1_ActiveCol1 =>
            next_state <= st5_WaitSync1;
         when st2_ActiveCol2 =>
            next_state <= st5_WaitSync1;                 
         when st3_ActiveCol3 =>
            next_state <= st5_WaitSync1;   
         when st4_ActiveCol4 =>
            next_state <= st5_WaitSync1;   
        when st5_WaitSync1 =>
            next_state <= st6_WaitSync2; 
        when st6_WaitSync2 =>
            next_state <= st7_CheckRow1;   
        when st7_CheckRow1 =>
            if SyncLeadRow_H(0) = '0' then
                next_state <= st8_CheckRow2;
            elsif SyncLeadRow_H(0) = '1' then
                next_state <= st11_OutputRow1;
            end if;  
        when st8_CheckRow2 =>
            if SyncLeadRow_H(1) = '0' then
                next_state <= st9_CheckRow3;
            elsif SyncLeadRow_H(1) = '1' then
                next_state <= st12_OutputRow2;
            end if;  
        when st9_CheckRow3 =>
            if SyncLeadRow_H(2) = '0' then
                next_state <= st10_CheckRow4;
            elsif SyncLeadRow_H(2) = '1' then
                next_state <= st13_OutputRow3;
            end if;  
        when st10_CheckRow4 =>
            if SyncLeadRow_H(3) = '0' then
                DataValid_H <= '0';
                ASCIICode_H <= "00000000";
                next_state <= st19_NextCol;
            elsif SyncLeadRow_H(3) = '1' then
                next_state <= st14_OutputRow4;
            end if;  
        when st11_OutputRow1 =>
            if ColFlag_H(0) = '1' then
                ASCIICode_H <= "00011111";
                DataValid_H <= '1';
                next_state <= st15_WaitTrailRow1;
            elsif ColFlag_H(1) = '1' then
                ASCIICode_H <= "00100000";
                DataValid_H <= '1';
                next_state <= st15_WaitTrailRow1;
            elsif ColFlag_H(2) = '1' then
                ASCIICode_H <= "00100001";
                DataValid_H <= '1';
                next_state <= st15_WaitTrailRow1;
            elsif ColFlag_H(3) = '1' then
                ASCIICode_H <= "00101001";
                DataValid_H <= '1';
                next_state <= st15_WaitTrailRow1;
            end if; 
        when st12_OutputRow2 =>
            if ColFlag_H(0) = '1' then
                ASCIICode_H <= "00100010";
                DataValid_H <= '1';
                next_state <= st16_WaitTrailRow2;
            elsif ColFlag_H(1) = '1' then
                ASCIICode_H <= "00100011";
                DataValid_H <= '1';
                next_state <= st16_WaitTrailRow2;
            elsif ColFlag_H(2) = '1' then
                ASCIICode_H <= "00100100";
                DataValid_H <= '1';
                next_state <= st16_WaitTrailRow2;
            elsif ColFlag_H(3) = '1' then
                ASCIICode_H <= "00101010";
                DataValid_H <= '1';
                next_state <= st16_WaitTrailRow2;
            end if; 
        when st13_OutputRow3 =>
            if ColFlag_H(0) = '1' then
                ASCIICode_H <= "00100101";
                DataValid_H <= '1';
                next_state <= st17_WaitTrailRow3;
            elsif ColFlag_H(1) = '1' then
                ASCIICode_H <= "00100110";
                DataValid_H <= '1';
                next_state <= st17_WaitTrailRow3;
            elsif ColFlag_H(2) = '1' then
                ASCIICode_H <= "00100111";
                DataValid_H <= '1';
                next_state <= st17_WaitTrailRow3;
            elsif ColFlag_H(3) = '1' then
                ASCIICode_H <= "00101011";
                DataValid_H <= '1';
                next_state <= st17_WaitTrailRow3;
            end if; 
        when st14_OutputRow4 =>
            if ColFlag_H(0) = '1' then
                ASCIICode_H <= "00011110";
                DataValid_H <= '1';
                next_state <= st18_WaitTrailRow4;
            elsif ColFlag_H(1) = '1' then
                ASCIICode_H <= "00101110";
                DataValid_H <= '1';
                next_state <= st18_WaitTrailRow4;
            elsif ColFlag_H(2) = '1' then
                ASCIICode_H <= "00101101";
                DataValid_H <= '1';
                next_state <= st18_WaitTrailRow4;
            elsif ColFlag_H(3) = '1' then
                ASCIICode_H <= "00101100";
                DataValid_H <= '1';
                next_state <= st18_WaitTrailRow4;
            end if; 
        when st15_WaitTrailRow1 =>
            if SyncTrailRow_L(0) = '0' then
                next_state <= st19_NextCol;
            elsif SyncTrailRow_L(0) = '1' then
                next_state <= st15_WaitTrailRow1;
            end if;  
        when st16_WaitTrailRow2 =>
            if SyncTrailRow_L(1) = '0' then
                next_state <= st19_NextCol;
            elsif SyncTrailRow_L(1) = '1' then
                next_state <= st16_WaitTrailRow2;
            end if;  
        when st17_WaitTrailRow3 =>
            if SyncTrailRow_L(2) = '0' then
                next_state <= st19_NextCol;
            elsif SyncTrailRow_L(2) = '1' then
                next_state <= st17_WaitTrailRow3;
            end if;
        when st18_WaitTrailRow4 =>
            if SyncTrailRow_L(3) = '0' then
                next_state <= st19_NextCol;
            elsif SyncTrailRow_L(3) = '1' then
                next_state <= st18_WaitTrailRow4;
            end if; 
        when st19_NextCol =>
            if ColFlag_H(3) = '1' then
                next_state <= st1_ActiveCol1;
            elsif ColFlag_H(0) = '1' then
                next_state <= st2_ActiveCol2;
            elsif ColFlag_H(1) = '1' then
                next_state <= st3_ActiveCol3;
            elsif ColFlag_H(2) = '1' then
                next_state <= st4_ActiveCol4;
            end if;  
                           
        when others =>
                next_state <= st1_ActiveCol1; -- default state is closing for security reasons.
      end case;
   end process;
END Behavioral;