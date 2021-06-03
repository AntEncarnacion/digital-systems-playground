----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/23/2021 06:49:19 PM
-- Design Name: 
-- Module Name: DebouncersSynchronizersLeadingAndTrailingEdge - Behavioral
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

entity DebouncersSynchronizersLeadingAndTrailingEdge is
  Port ( 
  Row_L : IN STD_LOGIC;
  ResetDB_L : IN STD_LOGIC;
  Set_L : IN STD_LOGIC;
  Rst_L : IN STD_LOGIC;
  Clk_H : IN STD_LOGIC;
  SyncLeadRow_H : OUT STD_LOGIC;
  SyncTrailRow_L : OUT STD_LOGIC
  );
end DebouncersSynchronizersLeadingAndTrailingEdge;

architecture Behavioral of DebouncersSynchronizersLeadingAndTrailingEdge is
COMPONENT DFlipFlop IS
   port(
      D_H :in  std_logic;
      Q_H : inout std_logic;    
      myClk_H :in std_logic;   
      Set_L : in STD_LOGIC;     -- Set signal asserted low, it is asynchronous, thus should cause Setting the FF to Q_H =1 when asserted to Low
      Rst_L : in STD_LOGIC    
   );
       END COMPONENT;
       SIGNAL wNAND0, wNAND1, wNOR0, wNOR1, wQ0, wQ1, wQ2, wQ3, notQ0 : STD_LOGIC := '0';
begin
       wNAND0 <= NOT(Row_L AND wNAND1);
       wNAND1 <= NOT(ResetDB_L AND wNAND0);
       wNOR0 <= NOT(Row_L OR wNOR1);
       wNOR1 <= NOT(NOT ResetDB_L OR wNOR0);
       notQ0 <= NOT wQ0;
       
       FF0 : DFlipFlop PORT MAP
       (  
              Set_L => Set_L,
              Rst_L => Rst_L,
              Q_H => wQ0,   
              myClk_H => Clk_H,
              D_H => wNAND0
       );
       FF1 : DFlipFlop PORT MAP
       (
              Set_L => Set_L,
              Rst_L => Rst_L,
              Q_H => wQ1,   
              myClk_H => Clk_H,
              D_H => wQ0
       ); 
       
       FF2 : DFlipFlop PORT MAP
       (
              Set_L => Set_L,
              Rst_L => Rst_L,
              Q_H => wQ2,   
              myClk_H => Clk_H,
              D_H => wNOR0
       );
       FF3 : DFlipFlop PORT MAP
       (
              Set_L => Set_L,
              Rst_L => Rst_L,
              Q_H => wQ3,   
              myClk_H => Clk_H,
              D_H => wQ2
       );   
       
       SyncLeadRow_H <= wQ0 AND wQ1;
       SyncTrailRow_L <= wQ2 OR wQ3;
end Behavioral;
