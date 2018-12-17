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
  generic(N : integer := 16); -- 16
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
signal x1: std_logic_vector(N-1 downto 0):= (others=> '0');   -- signal out of fliflop between C0 and C1 (without multiplication)
signal x2: std_logic_vector(N-1 downto 0):= (others=> '0');   -- signal out of fliflop between C1 and C2 (without multiplication)
signal x3: std_logic_vector(N-1 downto 0):= (others=> '0');   -- signal out of fliflop between C2 and C3 (without multiplication)
signal x4: std_logic_vector(N-1 downto 0):= (others=> '0');   -- signal out of fliflop between C3 and C4 (without multiplication)
--signal x_sum_2N: std_logic_vector(2*N-1 downto 0); -- sum of all signals multiplied by costants
                                                   -- this is 2N bits, becuse it comes from multiplication between two N-bits signals
signal x_sum : std_logic_vector(N-1 downto 0):= (others=> '0');     -- need to reduce x_sum to N bits

begin

-- Coefficients
   -- test = [1,2,3,4,5]
   -- low pass = [0.19335315 0.20330353 0.20668665 0.20330353 0.19335315]
C0 <= to_signed(1, N);
C1 <= to_signed(2, N);
C2 <= to_signed(3, N);
C3 <= to_signed(4, N);
C4 <= to_signed(5, N);

--flipflops
f01   : flipflop port map (clk => clk, rst => rst, ff_in => x_in, ff_out => x1);
f12   : flipflop port map (clk => clk, rst => rst, ff_in => x1, ff_out => x2);
f23   : flipflop port map (clk => clk, rst => rst, ff_in => x2, ff_out => x3);
f34   : flipflop port map (clk => clk, rst => rst, ff_in => x3, ff_out => x4);
f_end : flipflop port map (clk => clk, rst => rst, ff_in => x_sum, ff_out => y_out);

m0 <= resize(C0*signed(x_in), N);
m1 <= resize(C1*signed(x1),   N);
m2 <= resize(C2*signed(x2),   N);
m3 <= resize(C3*signed(x3),   N);
m4 <= resize(C4*signed(x4),   N);

x_sum <= std_logic_vector(m0 + m1 + m2 + m3 + m4);

end rtl;
