----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2021 07:30:19 PM
-- Design Name: 
-- Module Name: TB_KeypadScannerController - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB_KeypadScannerController is
--  Port ( );
end TB_KeypadScannerController;

architecture Behavioral of TB_KeypadScannerController is
COMPONENT Controller is
  Port (
    Row_L : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    Rst_L : IN STD_LOGIC;
    Clk_12_MHz_H : IN STD_LOGIC;
    Clk_1_Hz_H : OUT STD_LOGIC;
    Col_L : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    ASCIICode_H : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    DataValid_H : OUT STD_LOGIC;
    PresentState_H : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
  );
end COMPONENT;
        SIGNAL wRow_L : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
        SIGNAL wCol_L : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
        SIGNAL wASCIICode_H : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
        SIGNAL wClk_12_MHz_H, wClk_1_Hz_H, wDataValid_H, wRst_L : STD_LOGIC := '0';
        SIGNAL wPresentState_H : STD_LOGIC_VECTOR (4 DOWNTO 0) := "00000";
        CONSTANT CLOCK_PERIOD_1 : TIME := 10 ns;
        CONSTANT CLOCK_PERIOD_2 : TIME := CLOCK_PERIOD_1 * 12000000;
begin
Controller0 : Controller PORT MAP (
    Row_L => wRow_L,
    Rst_L => wRst_L,
    Clk_12_MHz_H => wClk_12_MHz_H,
    Clk_1_Hz_H => wClk_1_Hz_H,
    Col_L => wCol_L,
    ASCIICode_H => wASCIICode_H,
    DataValid_H => wDataValid_H,
    PresentState_H => wPresentState_H
    );
        sync : PROCESS (wClk_12_MHz_H)
        BEGIN
                wClk_12_MHz_H <= NOT wClk_12_MHz_H AFTER CLOCK_PERIOD_1/2;
        END PROCESS;
        stimulus : PROCESS
        BEGIN
                -- we need to synchronize to the clock the assignment of values to the other input signals 
                WAIT UNTIL (wClk_1_Hz_H'event AND wClk_1_Hz_H = '1');
                -- Test cases that seek to exercise all the FSM transitions.        

                -- Test 0: Verify Controller resets to 
            wRst_L <= '0';
            WAIT FOR CLOCK_PERIOD_2;
            
            --  Test 1: 
            wRst_L <= '1';
            wRow_L(0) <= '0';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 4;
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 3;
            
            ASSERT (wCol_L = "1110") AND (wDataValid_H = '1') AND (wASCIICode_H = "00011111")
            REPORT "Failed to "
            SEVERITY FAILURE;
            
            -- Test 2: 
            wRow_L(0) <= '0';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 4;
            
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 3;
            
            ASSERT (wCol_L = "1101") AND (wDataValid_H = '1') AND (wASCIICode_H = "00100000")
            REPORT "Failed to "
            SEVERITY FAILURE;
            
            -- Test 3:
            wRow_L(0) <= '0';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 4;
            
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 3;
                        
            ASSERT (wCol_L = "1011") AND (wDataValid_H = '1') AND (wASCIICode_H = "00100001")
            REPORT "Failed to "
            SEVERITY FAILURE;
            
            -- Test 4:
            wRow_L(0) <= '0';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 4;
            
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 3;
                        
            ASSERT (wCol_L = "0111") AND (wDataValid_H = '1') AND (wASCIICode_H = "00101001")
            REPORT "Failed to "
            SEVERITY FAILURE;
            
            --  Test 5:
            wRow_L(0) <= '1';
            wRow_L(1) <= '0';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 5;
            
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 3;
                        
            ASSERT (wCol_L = "1110") AND (wDataValid_H = '1') AND (wASCIICode_H = "00100010")
            REPORT "Failed to "
            SEVERITY FAILURE;
            
            -- Test 6:
            wRow_L(0) <= '1';
            wRow_L(1) <= '0';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 5;
            
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 3;
                        
            ASSERT (wCol_L = "1101") AND (wDataValid_H = '1') AND (wASCIICode_H = "00100011")
            REPORT "Failed to "
            SEVERITY FAILURE;
            
            -- Test 7: 
            wRow_L(0) <= '1';
            wRow_L(1) <= '0';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 5;
            
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 3;
                        
            ASSERT (wCol_L = "1011") AND (wDataValid_H = '1') AND (wASCIICode_H = "00100100")
            REPORT "Failed to "
            SEVERITY FAILURE;
            
            -- Test 8:
            wRow_L(0) <= '1';
            wRow_L(1) <= '0';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 5;
            
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 3;
                        
            ASSERT (wCol_L = "0111") AND (wDataValid_H = '1') AND (wASCIICode_H = "00101010")
            REPORT "Failed to "
            SEVERITY FAILURE;
            
            --  Test 9: 
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '0';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 6;
            
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 3;
                        
            ASSERT (wCol_L = "1110") AND (wDataValid_H = '1') AND (wASCIICode_H = "00100101")
            REPORT "Failed to "
            SEVERITY FAILURE;
            
            -- Test 10:
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '0';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 6;
            
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 3;
                        
            ASSERT (wCol_L = "1101") AND (wDataValid_H = '1') AND (wASCIICode_H = "00100110")
            REPORT "Failed to "
            SEVERITY FAILURE;
            
            -- Test 11:
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '0';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 6;
            
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 3;
                        
            ASSERT (wCol_L = "1011") AND (wDataValid_H = '1') AND (wASCIICode_H = "00100111")
            REPORT "Failed to "
            SEVERITY FAILURE;
            
            -- Test 12:
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '0';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 6;
            
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 3;
                       
            ASSERT (wCol_L = "0111") AND (wDataValid_H = '1') AND (wASCIICode_H = "00101011")
            REPORT "Failed to "
            SEVERITY FAILURE;
            
            --  Test 13:
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '0';
            WAIT FOR CLOCK_PERIOD_2 * 7;
            
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 3;
                        
            ASSERT (wCol_L = "1110") AND (wDataValid_H = '1') AND (wASCIICode_H = "00011110")
            REPORT "Failed to "
            SEVERITY FAILURE;
            
            --Test 14:
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '0';
            WAIT FOR CLOCK_PERIOD_2 * 7;
            
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 3;
                            
            ASSERT (wCol_L = "1101") AND (wDataValid_H = '1') AND (wASCIICode_H = "00101110")
            REPORT "Failed to "
            SEVERITY FAILURE;
                    
            --Test 15:
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '0';
            WAIT FOR CLOCK_PERIOD_2 * 7;
            
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 3;
                           
            ASSERT (wCol_L = "1011") AND (wDataValid_H = '1') AND (wASCIICode_H = "00101101")
            REPORT "Failed to "
            SEVERITY FAILURE;
                     
            --Test 16:
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '0';
            WAIT FOR CLOCK_PERIOD_2 * 7;
            
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 3;
            
            ASSERT (wCol_L = "0111") AND (wDataValid_H = '1') AND (wASCIICode_H = "00101100")
            REPORT "Failed to "
            SEVERITY FAILURE;
            
            --Test 17:
            wRow_L(0) <= '1';
            wRow_L(1) <= '1';
            wRow_L(2) <= '1';
            wRow_L(3) <= '1';
            WAIT FOR CLOCK_PERIOD_2 * 9;

        END PROCESS;

end Behavioral;
