LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
ENTITY alu_1bit IS
    PORT (
        a : IN STD_LOGIC;
        b : IN STD_LOGIC;
        ci : IN STD_LOGIC;
        less : IN STD_LOGIC;
        binvert : IN STD_LOGIC;
        Op : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        co : OUT STD_LOGIC;
        result : OUT STD_LOGIC);
       
END alu_1bit;
ARCHITECTURE Behavioral OF alu_1bit IS
    SIGNAL b_int : STD_LOGIC;
BEGIN
    WITH binvert SELECT
        b_int <= b WHEN '0',
        NOT (b) WHEN '1',
        'X' WHEN OTHERS;
    WITH Op SELECT
        result <= a AND b_int WHEN "00",
        a OR b_int WHEN "01",
        a XOR b_int XOR ci WHEN "10",
        less WHEN "11",
        '0' WHEN OTHERS;
    WITH Op SELECT
        co <= (a AND ci) OR (b_int AND ci) OR (a AND b_int) WHEN "10",
        (a AND ci) OR (b_int AND ci) OR (a AND b_int) WHEN "11",
        '0' WHEN OTHERS;
END Behavioral;