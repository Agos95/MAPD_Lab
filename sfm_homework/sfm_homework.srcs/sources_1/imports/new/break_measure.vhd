library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity break_measure is
  generic(DONE_TIME : integer := 100);
  Port (clk   : in  std_logic;
        rst   : in  std_logic;            
        pulses_in  : in  std_logic; -- Counter input
        count_out  : out unsigned(5 downto 0); -- break time measurement in clock cycles
        done_out   : out std_logic);-- Calculation done
end break_measure;

architecture Behavioral of break_measure is

----------------------------------------------------------
----            WRITE YOUR CODE HERE                  ----
----------------------------------------------------------
signal pulses_p : std_logic;
type state is (s_idle, s_count, s_led); -- idle
                                        -- [falling pulses]
                                        -- counting
                                        -- [rising pulses]
                                        -- led                            
signal state_fsm : state;

begin

p_fsm : process(clk, rst, pulses_in) is
variable cnt : integer;
begin
  if rst = '1' then
    state_fsm <= s_idle;
    cnt := 0;
  elsif rising_edge(clk) then
    pulses_p <= pulses_in;
    case state_fsm is
    when s_idle =>
      if pulses_in = '0' and pulses_p = '1' then  -- simulate falling_edge(pulses_in)
        state_fsm <= s_count;
      else
        state_fsm <= s_idle;
      end if;
      cnt:= 0;
    when s_count =>
      if pulses_in = '1' and pulses_p = '0' then  -- simulate rising_edge(pulses_in)  
        state_fsm <= s_led;
      else
        state_fsm <= s_count;
      end if;
      cnt := cnt + 1;
    when s_led =>
    end case;
  end if;
end process;

end Behavioral;
