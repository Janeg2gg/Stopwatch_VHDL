----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.04.2023 23:06:08
-- Design Name: 
-- Module Name: Stopwatch_top - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity Stopwatch_top is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           start_stop_button_i : in STD_LOGIC;
           led7_an_o : inout STD_LOGIC_VECTOR (3 downto 0);
           led7_seg_o : inout STD_LOGIC_VECTOR (7 downto 0));
end Stopwatch_top;

architecture Behavioral of Stopwatch_top is

component encoder is
    Port ( digit_i : in  STD_LOGIC_VECTOR (3 downto 0);
           seg_o : out  STD_LOGIC_VECTOR (6 downto 0));
end component;

component  Display_stopwatch is
    Port ( clk_i : in  STD_LOGIC;
           rst_i : in  STD_LOGIC;
           digit_i : in  STD_LOGIC_VECTOR (31 downto 0);
           led7_seg_o : out  STD_LOGIC_VECTOR (7 downto 0);
           led7_an_o : out  STD_LOGIC_VECTOR (3 downto 0));
end component;

    signal counter : unsigned(23 downto 0) := (others => '0');
    signal start   : boolean := false;
    signal stopped : boolean := false;
    signal prev_ss : std_logic := '0';
    signal digits : STD_LOGIC_VECTOR (31 downto 0);
    signal d1,d2,d3,d4 : STD_LOGIC_VECTOR (3 downto 0);

    constant freq : integer := 100000000; -- clock frequency in Hz

begin

dpm: Display_stopwatch port map(
    clk_i => clk_i,
    rst_i => rst_i,
    digit_i => digits,
    led7_an_o => led7_an_o,
    led7_seg_o => led7_seg_o
    );
	
 process (clk_i, rst_i)
    begin
        if (rst_i = '1') then
            counter <= (others => '0');
            start   <= false;
            stopped <= false;
        elsif rising_edge(clk_i) then
            if (start) then
                counter <= counter + 1;
            end if;
        end if;
    end process;

    process (start_stop_button_i)
    begin
        if (start_stop_button_i = '1' and prev_ss = '0') then
            if (not start) then
                start   <= true;
                stopped <= false;
            elsif (start and not stopped) then
                stopped <= true;
            elsif (start and stopped) then
                start   <= false;
                stopped <= false;
            end if;
        end if;
        prev_ss <= start_stop_button_i;
    end process;

    process (counter)
    variable count_ms : integer;
    variable count_s  : integer;
    begin
        count_ms := to_integer(counter / (freq / 1000));
        count_s  := count_ms / 1000;
        count_ms := count_ms mod 1000;
        digits(7 downto 1) <= std_logic_vector(to_unsigned(count_ms mod 10, 7));
        d1 <= "1110";
        digits(15 downto 9) <= std_logic_vector(to_unsigned((count_ms / 10) mod 10, 7));
        d2 <= "1101";
        digits(23 downto 17) <= std_logic_vector(to_unsigned(count_s mod 10, 7));
        d3 <= "1011";
        digits(31 downto 25) <= std_logic_vector(to_unsigned((count_s / 10) mod 6, 7));
        d4 <= "0111";
    end process;

digits(0)<='1'; digits(8)<='1'; digits(16)<='0'; digits(24)<='1';

    d1m: encoder port map(d1,digits(7 downto 1));
	d2m: encoder port map(d2,digits(15 downto 9));
	d3m: encoder port map(d3,digits(23 downto 17));
	d4m: encoder port map(d4,digits(31 downto 25));
	
end Behavioral;














