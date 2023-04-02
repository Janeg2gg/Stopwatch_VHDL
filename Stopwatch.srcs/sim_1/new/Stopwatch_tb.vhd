----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.04.2023 23:43:13
-- Design Name: 
-- Module Name: Stopwatch_tb - Behavioral
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

entity Stopwatch_tb is
--  Port ( );
end Stopwatch_tb;

architecture Behavioral of Stopwatch_tb is

    -- Component declaration for the DUT (Design Under Test)
    component Stopwatch_top
        Port ( clk_i : in STD_LOGIC;
               btn_i : in STD_LOGIC;
               time_o : out STD_LOGIC_VECTOR (23 downto 0));
    end component;

    -- Inputs
    signal clk_i : STD_LOGIC := '0';
    signal btn_i : STD_LOGIC := '0';

    -- Outputs
    signal time_o : STD_LOGIC_VECTOR (23 downto 0);

    -- Clock period definitions
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the DUT
    uut: Stopwatch_top port map (
        clk_i => clk_i,
        btn_i => btn_i,
        time_o => time_o
    );

    -- Clock generation process
    clk_process :process
    begin
        while now < 1000 ns loop  -- simulate for 1000 ns
            clk_i <= '0';
            wait for clk_period / 2;
            clk_i <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Test scenario 1: Start, stop, reset
    btn_process_1 : process
    begin
        -- Start
        btn_i <= '1';
        wait for 100 ns;

        -- Stop
        btn_i <= '0';
        wait for 200 ns;
        
        -- Start
        btn_i <= '1';
        wait for 300 ns;

        -- Stop
        btn_i <= '0';
        wait for 400 ns;

        -- Reset
        btn_i <= '1';
        wait for 500 ns;

        -- Start
        btn_i <= '1';
        wait for 600 ns;

        wait;
    end process;
    
end Behavioral;
