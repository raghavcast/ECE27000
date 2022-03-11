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

  // Your code goes here...`default_nettype none
  enc16to4 u1 (.in(pb[15:0]), .out(right[3:0]), .strobe(green));
  
endmodule

// Add more modules down here...
module enc16to4 (
    input logic [15:0] in,
    output logic [3:0] out,
    output logic strobe
);

    assign strobe = |in;
    assign out[3] = |in[15:8];
    assign out[2] = |in[15:12] | |in[7:4];
    assign out[1] = |in[15:14] | |in[11:10] | |in[7:6] | |in[3:2];
    assign out[0] = in[1] | in[3] | in[5] | in[7] | in[9] | in[11] | in[13] | in[15];

endmodule
