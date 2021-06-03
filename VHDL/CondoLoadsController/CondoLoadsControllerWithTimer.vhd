----------------------------------------------------------------------------------
-- Company: COE3302-20
-- Engineer: Anthony Y. Encarnacion Torres 
-- 
-- Create Date: 05/17/2021 07:17:33 PM
-- Design Name: 
-- Module Name: CondoLoadsControllerWithTimer - Behavioral
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

ENTITY CondoLoadsControllerWithTimer IS
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
END CondoLoadsControllerWithTimer;

ARCHITECTURE Behavioral OF CondoLoadsControllerWithTimer IS
        COMPONENT CondoLoadsController IS
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
        END COMPONENT;
        COMPONENT ClockScaler100_Mhz_To_1_Hz IS
                PORT (
                        Clk_100_MHz_H : IN STD_LOGIC;
                        Clk_1_Hz_H : OUT STD_LOGIC
                );
        END COMPONENT;
        COMPONENT PumpAlternation IS
                PORT (
                        ActivatePump_H : IN STD_LOGIC;
                        Pump_1_On_H : INOUT STD_LOGIC;
                        Pump_2_On_H : INOUT STD_LOGIC;
                        Rst_L : IN STD_LOGIC
                );
        END COMPONENT;
        COMPONENT Timer256 IS
                PORT (
                        Clk_H : IN STD_LOGIC;
                        TimerEn_H : IN STD_LOGIC; -- timer resets when Enable is 
                        TimeOut_H : OUT STD_LOGIC
                );
        END COMPONENT;
        SIGNAL wTimeOut_H, wClk_H, wActivePump_H, wTimerEnable_H : STD_LOGIC; -- outputs are not initialized
        SIGNAL wRst_L : STD_LOGIC;

BEGIN
        Controller0 : CondoLoadsController PORT MAP(-- map associates the model port signals with external wiring signals.
                HWL_H => HWL_H,
                LWL_H => LWL_H,
                HPress_H => HPress_H,
                LPress_H => LPress_H,
                Elev_1_Req_H => Elev_1_Req_H,
                Elev_1_Down_H => Elev_1_Down_H,
                Elev_2_Req_H => Elev_2_Req_H,
                Elev_2_Down_H => Elev_2_Down_H,
                TimeOut_H => wTimeOut_H,
                Clk_H => wClk_H,
                Rst_L => Rst_L,
                ActivePump_H => wActivePump_H,
                ActiveCompressor_H => ActiveCompressor_H,
                Elevator1Enable_H => Elevator1Enable_H,
                Elevator2Enable_H => Elevator2Enable_H,
                TimerEnable_H => wTimerEnable_H,
                PresentState_H => PresentState_H
        );
        ClockScaler0 : ClockScaler100_Mhz_To_1_Hz PORT MAP(-- map associates the model port signals with external wiring signals.
                Clk_100_MHz_H => Clk_100_MHz_H,
                Clk_1_Hz_H => wClk_H
        );
        Timer0 : Timer256 PORT MAP(
                Clk_H => wClk_H,
                TimerEn_H => wTimerEnable_H,
                TimeOut_H => wTimeOut_H
        );
        Pump0 : PumpAlternation PORT MAP(
                ActivatePump_H => wActivePump_H,
                Pump_1_On_H => Pump_1_On_H,
                Pump_2_On_H => Pump_2_On_H,
                Rst_L => Rst_L
        );

        TimerEnable_H <= wTimerEnable_H;
        ActivePump_H <= wActivePump_H;
        Clk_1_Hz_H <= wClk_H;
        TimeOut_H <= wTimeOut_H;

END Behavioral;