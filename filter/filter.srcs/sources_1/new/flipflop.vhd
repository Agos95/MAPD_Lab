----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/06/2018 10:12:29 AM
-- Design Name: 
-- Module Name: flipflop - Behavioral
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

entity flipflop is
  generic(N : integer := 24);
  Port( clk : in std_logic;
        rst : in std_logic;
        ff_in : in std_logic_vector(N-1 downto 0);
        ff_out : out std_logic_vector(N-1 downto 0)
        ); 
end flipflop;

architecture Behavioral of flipflop is

signal init : std_logic_vector(N-1 downto 0) := (others => '0');

begin

ff_out <= init;

process(clk, rst, ff_in) is
  begin
  if rst = '1' then
    init <= (others => '0');--ff_out <= (others => '0');
  elsif rising_edge(clk) then
    init <= ff_in;--ff_out <= ff_in;
  end if;
end process;

end Behavioral;
