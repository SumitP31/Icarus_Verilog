// test bench

`include "xor.v"

module tb;
    reg a,b;
    wire y;

    test i1(a,b,y);

    initial begin
        $dumpfile("half_adder.vcd");
        $dumpvars(0, tb);
        a=0 ; b=0;
        #1
        a=0 ; b=1;
        #1
        a=1 ; b=0;
        #1
        a=1 ; b=1;
        
    end
endmodule