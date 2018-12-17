library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity top is
  Port (clk  :       in  std_logic;
        rst  :       in  std_logic;                     -- CONNECT TO BTN0
        up_down_in : in  std_logic;                     -- CONNECT TO SW0   
        y_out:       out std_logic_vector(3 downto 0)); -- CONNECT TO LD3, LD2, LD1, LD0
end top;

architecture rtl of top is

--debug components
COMPONENT vio_0
  PORT (
    clk : IN STD_LOGIC;
    probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_out1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_out2 : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
  );
END COMPONENT;

COMPONENT ila_0
PORT (
	clk : IN STD_LOGIC;
	probe0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	probe1 : IN STD_LOGIC_VECTOR(3 DOWNTO 0)
);
END COMPONENT  ;

--debug signals
signal vio_rst, vio_up_down : std_logic;
signal vio_slow_counter : std_logic_vector (3 downto 0);

signal ila_up_down : std_logic;
signal ila_y : std_logic_vector (3 downto 0);

--signals
signal slow_clk, slow_clk_p : std_logic;
signal counter : unsigned (27 downto 0);
signal slow_counter : unsigned (3 downto 0);

begin

p_cnt: process(clk, vio_rst) is
   begin
   if vio_rst = '1' then
      counter <= (others => '0');
   elsif rising_edge(clk) then
      counter <= counter + 1;
   end if;
end process;

slow_clk <= counter(3); 

p_slw_cnt: process(clk, vio_rst, slow_clk) is
   begin
   if vio_rst = '1' then
      slow_counter <= unsigned( vio_slow_counter );
   elsif rising_edge(clk) then
      slow_clk_p <= slow_clk;
      if slow_clk = '1' and slow_clk_p = '0' then -- "RISING EDGE"
          if vio_up_down = '0' then
             slow_counter <= slow_counter + 1;
          else
             slow_counter <= slow_counter - 1;
          end if;   
      end if;
   end if;
end process;

y_out <= std_logic_vector(slow_counter);

ila_up_down <= vio_up_down;
ila_y <= std_logic_vector(slow_counter);

--DEBUG
vio0 : vio_0
  PORT MAP (
    clk => clk,
    probe_out0(0) => vio_rst,
    probe_out1(0) => vio_up_down,
    probe_out2    => vio_slow_counter
  );
  
ila0 : ila_0
  PORT MAP (
      clk => clk,  
      probe0(0) => ila_up_down,
      probe1    => ila_y
  );

end rtl;
