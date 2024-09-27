module moore_machine (
    input wire clk,
    input wire reset,
    input wire in,   // Input to the Moore machine
    output reg out   // Output from the Moore machine
);

    typedef enum reg [1:0] {
        S0 = 2'b00,
        S1 = 2'b01,
        S2 = 2'b10,
        S3 = 2'b11
    } state_t;

    state_t state, next_state;

    // Next State Logic
    always @(*) begin
        case (state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S3 : S0;
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
            out <= 0;
        else begin
            case (state)
                S0: out <= 0;
                S1: out <= 0;
                S2: out <= 0;
                S3: out <= 1;
                default: out <= 0;
            endcase
        end
    end
endmodule

module tb_moore_machine;

    reg clk, reset, in;
    wire out;

    moore_machine uut (
        .clk(clk),
        .reset(reset),
        .in(in),
        .out(out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock cycle
    end

    initial begin
        $monitor("Time = %0dns, Input = %b, Output = %b", $time, in, out);
        reset = 1; in = 0; #10 reset = 0;

        // Simulate inputs for the Moore machine
        #10 in = 1; 
        #10 in = 0;
        #10 in = 1;
        #10 in = 1;
        #10 in = 0;

        #50 $finish;
    end
endmodule
