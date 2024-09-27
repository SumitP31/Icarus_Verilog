module sequence_detector (
    input wire clk,
    input wire reset,
    input wire x,   // Input sequence
    output reg z    // Output signal
);

    typedef enum reg [2:0] {
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100
    } state_t;

    state_t state, next_state;

    // Next State Logic
    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = x ? S2 : S0;
            S2: next_state = x ? S2 : S3;
            S3: next_state = x ? S4 : S0;
            S4: next_state = x ? S1 : S0;
            default: next_state = S0;
        endcase
    end

    // State Register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S0;
        else
            state <= next_state;
    end

    // Output Logic
    always @(posedge clk) begin
        if (reset)
            z <= 0;
        else if (state == S4 && x == 1)
            z <= 1;
        else
            z <= 0;
    end
endmodule

module tb_sequence_detector;

    reg clk, reset, x;
    wire z;

    sequence_detector uut (
        .clk(clk),
        .reset(reset),
        .x(x),
        .z(z)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock cycle
    end

    initial begin
        $monitor("Time = %0dns, Input = %b, Output = %b", $time, x, z);
        reset = 1; x = 0; #10 reset = 0;

        // Simulate inputs for the sequence detector
        #10 x = 1; 
        #10 x = 1;
        #10 x = 0;
        #10 x = 1;

        #50 $finish;
    end
endmodule
