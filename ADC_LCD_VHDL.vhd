library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ADC_LCD is
port(Clk   		  :   IN  STD_LOGIC;  
	  iGO   		  :   IN  STD_LOGIC := '0';
     oDIN  		  :   OUT STD_LOGIC;
     oCS_n 		  :   OUT STD_LOGIC;
     oSCLK 		  :   OUT STD_LOGIC;
     iDOUT 		  :   IN  STD_LOGIC;
     iCH   		  :   IN  STD_LOGIC_VECTOR(2 downto 0);	  
	  LCD_RS      :   OUT STD_LOGIC;
     LCD_E       :   OUT STD_LOGIC;	
	  LCD_DataOut :   OUT STD_LOGIC_VECTOR(7 downto 0));
end entity;

architecture ADC_LCD_arc of ADC_LCD is

component LCD_Disp is
port( Clk      	 : IN  STD_LOGIC := '0';
      LCD_RS   	 : OUT STD_LOGIC;
      LCD_E     	: OUT STD_LOGIC;	
      LCD_DataIn  : IN  STD_LOGIC_VECTOR(11 downto 0) := "000000000000";
      WaveSel   	: IN  STD_LOGIC_VECTOR(2 downto 0);
      LCD_DataOut : OUT STD_LOGIC_VECTOR(7 downto 0));
end component;

component ADCModule is
port ( Clk   : IN  STD_LOGIC;
       iGO   : IN  STD_LOGIC := '0';
       oDIN  : OUT STD_LOGIC;
       oCS_n : OUT STD_LOGIC;
       oSCLK : OUT STD_LOGIC;
       iDOUT : IN  STD_LOGIC;
       iCH   : IN  STD_LOGIC_VECTOR(2 downto 0);
       OutCkt: OUT STD_LOGIC_VECTOR(11 downto 0)); 
end component;

signal ADC_Data : STD_LOGIC_VECTOR(11 downto 0);

begin

ADC1 : ADCModule port map(Clk, iGO, oDIN, oCS_n, oSCLK, iDOUT, iCH, ADC_Data);
LCD1 : LCD_Disp  port map(Clk, LCD_RS, LCD_E, ADC_Data, iCH, LCD_DataOut);

end architecture ADC_LCD_arc;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LCD_Disp is
port( Clk      	 : IN  STD_LOGIC := '0';
      LCD_RS   	 : OUT STD_LOGIC;
      LCD_E     	: OUT STD_LOGIC;	
      LCD_DataIn  : IN  STD_LOGIC_VECTOR(11 downto 0) := "000000000000";
      WaveSel   	: IN  STD_LOGIC_VECTOR(2 downto 0);
      LCD_DataOut : OUT STD_LOGIC_VECTOR(7 downto 0));
end entity;

architecture LCD_Disp_arc of LCD_Disp is

constant N : INTEGER := 21;
Type arrayData is array (0 to N) of STD_LOGIC_VECTOR(7 downto 0);

signal Datas: arrayData;
signal TempVal   : INTEGER;
signal TempVal_1 : INTEGER;
signal TempVal_2 : INTEGER;
signal TempVal_3 : INTEGER;
signal TempVal_4 : INTEGER;

begin

--Commands--

Datas(0)  <= X"38";
Datas(1)  <= X"0c";
Datas(2)  <= X"06";
Datas(3)  <= X"80";

--Datas--

Datas(4)  <= x"44";
Datas(5)  <= x"41";
Datas(6)  <= x"54";
Datas(7)  <= x"41";
Datas(8)  <= x"3A";
Datas(9)  <= x"20";

TempVal   <= (3300 * (to_integer(UNSIGNED(LCD_DataIn))))/4095;
TempVal_1 <= (TempVal) mod 10;
TempVal_2 <= (TempVal/10) mod 10;
TempVal_3 <= (TempVal/100) mod 10;
TempVal_4 <= (TempVal/1000);

with (TempVal_1) select
Datas(14) <= x"30" when 0,
             x"31" when 1,
	     x"32" when 2,
	     x"33" when 3,
	     x"34" when 4,
	     x"35" when 5,
	     x"36" when 6,
	     x"37" when 7,
	     x"38" when 8,
	     x"39" when 9,
	     x"30" when others;
				 
with (TempVal_2) select
Datas(13) <= x"30" when 0,
             x"31" when 1,
	     x"32" when 2,
	     x"33" when 3,
	     x"34" when 4,
	     x"35" when 5,
    	     x"36" when 6,
	     x"37" when 7,
	     x"38" when 8,
	     x"39" when 9,
	     x"30" when others;

with (TempVal_3) select
Datas(12) <= x"30" when 0,
             x"31" when 1,
	     x"32" when 2,
	     x"33" when 3,
	     x"34" when 4,
	     x"35" when 5,
    	     x"36" when 6,
	     x"37" when 7,
	     x"38" when 8,
	     x"39" when 9,
	     x"30" when others;

Datas(11) <= x"2E";
				 
with (TempVal_4) select
Datas(10) <= x"30" when 0,
             x"31" when 1,
	     x"32" when 2,
	     x"33" when 3,
	     x"34" when 4,
	     x"35" when 5,
	     x"36" when 6,
	     x"37" when 7,
	     x"38" when 8,
	     x"39" when 9,
	     x"30" when others;
				 
Datas(15) <= x"20";
Datas(16) <= x"56";
Datas(17) <= X"C0"; --Move to Line 2--
Datas(18) <= x"41";
Datas(19) <= x"43";
Datas(20) <= x"48";
							 
with (WaveSel) select
Datas(21) <= x"30" when "000", --0--
             x"31" when "001", --1--
	     x"32" when "010", --2--
	     x"33" when "011", --3--
             x"34" when "100", --4--
 	     x"35" when "101", --5--
             x"36" when "110", --6--
	     x"37" when "111", --7--
	     x"5B" when others;		
	
LCD_proc: process(Clk)
       
       variable i : integer := 0;
       variable j : integer := 0;
       variable k : integer := 0;
     
   begin
       if (Clk'event and Clk = '1') then
          if(i <= 85000) then i := i + 1; LCD_E <= '1'; LCD_DataOut <= DataS(j)(7 downto 0);
          elsif(i > 85000 and i < 160000) then i := i + 1; lcd_e <= '0';
          elsif(i = 160000) then j := j + 1; i := 0;
          end if;

	  if(j < 4) then LCD_RS <= '0';  						  -- Command Signal --
          elsif (j >= 4 and j <= 16) then lcd_rs <= '1';   -- Data Signal -- 
	  elsif (j = 17) then lcd_rs <= '0'; 				  -- Command Signal --
	  elsif (j > 17 and j < 22) then lcd_rs <= '1';    -- Data Signal --
          end if;

	  if(j = 22) then j := 0;                -- Repeat Data Display Routine --
          end if;
       end if;
   end process LCD_proc;

end LCD_Disp_arc;

-- for ADC128S002 Analog to Digital Converter from Analog Devices

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ADCModule is
port ( Clk   : IN  STD_LOGIC;
       iGO   : IN  STD_LOGIC := '0';
       oDIN  : OUT STD_LOGIC;
       oCS_n : OUT STD_LOGIC;
       oSCLK : OUT STD_LOGIC;
       iDOUT : IN  STD_LOGIC;
       iCH   : IN  STD_LOGIC_VECTOR(2 downto 0);
       OutCkt: OUT STD_LOGIC_VECTOR(11 downto 0)); 
end entity;

architecture ADCModule_arc of ADCModule is 

component SPICLK  is 					  -- PLL Module : To be defined externally
port( inclk0 : IN STD_LOGIC  := '0';  -- Main Clock = 50Mhz --
      c0     : OUT STD_LOGIC ;        -- 0 deg. phase w.r.t main clock (2 MHz) --
      c1     : OUT STD_LOGIC );       -- 180 deg. phase w.r.t main clock (2MHz) --
end component;

signal go_en: STD_LOGIC;
signal cont, m_cont: INTEGER;
signal adc_data: STD_LOGIC_VECTOR(11 downto 0);
signal iCLK, iCLK_n: STD_LOGIC;
begin

CLKPLL: SPICLK port map (Clk, iCLK, iCLK_n);  -- Module requires a 2 MHz PLL --
oCS_n  <=  not go_en;

with go_en select
   oSCLK <= iCLK when '1',
            '1'  when '0',
	    '1'  when others;		  

Start_ADC_proc: process(iGO)
  begin
	  if (iGO = '1') then go_en <= '1';
	  else go_en <= '0';
	  end if;
end process Start_ADC_proc;

counter1_proc: process(iCLK, go_en)
begin
	 if(go_en = '0') then cont <= 0;
	 elsif (rising_edge(iCLK)) then 
	   if (cont = 15) then cont <= 0;
		else cont <= cont + 1;
		end if;
	 end if;
end process counter1_proc;

counter2_proc: process(iCLK_n)
begin
	 if(rising_edge(iCLK_n)) then m_cont <= cont;
	 end if;
end process Counter2_proc;

channel_ADC_proc: process(iCLK_n, go_en)
begin
	  if(go_en = '0') then oDIN <=	'0';
	  elsif(rising_edge(iCLK_n)) then
		if (cont = 1) then oDIN	    <=	iCH(2);
		elsif (cont = 2) then oDIN  <=	iCH(1);
		elsif (cont = 3) then oDIN  <=	iCH(0);
		else oDIN <= '0';
		end if;
	  end if;
end process channel_ADC_proc;

output_ADC_proc: process(iCLK, iCLK_n, go_en)
begin
    if(go_en = '0') then adc_data <= "000000000000";
	 elsif(rising_edge(iCLK)) then 
		  if    (m_cont = 3)  then adc_data(11) <= iDOUT;
		  elsif (m_cont = 4)  then adc_data(10) <= iDOUT;
		  elsif (m_cont = 5)  then adc_data(9)  <= iDOUT;
		  elsif (m_cont = 6)  then adc_data(8)  <= iDOUT;
		  elsif (m_cont = 7)  then adc_data(7)  <= iDOUT;
		  elsif (m_cont = 8)  then adc_data(6)  <= iDOUT;
		  elsif (m_cont = 9)  then adc_data(5)  <= iDOUT;
		  elsif (m_cont = 10) then adc_data(4)  <= iDOUT;
		  elsif (m_cont = 11) then adc_data(3)  <= iDOUT;
		  elsif (m_cont = 12) then adc_data(2)  <= iDOUT;
		  elsif (m_cont = 13) then adc_data(1)  <= iDOUT;
		  elsif (m_cont = 14) then adc_data(0)  <= iDOUT;
		  elsif (m_cont = 1)  then OutCkt <= adc_data; 
		  end if;
	 end if;
end process output_ADC_proc;

end ADCModule_arc;
