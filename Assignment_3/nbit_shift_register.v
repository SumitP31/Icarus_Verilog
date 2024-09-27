module shift_register #(parameter N = 8) (
    input wire clk,
    input wire reset,
    input wire shift_dir,  // 1 for right, 0 for left
    input wire [N-1:0] data_in,
    output reg [N-1:0] data_out
);
   

    always @(posedge clk or posedge reset) begin
        if (reset)
            data_out <= data_in;
        else if (shift_dir)
            data_out <= data_out >> 1; // Shift right
        else
            data_out <= data_out << 1; // Shift left
    end
endmodule

module tb_shift_register;

    reg clk, reset, shift_dir;
    reg [7:0] data_in;
    wire [7:0] data_out;

    shift_register #(8) uut (
        .clk(clk),
        .reset(reset),
        .shift_dir(shift_dir),
        .data_in(data_in),
        .data_out(data_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("nbit_shift_register.vcd");
        $dumpvars(0, tb_shift_register);

        reset = 1; data_in = 8'b10101010; shift_dir = 1; #10 reset = 0;

        // Shift right
        #50 shift_dir = 0;

        // Shift left
        #50 $finish;
    end
endmodule
