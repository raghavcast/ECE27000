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
  wire [3:0] buttons;
  wire en_wire;
  
  prienc16to4 penc (.in(pb[15:0]), .out(buttons), .strobe(en_wire));
  
  ssdec sd (.in(buttons), .enable(en_wire), .out(ss0[6:0]));
  
endmodule

// Add more modules down here...
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

module prienc16to4 (
    input logic [15:0] in,
    output logic [3:0] out,
    output logic strobe
);

    assign {out, strobe} = (in[15] == 1)? 5'b11111 :
                           (in[14] == 1)? 5'b11101 :
                           (in[13] == 1)? 5'b11011 :
                           (in[12] == 1)? 5'b11001 :
                           (in[11] == 1)? 5'b10111 :
                           (in[10] == 1)? 5'b10101 :
                           (in[9] == 1)? 5'b10011 :
                           (in[8] == 1)? 5'b10001 :
                           (in[7] == 1)? 5'b01111 :
                           (in[6] == 1)? 5'b01101 :
                           (in[5] == 1)? 5'b01011 :
                           (in[4] == 1)? 5'b01001 :
                           (in[3] == 1)? 5'b00111 :
                           (in[2] == 1)? 5'b00101 :
                           (in[1] == 1)? 5'b00011 :
                           (in[0] == 1)? 5'b00001 :
                           5'b00000;

endmodule