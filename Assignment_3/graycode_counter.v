module gray_code_counter (
    input wire clk,
    input wire reset,
    input wire up,      // 1 for UP, 0 for DOWN
    output reg [2:0] gray_code
);

    reg [2:0] binary;

    // Binary to Gray code conversion
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            binary <= 3'b000;
        end
        else if (up) begin
            binary <= binary + 1;
        end
        else begin
            binary <= binary - 1;
        end
    end

    always @(*) begin
        gray_code = (binary >> 1) ^ binary;  // Convert binary to gray code i.e. g[i] = b[i] ^ b[i+1]
    end
endmodule

module tb_gray_code_counter;

    reg clk, reset, up;
    wire [2:0] gray_code;

    gray_code_counter uut (
        .clk(clk),
        .reset(reset),
        .up(up),
        .gray_code(gray_code)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Clock period of 10ns
    end

    initial begin
        // $monitor("Time = %0dns, Gray Code = %b", $time, gray_code);
        $dumpfile("graycode_counter.vcd");
        $dumpvars(0, tb_gray_code_counter);
        reset = 1; up = 1; #10 reset = 0;

        // Count up
        #50 up = 0;

        // Count down
        #50 $finish;
    end
endmodule
