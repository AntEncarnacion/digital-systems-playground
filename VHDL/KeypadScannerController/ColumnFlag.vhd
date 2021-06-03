----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2021 04:55:05 PM
-- Design Name: 
-- Module Name: ColumnFlag - Behavioral
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

entity ColumnFlag is
  Port (
    SetColumn_H : in STD_LOGIC;
    SetColumn2_H : in STD_LOGIC;
    SetColumn3_H : in STD_LOGIC;
    SetColumn4_H : in STD_LOGIC;
    myClk_H : in STD_LOGIC;   -- clock signal
    ColFlag_L : out STD_LOGIC;
    ColFlag_H : out STD_LOGIC
  );
end ColumnFlag;

architecture Behavioral of ColumnFlag is
COMPONENT DFlipFlop IS
   port(
      D_H :in  std_logic;
      Q_H : inout std_logic;    
      myClk_H :in std_logic;   
      Set_L : in STD_LOGIC;     -- Set signal asserted low, it is asynchronous, thus should cause Setting the FF to Q_H =1 when asserted to Low
      Rst_L : in STD_LOGIC    
   );
END COMPONENT;
SIGNAL wColFlag, wRst_L : STD_LOGIC := '0';
begin
       wRst_L <= SetColumn2_H AND SetColumn3_H AND SetColumn4_H;
       FF0 : DFlipFlop PORT MAP
       (  
              Set_L => SetColumn_H,
              Rst_L => wRst_L,
              Q_H => wColFlag,   
              myClk_H => myClk_H,
              D_H => wColFlag
       );
       ColFlag_L <= NOT wColFlag;
       ColFlag_H <= wColFlag;
end Behavioral;
