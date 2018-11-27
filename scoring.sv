module scoring(input logic clk,
                    input logic reset,
                    input logic step,
                    input logic beatEn,
                    input logic button,
                    output logic [31:0] score,
                    output logic redLed,
                    output logic greenLed)
    
    //INPUTS AND TIME CAPTURE
    logic [3:0] buttonPulse;
    levelToPulse l2p_0(clk, reset, button[0], buttonPulse[0]);
    levelToPulse l2p_1(clk, reset, button[1], buttonPulse[1]);
    levelToPulse l2p_2(clk, reset, button[2], buttonPulse[2]);
    levelToPulse l2p_3(clk, reset, button[3], buttonPulse[3]);

    logic [63:0] currentTime;
    logic [63:0] beatTime;
    logic [63:0] button0Time;
    logic [63:0] button1Time;
    logic [63:0] button2Time;
    logic [63:0] button3Time;
    always_ff @(posedge clk) begin
        if (reset) begin
            currentTime <= 0;
            beatTime <= 0;
            button0Time <= 0;
            button1Time <= 0;
            button2Time <= 0;
            button3Time <= 0;
        end
        else begin
            currentTime <= currentTime + 1;
            if (beatEn)
                beatTime <= currentTime;
            if (buttonPulse[0])
                button0Time <= currentTime;
            if (buttonPulse[1])
                button1Time <= currentTime;
            if (buttonPulse[2])
                button2Time <= currentTime;
            if (buttonPulse[3])
                button3Time <= currentTime;
        end
    end

    //COMPARE BUTTON PRESSES WITH STEPS
    /*logic [3:0] scoreEn;
    assign scoreEn = (step & button);

    logic [31:0] diff0;
    logic [31:0] diff1;
    logic [31:0] diff2;
    logic [31:0] diff3;
    always_comb begin
        diff0 <= beatTime-button0Time;
        diff1 <= beatTime-button1Time;
        diff2 <= beatTime-button2Time;
        diff3 <= beatTime-button3Time;
    end*/
    //logic [31:0] timeSinceBeat;
    //assign timeSinceBeat = currentTime - beatTime;
    
    logic beatReset;
    //Beat is reset halfway between beatEnables
    assign beatReset = levelToPulse l2p_4(clk, reset, ~bpmClk, beatReset);

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
    assign goodStep = (step == buttonPressedDuringStep);

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
    always_ff @(posedge clk) begin
        if (ledReset)
            greenLed <= 0;
        else if (deltaScore)
            greenLed <= 1;
    end

    always_ff @(posedge clk) begin
        if (ledReset)
            redLed <= 0;
        else if (redLedEn)
            redLed <= 1;
    end
    assign redLedEn = (beatReset && !deltaScore);
    assign ledReset = (reset || beatReset);

endmodule