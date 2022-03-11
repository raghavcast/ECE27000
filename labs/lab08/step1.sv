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
  mux4to1  u1 (.sel(pb[1:0]), .d(pb[7:4]), .y(green));
  
endmodule

// Add more modules down here...
module mux4to1 (
  input logic [1:0] sel,
  input logic [3:0] d,
  output logic y
);

  assign y = (sel == 2'b00)? d[0] :
             (sel == 2'b01)? d[1] :
             (sel == 2'b10)? d[2] :
             (sel == 2'b11)? d[3] :
             1'b0;

endmodule
