`default_nettype none
// Empty top module

module top (
  // I/O ports
  input logic  hz100, reset,
  input logic  [20:0] pb,
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,

  // UART ports
  output logic [7:0] txdata,
  input logic  [7:0] rxdata,
  output logic txclk, rxclk,
  input logic  txready, rxready
);

  logic [15:0] y;

  decoder u4(.e(1'b1), .a(pb[3:0]), .y(y));

  assign y = {left,right}; // for debugging

  logic a,b,c,d,e,f,g;
  assign ss0[6:0] = {g,f,e,d,c,b,a}; // connect A-G to ss0

  // Your segment decode statements go below.
  assign a = ~(y[1] | y[4] | y[11] | y[13]);
  assign b = ~(y[5] | y[6] | y[11] | y[12] | y[14] | y[15]);
  assign c = ~(y[2] | y[12] | y[14] | y[15]);
  assign d = ~(y[1] | y[4] | y[7] | y[9] | y[10] | y[15]);
  assign e = ~(y[1] | y[3] | y[4] | y[5] | y[7] | y[9]);
  assign f = ~(y[1] | y[2] | y[3] | y[7] | y[13]);
  assign g = ~(y[0] | y[1] | y[7] | y[12]);
endmodule

module decoder(
  input logic e,
  input logic [3:0] a,
  output logic [15:0] y
);

  logic [15:0] ypos; // ypos is the positively-asserted version of the output
  assign y = { e &  a[3] &  a[2] &  a[1] &  a[0],
               e &  a[3] &  a[2] &  a[1] & ~a[0],
               e &  a[3] &  a[2] & ~a[1] &  a[0],
               e &  a[3] &  a[2] & ~a[1] & ~a[0],
               e &  a[3] & ~a[2] &  a[1] &  a[0],
               e &  a[3] & ~a[2] &  a[1] & ~a[0],
               e &  a[3] & ~a[2] & ~a[1] &  a[0],
               e &  a[3] & ~a[2] & ~a[1] & ~a[0],
               e & ~a[3] &  a[2] &  a[1] &  a[0],
               e & ~a[3] &  a[2] &  a[1] & ~a[0],
               e & ~a[3] &  a[2] & ~a[1] &  a[0],
               e & ~a[3] &  a[2] & ~a[1] & ~a[0],
               e & ~a[3] & ~a[2] &  a[1] &  a[0],
               e & ~a[3] & ~a[2] &  a[1] & ~a[0],
               e & ~a[3] & ~a[2] & ~a[1] &  a[0],
               e & ~a[3] & ~a[2] & ~a[1] & ~a[0] };
endmodule