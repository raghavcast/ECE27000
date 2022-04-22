`default_nettype none
 Empty top module

module top (
   IO ports
  input  hz100, reset,
  input  [200] pb,
  output [70] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output red, green, blue,

   UART ports
  output [70] txdata,
  input  [70] rxdata,
  output txclk, rxclk,
  input  txready, rxready
);

   Your code goes here...
  logic hzX;
  logic [70] ctr;
  
  count8du c8_1 (.clk(hz100), .rst(reset), .enable(1'b1), .out(ctr), .dir(1'b0), .MAX(8'd25));
  
  lunarlander #(16'h800, 16'h4500, 16'h0, 16'h5) ll (
    .hz100(hz100), .clk(hzX), .rst(reset), .in(pb[190]), .crash(red), .land(green),
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

 Add more modules down here...
module count8du (
  input logic clk,
  input logic rst,
  input logic enable,
  input logic dir,
  input logic [70] MAX,
  output reg [70] out
);
  reg[70] next_Q;
  reg [70] Q;
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

  always @()
    case ({a, b, ci}) 
      3'b000 {co, s} = 2'b00;
      3'b001 {co, s} = 2'b01;
      3'b010 {co, s} = 2'b01;
      3'b011 {co, s} = 2'b10;
      3'b100 {co, s} = 2'b01;
      3'b101 {co, s} = 2'b10;
      3'b110 {co, s} = 2'b10;
      3'b111 {co, s} = 2'b11;
    endcase
endmodule

module fa4 (
  input logic [30] a,
  input logic [30] b,
  input logic ci,
  output logic [30] s,
  output logic co
);

  wire co0, co1, co2;
  fa f0 (.a(a[0]), .b(b[0]), .ci(ci), .s(s[0]), .co(co0));
  fa f1 (.a(a[1]), .b(b[1]), .ci(co0), .s(s[1]), .co(co1));
  fa f2 (.a(a[2]), .b(b[2]), .ci(co1), .s(s[2]), .co(co2));
  fa f3 (.a(a[3]), .b(b[3]), .ci(co2), .s(s[3]), .co(co));
endmodule

module bcdadd1 (
  input logic [30] a,
  input logic [30] b,
  input logic ci,
  output logic [30] s,
  output logic co
);
  wire [30] s0;
  wire co0;
  assign co = co0  (s0[3] && s0[2])  (s0[3] && s0[1]);
  fa4 f0 (.a(a), .b(b), .ci(ci), .s(s0), .co(co0));
  fa4 f1 (.a({1'b0, co, co, 1'b0}), .b(s0), .ci(1'b0), .s(s));
endmodule

module bcdadd4 (
  input logic [150] a,
  input logic [150] b,
  input logic ci,
  output logic [150] s,
  output logic co
);
  wire co0, co1, co2;
  bcdadd1 ba0 (.a(a[30]), .b(b[30]), .ci(ci), .s(s[30]), .co(co0));
  bcdadd1 ba1 (.a(a[74]), .b(b[74]), .ci(co0), .s(s[74]), .co(co1));
  bcdadd1 ba2 (.a(a[118]), .b(b[118]), .ci(co1), .s(s[118]), .co(co2));
  bcdadd1 ba3 (.a(a[1512]), .b(b[1512]), .ci(co2), .s(s[1512]), .co(co));
endmodule

module bcd9comp1 (
  input logic [30] in,
  output reg [30] out
);
  
  always @ () 
    case (in)
      4'b0000 out = 4'b1001;
      4'b0001 out = 4'b1000;
      4'b0010 out = 4'b0111;
      4'b0011 out = 4'b0110;
      4'b0100 out = 4'b0101;
      4'b0101 out = 4'b0100;
      4'b0110 out = 4'b0011;
      4'b0111 out = 4'b0010;
      4'b1000 out = 4'b0001;
      4'b1001 out = 4'b0000;
    endcase
endmodule

module bcdaddsub4 (
  input logic [150] a,
  input logic [150] b,
  input logic op,
  input logic cin,
  output reg [150] s
);

  wire [150] sadd, ssub, bcomp;
  bcdadd4 badd (.a(a), .b(b), .ci(0), .s(sadd));
  bcdadd4 bsub (.a(a), .b(bcomp), .ci(1), .s(ssub));
  
  bcd9comp1 b0(.in(b[30]), .out(bcomp[30]));
  bcd9comp1 b1(.in(b[74]), .out(bcomp[74]));
  bcd9comp1 b2(.in(b[118]), .out(bcomp[118]));
  bcd9comp1 b3(.in(b[1512]), .out(bcomp[1512]));
  
  assign s = (op == 1'b0) sadd  ssub;
endmodule

module ssdec (
  input logic [30] in,
  input logic enable,
  output logic [60] out
);
  assign out = (enable == 1'b1) 
               (in == 4'b0000) 7'b0111111 
               (in == 4'b0001) 7'b0000110 
               (in == 4'b0010) 7'b1011011 
               (in == 4'b0011) 7'b1001111 
               (in == 4'b0100) 7'b1100110 
               (in == 4'b0101) 7'b1101101 
               (in == 4'b0110) 7'b1111101 
               (in == 4'b0111) 7'b0000111 
               (in == 4'b1000) 7'b1111111 
               (in == 4'b1001) 7'b1100111 
               (in == 4'b1010) 7'b1110111 
               (in == 4'b1011) 7'b1111100 
               (in == 4'b1100) 7'b0111001 
               (in == 4'b1101) 7'b1011110 
               (in == 4'b1110) 7'b1111001 
               7'b1110001  7'b0000000;
endmodule