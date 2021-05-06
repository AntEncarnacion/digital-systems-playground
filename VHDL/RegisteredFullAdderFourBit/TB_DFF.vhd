----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2021 09:32:13 PM
-- Design Name: 
-- Module Name: TB_DFF - Behavioral
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

entity TB_DFF is
--  Port ( );
end TB_DFF;

architecture Behavioral of TB_DFF is

    COMPONENT DFF IS
    PORT (
        D_H : IN STD_LOGIC; -- port declaration defines the signals that will interface the model to the outside world.
        Q_H : INOUT STD_LOGIC; -- Signal name, followed by mode (in, out, inout, buf) and followed by signal type
        myClk_H : IN STD_LOGIC; -- clock signal
        Set_L : IN STD_LOGIC; -- Set signal asserted low, it is asynchronous, thus should cause Setting the FF to Q_H =1 when asserted to Low
        Rst_L : IN STD_LOGIC);
    END COMPONENT;

    SIGNAL D, CLK, RST, Q, Set: STD_LOGIC;
begin
    uut : DFF PORT MAP(
        D_H => D,
        myClk_H => CLK,
        Rst_L => RST,
        Q_H => Q,
        Set_L => Set);

    Clock : PROCESS
    BEGIN
        CLK <= '0';
        WAIT FOR 10 ns;
        CLK <= '1';
        WAIT FOR 10 ns;
    END PROCESS;

    stim : PROCESS
    BEGIN

        RST <= '1';
        Set <= '1';
        D <= '0';
        WAIT FOR 40 ns;
        D <= '1';
        WAIT FOR 40 ns;

    END PROCESS;

end Behavioral;
