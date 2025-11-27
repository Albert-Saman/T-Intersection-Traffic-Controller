// ==========================================
// Module: JK Flip-Flop
// Description: Basic building block for the counter
// ==========================================
module jk_ff(j, k, clk, clr, q);
    input j, k, clr, clk;
    output reg q;

    initial begin
        q <= 1'b0; // Initialize to 0
    end

    always @(posedge clk or posedge clr) begin
        if (clr) begin // Active high clear
            q <= 1'b0;
        end else begin
            case ({j,k})
                2'b00: q <= q;    // No change
                2'b01: q <= 1'b0; // Reset
                2'b10: q <= 1'b1; // Set
                2'b11: q <= ~q;   // Toggle
            endcase
        end
    end
endmodule

// ==========================================
// Module: 5-bit Synchronous Counter
// Description: Structural design using JK Flip-Flops
// ==========================================
module counter(out, clr, clk);
    input clk, clr;
    output [4:0] out;
    wire w1, w2, w3;

    // Logic gates for synchronous counting
    and x1(w1, out[1], out[0]);
    and x2(w2, out[2], w1);
    and x3(w3, out[3], w2);

    // Instantiation of JK Flip-Flops
    jk_ff jkf1(1'b1, 1'b1, clk, clr, out[0]);
    jk_ff jkf2(out[0], out[0], clk, clr, out[1]);
    jk_ff jkf3(w1, w1, clk, clr, out[2]);
    jk_ff jkf4(w2, w2, clk, clr, out[3]);
    jk_ff jkf5(w3, w3, clk, clr, out[4]);
endmodule

// ==========================================
// Module: Traffic Light Controller (Top Level)
// Description: FSM logic to control lights based on counter and inputs
// ==========================================
module traffic_controller (I, A1, A2, B, C, clk, mode);
    input I, clk;
    output reg A1, A2, B, C;
    output reg [1:0] mode = 1; // Initialize at Mode 1
    
    wire [4:0] count_val;
    reg clr = 0;

    // Instantiate the structural counter
    counter m(count_val, clr, clk);

    always @(posedge clk) begin
        case (mode)
            // Mode 0: Pedestrian Crossing (30 seconds)
            2'b00: begin 
                A1 = 0; A2 = 0; B = 0; C = 0;
                if (clr == 1) clr = 0; // Reset clear signal
                
                if (count_val == 29) begin // 0 to 29 = 30 cycles
                    mode = 1;
                    A1 = 1; A2 = 0; B = 0; C = 1; 
                    clr = 1; // Reset counter
                end
            end
            
            // Mode 1: Road A & C Green (30 seconds)
            2'b01: begin 
                A1 = 1; A2 = 0; B = 0; C = 1; 
                if (clr == 1) clr = 0;
                
                if (count_val == 29) begin
                    clr = 1;
                    if (I) begin 
                        mode = 0; // Go to Pedestrian mode if button pressed
                        A1 = 0; A2 = 0; B = 0; C = 0; 
                    end
                    else begin 
                        mode = 2; // Otherwise go to Mode 2
                        A1 = 1; A2 = 1; B = 0; C = 0; 
                    end
                end
            end
            
            // Mode 2: Road A Left Turn (10 seconds)
            2'b10: begin 
                A1 = 1; A2 = 1; B = 0; C = 0;
                if (clr == 1) clr = 0;
                
                if (count_val == 9) begin // 0 to 9 = 10 cycles
                    clr = 1;
                    if (I) begin 
                        mode = 0;
                        A1 = 0; A2 = 0; B = 0; C = 0;
                    end
                    else begin 
                        mode = 3;
                        A1 = 0; A2 = 0; B = 1; C = 0;
                    end
                end
            end
            
            // Mode 3: Road B Green (20 seconds)
            2'b11: begin 
                A1 = 0; A2 = 0; B = 1; C = 0;
                if (clr == 1) clr = 0;
                
                if (count_val == 19) begin // 0 to 19 = 20 cycles
                    clr = 1;
                    if (I) begin 
                        mode = 0;
                        A1 = 0; A2 = 0; B = 0; C = 0;
                    end
                    else begin 
                        mode = 1;
                        A1 = 1; A2 = 0; B = 0; C = 1;
                    end
                end
            end
        endcase
    end
endmodule
