module stepShiftRegister(input logic clk,
								 input logic reset,
								 input logic stepEn,
								 input logic [3:0] colEn,
								 input logic [3:0] inputStep,
								 output logic [7:0] col,
								 output logic [3:0] actionStep);
								 
	logic [3:0] step0, step1, step2, step3, step4, step5, step6, step7;
	// shift register to shift steps every beat
	always_ff@(posedge clk)
		if (reset) begin
				step0 <= 4'h0;
				step1 <= 4'h0;
				step2 <= 4'h0;
				step3 <= 4'h0;
				step4 <= 4'h0;
				step5 <= 4'h0;
				step6 <= 4'h0;
				step7 <= 4'h0;
			end
		else if (stepEn) begin
			step0 <= inputStep;
			step1 <= step0;
			step2 <= step1;
			step3 <= step2;
			step4 <= step3;
			step5 <= step4;
			step6 <= step5;
			step7 <= step6;
		end
	
	assign actionStep = col[7:4];
	
	always_comb
		case (colEn)
			4'b0001: col = {~step0[3], ~step1[3], ~step2[3], ~step3[3], ~step4[3], ~step5[3], ~step6[3], ~step7[3]};
			4'b0010: col = {~step0[2], ~step1[2], ~step2[2], ~step3[2], ~step4[2], ~step5[2], ~step6[2], ~step7[2]};
			4'b0100: col = {~step0[1], ~step1[1], ~step2[1], ~step3[1], ~step4[1], ~step5[1], ~step6[1], ~step7[1]};
			4'b1000: col = {~step0[0], ~step1[0], ~step2[0], ~step3[0], ~step4[0], ~step5[0], ~step6[0], ~step7[0]};
			default: col = {~step0[3], ~step1[3], ~step2[3], ~step3[3], ~step4[3], ~step5[3], ~step6[3], ~step7[3]};
		endcase
	
	
endmodule
	