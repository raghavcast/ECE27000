`default_nettype none
// Empty top module

module top (
  // I/O ports
  input  logic hz100, reset,
  input  logic [20:0] pb,
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,

  // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready
);

  // Your code goes here...
  //fr_counter frc (.clk(hz100), .rst(reset), .enable(pb[0]), .out(right));
  
  //wordcmp wcmp (.guessed("desert"), .selected("design"), .in_word(right[5:0]), .in_place(left[5:0]));
  
  /*printer prn (
  .clk(hz100), .rst(reset), // clock and async reset for flip-flops
  .num(pb[2:0]),            // select the message
  .activate(pb[3]),         // when high, start printing and ignore until finished printing
  .txready(txready),        // let us know when ready to transmit
  .char_in("a"),            // for repeating characters entered by user (we'll just use the character 'a' for now)
  .txclk(txclk),            // UART "clock"
  .txdata(txdata),          // UART data out
  .done_printing(green)     // indicate when done
  );*/
  
  ssdisplay ssd (.in_place(pb[5:0]), .in_word(pb[13:8]), .ssout({ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0}));
endmodule

// Add more modules down here...
module fr_counter (
  input logic clk,
  input logic rst,
  input logic enable,
  output reg [7:0] out
);
  reg [7:0] out_next;
  assign out_next = (out == 8'b11111111)? 8'b00000000: out + 1;
  always_ff @ (posedge clk, posedge rst) begin
    if (rst == 1'b1)
      out <= 8'b00000000;
    else if (enable == 1'b1)
      out <= out_next;
  end
endmodule

module wordcmp (
  input logic [47:0] guessed,
  input logic [47:0] selected,
  output reg [5:0] in_word,
  output reg [5:0] in_place
);
  assign in_place = {
    (guessed[47:40] == selected[47:40])? 1'b1 : 1'b0,
    (guessed[39:32] == selected[39:32])? 1'b1 : 1'b0,
    (guessed[31:24] == selected[31:24])? 1'b1 : 1'b0,
    (guessed[23:16] == selected[23:16])? 1'b1 : 1'b0,
    (guessed[15:8] == selected[15:8])? 1'b1 : 1'b0,
    (guessed[7:0] == selected[7:0])? 1'b1 : 1'b0
  };
  
  always_comb begin
    case (guessed[47:40])
      selected[39:32], selected[31:24], selected[23:16], selected[15:8], selected[7:0]: in_word[5] = 1'b1;
      default: in_word[5] = 1'b0;
    endcase
    case (guessed[39:32])
      selected[47:40], selected[31:24], selected[23:16], selected[15:8], selected[7:0]: in_word[4] = 1'b1;
      default: in_word[4] = 1'b0;
    endcase
    case (guessed[31:24])
      selected[47:40], selected[39:32], selected[23:16], selected[15:8], selected[7:0]: in_word[3] = 1'b1;
      default: in_word[3] = 1'b0;
    endcase
    case (guessed[23:16])
      selected[47:40], selected[39:32], selected[31:24], selected[15:8], selected[7:0]: in_word[2] = 1'b1;
      default: in_word[2] = 1'b0;
    endcase
    case (guessed[15:8])
      selected[47:40], selected[39:32], selected[31:24], selected[23:16], selected[7:0]: in_word[1] = 1'b1;
      default: in_word[1] = 1'b0;
    endcase
    case (guessed[7:0])
      selected[47:40], selected[39:32], selected[31:24], selected[23:16], selected[15:8]: in_word[0] = 1'b1;
      default: in_word[0] = 1'b0;
    endcase
  end
endmodule

module printer (
  input logic clk,
  input logic rst,
  input logic [2:0] num,
  input logic activate,
  input logic txready,
  input logic [7:0] char_in,
  output reg txclk,
  output reg [7:0] txdata,
  output reg done_printing
);
  // Sets of messages from which the printer will select one, and send out
  logic [511:0] msg [7:0];
  assign msg[0] = {272'b0, "Ready to play? Press any key: "};
  assign msg[1] = {440'b0, "\r\nGuess: "};
  assign msg[2] = {152'b0, "You win!  Press 3-0-W on the FPGA to reset.\r\n"};
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
  
  // this section sets the number of characters for each message
  // so that the printer knows where to stop
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
  
  // are we printing anything at all? 
  reg printing;
  // if true, set data before clock, otherwise assert clock
  reg set_data;

  // use the indentation to determine whether a statement falls beneath an if/else statement!
  always_ff @ (posedge clk, posedge rst)
    if (rst == 1'b1) begin
      txclk <= 0;
      txdata <= 0;
      done_printing <= 0;
      printing <= 0;
      set_data <= 0;
    end
    else begin
      if ((activate == 0) && (printing == 0) && (done_printing == 1))
        done_printing <= 0;
      else if ((activate == 1) && (printing == 0)) begin
        set_data <= 0;       // reinitializing for a new message to be printed
        printing <= 1;       // bookkeeping to know that a message is being printed
        done_printing <= 0;  // if we're just starting to print, we can't be done printing!  
        len <= senlen;       // initialize length to length of message, and count down by 8 bits (1 letter)
      end
      else if ((printing == 1) && (len == 0)) begin
        printing <= 0;       // we're done printing, don't print any more!
        txclk <= 0;          // reset for when we need to print the next message
        set_data <= 0;       // reset for when we need to print the next message
        done_printing <= 1;  // we're done printing, so indicate that to the controller
      end
      else if ((txready == 1) && (printing == 1)) begin
        if (~set_data)  begin   // set our data BEFORE clock, so that we do not have setup time violations
          if ((num == 3'b011) && (char_in == 8'd127))            // if the character being received is a backspace
            txdata <= 8'd8;                      // send the code for a backspace to make your cursor move left!
          else
            txdata <= msg[num][(len - 1) -: 8];
            // (len - 1) -: 8, in Verilog, can be expanded to (len-1) : (len-1-(8-1))
            // so if you're trying to send the last character, len would be 8, which 
            // would cause the expression to evaluate to [7:0]
          txclk <= 0;
          set_data <= 1;
        end
        else begin
          txclk <= 1;
          set_data <= 0;
          len <= len - 8;
        end
      end
    end
endmodule

module ssdisplay (
  input logic [5:0] in_word,
  input logic [5:0] in_place,
  output reg [63:0] ssout
);

  localparam CHAR_G = 8'b01101111;
  localparam CHAR_O = 8'b00111111;
  localparam CHAR_D = 8'b01011110;
  localparam CHAR_J = 8'b00001111;
  localparam CHAR_B = 8'b01111100;
  localparam CHAR_Y = 8'b01101110;
  
  always_comb begin
    if (&in_place == 1)
      ssout = {CHAR_G, CHAR_O, CHAR_O, CHAR_D, 8'b0, CHAR_J, CHAR_O, CHAR_B};
    else begin
      // for each letter, show G if the letter is in the right place,
      // show Y if the letter exists in the word but isn't in the right place, 
      // otherwise show a blank.
      // use a ternary operator for this
      
      ssout[63:56] = 0;     // we only have six letters
      ssout[55:48] = (in_place[5] == 1)? CHAR_G : (in_word[5] == 1)? CHAR_Y : 8'b0;
      ssout[47:40] = (in_place[4] == 1)? CHAR_G : (in_word[4] == 1)? CHAR_Y : 8'b0;
      ssout[39:32] = (in_place[3] == 1)? CHAR_G : (in_word[3] == 1)? CHAR_Y : 8'b0;
      ssout[31:24] = (in_place[2] == 1)? CHAR_G : (in_word[2] == 1)? CHAR_Y : 8'b0;
      ssout[23:16] = (in_place[1] == 1)? CHAR_G : (in_word[1] == 1)? CHAR_Y : 8'b0;
      ssout[15:8] = (in_place[0] == 1)? CHAR_G : (in_word[0] == 1)? CHAR_Y : 8'b0;
      ssout[7:0] = 0;       // we only have six letters
    end
  end

endmodule
