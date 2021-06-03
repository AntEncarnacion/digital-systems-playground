----------------------------------------------------------------------------------
-- Company: COE3302-20
-- Engineer: Anthony Y. Encarnacion Torres
-- 
-- Create Date: 09/26/2019 05:37:37 PM
-- Design Name: 
-- Module Name: FourBitBinaryCounter - Behavioral
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
LIBRARY IEEE; -- IEEE library
USE IEEE.STD_LOGIC_1164.ALL; -- std logic package
USE IEEE.std_logic_arith.ALL; -- provides the func to convert integer to standard logic vector.
USE IEEE.std_logic_signed.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
ENTITY FourBitBinaryCounter IS
	PORT (
		T_H : IN STD_LOGIC; -- Carry in from previous counter stage
		P_H : IN STD_LOGIC; -- Counter Enable 
		Q_H : INOUT STD_LOGIC_VECTOR (3 DOWNTO 0); -- Counter count bit
		D_H : IN STD_LOGIC_VECTOR (3 DOWNTO 0); -- value to be loaded 
		COUT_H : OUT STD_LOGIC; -- Carry out asserted hight
		RST_L : IN STD_LOGIC; -- Reset asserted low
		LD_H : IN STD_LOGIC; -- load an initial count into the counter when high
		CLK_H : IN STD_LOGIC); -- positive going edge clock
END FourBitBinaryCounter;

ARCHITECTURE Behavioral OF FourBitBinaryCounter IS
	SIGNAL Q_Internal : INTEGER; -- Q is the counter register holding the count value

BEGIN -- begin of architecture block

	Q_H <= CONV_STD_LOGIC_VECTOR(Q_Internal, 4); -- convert the counter value to StdLV and send to output

	Cout_H <= Q_H(3) AND Q_H(2) AND Q_H(1) AND Q_H(0) AND T_H; -- carry out depends on carry-in and count

	PROCESS (Clk_H, RST_L, LD_H, P_H, T_H)
	BEGIN
		IF Clk_H'event AND Clk_H = '1' THEN -- change state on rising edge
			IF RST_L = '0' THEN
				Q_Internal <= 0;
			ELSIF LD_H = '1' THEN
				Q_Internal <= CONV_INTEGER(D_H); -- needs conversion
			ELSIF (P_H AND T_H) = '1' THEN
				Q_Internal <= Q_Internal + 1 AFTER 3 ns;
			END IF;
		END IF;
	END PROCESS;

END Behavioral;