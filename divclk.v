/*---------------50 Mhz to 1khz clock----------------*/
module divclk(clk50,intclk,led);
input clk50;
output intclk,led;
integer counter=0;
reg intclk=1'b0;
reg led;

always@(posedge clk50)
begin: divclk
	counter=counter+1;
	if (counter==50000) begin
		counter=0;
		led<=1'b0;
		intclk<=~intclk;
	end
	else begin 
		led<=1'b1;
	end
end
endmodule 