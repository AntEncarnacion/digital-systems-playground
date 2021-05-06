LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY Full_Adder_Four_Bit IS
       PORT (
              A, B : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
              S : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
              Cout : OUT STD_LOGIC
       );
END Full_Adder_Four_Bit;

ARCHITECTURE behavior OF Full_Adder_Four_Bit IS

       COMPONENT Full_Adder
              PORT (
                     X_H : IN STD_LOGIC;
                     Y_H : IN STD_LOGIC;
                     Cin_H : IN STD_LOGIC;
                     Cout_H : OUT STD_LOGIC;
                     S_H : OUT STD_LOGIC
              );
       END COMPONENT;

       SIGNAL c0, c1, c2, c3 : STD_LOGIC := '0';

BEGIN

       FA1 : Full_Adder PORT MAP(
              X_H => A(0),
              Y_H => B(0),
              Cin_H => '0',
              Cout_H => c0,
              S_H => S(0)
       );

       FA2 : Full_Adder PORT MAP(
              X_H => A(1),
              Y_H => B(1),
              Cin_H => c0,
              Cout_H => c1,
              S_H => S(1)
       );

       FA3 : Full_Adder PORT MAP(
              X_H => A(2),
              Y_H => B(2),
              Cin_H => c1,
              Cout_H => c2,
              S_H => S(2)
       );

       FA4 : Full_Adder PORT MAP(
              X_H => A(3),
              Y_H => B(3),
              Cin_H => c2,
              Cout_H => Cout,
              S_H => S(3)
       );
END;