module LCD_DISPLAY(clk, lcd_e, lcd_rs, data);
input clk;
output reg lcd_e, lcd_rs;
output reg [7:0] data;
integer i = 0;
integer j = 1;

reg [7:0] Datas [1:25];
		
always @(posedge clk) begin
Datas[1] = 8'h38;
Datas[2] = 8'h0C;
Datas[3] = 8'h06;
Datas[4] = 8'h01;
Datas[5] = 8'h80;
Datas[6] = 8'h46;
Datas[7] = 8'h50;

Datas[8] = 8'h47;
Datas[9] = 8'h41;
Datas[10] = 8'h73;
Datas[11] = 8'h20;
Datas[12] = 8'h61;
Datas[13] = 8'h72;

Datas[14] = 8'h65;
Datas[15] = 8'h20;
Datas[16] = 8'h66;
Datas[17] = 8'h75;
Datas[18] = 8'h6E;

Datas[19] = 8'h21;
Datas[20] = 8'h21;
Datas[21] = 8'h21;
Datas[22] = 8'hC0;
Datas[23] = 8'h3A;
Datas[24] = 8'h2D;
Datas[25] = 8'h29;
end		
		
always @(posedge clk) begin

  if (i <= 1000000) begin
  i = i + 1; lcd_e = 1;
  data = Datas[j];
  end
  
  else if (i > 1000000 & i < 2000000) begin
  i = i + 1; lcd_e = 0;
  end
  
  else if (i == 2000000) begin
  j = j + 1; i = 0;
  end
  else i = 0;
  
  if (j <= 5) lcd_rs = 0; 
  else if (j > 5 & j< 22) lcd_rs = 1;   
  else if (j == 22) lcd_rs = 0;
  else if (j > 22) begin 
  lcd_rs = 1; j = 5;
  end
 
 end
endmodule

