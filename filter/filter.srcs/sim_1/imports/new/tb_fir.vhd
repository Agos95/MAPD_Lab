----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2018 10:18:50 AM
-- Design Name: 
-- Module Name: tb_fir - Behavioral
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

USE IEEE.STD_LOGIC_UNSIGNED.all;
USE IEEE.NUMERIC_STD.ALL;

--USE std.textio.ALL;
--USE IEEE.STD_LOGIC_TEXTIO.ALL;

--USE IEEE.STD_LOGIC_ARITH.ALL;

entity tb_fir is
--  Port ( );
end tb_fir;

architecture Behavioral of tb_fir is

component fir is
  generic(N : integer := 16);
  Port (
     clk   : in  std_logic;
     rst   : in  std_logic;
     x_in  : in  std_logic_vector(N-1 downto 0);
     y_out : out std_logic_vector(N-1 downto 0));
end component;

signal x_in, y_out: std_logic_vector(15 downto 0);
signal clk, rst   : std_logic;

begin

uut : fir port map(clk => clk, rst => rst, x_in => x_in, y_out => y_out);

p_clk : process
  begin
    clk <= '1'; wait for 5 ns;
    clk <= '0'; wait for 5 ns;
  end process;

p_rst : process
  begin
    rst <= '0'; wait for 500 ns;
--    rst <= '0'; wait for 500 ns;
  end process;

p_in  : process
  begin
    x_in <= std_logic_vector(to_signed(5000, 16)); wait for 25 ns;
  end process;
  

end Behavioral;
