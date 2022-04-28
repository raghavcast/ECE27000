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
  count8du c8_1 (.clk(hz100), .rst(reset), .enable(1'b1), .DIR(1'b0), .out(ctr), .MAX(8'd49));
  
   hangman hg (.hz100(hz100), .reset(pb[19]), .hex(pb[15:10]), .ctrdisp(ss7[6:0]), .letterdisp({ss3[6:0], ss2[6:0], ss1[6:0], ss0[6:0]}), .win(green), .lose(red), .flash(flash)); 
  
  logic flash;
  logic hz1;
  logic [7:0] ctr;
  
  //assign blue = flash;
  
  always_ff @ (posedge hz100, posedge reset) begin
    if (reset == 1'b1)
      hz1 = 0;
    else 
      hz1 = (ctr == 8'd49);
  end 
  
  always_ff @ (posedge hz1, posedge reset) begin
    if (reset == 1'b1)
      flash = 1'b0;
    else
      flash = ~flash;
  end
endmodule

// Add more modules down here...
module count8du (
  input logic clk,
  input logic rst,
  input logic enable,
  input logic DIR,
  input logic [7:0] MAX,
  output reg [7:0] out
);
  reg[7:0] next_Q;
  reg [7:0] Q;
  assign out = Q;
  always_ff @ (posedge clk, posedge rst) begin
    if (rst == 1'b1)
      Q <= 8'b00000000;
    else if (enable == 1'b1)
      Q <= next_Q;
  end   
  
  always_comb begin
    if (DIR == 1'b0) begin
      if (Q == 8'd0) 
        next_Q = MAX;
      else
        next_Q = Q - 1;
    end
    else begin
      if (Q == MAX)
        next_Q = 8'd0;
      else
        next_Q = Q + 1;
    end
  end
endmodule

module ssdec (
  input logic [3:0] in,
  input logic enable,
  output logic [6:0] out
);
  assign out = (enable == 1'b1)? 
               (in == 4'b0000)? 7'b0111111 :
               (in == 4'b0001)? 7'b0000110 :
               (in == 4'b0010)? 7'b1011011 :
               (in == 4'b0011)? 7'b1001111 :
               (in == 4'b0100)? 7'b1100110 :
               (in == 4'b0101)? 7'b1101101 :
               (in == 4'b0110)? 7'b1111101 :
               (in == 4'b0111)? 7'b0000111 :
               (in == 4'b1000)? 7'b1111111 :
               (in == 4'b1001)? 7'b1100111 :
               (in == 4'b1010)? 7'b1110111 :
               (in == 4'b1011)? 7'b1111100 :
               (in == 4'b1100)? 7'b0111001 :
               (in == 4'b1101)? 7'b1011110 :
               (in == 4'b1110)? 7'b1111001 :
               7'b1110001 : 7'b0000000;
endmodule
