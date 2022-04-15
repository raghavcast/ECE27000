module verdle (
  input logic clk, rst,
  input logic txready, rxready,
  output logic txclk, rxclk, 
  input logic [7:0] rxdata,
  output logic [7:0] txdata,
  output logic [63:0] ssout
);
endmodule