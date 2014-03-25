module ADC_CTRL (iRST, iCLK, iCLK_n, iGO, iCH, oLED, oDIN, oCS_n, oSCLK, iDOUT, lcd_rs, lcd_e, data1);
			
input	iRST,iCLK, iCLK_n, iGO;
input	[2:0] iCH;
output  [7:0] oLED;
output  oDIN, oCS_n, oSCLK;
input	iDOUT;

reg data, go_en;
wire [2:0] ch_sel;
reg [3:0]  cont;
reg [3:0]  m_cont;
reg [11:0] adc_data;
reg sclk;
integer xval; 
integer xval2; 
reg [7:0] led;

output reg lcd_e, lcd_rs;
output reg [7:0] data1;
integer i = 0;
integer j = 1;
reg [7:0] Datas [1:36];

assign oCS_n  =  ~go_en;
assign oSCLK  =  (go_en)? iCLK:1 ;
assign oDIN   =	 data;
assign ch_sel =	 iCH;
assign oLED   =	 led;

always@(posedge iGO or negedge iRST)
begin
	if(!iRST)
		go_en	<=  0;
	else
	begin
		if(iGO)
		go_en	<=  1;
	end
end

always@(posedge iCLK or negedge go_en)
begin
	if(!go_en)
		cont	<=  0;
	else
	begin
		if(iCLK)
		cont	<=  cont + 1;
	end
end

always@(posedge iCLK_n)
begin
	if(iCLK_n)
		m_cont <= cont;
end

always@(posedge iCLK_n or negedge go_en)
begin
	if(!go_en)
		data	<=  0;
	else
	begin
		if(iCLK_n)
		begin
			if (cont == 2)
				data  <=  iCH[2];
			else if (cont == 3)
				data  <=  iCH[1];
			else if (cont == 4)
				data  <= iCH[0];
			else
				data  <=  0;
		end
	end
end

always@(posedge iCLK or negedge go_en)
begin
	if(!go_en)
	begin
		adc_data  <=	0;
		led	  <=	8'h00;
	end
	else
	begin
		if(iCLK)
		begin
			if (m_cont == 4)
				adc_data[11]	<=	iDOUT;
			else if (m_cont == 5)
				adc_data[10]	<=	iDOUT;
			else if (m_cont == 6)
				adc_data[9]	<=	iDOUT;
			else if (m_cont == 7)
				adc_data[8]	<=	iDOUT;
			else if (m_cont == 8)
				adc_data[7]	<=	iDOUT;
			else if (m_cont == 9)
				adc_data[6]	<=	iDOUT;
			else if (m_cont == 10)
				adc_data[5]	<=	iDOUT;
			else if (m_cont == 11)
				adc_data[4]	<=	iDOUT;
			else if (m_cont == 12)
				adc_data[3]	<=	iDOUT;
			else if (m_cont == 13)
				adc_data[2]	<=	iDOUT;
			else if (m_cont == 14)
				adc_data[1]	<=	iDOUT;
			else if (m_cont == 15)
				adc_data[0]	<=	iDOUT;
			else if (m_cont == 1)
				led     	<=	adc_data[11:4];
		end
	end
end

always @(posedge iCLK) begin


xval2 = adc_data;

Datas[1] = 8'h38;
Datas[2] = 8'h0C;
Datas[3] = 8'h06;
Datas[4] = 8'h01;
Datas[5] = 8'h80;

Datas[6] = 8'h42;
Datas[7] = 8'h3A;
Datas[8] = 8'h20;

if(adc_data[11] == 1)
Datas[9] = 8'h31;
else Datas[9] = 8'h30;

if(adc_data[10] == 1)
Datas[10] = 8'h31;
else Datas[10] = 8'h30;

if(adc_data[9] == 1)
Datas[11] = 8'h31;
else Datas[11] = 8'h30;

if(adc_data[8] == 1)
Datas[12] = 8'h31;
else Datas[12] = 8'h30;

if(adc_data[7] == 1)
Datas[13] = 8'h31;
else Datas[13] = 8'h30;

if(adc_data[6] == 1)
Datas[14] = 8'h31;
else Datas[14] = 8'h30;

if(adc_data[5] == 1)
Datas[15] = 8'h31;
else Datas[15] = 8'h30;

if(adc_data[4] == 1)
Datas[16] = 8'h31;
else Datas[16] = 8'h30;

if(adc_data[3] == 1)
Datas[17] = 8'h31;
else Datas[17] = 8'h30;

if(adc_data[2] == 1)
Datas[18] = 8'h31;
else Datas[18] = 8'h30;

if(adc_data[1] == 1)
Datas[19] = 8'h31;
else Datas[19] = 8'h30;

if(adc_data[0] == 1)
Datas[20] = 8'h31;
else Datas[20] = 8'h30;

Datas[21] = 8'hC0;
Datas[22] = 8'h44;
Datas[23] = 8'h3A;
Datas[24] = 8'h20;

xval = adc_data;

case (xval%10) 
0 : Datas[28] = 8'h30;
1 : Datas[28] = 8'h31;
2 : Datas[28] = 8'h32;
3 : Datas[28] = 8'h33;
4 : Datas[28] = 8'h34;
5 : Datas[28] = 8'h35;
6 : Datas[28] = 8'h36;
7 : Datas[28] = 8'h37;
8 : Datas[28] = 8'h38;
9 : Datas[28] = 8'h39;
endcase;

xval = xval/10;

case (xval%10) 
0 : Datas[27] = 8'h30;
1 : Datas[27] = 8'h31;
2 : Datas[27] = 8'h32;
3 : Datas[27] = 8'h33;
4 : Datas[27] = 8'h34;
5 : Datas[27] = 8'h35;
6 : Datas[27] = 8'h36;
7 : Datas[27] = 8'h37;
8 : Datas[27] = 8'h38;
9 : Datas[27] = 8'h39;
endcase;

xval = xval/10;

case (xval%10) 
0 : Datas[26] = 8'h30;
1 : Datas[26] = 8'h31;
2 : Datas[26] = 8'h32;
3 : Datas[26] = 8'h33;
4 : Datas[26] = 8'h34;
5 : Datas[26] = 8'h35;
6 : Datas[26] = 8'h36;
7 : Datas[26] = 8'h37;
8 : Datas[26] = 8'h38;
9 : Datas[26] = 8'h39;
endcase;

case (xval/10) 
0 : Datas[25] = 8'h30;
1 : Datas[25] = 8'h31;
2 : Datas[25] = 8'h32;
3 : Datas[25] = 8'h33;
4 : Datas[25] = 8'h34;
5 : Datas[25] = 8'h35;
6 : Datas[25] = 8'h36;
7 : Datas[25] = 8'h37;
8 : Datas[25] = 8'h38;
9 : Datas[25] = 8'h39;
endcase;

Datas[29] = 8'h20;
Datas[30] = 8'h56;
Datas[31] = 8'h3A;
Datas[32] = 8'h20;
Datas[34] = 8'h2E;

xval2 = ((xval2 * 330) / 4095);

case (xval2%10)
0 : Datas[36] = 8'h30;
1 : Datas[36] = 8'h31;
2 : Datas[36] = 8'h32;
3 : Datas[36] = 8'h33;
4 : Datas[36] = 8'h34;
5 : Datas[36] = 8'h35;
6 : Datas[36] = 8'h36;
7 : Datas[36] = 8'h37;
8 : Datas[36] = 8'h38;
9 : Datas[36] = 8'h39;
endcase;

xval2 = xval2 / 10;

case (xval2%10)
0 : Datas[35] = 8'h30;
1 : Datas[35] = 8'h31;
2 : Datas[35] = 8'h32;
3 : Datas[35] = 8'h33;
4 : Datas[35] = 8'h34;
5 : Datas[35] = 8'h35;
6 : Datas[35] = 8'h36;
7 : Datas[35] = 8'h37;
8 : Datas[35] = 8'h38;
9 : Datas[35] = 8'h39;
endcase;

case (xval2/10)
0 : Datas[33] = 8'h30;
1 : Datas[33] = 8'h31;
2 : Datas[33] = 8'h32;
3 : Datas[33] = 8'h33;
4 : Datas[33] = 8'h34;
5 : Datas[33] = 8'h35;
6 : Datas[33] = 8'h36;
7 : Datas[33] = 8'h37;
8 : Datas[33] = 8'h38;
9 : Datas[33] = 8'h39;
endcase;

end		
		
always @(posedge iCLK) begin

  if (i <= 10000) begin
  i = i + 1; lcd_e = 1;
  data1 = Datas[j];
  end
  
  else if (i > 10000 & i < 20000) begin
  i = i + 1; lcd_e = 0;
  end
  
  else if (i == 20000) begin
  j = j + 1; i = 0;
  end
  else i = 0;
  
  if (j <= 5) lcd_rs = 0; 
  else if (j > 5 & j< 21) lcd_rs = 1;   
  else if (j == 21) lcd_rs = 0;
  else if (j > 21 & j < 37) lcd_rs = 1;
  else if (j == 37) 
  begin lcd_rs = 1; j = 5;
  end
 
 end

endmodule
