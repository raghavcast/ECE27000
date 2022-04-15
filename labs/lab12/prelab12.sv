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
  count8du c8_1 (.clk(hz100), .rst(reset), .enable(1'b1), .out(right));
endmodule

// Add more modules down here...
module count8du (
  input logic clk,
  input logic rst,
  input logic enable,
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
    if (Q == 8'd99) 
      next_Q = 8'd0;
    else
      next_Q = Q + 1;
  end
endmodule
