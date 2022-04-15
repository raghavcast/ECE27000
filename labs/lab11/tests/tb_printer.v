/******************************************************************************
YOU ARE NOT PERMITTED TO USE ANYTHING FROM THIS FILE IN YOUR OWN CODE.
ANY ATTEMPT TO DO SO WILL BE CONSIDERED AN INSTANCE OF ACADEMIC DISHONESTY.
******************************************************************************/

`timescale 1ms/10ps
module tb_printer();
  logic clk, rst;
  logic [2:0] num;
  logic activate;
  logic txready;
  logic [7:0] char_in;
  logic txclk;
  logic [7:0] txdata;
  logic done_printing; 

  printer prn (
    .clk(clk), .rst(rst),
    .num(num), 
    .activate(activate), 
    .txready(txready), 
    .char_in(char_in), 
    .txclk(txclk), 
    .txdata(txdata), 
    .done_printing(done_printing)
  );

  integer STDERR = 32'h8000_0002;

  logic [511:0] msg [7:0];
  assign msg[0] = {272'b0, "Ready to play? Press any key: "};
  assign msg[1] = {440'b0, 8'd13, 8'd10, "Guess: "};
  assign msg[2] = {152'b0, "You win!  Press 3-0-W on the FPGA to reset.", 8'd13, 8'd10};
  // when user is entering characters, print them so user can see what they're typing
  // this is also called echoback
  assign msg[3] = {504'b0, char_in};
  // COLOR_Y - to color the next letter yellow
  assign msg[4] = {472'b0, 8'h1b, 8'h5b, 8'h33, 8'h33, 8'h6d};
  // COLOR_G - to color the next letter green
  assign msg[5] = {472'b0, 8'h1b, 8'h5b, 8'h33, 8'h32, 8'h6d};
  // COLOR_W - to color the next letter white
  assign msg[6] = {472'b0, 8'h1b, 8'h5b, 8'h33, 8'h37, 8'h6d};
  // unused, so we'll initialize to zero
  assign msg[7] = 512'b0;
  logic [15:0] len, senlen;
  always_comb begin
    case(num)
      0: senlen = 30*8;
      1: senlen = 9*8;
      2: senlen = 46*8;
      3: senlen = 1*8;  
      4,5,6: senlen = 5*8;
      default: senlen = 0;
    endcase
  end

  logic [511:0] sentence;
  logic [7:0] selected_char;
  assign selected_char = msg[num][(len - 1) -: 8];

  // keep track of time for labeling
  integer rltime;
  initial rltime = 0;
  always #1 rltime = rltime + 1;

  // keep clocking!
  always begin clk = 0; #5; clk = 1; #5; end

  logic errored;

  initial begin
    $dumpfile("build/printer.vcd");
    $dumpvars(0, tb_printer);
    errored = 0;
    // power on reset
    activate = 0; txready = 0; num = 0; char_in = "a";
    rst = 1;
    #20;
    if (!(txclk == 0 && txdata == 0 && done_printing == 0)) begin
      $fdisplay(STDERR, "%d ns | ERROR: power-on reset test --- txclk %1d txdata %8b done_printing %1d, expected %1d %8b %1d",
              rltime, txclk, txdata, done_printing, 0, 0, 0);
              errored = 1;
    end
    // Print and check each message
    rst = 0; txready = 1; num = 0; 
    for (num = 0; num < 7; num++) begin
      activate = 1;
      #10;
      activate = 0;
      #10;
      for (len = senlen; len > 0; len -= 8) begin
        if (txclk != 0 && txdata != selected_char) begin
          $fdisplay(STDERR, "%d ns | ERROR: msg %d on data set test --- txclk %1d txdata %8b done_printing %1d, expected %1d %8b %1d",
            rltime, num, txclk, txdata, done_printing, 0, selected_char, 0);
            errored = 1;
        end
        #10;
        if (txclk != 1) begin
          $fdisplay(STDERR, "%d ns | ERROR: msg %d on clock set test --- txclk %1d txdata %8b done_printing %1d, expected %1d %8b %1d",
            rltime, num, txclk, txdata, done_printing, 1, selected_char, 0);
            errored = 1;
        end
        #10;
        if (done_printing != 0 && len - 8 > 0) begin
          $fdisplay(STDERR, "%d ns | ERROR: msg %d on done_printing test while printing --- txclk %1d txdata %8b done_printing %1d, expected %1d %8b %1d",
            rltime, num, txclk, txdata, done_printing, 0, selected_char, 0);
            errored = 1;
        end
      end
      if (done_printing != 1) begin
        $fdisplay(STDERR, "%d ns | ERROR: msg %d on done_printing test 1 --- txclk %1d txdata %8b done_printing %1d, expected %1d %8b %1d",
          rltime, num, txclk, txdata, done_printing, 0, selected_char, 1);
          errored = 1;
      end
      #10;
      if (done_printing != 0) begin
        $fdisplay(STDERR, "%d ns | ERROR: msg %d on done_printing test 2 --- txclk %1d txdata %8b done_printing %1d, expected %1d %8b %1d",
          rltime, num, txclk, txdata, done_printing, 0, selected_char, 0);
          errored = 1;
      end
    end
    if (errored == 0) $display("All tests passed!");
    $finish_and_return(errored);
  end

endmodule



