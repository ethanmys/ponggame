module debounce (inbutton,clk,outbutton);

input wire clk, inbutton;
output reg outbutton;

reg [7:0] register;

//reg: wait for stable
always @ (posedge clk) 
begin
register[7:0] <= {register[6:0],inbutton}; //shift register
	if(register[7:0] == 8'b00000000)
		outbutton <= 1'b0;
	else if(register[7:0] == 8'b11111111)
		outbutton <= 1'b1;
	else outbutton <= outbutton;
	end
endmodule

/*module debounce (reset, clk, inbutton, outbutton);
   input reset, clk, inbutton;
   output outbutton;

   parameter NDELAY = 650000;
   parameter NBITS = 20;

   reg [NBITS-1:0] count;
   reg xnew, outbutton;

   always @(posedge clk)
     if (reset) begin xnew <= inbutton; outbutton <= inbutton; count <= 0; end
     else if (inbutton != xnew) begin xnew <= inbutton; count <= 0; end
     else if (count == NDELAY) outbutton <= xnew;
     else count <= count+1;

endmodule
*/