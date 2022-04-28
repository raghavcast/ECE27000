`default_nettype none
// Empty top module

module top (
  // IO ports
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
  logic hzX;
  logic [7:0] ctr;
  
  count8du c8_1 (.clk(hz100), .rst(reset), .enable(1'b1), .out(ctr), .dir(1'b0), .MAX(8'd25));
  
  lunarlander ll (
    .hz100(hz100), .clk(hzX), .rst(reset), .in(pb[19:0]), .crash(red), .land(green),
    .ss({ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0})
  );
  
  always_ff @ (posedge hz100, posedge reset) begin
    if (reset == 1)
      hzX = 0;
    else begin
      hzX = (ctr == 8'd12);  
    end
  end
endmodule

// Add more modules down here...
module count8du (
  input logic clk,
  input logic rst,
  input logic enable,
  input logic dir,
  input logic [7:0] MAX,
  output reg [7:0] out
);
  reg[7:0] next_Q;
  reg [7:0] Q;
  assign out = Q;
  always_ff @ (posedge clk, posedge rst) begin
    if (rst == 1'b1)
      Q = 8'b00000000;
    else if (enable == 1'b1)
      Q = next_Q;
  end   
  
  always_comb begin
    if (dir == 1) begin
      if (Q == MAX) 
        next_Q = 8'd0;
      else
        next_Q = Q + 1;
    end
    else begin
      if (Q == 8'd0)
        next_Q = MAX;
      else
        next_Q = Q - 1;
    end
  end
endmodule

module fa (
  input logic a,
  input logic b,
  input logic ci,
  output reg s,
  output reg co
);

  always_comb
    case ({a, b, ci}) 
      3'b000: {co, s} = 2'b00;
      3'b001: {co, s} = 2'b01;
      3'b010: {co, s} = 2'b01;
      3'b011: {co, s} = 2'b10;
      3'b100: {co, s} = 2'b01;
      3'b101: {co, s} = 2'b10;
      3'b110: {co, s} = 2'b10;
      3'b111: {co, s} = 2'b11;
      default: {co, s} = 2'b00;
    endcase
endmodule

module fa4 (
  input logic [3:0] a,
  input logic [3:0] b,
  input logic ci,
  output logic [3:0] s,
  output logic co
);

  wire co0, co1, co2;
  fa f0 (.a(a[0]), .b(b[0]), .ci(ci), .s(s[0]), .co(co0));
  fa f1 (.a(a[1]), .b(b[1]), .ci(co0), .s(s[1]), .co(co1));
  fa f2 (.a(a[2]), .b(b[2]), .ci(co1), .s(s[2]), .co(co2));
  fa f3 (.a(a[3]), .b(b[3]), .ci(co2), .s(s[3]), .co(co));
endmodule

module bcdadd1 (
  input logic [3:0] a,
  input logic [3:0] b,
  input logic ci,
  output logic [3:0] s,
  output logic co
);
  wire [3:0] s0;
  wire co0;
  assign co = co0 || (s0[3] && s0[2]) || (s0[3] && s0[1]);
  fa4 f0 (.a(a), .b(b), .ci(ci), .s(s0), .co(co0));
  fa4 f1 (.a({1'b0, co, co, 1'b0}), .b(s0), .ci(1'b0), .s(s));
endmodule

module bcdadd4 (
  input logic [15:0] a,
  input logic [15:0] b,
  input logic ci,
  output logic [15:0] s,
  output logic co
);
  wire co0, co1, co2;
  bcdadd1 ba0 (.a(a[3:0]), .b(b[3:0]), .ci(ci), .s(s[3:0]), .co(co0));
  bcdadd1 ba1 (.a(a[7:4]), .b(b[7:4]), .ci(co0), .s(s[7:4]), .co(co1));
  bcdadd1 ba2 (.a(a[11:8]), .b(b[11:8]), .ci(co1), .s(s[11:8]), .co(co2));
  bcdadd1 ba3 (.a(a[15:12]), .b(b[15:12]), .ci(co2), .s(s[15:12]), .co(co));
endmodule

module bcd9comp1 (
  input logic [3:0] in,
  output reg [3:0] out
);
  
  always_comb 
    case (in)
      4'b0000: out = 4'b1001;
      4'b0001: out = 4'b1000;
      4'b0010: out = 4'b0111;
      4'b0011: out = 4'b0110;
      4'b0100: out = 4'b0101;
      4'b0101: out = 4'b0100;
      4'b0110: out = 4'b0011;
      4'b0111: out = 4'b0010;
      4'b1000: out = 4'b0001;
      4'b1001: out = 4'b0000;
      default: out = 4'b0000;
    endcase
endmodule

module bcdaddsub4 (
  input logic [15:0] a,
  input logic [15:0] b,
  input logic op,
  input logic cin,
  output reg [15:0] s
);

  wire [15:0] sadd, ssub, bcomp;
  bcdadd4 badd (.a(a), .b(b), .ci(0), .s(sadd));
  bcdadd4 bsub (.a(a), .b(bcomp), .ci(1), .s(ssub));
  
  bcd9comp1 b0(.in(b[3:0]), .out(bcomp[3:0]));
  bcd9comp1 b1(.in(b[7:4]), .out(bcomp[7:4]));
  bcd9comp1 b2(.in(b[11:8]), .out(bcomp[11:8]));
  bcd9comp1 b3(.in(b[15:12]), .out(bcomp[15:12]));
  
  assign s = (op == 1'b0)? sadd : ssub;
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
