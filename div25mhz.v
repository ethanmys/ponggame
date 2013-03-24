/*---------------50 Mhz to 25Mhz clock----------------*/
module div25mhz(clk50,clk25);
input clk50;
output clk25;
reg clk25=1'b0;


always@(posedge clk50)
begin
		clk25<=~clk25;	
end
endmodule
