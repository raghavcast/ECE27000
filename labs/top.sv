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
  assign ss0[7:0] = pb[7:0];
  
  bargraph u4(.in(pb[15:0]), .out({left[7:0], right[7:0]}));
  
  decode3to8 u5(.in(pb[2:0]), .out({ss7[7], ss6[7], ss5[7],ss4[7],ss3[7],ss2[7],ss1[7],ss0[7]}));
  
endmodule

// Add more modules down here...
module bargraph(
  input logic [15:0] in,
  output logic [15:0] out
);

 assign out = {in[15],
               |in[15:14],
               |in[15:13],
               |in[15:12],
               |in[15:11],
               |in[15:10],
               |in[15:9],
               |in[15:8],
               |in[15:7],
               |in[15:6],
               |in[15:5],
               |in[15:4],
               |in[15:3],
               |in[15:2],
               |in[15:1],
               |in[15:0]};

endmodule

module decode3to8(
  input  logic [2:0] in,
  output logic [7:0] out
);

  assign out[0] = ~in[2]&~in[1]&~in[0];
  assign out[1] = ~in[2]&~in[1]&in[0];
  assign out[2] = ~in[2]&in[1]&~in[0];
  assign out[3] = ~in[2]&in[1]&in[0];
  assign out[4] = in[2]&~in[1]&~in[0];
  assign out[5] = in[2]&~in[1]&in[0];
  assign out[6] = in[2]&in[1]&~in[0];
  assign out[7] = in[2]&in[1]&in[0];

endmodule