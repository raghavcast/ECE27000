/******************************************************************************
YOU ARE NOT PERMITTED TO USE ANYTHING FROM THIS FILE IN YOUR OWN CODE.
ANY ATTEMPT TO DO SO WILL BE CONSIDERED AN INSTANCE OF ACADEMIC DISHONESTY.
******************************************************************************/

`timescale 1ms/10ps
module tb_ssdisplay();
  logic [5:0] in_place, in_word;
  logic [63:0] ssout;

  ssdisplay ssd (.in_place(in_place), .in_word(in_word), .ssout(ssout));

  // send errors to stderr, not stdout :P
  integer STDERR = 32'h8000_0002;
  // keep track of time for labeling
  integer rltime;
  initial rltime = 0;
  always #1 rltime = rltime + 1;

  localparam HYPHEN = 8'b01000000;
  localparam CHAR_G = 8'b01101111;
  localparam CHAR_O = 8'b00111111;
  localparam CHAR_D = 8'b01011110;
  localparam CHAR_J = 8'b00001111;
  localparam CHAR_B = 8'b01111100;
  localparam CHAR_Y = 8'b01101110;
  localparam BLANK = 8'b0;

  integer errored;
  logic [63:0] corrbus;
  integer inp, inw;
  logic [7:0] corrss [7:0];

  initial begin
    $dumpfile("build/ssdisplay.vcd");
    $dumpvars(0, tb_ssdisplay);
    errored = 0; in_place = 0; in_word = 0;
    #1;
    if (ssout != {HYPHEN, BLANK, BLANK, BLANK, BLANK, BLANK, BLANK, HYPHEN}) begin
      $fdisplay(STDERR, "%d ns | ERROR: power-on test | Expected but did not get '-      -' when in_place = in_word = 0");
      errored = 1;
    end
    for (inp = 0; inp <= 6'h3F; inp++) begin
      in_place = inp[5:0];
      for (inw = 0; inw <= 6'h3F; inw++) begin
        in_word = inw[5:0];
        #1;
        corrss[7] = &in_place ? CHAR_G : 8'b01000000;     // we only have six letters
        corrss[6] = &in_place ? CHAR_O : in_place[5] ? CHAR_G : in_word[5] ? CHAR_Y : 8'b0;
        corrss[5] = &in_place ? CHAR_O : in_place[4] ? CHAR_G : in_word[4] ? CHAR_Y : 8'b0;
        corrss[4] = &in_place ? CHAR_D : in_place[3] ? CHAR_G : in_word[3] ? CHAR_Y : 8'b0;
        corrss[3] = &in_place ? BLANK  : in_place[2] ? CHAR_G : in_word[2] ? CHAR_Y : 8'b0;
        corrss[2] = &in_place ? CHAR_J : in_place[1] ? CHAR_G : in_word[1] ? CHAR_Y : 8'b0;
        corrss[1] = &in_place ? CHAR_O : in_place[0] ? CHAR_G : in_word[0] ? CHAR_Y : 8'b0;
        corrss[0] = &in_place ? CHAR_B : 8'b01000000;       // we only have six letters
        corrbus = {corrss[7], corrss[6], corrss[5], corrss[4], corrss[3], corrss[2], corrss[1], corrss[0]};
        if (ssout != corrbus) begin
          $fdisplay(STDERR, "%d ns | ERROR: ssdisplay test | Did not get expected value when in_place = %6b, in_word = %6b", in_place, in_word);
          errored = 1;
        end
      end
    end
    if (errored == 0) $display("All tests passed!");
    $finish_and_return(errored);
  end

endmodule