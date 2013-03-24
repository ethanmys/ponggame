`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:41:24 03/10/2013 
// Design Name: 
// Module Name:    ponggame 
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
//////////////////////////////	////////////////////////////////////////////////////
module ponggame(hs,vs,clk50,r,g,b,seg7,anode,led,button,button1,reset);
input clk50;
input button,button1,reset;
//input [3:0] segin;
output hs,vs,r,g,b,led;
output [6:0] seg7;
output [3:0] anode;


//position and directio of the pong ball
reg [15:0] x1=400;
reg [15:0] y1=400;
//end of position and direction of the pong ball

wire led,clk,pongclk;
//reg [6:0]seg7;
reg [3:0] anode;
reg hs,vs=0;
reg r,g,b,obj_on;
//reg led;
reg[3:0] dig1,dig2,dig3,dig4=4'b000;
reg[3:0] hex;
parameter x_pwbp=144; // pw+bp time period for x
parameter y_pwbp=31; // pw+bp time period for y
integer Hcounter,Vcounter=0;
parameter obj_l=100;
parameter obj_r=120;
parameter obj_u=100;
parameter obj_d=120;

pongclk pongclock(.clk50(clk50),.pongclk(pongclk));
div25mhz div2clk50(.clk50(clk50),.clk25(clk));// divide 50mhz clk to 25 mhz
// seg 7 display
seg7display seg7disp(.ssOut(seg7), .nIn(hex));// seg 7 display
//division of the clock for 7segment;
divclk segclk(.clk50(clk50),.intclk(intclk),.led(led));
//controller for 7seg
integer c=0;
always @(posedge intclk)

begin
	if (c==3)
		c=0;
	else
		c=c+1;
	
	begin
		case(c)
			0: begin anode<=4'b1110;
						hex<=dig1; end 
			1: begin anode<=4'b1101;
						hex<=dig2; end
			2: begin anode<=4'b1011;
						hex<=dig3; end
			3:	begin anode<=4'b0111;
						hex<=dig4; end 
		endcase
	end
end
//end of 7 seg controller

always@(posedge clk)
begin:HsVSgenerator
	if (Hcounter<799 && Hcounter>=0) begin
		Hcounter<=Hcounter+1;
	end
	else if (Hcounter==799)begin
		Hcounter<=0;
		Vcounter<=Vcounter+1;
	end
	else begin
		Hcounter<=0;
		Vcounter<=Vcounter+1;
	end
	if(Vcounter==520) begin
		Vcounter<=0;
	end
/*x<=Hcounter-144;
y<=Vcounter-31;*/
end

always @(Hcounter,Vcounter)
begin
	if ((Hcounter<96) && (Hcounter>=0)) begin
		hs<=1'b0; 
		end
	else begin
		hs<=1'b1;
		end
	
	if ((Vcounter<2) &&(Vcounter>=0)) begin
		vs<=1'b0;
		end
	else begin
		vs<=1'b1;
		end
end

//need to have a register to tell when it is  ready for a new frame
reg UpdateBallPosition;       // active only once for every video frame
always @(posedge clk50) UpdateBallPosition <= (Vcounter==520) & (Hcounter==0);
// to determine the direction vector
// need to know what position 
reg posX=1'b0;
reg posY=1'b0;

wire fbutton,fbutton1;

wire secclk;
divclk2 secclk2(.clk50(clk50),.intclk(secclk));
always @(posedge secclk)
begin
//if (UpdateBallPosition) begin
//	if (posedge secclk) begin
		if (posX==1'b0) begin
			if (x1<640) begin
				x1<=x1+1;
				//x1<=10;
			end 
			else begin
				posX<=1'b1;
			end
		end
		else if (posX==1'b1)begin
			if (x1>0) begin
				x1<=x1-1;
				//x1<=60;
			end
			else begin 
				posX<=1'b0;
			end
		end
		else begin
		posY<=posY;
		posX<=posX;
		end
	
		if (posY==1'b0) begin
			if (y1<480) begin
				y1<=y1+1;
				//y1<=10;
			end 
			else begin
				posY<=1'b1;
			end
		end
		else if(posY==1'b1) begin
			if (y1>0) begin
				y1<=y1-1;
				//y1<=40;
			end
			else begin 
				posY<=1'b0;
			end 
		end
		else begin 
		posY<=posY;
		posX<=posX;
		end
dig1<=x1[3:0];
dig2<=x1[7:4];
dig3<=x1[11:8];
dig4<=x1[15:12];
end 

debounce debouncebutton (.inbutton(button),.outbutton(fbutton),.clk(secclk));
debounce debouncebutton1 (.inbutton(button1),.outbutton(fbutton1),.clk(secclk));

always @(Hcounter,Vcounter,x_pwbp,y_pwbp,x1,y1)
begin

	if ((Hcounter >=x1+x_pwbp) && (Hcounter < x1+x_pwbp+10) && (Vcounter >=y1+y_pwbp) && (Vcounter <y1+y_pwbp+10)) begin
		obj_on<=1'b1;
	end
	else begin
		obj_on<=1'b0;
	end
end
// the paddle
// change of paddle
reg [15:0]xpaddle=0;
reg [15:0]ypaddle=200;
reg paddle_on;
always @(fbutton,fbutton1,x1,y1,ypaddle)
begin
if (UpdateBallPosition) begin
	if ((fbutton==1'b1)&&(y1>0)) begin	
		ypaddle=ypaddle+1;
	end
	else if ((fbutton1==1'b1)&&(y1<480)) begin
		ypaddle=ypaddle-1; 
	end
	else if(ypaddle>=480) begin
		ypaddle=480;
	end
	else if(ypaddle<=0)begin
		ypaddle=0;
	end
	else begin
		ypaddle=ypaddle;
	end
end	
end 
//position of paadle

always @(Hcounter,Vcounter,x_pwbp,y_pwbp,xpaddle,ypaddle)
begin

	if ((Hcounter >=xpaddle+x_pwbp) && (Hcounter < xpaddle+x_pwbp+50) && (Vcounter >=ypaddle+y_pwbp) && (Vcounter <ypaddle+y_pwbp+100)) begin
		paddle_on<=1'b1;
	end
	else begin
		paddle_on<=1'b0;
	end
end
// end of the paddle
always @(obj_on,Hcounter,Vcounter)
begin

	if ((obj_on==1'b1)||(paddle_on==1'b1)) begin
		r<=1'b0;
		g<=((obj_on) || (paddle_on));
		b<=1'b0;
	end
	else begin
		r<=1'b0;
		g<=1'b0;
		b<=1'b0;
	end	
end

endmodule
