/*---------------50 Mhz to 1hz clock----------------*/
module divclk2(clk50,intclk);
input clk50;
output intclk;
integer counter=0;
reg intclk=1'b0;
//reg led;

always@(posedge clk50)
begin: divclk

	if (counter==250000) begin
		counter=0;
//		led<=1'b0;
		intclk<=~intclk;
	end
	else begin 
		counter=counter+1;
	end
end
endmodule 