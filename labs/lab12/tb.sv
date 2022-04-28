////////////////////////////////////////////////////////////////////// 
// YOU SHOULD NOT MODIFY THIS FILE.
// WE MIGHT HAVE TO CONSIDER IT ACADEMIC DISHONESTY.
//////////////////////////////////////////////////////////////////////

module lab_testbench ();

logic clk, rst, mode, enable;
logic [7:0] ctr;

count8du c8_1 (.clk(clk), .rst(rst), .DIR(mode), .enable(enable), .MAX(8'd99), .out(ctr));

integer STDERR = 32'h8000_0002;
logic errored;

logic [7:0] ans;
logic [1023:0] testname;

task automatic clock(integer n);
    while (n != 0) begin
        clk = 1'b1;
        #1;
        clk = 1'b0;
        #1;
        n--;
    end
endtask //automatic

integer i;
initial begin
    $dumpfile ("lab12.vcd");
    $dumpvars (0, lab_testbench);
    errored = 0;
    // put tests here
    testname = "count8du Reset Test";
    enable = 1'b1; mode = 1'b0; rst = 1'b1; clk = 1'b0;
    // #10;
    clock(10);
    if (ctr != 0) begin
        errored = 1;
        $fdisplay(STDERR, "ERROR: Expected count8du out = 0 when reset = 1"); 
    end

    #2;
    testname = "count8du Enable Test";
    enable = 1'b0; mode = 1'b0; rst = 1'b0;
    // #10;
    clock(10);
    if (ctr != 0) begin
        errored = 1;
        $fdisplay(STDERR, "ERROR: Expected count8du out = 0 when enable = 0"); 
    end

    #2;
    testname = "count8du Count-Up Test";
    enable = 1'b1; mode = 1'b1; rst = 1'b0;
    for (i = 0; i < 110; i++) begin
        if (ctr != (i % 100)) begin
            errored = 1;
            $fdisplay(STDERR, "ERROR: Expected count8du out = %3d but got %3d when en = 1, mode = 1'b0, after %3d clock cycles", (i % 100), ctr, i); 
        end
        clock(1);
    end

    rst = 1'b1;
    #2;
    rst = 1'b0;
    #2;
    testname = "count8du Count-Down Test";
    enable = 1'b1; mode = 1'b0; rst = 1'b0;
    for (i = 0; i < 100; i++) begin
        ans = i == 0 ? 0 : 99 - i + 1;
        if (ctr != ans) begin
            errored = 1;
            $fdisplay(STDERR, "ERROR: Expected count8du out = %3d but got %3d when en = 1, mode = 1'b1, after %3d clock cycles", ans, ctr, i); 
        end
        clock(1);
    end

    if (errored == 0)
        $finish;
    else
        $stop;
end

endmodule
