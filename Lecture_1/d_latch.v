module D_latch(input clk, en, reset,
                input  d, 
                output reg q);
    always @ (posedge clk)
        begin if 
            (reset==0) q<=0; //when reset
        else if (en)   // when en and clk rise
            q <= d;
        end
endmodule


module test_bench;
    reg clk, reset, en;
    reg  d;
    wire q;
    
    always begin 
        #3
        clk = ~clk;
    end
    D_latch dl(clk, en, reset, d, q);    
    initial begin 
        $dumpfile("d_latch.vcd");
        $dumpvars(0, test_bench);
       clk <= 1'b0;
       reset <= 1'b1;
       en = 1;
       d <= 1'b0;
       #10
       d <= 1'b1;
       #10
       d <= 1'b0;
       
    $finish;
    end
    
endmodule