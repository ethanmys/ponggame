`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:41:19 03/16/2013 
// Design Name: 
// Module Name:    test_ponggame 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module test_ponggame;
reg hs,vs,clk50,r,g,b,led,button;
reg [6:0] seg7;
reg [3:0] anode;
wire x1,y1;
ponggame testponggame(.hs(hs),.vs(vs),.clk50(clk50),.r(r),.g(g),.b(b),.seg7(seg7),.anode(anode),.led(led),.button(button));
initial
	begin
		clk50=0;
		#10 forever #10 clk50=!clk50;
	end
initial
	begin
		#5000 $stop;
	end

initial
begin 
 $monitor($x1,,$y1,,clk50);
end
endmodule
