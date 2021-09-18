LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY alu_1bit_test IS
END alu_1bit_test;
ARCHITECTURE behavior OF alu_1bit_test IS
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT alu_1bit
        PORT (
            a : IN STD_LOGIC;
            b : IN STD_LOGIC;
            ci : IN STD_LOGIC;
            less : IN STD_LOGIC;
            binvert : IN STD_LOGIC;
            Op : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            co : OUT STD_LOGIC;
            result : OUT STD_LOGIC
        );
    END COMPONENT;
    --Inputs
    SIGNAL a : STD_LOGIC := '0';
    SIGNAL b : STD_LOGIC := '0';
    SIGNAL ci : STD_LOGIC := '0';
    SIGNAL less : STD_LOGIC := '0';
    SIGNAL binvert : STD_LOGIC := '0';
    SIGNAL Op : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    --Outputs
    SIGNAL co : STD_LOGIC;
    SIGNAL result : STD_LOGIC;
    -- No clocks detected in port list. Replace <clock> below with
    -- appropriate port name
    -- constant <clock>_period : time := 10 ns;
BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : alu_1bit PORT MAP(
        a => a,
        b => b,
        ci => ci,
        less => less,
        binvert => binvert,
        Op => Op,
        co => co,
        result => result
    );
    -- Stimulus process
    stim_proc : PROCESS
    BEGIN
        -- hold reset state for 100 ns.

        -- AND tests:
        binvert <= '0';
        op <= "00";
        ci <= '0';
        ----------------------------
        a <= '0';
        b <= '0';
        WAIT FOR 10 ns;
        a <= '1';
        WAIT FOR 10 ns;
        a <= '0';
        b <= '1';
        WAIT FOR 10 ns;
        a <= '1';
        WAIT FOR 10 ns;
        a <= '0';
        b <= '0';

        -- OR tests:
        binvert <= '0';
        op <= "01";
        ci <= '0';
        ----------------------------
        a <= '0';
        b <= '0';
        WAIT FOR 10 ns;
        a <= '1';
        WAIT FOR 10 ns;
        a <= '0';
        b <= '1';
        WAIT FOR 10 ns;
        a <= '1';
        WAIT FOR 10 ns;
        a <= '0';
        b <= '0';

        -- sum tests:
        binvert <= '0';
        op <= "10";
        ci <= '0';
        ----------------------------
        a <= '0';
        b <= '0';
        WAIT FOR 10 ns;
        a <= '1';
        WAIT FOR 10 ns;
        a <= '0';
        b <= '1';
        WAIT FOR 10 ns;
        a <= '1';
        WAIT FOR 10 ns;
        a <= '0';
        b <= '0';

        -- substraction tests:
        binvert <= '1';
        op <= "10";
        ci <= '1';
        ----------------------------
        a <= '0';
        b <= '0';
        WAIT FOR 10 ns;
        a <= '1';
        WAIT FOR 10 ns;
        a <= '0';
        b <= '1';
        WAIT FOR 10 ns;
        a <= '1';
        WAIT FOR 10 ns;
        a <= '0';
        b <= '0';
        
        -- SLT tests:
        binvert <= '1';
        op <= "11";
        ci <= '0';
        ----------------------------
        a <= '0';
        b <= '0';
        WAIT FOR 10 ns;
        a <= '1';
        WAIT FOR 10 ns;
        a <= '0';
        b <= '1';
        WAIT FOR 10 ns;
        a <= '1';
        WAIT FOR 10 ns;
        
        less <= '1';
        a <= '0';
        b <= '0';
        WAIT FOR 10 ns;
        a <= '1';
        WAIT FOR 10 ns;
        a <= '0';
        b <= '1';
        WAIT FOR 10 ns;
        a <= '1';
        WAIT;

    END PROCESS;
END;