module DDR(input logic clk,
			  input logic bpmClk,
			  input logic reset, 
			  input logic [3:0] step,
			  output logic [3:0] colEnOut,
			  output logic [7:0] col,
			  output logic [3:0] inputStep,
			  output logic redLed,
			  output logic greenLed,
			  output logic );
			  
	logic [15:0] counter;
	logic multiplexClk;
	logic [3:0] actionStep;
	logic [3:0] colEn;
	logic stepEn;
	
	always_ff@(posedge clk)
		if (reset) counter <= 0;
		else counter <= counter + 1;
	
	assign multiplexClk = counter[15];
	
	levelToPulse l2p(clk, reset, bpmClk, stepEn);
	colMuxer colMux(multiplexClk, reset, colEn);
	stepShiftRegister stepReg(clk, reset, stepEn, colEn, step, col, actionStep);
	
	assign colEnOut = ~colEn;
	//DEBUG
	assign inputStep = colEn;

	logic [31:0] score;
	scoring scoring0(clk,reset,actionStep,stepEn,button,score,redLed,greenLed);
	
	scoreDisplay scoreDisplay0(clk,reset,score[8:0],leftDigitTransBase,rightDigitTransBase,seg,);
	
endmodule

	