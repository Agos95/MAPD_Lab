library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fir is
  generic(N : integer := 24); -- 16
  Port (
     clk   : in  std_logic;
     rst   : in  std_logic;
     x_in  : in  std_logic_vector(N-1 downto 0);
     y_out : out std_logic_vector(N-1 downto 0));
end fir;

architecture rtl of fir is

component flipflop is
  Port( clk    : in std_logic;
        rst    : in std_logic;
        ff_in   : in std_logic_vector(N-1 downto 0);
        ff_out : out std_logic_vector(N-1 downto 0)
        );
end component;

signal C0, C1, C2, C3, C4 : signed(N-1 downto 0);
signal m0, m1, m2, m3, m4 : signed(N-1 downto 0) := (others=> '0');
-- output of the flip flop
signal y_out_01: std_logic_vector(N-1 downto 0):= (others=> '0');   -- signal out of fliflop between C0 and C1 (without multiplication)
signal y_out_12: std_logic_vector(N-1 downto 0):= (others=> '0');   -- signal out of fliflop between C1 and C2 (without multiplication)
signal y_out_23: std_logic_vector(N-1 downto 0):= (others=> '0');   -- signal out of fliflop between C2 and C3 (without multiplication)
signal y_out_34: std_logic_vector(N-1 downto 0):= (others=> '0');   -- signal out of fliflop between C3 and C4 (without multiplication)
--signal x_sum_2N: std_logic_vector(2*N-1 downto 0); -- sum of all signals multiplied by costants
                                                   -- this is 2N bits, becuse it comes from multiplication between two N-bits signals
signal x_sum : std_logic_vector(N-1 downto 0):= (others=> '0');     -- need to reduce x_sum to N bits

begin

-- Coefficients
C0 <= to_signed(1, N);
C1 <= to_signed(2, N);
C2 <= to_signed(3, N);
C3 <= to_signed(4, N);
C4 <= to_signed(5, N);

--flipflops
f01   : flipflop port map (clk => clk, rst => rst, ff_in => x_in, ff_out => y_out_01);
f12   : flipflop port map (clk => clk, rst => rst, ff_in => y_out_01, ff_out => y_out_12);
f23   : flipflop port map (clk => clk, rst => rst, ff_in => y_out_12, ff_out => y_out_23);
f34   : flipflop port map (clk => clk, rst => rst, ff_in => y_out_23, ff_out => y_out_34);
f_end : flipflop port map (clk => clk, rst => rst, ff_in => x_sum, ff_out => y_out);

m0 <= resize(C0*signed(x_in), N);
m1 <= resize(C1*signed(y_out_01), N);
m2 <= resize(C2*signed(y_out_12), N);
m3 <= resize(C3*signed(y_out_23), N);
m4 <= resize(C4*signed(y_out_34), N);

x_sum <= std_logic_vector(m1 + m2 + m3 + m4);

-- x_sum_2N   <= std_logic_vector(C0*signed(x_in) + C1*signed(y_out_01) + C2*signed(y_out_12) + C3*signed(y_out_23) + C4*signed(y_out_34));
-- x_sum <= x_sum_2N(2*N-1 downto N);


end rtl;
