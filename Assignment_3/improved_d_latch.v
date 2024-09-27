module improved_d_latch(
    input wire D,        // Data input
    input wire CLK,      // Clock input
    input wire Q_prev,   // Previous Q output
    output wire Q        // Current Q output
);

    wire nCLK, N1, N2;

    // NOT gate for clock inversion with 1 ns delay
    not #(1) U1 (nCLK, CLK);

    // AND gate 1 for CLK.D with 1 ns delay
    and #(1) U2 (N1, CLK, D);

    // AND gate 2 for nCLK.Q_prev with 1 ns delay
    and #(1) U3 (N2, nCLK, Q_prev);

    // OR gate to get the final Q with 1 ns delay
    or  #(1) U4 (Q, N1, N2);

endmodule

module tb_improved_d_latch;

    // Inputs
    reg D;
    reg CLK;
    reg Q_prev;

    // Outputs
    wire Q;

    // Instantiate the D latch module
    improved_d_latch uut (
        .D(D), 
        .CLK(CLK), 
        .Q_prev(Q_prev), 
        .Q(Q)
    );

    // Clock generation (alternates every 5 ns)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

    // Test sequence
    initial begin
        //$monitor("Time = %0dns, D = %b, CLK = %b, Q_prev = %b, Q = %b", $time, D, CLK, Q_prev, Q);

        $dumpfile("improved_d_latch.vcd");
        $dumpvars(0, tb_improved_d_latch);
        // Monitor changes in inputs and outputs
        

        // Initialize values
        D = 0; Q_prev = 0;

        // Apply test cases
        #10 D = 0; Q_prev = 0;
        #10 D = 1; Q_prev = 0;
        #10 D = 0; Q_prev = 1;
        #10 D = 1; Q_prev = 1;
        #10 D = 0; Q_prev = 1;

        // Finish simulation
        
        $finish;
    end

endmodule
