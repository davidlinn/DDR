module colMuxer(input logic multiplexClk,
					 input logic reset,
					 output logic [3:0] colEn);
					 
	logic [3:0] nextColEn;
	
	always_ff@(posedge multiplexClk)
		if (reset) colEn <= 4'b0001;
		else 		  colEn <= nextColEn;
		
	always_comb
		case (colEn)
			4'b0001: nextColEn <= 4'b0010;
			4'b0010: nextColEn <= 4'b0100;
			4'b0100: nextColEn <= 4'b1000;
			4'b1000: nextColEn <= 4'b0001;
			default: nextColEn <= 4'b0001;
		endcase

endmodule
