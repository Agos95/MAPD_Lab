----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/19/2018 09:09:40 AM
-- Design Name: 
-- Module Name: fsm_counter - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm_counter is
  generic(WTIME : integer := 100000000);
  Port (clk   : in  std_logic;
        rst   : in  std_logic;
        sw_in : in  std_logic;
        y_out : out std_logic_vector(2 downto 0) );  -- std_logic_vector ???
end fsm_counter;

architecture Behavioral of fsm_counter is

type state is (s_000, s_001, s_010, s_011, s_100, s_101, s_110, s_111);
signal state_fsm: state;

signal y : std_logic_vector(2 downto 0);

begin

p_fsm : process(clk, rst, sw_in) is 
variable cnt : integer;  -- FPGA internal oscillator frequence = 10 MHz

begin
  if rst = '1' then
     state_fsm <= s_000;
     y <= "000";
     cnt := 0;
  elsif rising_edge(clk) then
    case state_fsm is
    
    when  s_000 =>
      if cnt < WTIME then
        cnt := cnt + 1;
        state_fsm <= s_000;      
      else
        cnt := 0;
        if sw_in = '0' then
          state_fsm <= s_001;
        else
          state_fsm <= s_111;
        end if;
      end if;
      y <= "000";
      
    when  s_001 =>
      if cnt < WTIME then
        cnt := cnt + 1;
        state_fsm <= s_001;      
      else
        cnt := 0;
        if sw_in = '0' then
          state_fsm <= s_010;
        else
          state_fsm <= s_000;
        end if;
      end if;
      y <= "001";
      
    when  s_010 =>
      if cnt < WTIME then
        cnt := cnt + 1;
        state_fsm <= s_010;      
      else
        cnt := 0;
        if sw_in = '0' then
          state_fsm <= s_011;
        else
          state_fsm <= s_001;
        end if;
      end if;
      y <= "010";

    when  s_011 =>
      if cnt < WTIME then
        cnt := cnt + 1;
        state_fsm <= s_011;      
      else
        cnt := 0;
        if sw_in = '0' then
          state_fsm <= s_100;
        else
          state_fsm <= s_010;
        end if;
      end if;
      y <= "010";
      
    when  s_100 =>
        if cnt < WTIME then
          cnt := cnt + 1;
          state_fsm <= s_100;      
        else
          cnt := 0;
          if sw_in = '0' then
            state_fsm <= s_101;
          else
            state_fsm <= s_011;
          end if;
        end if;
        y <= "100";

    when  s_101 =>
        if cnt < WTIME then
          cnt := cnt + 1;
          state_fsm <= s_101;      
        else
          cnt := 0;
          if sw_in = '0' then
            state_fsm <= s_110;
          else
            state_fsm <= s_100;
          end if;
        end if;
        y <= "101";
        
    when  s_110 =>
      if cnt < WTIME then
        cnt := cnt + 1;
        state_fsm <= s_110;      
      else
        cnt := 0;
        if sw_in = '0' then
          state_fsm <= s_111;
        else
          state_fsm <= s_101;
        end if;
      end if;
      y <= "110";

    when  s_111 =>
      if cnt < WTIME then
        cnt := cnt + 1;
        state_fsm <= s_111;      
      else
        cnt := 0;
        if sw_in = '0' then
          state_fsm <= s_000;
        else
          state_fsm <= s_110;
        end if;
      end if;
      y <= "111";

    when others =>
      state_fsm <= s_000;
    end case;
  end if;
end process;

y_out <= y;

end Behavioral;
