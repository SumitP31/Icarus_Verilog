module sr_latch (
    input 
    input wire S,       // Set
    input wire R,       // Reset
    input wire En,      // Enable
    input wire Reset,   // Asynchronous Reset
    output reg Q,       // Output
    output reg Qn       // Complementary output
);

    always @(posedge clk) begin //i.e. if any value changes then 
        if (Reset) begin
            Q = 0;
            Qn = 1;
        end
        else if (En) begin
            if (S && !R) begin
                Q = 1;
                Qn = 0;
            end
            else if (!S && R) begin
                Q = 0;
                Qn = 1;
            end
            // No change when S=0 and R=0
        end
    end
endmodule


module tb_sr_latch;

    reg S, R, En, Reset;
    wire Q, Qn;

    sr_latch uut (
        .S(S),
        .R(R),
        .En(En),
        .Reset(Reset),
        .Q(Q),
        .Qn(Qn)
    );

    initial begin
        // $monitor("S=%b, R=%b, En=%b, Reset=%b, Q=%b, Qn=%b", S, R, En, Reset, Q, Qn);
        $dumpfile("sr_latch.vcd");
        $dumpvars(0, tb_sr_latch);
        // Initialize
        Reset = 1; S = 0; R = 0; En = 0;
        #10 Reset = 0; En = 1;

        // Set the latch
        #10 S = 1; R = 0;
        #10 S = 0; R = 1;

        // Reset the latch
        #10 Reset = 1;
        #10 Reset = 0;

        // Disable the latch
        #10 En = 0; S = 1; R = 0;

        $finish;
    end
endmodule
