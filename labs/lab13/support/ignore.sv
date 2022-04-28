module lunarlander #(
  parameter FUEL=16'h800,
  parameter ALTITUDE=16'h4500,
  parameter VELOCITY=16'h0,
  parameter THRUST=16'h4,
  parameter GRAVITY=16'h5
)(
  input logic hz100, clk, rst,
  input logic [19:0] in,
  output logic [63:0] ss,
  output logic crash, land
);

endmodule
