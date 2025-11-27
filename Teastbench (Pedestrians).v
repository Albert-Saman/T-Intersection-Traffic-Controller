`timescale 1s/1s

module testbench_pedestrian;
    reg clk = 0, I = 0;
    wire a1, a2, b, c;
    wire [1:0] mode;

    // Instantiate the Unit Under Test (UUT)
    traffic_controller uut(I, a1, a2, b, c, clk, mode);

    // Clock generation (1Hz -> Period = 2 units, toggle every 1)
    always #1 clk = ~clk;

    initial begin 
        // Monitor outputs
        $monitor("Time=%t | Mode=%d | Button(I)=%b | Lights: A1=%b A2=%b B=%b C=%b", 
                 $time, mode, I, a1, a2, b, c);

        // -- Simulation Start --
        
        // Mode 1 runs for 30s (starts at 0)
        #60; 
        
        // Mode 2 runs for 10s. We press button halfway through.
        I = 1; 
        #20; 
        
        // Should transition to Mode 0 (Pedestrian) because button was pressed
        I = 0; // Release button
        #60; // Mode 0 runs for 30s
        
        // Should return to Mode 1
        #60; 
        
        // Should go to Mode 2
        #20; 
        
        // Should go to Mode 3
        #40;
        
        $finish;
    end
endmodule
