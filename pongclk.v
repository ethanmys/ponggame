/*---------------50 Mhz to 1hz clock----------------*/
module pongclk(clk50,pongclk);
input clk50;
output pongclk;
integer counter=0;
reg pongclk=1'b0;

always@(posedge clk50)
begin
	counter=counter+1;
	if (counter==505000) begin
		counter=0;
		pongclk<=1'b1;
	end
	else begin
		pongclk<=1'b0;
	end
end
endmodule 