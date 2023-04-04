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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Stopwatch_top is
    Port ( clk_i : in STD_LOGIC;
           rst_i : in STD_LOGIC;
           start_stop_button_i : in STD_LOGIC;
           led7_an_o : out STD_LOGIC_VECTOR (3 downto 0);
           led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0));
end Stopwatch_top;

architecture Behavioral of Stopwatch_top is

    signal counter : unsigned(27 downto 0) := (others => '0');
    signal start   : boolean := false;
    signal stopped : boolean := false;
    signal prev_ss : std_logic := '0';
    signal temp : std_logic_vector(6 downto 0) := "0000000";
    signal state : std_logic_vector(6 downto 0) := "0000000";

    constant freq : integer := 100000000; -- clock frequency in Hz

begin

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
            --presing button first time
            if (not start) then
                start   <= true;
                stopped <= false;
            --pressing button  second time
            elsif (start and not stopped) then
                stopped <= true;
            --pressing button third time
            elsif (start and stopped) then
                start   <= false;
                stopped <= false;
                counter <= (others => '0');
            end if;
        end if;
        prev_ss <= start_stop_button_i;
    end process;

    process (counter)
    variable count_ms : integer;
    variable seconds : integer range 0 to 59 := 0;
    variable mili_sec : integer range 0 to 99 := 0;
    begin
        --Initialization of "."
        led7_seg_o <= "00000001";
        led7_an_o <= "1011";
        
        --couter from frequency
        count_ms := to_integer(counter / (freq / 1000));
        mili_sec := count_ms;
        seconds := count_ms * 100;
        
        state <= std_logic_vector(to_unsigned(mili_sec mod 10, 7));
        with state select
        temp <= "0000001" when "0000000",  -- 0
            "1111001" when "0000001",  --1
            "0010010" when "0000010",
            "0000110" when "0000011",
            "1001100" when "0000100",
            "0100100" when "0000101",
            "0100000" when "0000110",
            "0001111" when "0000111",
            "0000000" when "0001000",
            "0000100" when "0001001",  --9
            "1111111" when others;     
        led7_seg_o(7 downto 1) <= temp;
        led7_an_o <= "1110";
        
        state <= std_logic_vector(to_unsigned((mili_sec / 10) mod 10, 7));
        with state select
        temp <= "0000001" when "0000000",  -- 0
            "1111001" when "0000001",  --1
            "0010010" when "0000010",
            "0000110" when "0000011",
            "1001100" when "0000100",
            "0100100" when "0000101",
            "0100000" when "0000110",
            "0001111" when "0000111",
            "0000000" when "0001000",
            "0000100" when "0001001",  --9
            "1111111" when others; 
        led7_seg_o(7 downto 1) <= temp;
        led7_an_o <= "1101";
        
        state <= std_logic_vector(to_unsigned(seconds mod 10 , 7));
        with state select
        temp <= "0000001" when "0000000",  -- 0
            "1111001" when "0000001",  --1
            "0010010" when "0000010",
            "0000110" when "0000011",
            "1001100" when "0000100",
            "0100100" when "0000101",
            "0100000" when "0000110",
            "0001111" when "0000111",
            "0000000" when "0001000",
            "0000100" when "0001001",  --9
            "1111111" when others; 
        led7_seg_o(7 downto 1) <= temp;
        led7_an_o <= "1011";
        
        state <= std_logic_vector(to_unsigned((seconds / 10) mod 10 , 7));
        with state select
        temp <= "0000001" when "0000000",  -- 0
            "1111001" when "0000001",  --1
            "0010010" when "0000010",
            "0000110" when "0000011",
            "1001100" when "0000100",
            "0100100" when "0000101",
            "0100000" when "0000110",
            "0001111" when "0000111",
            "0000000" when "0001000",
            "0000100" when "0001001",  --9
            "1111111" when others; 
        led7_seg_o(7 downto 1) <= temp;
        led7_an_o <= "0111";
        
        if (seconds = 59) and (mili_sec = 99) then
            led7_seg_o <= "00000010";
            led7_an_o <= "0000";
        end if;
    end process;


end Behavioral;
