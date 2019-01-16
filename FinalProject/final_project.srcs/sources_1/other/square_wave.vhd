library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity square_wave is
  generic( PERIOD      : integer := 20; -- in number of clock cycles
           DUTY_CYC    : integer := 50; -- in number of clock cycles
           SAMPLE_N    : integer := 1024
  );
  Port (clk        : in  std_logic;  
        rst        : in  std_logic; 
        en_gen_in  : in  std_logic;                       -- start signal
        we_out     : out std_logic;                       -- write enable for the dpram
        address_out: out std_logic_vector(9 downto 0);    -- address for the dpram 
        y_out      : out std_logic_vector(31 downto 0));  -- data to write in the dpram
end square_wave;

architecture Behavioral of square_wave is

signal y : std_logic_vector(31 downto 0);

type state is (s_idle, s_high, s_low);
signal state_fsm: state;

-- HIGH LOGIC LEVEL
-- y <= std_logic_vector(to_signed(1024 , y'length)); 

-- LOW LOGIC LEVEL
-- y <= std_logic_vector(to_signed(-1024, y'length));


begin

p_fsm : process(clk, rst, en_gen_in) is 
  variable cnt, t : integer;
  begin
    if rst = '1' then
       state_fsm <= s_idle;
       y <= (others => '0');
       cnt := 0;
       t := 0;
    elsif rising_edge(clk) then
      case state_fsm is
      
      when s_idle =>
        if t < PERIOD*DUTY_CYC/100 then -- T_clock ???
          state_fsm <= s_high;
        else
          state_fsm <= s_low;
        end if;
        
      when s_high =>
        if cnt < SAMPLE_N then
          y <= std_logic_vector(to_signed(1024 , y'length));
          cnt := cnt + 1;
        else
          cnt := 0;
          t := t + 1;
          state_fsm <= s_idle;
        end if;  
        
      when s_low =>
        if cnt < SAMPLE_N then
          y <= std_logic_vector(to_signed(-1024 , y'length));
          cnt := cnt + 1;
        else
          cnt := 0;
          t := t + 1;
          state_fsm <= s_idle;
        end if;
          
      end case;
      
    end if;

  y_out <= y;

end process;
end Behavioral;
