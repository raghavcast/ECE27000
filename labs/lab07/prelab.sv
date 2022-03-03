`default_nettype none
// Empty top module

module top (
  // I/O ports
  input  hz100, reset,
  input  [20:0] pb,
  output [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output red, green, blue,

  // UART ports
  output [7:0] txdata,
  input  [7:0] rxdata,
  output txclk, rxclk,
  input  txready, rxready
);

  // Your code goes here...
  logic [15:0] p;
  logic R, S, T, U;
  assign R = pb[3];
  assign S = pb[2];
  assign T = pb[1];
  assign U = pb[0];
  hc138 leftHalf (.e1(1'b0), .e2(R), .e3(1'b1), .a({S, T, U}), .y(p[7:0]));
  hc138 rightHalf (.e1(1'b0), .e2(1'b0), .e3(R), .a({S, T, U}), .y(p[15:8]));
  assign right[0] = ~(p[0] & p[3] & p[9]);
  assign right[1] = ~(p[12] & p[14] & p[15]);
  assign right[2] = ~(p[5] & p[10] & p[11]);
  assign right[3] = ~(p[1] & p[6] & p[8]);
  assign right[4] = ~(p[4] & p[7] & p[13]);
  assign right[5] = (p[4] & p[13]);
  assign right[6] = (p[6] & p[7]);
  assign right[7] = (p[1] & p[8]);
endmodule

// Add more modules down here...
// A SystemVerilog implementation of the 74HC138
// 3-to-8 decoder with active-low outputs.
module hc138(input logic e1,e2,e3,
             input logic [2:0]a,
             output [7:0]y);

  logic enable;
  logic [7:0] ypos;  // uninverted y
  assign enable = ~e1 & ~e2 & e3;
  assign ypos = { enable &  a[2] &  a[1] &  a[0],
                  enable &  a[2] &  a[1] & ~a[0],
                  enable &  a[2] & ~a[1] &  a[0],
                  enable &  a[2] & ~a[1] & ~a[0],
                  enable & ~a[2] &  a[1] &  a[0],
                  enable & ~a[2] &  a[1] & ~a[0],
                  enable & ~a[2] & ~a[1] &  a[0],
                  enable & ~a[2] & ~a[1] & ~a[0] };
  assign y = ~ypos;
endmodule