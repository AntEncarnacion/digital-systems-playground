LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY DFF_Five_Bit IS
      PORT (
            D_H : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            Q_H : INOUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            myClk_H : IN STD_LOGIC;
            Set_L : IN STD_LOGIC;
            Rst_L : IN STD_LOGIC);
END DFF_Five_Bit;

ARCHITECTURE behavior OF DFF_Five_Bit IS

      COMPONENT DFF
            PORT (
                  D_H : IN STD_LOGIC;
                  Q_H : INOUT STD_LOGIC;
                  myClk_H : IN STD_LOGIC;
                  Set_L : IN STD_LOGIC;
                  Rst_L : IN STD_LOGIC);
      END COMPONENT;
BEGIN
      FF1 : DFF PORT MAP(
            D_H => D_H(0),
            Q_H => Q_H(0),
            myClk_H => myClk_H,
            Set_L => Set_L,
            Rst_L => Rst_L
      );

      FF2 : DFF PORT MAP(
            D_H => D_H(1),
            Q_H => Q_H(1),
            myClk_H => myClk_H,
            Set_L => Set_L,
            Rst_L => Rst_L
      );

      FF3 : DFF PORT MAP(
            D_H => D_H(2),
            Q_H => Q_H(2),
            myClk_H => myClk_H,
            Set_L => Set_L,
            Rst_L => Rst_L
      );

      FF4 : DFF PORT MAP(
            D_H => D_H(3),
            Q_H => Q_H(3),
            myClk_H => myClk_H,
            Set_L => Set_L,
            Rst_L => Rst_L
      );

      FF5 : DFF PORT MAP(
            D_H => D_H(4),
            Q_H => Q_H(4),
            myClk_H => myClk_H,
            Set_L => Set_L,
            Rst_L => Rst_L
      );

END;