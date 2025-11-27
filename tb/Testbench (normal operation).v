`timescale 1s/1s

module testbench_normal;
    reg clk = 0, I = 0; // I is held 0 (No pedestrians)
    wire a1, a2, b, c;
    wire [1:0] mode;

    traffic_controller uut(I, a1, a2, b, c, clk, mode);

    always #1 clk = ~clk;

    initial begin 
        $monitor("Time=%t | Mode=%d | Lights: A1=%b A2=%b B=%b C=%b", 
                 $time, mode, a1, a2, b, c);

        // Expected Sequence: 1 -> 2 -> 3 -> 1
        
        #60; // Mode 1 (30s)
        #20; // Mode 2 (10s)
        #40; // Mode 3 (20s)
        
        #60; // Back to Mode 1
        #20; // Mode 2
        #40; // Mode 3
        
        $finish;
    end
endmodule
