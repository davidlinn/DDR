module scoring(input logic clk,
                    input logic reset,
                    input logic [3:0] step,
                    input logic beatEn,
                    input logic [3:0] button,
						  input logic bpmClk,
                    output logic [8:0] score,
                    output logic redLed,
                    output logic greenLed);
    
    //INPUTS AND TIME CAPTURE
    logic [3:0] buttonPulse;
    levelToPulse l2p_0(clk, reset, button[0], buttonPulse[0]);
    levelToPulse l2p_1(clk, reset, button[1], buttonPulse[1]);
    levelToPulse l2p_2(clk, reset, button[2], buttonPulse[2]);
    levelToPulse l2p_3(clk, reset, button[3], buttonPulse[3]);

    logic [63:0] currentTime;
    logic [63:0] beatTime;
    always_ff @(posedge clk) begin
        if (reset) begin
            currentTime <= 0;
            beatTime <= 0;
        end
        else begin
            currentTime <= currentTime + 1;
            if (beatEn)
                beatTime <= currentTime;
        end
    end
    
    logic beatReset;
    //Beat is reset halfway between beatEnables
    levelToPulse l2p_4(clk, reset, ~bpmClk, beatReset);

    logic [3:0] buttonPressedDuringStep;
    always_ff @(posedge clk) begin
        if (reset || beatReset)
            buttonPressedDuringStep <= 0;
        else if (buttonPulse[0])
            buttonPressedDuringStep[0] <= 1;
        else if (buttonPulse[1])
            buttonPressedDuringStep[1] <= 1;
        else if (buttonPulse[2])
            buttonPressedDuringStep[2] <= 1;
        else if (buttonPulse[3])
            buttonPressedDuringStep[3] <= 1;   
    end

    logic goodStep;
    assign goodStep = (step == buttonPressedDuringStep) && (step != 4'b0000);

    //CALCULATE SCORE
    logic addGoodStepToScore;
    logic deltaScore;
    always_ff @(posedge clk) begin
        if (reset) begin
            deltaScore <= 0;
            score <= 0;
        end
        else if (beatReset || deltaScore) begin //score as soon as step equals buttonPressedDuringStep
            deltaScore <= addGoodStepToScore;
            score <= score + deltaScore;
        end
    end
    assign addGoodStepToScore = goodStep && ~deltaScore;

    //LED FEEDBACK
    logic redLedEn;
    logic ledReset;
	 logic stepExpected;
    always_ff @(posedge clk) begin
        if (ledReset)
            greenLed <= 0;
        else if (deltaScore)
            greenLed <= 1;
    end

    always_ff @(posedge clk) begin
        if (beatEn)
            redLed <= 0;
        else if (redLedEn)
            redLed <= 1;
    end
	 assign stepExpected = (| step);
    assign redLedEn = (beatReset && !deltaScore && stepExpected && !goodStep);
    assign ledReset = (reset || beatReset);

endmodule