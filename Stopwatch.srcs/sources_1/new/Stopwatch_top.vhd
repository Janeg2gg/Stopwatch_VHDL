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
    variable count_sec : integer;
    variable seconds : integer range 0 to 59 := 0;
    variable mili_sec : integer range 0 to 59 := 0;
    begin
        count_sec := to_integer(counter / (freq / 1000));
        mili_sec := count_sec;
        seconds := count_sec * 100;
        led7_seg_o <= std_logic_vector(to_unsigned(mili_sec mod 10, 7));
        led7_an_o <= "1110";
        led7_seg_o <= std_logic_vector(to_unsigned((mili_sec / 10) mod 10, 7));
        led7_an_o <= "1101";
        led7_seg_o <= std_logic_vector(to_unsigned(seconds mod 10 , 7));
        led7_an_o <= "1011";
        led7_seg_o <= std_logic_vector(to_unsigned((seconds / 10) mod 10, 7));
        led7_an_o <= "0111";
        
        if (seconds = 59) and (mili_sec = 59) then
            led7_seg_o <= "00000010";
            led7_an_o <= "0000";
        end if;
    end process;


end Behavioral;
