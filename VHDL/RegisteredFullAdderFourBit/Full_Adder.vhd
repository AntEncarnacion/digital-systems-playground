LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

ENTITY Full_Adder IS
    PORT (
        X_H : IN STD_LOGIC;
        Y_H : IN STD_LOGIC;
        Cin_H : IN STD_LOGIC;
        Cout_H : OUT STD_LOGIC;
        S_H : OUT STD_LOGIC);
END Full_Adder;

ARCHITECTURE Behavioral OF Full_Adder IS

BEGIN
    S_H <= (X_H AND NOT Y_H AND NOT Cin_H) OR (NOT X_H AND Y_H AND NOT Cin_H) OR
        (NOT X_H AND NOT Y_H AND Cin_H) OR
        (X_H AND Y_H AND Cin_H) AFTER 2 ns;

    Cout_H <= (X_H AND NOT Y_H AND Cin_H) OR
        (X_H AND Y_H AND NOT Cin_H) OR
        (NOT X_H AND Y_H AND Cin_H) OR
        (X_H AND Y_H AND Cin_H) AFTER 2 ns;

END Behavioral;