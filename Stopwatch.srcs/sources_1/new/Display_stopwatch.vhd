----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.04.2023 00:09:39
-- Design Name: 
-- Module Name: Display_stopwatch - Behavioral
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Display_stopwatch is
    Port ( 
            clk_i : in STD_LOGIC;
            rst_i : in STD_LOGIC;
            digit_i : in STD_LOGIC_VECTOR (31 downto 0);
            led7_an_o : out STD_LOGIC_VECTOR (3 downto 0);
            led7_seg_o : out STD_LOGIC_VECTOR (7 downto 0)
        );
end Display_stopwatch ;

architecture Behavioral of Display_stopwatch  is

    signal temp : std_logic_vector (3 downto 0);

begin

process(clk_i,rst_i)
begin

    if(rst_i = '1') then
        temp <= "0000";   
        led7_seg_o <= "00000000";   
    elsif rising_edge (clk_i) then
        case temp is
            when "1110" => temp <= "1101"; led7_seg_o <= digit_i(15 downto 8);
            when "1101" => temp <= "1011"; led7_seg_o <= digit_i(23 downto 16);
            when "1011" => temp <= "0111"; led7_seg_o <= digit_i(31 downto 24);
            when others => temp <= "1110"; led7_seg_o <= digit_i(7 downto 0); 
        end case;
    end if;
    
end process;

led7_an_o <= temp;

end Behavioral;
