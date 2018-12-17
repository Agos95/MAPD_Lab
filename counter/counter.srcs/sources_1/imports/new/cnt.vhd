----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/22/2018 03:04:31 PM
-- Design Name: 
-- Module Name: adder_4b - rtl
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
use IEEE.NUMERIC_STD.ALL;

entity cnt is
  Port (clk  :   in  std_logic;
        rst  :   in  std_logic;
        sw0  :   in  std_logic;
        sw1  :   in  std_logic;                    
        y_out:   out std_logic_vector(3 downto 0)); 
end cnt;

architecture rtl of cnt is

signal slow_clk, slow_clk_p : std_logic;
signal counter : unsigned (27 downto 0);
signal slow_counter : unsigned (3 downto 0);

begin


p_cnt: process(clk, rst) is
   begin
   if rst = '1' then
      counter <= (others => '0');
   elsif rising_edge(clk) and sw1 = '0' then
      counter <= counter + 1;
   elsif rising_edge(clk) and sw1 = '1' then
      counter <= counter;   
   end if;
end process;

slow_clk <= counter(23); 

p_slw_cnt: process(clk, rst, slow_clk) is
   begin
   if rst = '1' then
      slow_counter <= (others => '0');
   elsif rising_edge(clk) then
      slow_clk_p <= slow_clk;
      if slow_clk = '1' and slow_clk_p = '0' then -- "RISING EDGE"
          if sw0 = '0' then
              slow_counter <= slow_counter + 1;
            else 
              slow_counter <= slow_counter - 1;
            end if;
      end if;
   end if;
end process;

y_out <= std_logic_vector(slow_counter);

end rtl;
