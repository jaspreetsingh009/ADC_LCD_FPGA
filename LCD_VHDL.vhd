library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity LCD_Disp is
port ( clk : in std_logic;   -- Clock input --
       lcd_e : out std_logic;   -- Enable Control --
       lcd_rs : out std_logic;   -- Data/Command Control --
       data   : out std_logic_vector(7 downto 0));  -- Data Line --
end LCD_Disp;
 
architecture LCD_Disp_arc of LCD_Disp is
constant N: integer := 25;
type arr is array (1 to N) of std_logic_vector(7 downto 0);
constant datas : arr := (X"38",X"0c",X"06",X"01",X"80",x"46",x"50",x"47",x"41",x"73",x"20",x"61",x"72",x"65",x"20",x"66",x"75",x"6E",x"21",x"21",x"21",X"C0",x"3A",x"2D",x"29" ); -- Command/Character List --                                           
begin
     proc1: process(clk)
       variable i : integer := 0;
       variable j : integer := 1;
       begin
       if (clk'event and clk = '1') then
          if i <= 1000000 then i := i + 1; lcd_e <= '1'; data <= datas(j)(7 downto 0);
          elsif i > 1000000 and i < 2000000 then i := i + 1; lcd_e <= '0';
          elsif i = 2000000 then j := j + 1; i := 0;
          end if;

			 if j <= 5 then lcd_rs <= '0';   -- Command Signal --
          elsif (j > 5 and j< 22) then lcd_rs <= '1';   --- Data Signal -- 
			 elsif j = 22 then lcd_rs <= '0';
			 elsif j > 22 then lcd_rs <= '1';
          end if;

			 if j = 26 then j := 5; -- Repeat Data Display Routine --
          end if;
       end if;
      end process proc1;
end LCD_Disp_arc;
