/******************************************************************************
YOU ARE NOT PERMITTED TO USE ANYTHING FROM THIS FILE IN YOUR OWN CODE.
ANY ATTEMPT TO DO SO WILL BE CONSIDERED AN INSTANCE OF ACADEMIC DISHONESTY.
******************************************************************************/

`timescale 1ms/10ps
module tb_fr_counter();
  logic clk, rst, enable;
  logic [7:0] out;

  fr_counter frc ( .clk(clk), .rst(rst), .enable(enable), .out(out) );

  // send errors to stderr, not stdout :P
  integer STDERR = 32'h8000_0002;
  // keep track of time for labeling
  integer rltime;
  initial rltime = 0;
  always #1 rltime = rltime + 1;
  // keep clocking!
  always begin clk = 0; #5; clk = 1; #5; end  

  integer i;
  integer errored;

  initial begin
    $dumpfile("build/fr_counter.vcd");
    $dumpvars(0, tb_fr_counter);
    errored = 0; enable = 0; rst = 1;
    #100;
    if (out != 0) begin
      $fdisplay(STDERR, "%d ns | ERROR: power-on reset test | expected out = %8b, got out = %8b", rltime, 8'b0, out);
      errored = 1;
    end
    enable = 1; rst = 0;
    #10;
    for (i = 1; i < 256; i++) begin
      if (out != (i & 8'hFF)) begin
        $fdisplay(STDERR, "%d ns | ERROR: enabled counter test | expected out = %8b, got out = %8b", rltime, i[7:0], out);
        errored = 1;
      end
      #10;
    end
    enable = 0;
    #100;
    if (out != (i & 8'hFF)) begin
      $fdisplay(STDERR, "%d ns | ERROR: disabled counter test | expected out = %8b, got out = %8b", rltime, i[7:0], out);
      errored = 1;
    end
    if (errored == 0) $display("All tests passed!");
    $finish_and_return(errored);
  end

endmodule