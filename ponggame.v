`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//	Created by: Ethan Kho
//	Function:
//	Created a pong game using verilog NEXYS2 Spartan 3E
//	Buttons are used in the board to control the both paddles
//	Score of players are illustrated on the 7 segment display
//  Projects consist of these components
//	- Ponggame.V: Top module of the design
//	- Debounce: debounce component for buttons
//	- Seg7disp: 7 Segment display
//	- divclk,divclk2,div25mhz,pongclk-clock divider for button, 7segment display
//	- ponggame.ucf: Pin mapping on FPGA board
// 	-
//////////////////////////////	////////////////////////////////////////////////////
module ponggame(hs,vs,clk50,r,g,b,seg7,anode,led,button,button1,button2,button3,ballspeed);
input clk50;
input button,button1,button2,button3;
input [1:0] ballspeed;
output hs,vs,r,g,b,led;
output [6:0] seg7;
output [3:0] anode;



reg [15:0] x1=400; // xposition of ball
reg [15:0] y1=400; //yposition of ball
wire led,clk;
reg [3:0] anode; // for 7 segment display
reg hs,vs=0;
reg r,g,b,obj_on;
reg[3:0] dig1,dig2,dig3,dig4=4'b000;
reg[3:0] hex; //hex register for 7 segment
parameter x_pwbp=144; // pw+bp time period for x
parameter y_pwbp=31; // pw+bp time period for y
integer Hcounter,Vcounter=0;
parameter [15:0]xpaddle=0; //xposition for left paddle
reg [15:0]ypaddle=200; // yposition for left paddle
parameter [15:0]xpaddle1=625;
reg [15:0]ypaddle1=200;
reg paddle_on=1'b0; //left paddle signal for vga
reg paddle1_on=1'b0;//right paddle signal for vga
reg [7:0]score=0; // score board for left player
reg [7:0]score1=0; // score board for right player
//reg sig=1'b0;
//pongclk pongclock(.clk50(clk50),.pongclk(pongclk),.sig(sig));
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
// hs vs signal generator
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
//end of hs vs signal generator for VGA
//need to have a register to tell when it is  ready for a new frame
/*
reg UpdateBallPosition;       // active only once for every video frame
always @(posedge clk50) UpdateBallPosition <= (Vcounter==520) & (Hcounter==0);
*/
reg posX=1'b0; // register for direction of ball in x-direction
reg posY=1'b0; //y register for direction of ball in y direction

wire fbutton,fbutton1,fbutton2,fbutton3;
wire secclk;
divclk2 secclk2(.clk50(clk50),.intclk(secclk));
// ball formation and direction
always @(posedge secclk)
begin
	//start of ball in x-direction
		if (posX==1'b0) begin
			if (((x1+10)>=xpaddle1)&&(ypaddle1<=y1)&&(y1<=(ypaddle1+100))) begin
				posX<=1'b1;
			end 
			else if(x1<640)  begin			
				x1<=x1+ballspeed;
			end
			else begin
				score1<=score1+1;
				x1<=300;
				y1<=240;
			end
		end
		else if (posX==1'b1)begin
			if (((x1)<=(xpaddle+15))&&(ypaddle<=y1)&&(y1<=(ypaddle+100))) begin
				posX<=1'b0;
			end
			else if (x1>0) begin 		
				x1<=x1-ballspeed;			
			end
			else begin
				score<=score+1;
				x1<=300;
				y1<=240;
			end
		end
		else begin
			posY<=posY;
			posX<=posX;
		end

	// end of x direction
	// start of y direction
		if (posY==1'b0) begin
			if (y1<480) begin
				y1<=y1+ballspeed;

			end 
			else begin
				posY<=1'b1;
			end
		end
		else if(posY==1'b1) begin
			if (y1>0) begin
				y1<=y1-ballspeed;
			end
			else begin 
				posY<=1'b0;
			end 
		end
		else begin 
		posY<=posY;
		posX<=posX;
		end
	// end of ball in y direction

end 
// debounce circuit for buttons
debounce debouncebutton (.inbutton(button),.outbutton(fbutton),.clk(secclk));
debounce debouncebutton1 (.inbutton(button1),.outbutton(fbutton1),.clk(secclk));
debounce debouncebutton2 (.inbutton(button2),.outbutton(fbutton2),.clk(secclk));
debounce debouncebutton3 (.inbutton(button3),.outbutton(fbutton3),.clk(secclk));
// end of debounce circuit for buttons
always @(Hcounter,Vcounter,x1,y1)
begin

	if ((Hcounter >=x1+x_pwbp) && (Hcounter < x1+x_pwbp+10) && (Vcounter >=y1+y_pwbp) && (Vcounter <y1+y_pwbp+10)) begin
		obj_on<=1'b1;
	end
	else begin
		obj_on<=1'b0;
	end
end
// end of ball formation and direction

// the left paddle 

always @(posedge secclk)
begin
//if (UpdateBallPosition) begin
	if (fbutton==1'b1) begin	
		if(ypaddle>0) begin
			ypaddle<=ypaddle-5;
		end
		else if (ypaddle<=0) begin
			ypaddle<=0;
		end
		else begin
			ypaddle<=ypaddle;
		end
	end		
	else if(fbutton1==1'b1)begin
		if(ypaddle<380) begin
			ypaddle<=ypaddle+5;
		end
		else if (ypaddle>=380) begin
			ypaddle<=380;
		end
		else begin
			ypaddle<=ypaddle;
		end
	end
	else begin
		ypaddle<=ypaddle;
	end 
dig1<=score[3:0];
dig2<=score[7:4];
dig3<=score1[3:0];
dig4<=score1[7:4];	
end 
//position of paadle

always @(Hcounter,Vcounter,ypaddle)
begin

	if ((Hcounter >=xpaddle+x_pwbp) && (Hcounter < xpaddle+x_pwbp+15) && (Vcounter >=ypaddle+y_pwbp) && (Vcounter <ypaddle+y_pwbp+100)) begin
		paddle_on<=1'b1;
	end
	else begin
		paddle_on<=1'b0;
	end
end
// end of the left paddle
/*-------------------------------*/
// Start of right paddle

always @(posedge secclk)
begin
//if (UpdateBallPosition) begin
	if (fbutton2==1'b1) begin	
		if(ypaddle1>0) begin
			ypaddle1<=ypaddle1-5;
		end
		else if (ypaddle1<=0) begin
			ypaddle1<=0;
		end
		else begin
			ypaddle1<=ypaddle1;
		end
	end		
	else if(fbutton3==1'b1)begin
		if(ypaddle1<380) begin
			ypaddle1<=ypaddle1+5;
		end
		else if (ypaddle1>=380) begin
			ypaddle1<=380;
		end
		else begin
			ypaddle1<=ypaddle1;
		end
	end
	else begin
		ypaddle1<=ypaddle1;
	end 
end 
//position of paadle


always @(Hcounter,Vcounter,ypaddle1)
begin

	if ((Hcounter >=xpaddle1+x_pwbp) && (Hcounter < xpaddle1+x_pwbp+15) && (Vcounter >=ypaddle1+y_pwbp) && (Vcounter <ypaddle1+y_pwbp+100)) begin
		paddle1_on<=1'b1;
	end
	else begin
		paddle1_on<=1'b0;
	end
end
// end of the right paddle
// selection of signal to output to monitor
always @(obj_on,Hcounter,Vcounter,paddle_on,paddle1_on)
begin

	if ((obj_on==1'b1)||(paddle_on==1'b1)||(paddle1_on==1'b1)) begin
		r<=(obj_on);
		g<=((paddle_on)||paddle1_on);
		b<=1'b0;
	end
	else begin
		r<=1'b0;
		g<=1'b0;
		b<=1'b0;
	end	
end

endmodule
