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

signal C0, C1, C2, C3, C4 : signed(N-1 downto 0);                             -- multiplication coefficients
signal m0, m1, m2, m3, m4 : signed(N-1 downto 0) := (others=> '0');           -- results after multiplications
signal x1, x2, x3, x4     : std_logic_vector(N-1 downto 0):= (others=> '0');  -- signal out of fliflops (before C1, C2, C3, C4)
signal x_sum              : std_logic_vector(N-1 downto 0):= (others=> '0');  -- sum of signals before last flipflop

begin

-- Coefficients
   -- test = [1,2,3,4,5]
   -- low pass = [0.19335315 0.20330353 0.20668665 0.20330353 0.19335315]
   -- shift = "2^10"
C0 <= to_signed(1993*(2**10)/10000, N);
C1 <= to_signed(2033*(2**10)/10000, N);
C2 <= to_signed(2066*(2**10)/10000, N);
C3 <= to_signed(2033*(2**10)/10000, N);
C4 <= to_signed(1933*(2**10)/10000, N);

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

x_sum <= std_logic_vector(shift_right(m0 + m1 + m2 + m3 + m4, 10));

end rtl;
