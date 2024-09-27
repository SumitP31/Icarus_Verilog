module counter_7_to_0 (
    input wire clk,
    input wire reset,
    output reg [2:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            count <= 3'b111;   // Reset to 7
        else
            count <= count - 1; // Count down
    end
endmodule

module tb_counter_7_to_0;

    reg clk, reset;
    wire [2:0] count;

    counter_7_to_0 uut (
        .clk(clk),
        .reset(reset),
        .count(count)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period of 10ns
    end

    initial begin
        // $monitor("Time = %0dns, Count = %d", $time, count);
        $dumpfile("3-bit_counter.vcd");
        $dumpvars(0, tb_counter_7_to_0);
        reset = 1; #10 reset = 0; // Start with reset active

        // Let the counter count down from 7 to 0
        $finish;
    end
endmodule
