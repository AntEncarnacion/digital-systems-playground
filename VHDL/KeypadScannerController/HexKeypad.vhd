----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/24/2021 05:23:39 PM
-- Design Name: 
-- Module Name: HexKeypad - Behavioral
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

entity HexKeypad is
  Port ( 
    Col_H : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
    Row_H : OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
  );
end HexKeypad;

architecture Behavioral of HexKeypad is

begin
Row_H(0) => 

end Behavioral;
