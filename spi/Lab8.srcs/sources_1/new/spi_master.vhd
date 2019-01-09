library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity spi_master is
   generic (
      WTIME    : integer   := 100;
      TXBITS   : integer   := 16;
      RXBITS   : integer   := 8
      );
   port ( 
      clock    : in  std_logic;
      reset    : in  std_logic;
      txd      : in  std_logic_vector(TXBITS-1 downto 0);
      rxd      : out std_logic_vector(RXBITS-1 downto 0);
      start    : in  std_logic;
      ready    : out std_logic;
      miso     : in  std_logic;
      mosi     : out std_logic;
      sclk     : out std_logic;
      cs       : out std_logic
      );
end spi_master;

architecture Behavioral of spi_master is

----------------------------------------
------  WRITE YOUR CODE HERE  ----------
----------------------------------------

-- states:
-- 1) send
-- 2) receive
-- 3) idle
type state is (s_send, s_receive, s_idle);

signal state_fsm : state;
   
begin

----------------------------------------
------  WRITE YOUR CODE HERE  ----------
-- and delete the following 3 lines  ---
----------------------------------------   
--cs <= '1'; 
--sclk <= '0';
--mosi <= miso; 
if reset = '1' then
  state_fsm <= s_idle;
elsif ??? then

    case state_fsm is
    
        when s_idle =>
          if falling_edge(cs) then
            state_fsm <= s_send;
          
          end if;
        
           
    
        when s_send =>
          tcnt := tcnt + 1;
          if tcnt = 1 then
            sclk_s <= '0';
            mosi_s <= bufout(wcnt);
          elsif tcnt = WTIME / 2 then
            sclk_s <= '1';
          elsif tcnt = WTIME then
            tcnt := 0;
            sclk_s <= '0';
            if wcnt = 0 then
              wcnt := TXBITS - 1;
              mosi_s <= '1';
            else 
              wcnt := wcnt - 1;
            end if;
          end if;
          
    end case;
end if;

end Behavioral;

