module levelToPulse(input logic clk,
        input logic reset,
        input logic a,
        output logic en);
 typedef enum {s0, s1, s2}xzc StateType;
 
 StateType state;
 StateType nextState;
 
 always_ff@(posedge clk, posedge reset)
  if (reset) state <= s0;
  else       state <= nextState;
  
 always_comb
  case(state)
   s0: nextState = a ? s1 : s0;
   s1: nextState = a ? s2 : s0;
   s2: nextState = a ? s2: s0;
  endcase
  
 // emit pulse for one clk cycle
 assign en = state == s1;
endmodule