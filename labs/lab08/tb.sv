////////////////////////////////////////////////////////////////////// 
// YOU SHOULD NOT BE LOOKING AT OR EDITING ANYTHING IN THIS FILE.
// AN ATTEMPT TO DO SO WILL BE CONSIDERED ACADEMIC DISHONESTY.
//////////////////////////////////////////////////////////////////////

module lab_testbench ();

logic [4:0] in;
logic enable;
logic [6:0] out;

ssdec sd (.in(in[3:0]), .enable(enable), .out(out));

integer STDERR = 32'h8000_0002;
logic errored;

logic [6:0] segment [15:0];
assign {segment[4'hF], segment[4'hE], segment[4'hD], segment[4'hC], 
        segment[4'hB], segment[4'hA], segment[4'h9], segment[4'h8], 
        segment[4'h7], segment[4'h6], segment[4'h5], segment[4'h4], 
        segment[4'h3], segment[4'h2], segment[4'h1], segment[4'h0]
        } = 112'hE3E6F39F9DF3FF0FF76E69F6C33F;

logic [7:0] ans;
logic [1023:0] testname;

initial begin
    $dumpfile ("lab08.vcd");
    $dumpvars (0, lab_testbench);
    errored = 0;
    // put tests here
    testname = "ssdec Enable Tests";
    enable = 0;
    in = 0;
    #10;
    for (in = 0; in < 16; in += 1) begin
        #10;
        if (out != 0) begin
            $fdisplay(STDERR,"ERROR: Expected ssdec out = 0 when enable = 0, in = %d", in);
            errored += 1;
        end
    end
    if (errored == 16) begin
        $fdisplay(STDERR,"ERROR: Your ssdec 'out' should be 0 whenever the enable is off.");
    end

    testname = "ssdec Output Tests";
    in = 0;
    enable = 1;
    #10;
    for (in = 0; in < 16; in += 1) begin
        #10;
        ans = segment[in];
        if (out != ans) begin
            $fdisplay(STDERR,"ERROR: Expected out = 7'b%b, but got 7'b%b, when in = 4'd%d", ans, out, in);
            errored = 1;
        end
    end
    if (errored == 0)
        $finish;
    else
        $stop;
end

endmodule
