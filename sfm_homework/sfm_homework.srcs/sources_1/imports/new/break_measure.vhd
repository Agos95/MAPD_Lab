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
        pulses_in  : in  std_logic;            -- Counter input
        count_out  : out unsigned(5 downto 0); -- break time measurement in clock cycles
        done_out   : out std_logic);           -- Calculation done
end break_measure;

architecture Behavioral of break_measure is

----------------------------------------------------------
----            WRITE YOUR CODE HERE                  ----
----------------------------------------------------------
COMPONENT ila_1
PORT (
	clk : IN STD_LOGIC;
	probe0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); -- pulses_in
	probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); -- pulses_p
	probe2 : IN STD_LOGIC_VECTOR(5 DOWNTO 0); -- count
	probe3 : IN STD_LOGIC_VECTOR(0 DOWNTO 0); -- done
	probe4 : IN STD_LOGIC_VECTOR(2 DOWNTO 0)  -- state
);
END COMPONENT  ;

signal pulses_p : std_logic;
signal done     : std_logic;
signal count    : unsigned(5 downto 0);
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
      cnt := 0;
      count <= to_unsigned(0, 6);
      done <= '0';
    
    when s_count =>
      if pulses_in = '1' and pulses_p = '0' then  -- simulate rising_edge(pulses_in)  
        state_fsm <= s_led;
      else
        state_fsm <= s_count;
      end if;
      count <= count + 1;
    
    when s_led =>
      if cnt < DONE_TIME - 1 then
        cnt := cnt + 1;
        state_fsm <= s_led;
      else
        state_fsm <= s_idle;
      end if;
      done <= '1';
    
    end case;
    
  end if;
  
end process;

count_out <= count;
done_out  <= done;

ila : ila_1
  PORT MAP (
      clk => clk,  
      probe0(0) => pulses_in, 
      probe1(0) => pulses_p,
      probe2    => std_logic_vector(count),
      probe3(0) => done,
      probe4    => std_logic_vector(to_unsigned(state'pos(state_fsm),3))
  );  

end Behavioral;
