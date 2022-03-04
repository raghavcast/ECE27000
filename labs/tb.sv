module lab_testbench ();

logic hz100;
logic reset;
logic [20:0] pb;
logic [7:0] ss7,ss6,ss5,ss4,ss3,ss2,ss1,ss0;
logic [7:0] left,right;
logic red,green,blue;
logic [7:0] rxdata, txdata;
logic txclk, rxclk, rxready, txready;

top top_inst(
      hz100, reset, pb,
      left, right, ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
      red, green, blue,
      txdata,
      rxdata,
      txclk, rxclk,
      txready, rxready
);

integer STDERR = 32'h8000_0002;

logic errored;

integer i;
logic [15:0] corr;
logic [7:0] ans;
logic [1023:0] testname;
initial begin
    $dumpfile ("lab06.vcd");
    $dumpvars (0, lab_testbench);
    errored = 0;
    // put tests here
    testname = "Bargraph Tests";
    pb = 0;
    #10;
    pb = 1; corr = 16'b1;
    #10;
    for (pb = 1; ~pb[16]; pb <<= 1) begin
        #10;
        if ({left, right} != corr) begin
            $fdisplay(STDERR,"ERROR: Expected {left,right} = 0x%x but got 0x%x when pb = 0x%x", corr, {left, right}, pb);
            errored = 1;
        end
        corr = (corr << 1) | 16'b1;
    end

    testname = "Decoder Tests";
    pb = 0;
    corr = 8'b1;
    for (pb = 0; pb[3:0] != 4'd8; pb += 1) begin
        #10;
        ans = {ss7[7], ss6[7], ss5[7], ss4[7], ss3[7], ss2[7], ss1[7], ss0[7]};
        if (ans != corr) begin
            $fdisplay(STDERR,"ERROR: Expected {...ssX[7]...} = 0x%x but got 0x%x when pb = 0b%b", corr, ans, pb[3:0]);
            errored = 1;
        end
        corr <<= 1;
    end
    if (errored == 0)
        $finish;
    else
        $stop;
end

endmodule
