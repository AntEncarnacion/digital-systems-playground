----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2021 07:33:55 PM
-- Design Name: 
-- Module Name: Controller - Behavioral
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

entity Controller is
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
end Controller;

architecture Behavioral of Controller is
COMPONENT KeypadScannerController IS
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
END COMPONENT;
COMPONENT DebouncersSynchronizersLeadingAndTrailingEdge is
  Port ( 
  Row_L : IN STD_LOGIC;
  ResetDB_L : IN STD_LOGIC;
  Set_L : IN STD_LOGIC;
  Rst_L : IN STD_LOGIC;
  Clk_H : IN STD_LOGIC;
  SyncLeadRow_H : OUT STD_LOGIC;
  SyncTrailRow_L : OUT STD_LOGIC
  );
end COMPONENT;
COMPONENT ColumnFlag is
  Port (
    SetColumn_H : in STD_LOGIC;
    SetColumn2_H : in STD_LOGIC;
    SetColumn3_H : in STD_LOGIC;
    SetColumn4_H : in STD_LOGIC;
    myClk_H : in STD_LOGIC;   -- clock signal
    ColFlag_L : out STD_LOGIC;
    ColFlag_H : out STD_LOGIC
  );
end COMPONENT;
COMPONENT ClockScaler is
    Port ( Clk_12_MHz_H : in STD_LOGIC;
              Clk_1_Hz_H : out STD_LOGIC
          );
end COMPONENT;
SIGNAL wColFlag_H, SyncTrailRow_L, wSyncLeadRow_H, wSetCol_L : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL wClk_H, wResetDB_L : STD_LOGIC;
begin
Controller0 : KeypadScannerController PORT MAP (
        ColFlag_H => wColFlag_H,
        SyncTrailRow_L => SyncTrailRow_L,
        SyncLeadRow_H => wSyncLeadRow_H,
        Clk_H => wClk_H,
        Rst_L => Rst_L,
        SetCol_L => wSetCol_L,
        ASCIICode_H => ASCIICode_H,
        DataValid_H => DataValid_H,
        ResetDB_L => wResetDB_L,
        PresentState_H => PresentState_H
    );
    
DBSync0 : DebouncersSynchronizersLeadingAndTrailingEdge PORT MAP (
  Row_L => Row_L(0),
  ResetDB_L => wResetDB_L,
  Set_L => '1',
  Rst_L => Rst_L,
  Clk_H => wClk_H,
  SyncLeadRow_H => wSyncLeadRow_H(0),
  SyncTrailRow_L => SyncTrailRow_L(0)
    );

DBSync1 : DebouncersSynchronizersLeadingAndTrailingEdge PORT MAP (
  Row_L => Row_L(1),
  ResetDB_L => wResetDB_L,
  Set_L => '1',
  Rst_L => Rst_L,
  Clk_H => wClk_H,
  SyncLeadRow_H => wSyncLeadRow_H(1),
  SyncTrailRow_L => SyncTrailRow_L(1)
    );
    
DBSync2 : DebouncersSynchronizersLeadingAndTrailingEdge PORT MAP (
  Row_L => Row_L(2),
  ResetDB_L => wResetDB_L,
  Set_L => '1',
  Rst_L => Rst_L,
  Clk_H => wClk_H,
  SyncLeadRow_H => wSyncLeadRow_H(2),
  SyncTrailRow_L => SyncTrailRow_L(2)
    );

DBSync3 : DebouncersSynchronizersLeadingAndTrailingEdge PORT MAP (
  Row_L => Row_L(3),
  ResetDB_L => wResetDB_L,
  Set_L => '1',
  Rst_L => Rst_L,
  Clk_H => wClk_H,
  SyncLeadRow_H => wSyncLeadRow_H(3),
  SyncTrailRow_L => SyncTrailRow_L(3)
    );
ColumnFlag0 : ColumnFlag PORT MAP (
    SetColumn_H => wSetCol_L(0),
    SetColumn2_H => wSetCol_L(1),
    SetColumn3_H => wSetCol_L(2),
    SetColumn4_H => wSetCol_L(3),
    myClk_H => wClk_H,
    ColFlag_L => Col_L(0),
    ColFlag_H => wColFlag_H(0)
    );

ColumnFlag1 : ColumnFlag PORT MAP (
    SetColumn_H => wSetCol_L(1),
    SetColumn2_H => wSetCol_L(0),
    SetColumn3_H => wSetCol_L(2),
    SetColumn4_H => wSetCol_L(3),
    myClk_H => wClk_H,
    ColFlag_L => Col_L(1),
    ColFlag_H => wColFlag_H(1)
    );

ColumnFlag2 : ColumnFlag PORT MAP (
    SetColumn_H => wSetCol_L(2),
    SetColumn2_H => wSetCol_L(0),
    SetColumn3_H => wSetCol_L(1),
    SetColumn4_H => wSetCol_L(3),
    myClk_H => wClk_H,
    ColFlag_L => Col_L(2),
    ColFlag_H => wColFlag_H(2)
    );
    
ColumnFlag3 : ColumnFlag PORT MAP (
    SetColumn_H => wSetCol_L(3),
    SetColumn2_H => wSetCol_L(0),
    SetColumn3_H => wSetCol_L(1),
    SetColumn4_H => wSetCol_L(2),
    myClk_H => wClk_H,
    ColFlag_L => Col_L(3),
    ColFlag_H => wColFlag_H(3)
    );

ClockScaler0 : ClockScaler PORT MAP (
    Clk_12_MHz_H => Clk_12_MHz_H,
    Clk_1_Hz_H => wClk_H
    );
Clk_1_Hz_H <= wClk_H;
end Behavioral;
