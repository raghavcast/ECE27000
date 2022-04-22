# Adders and the Lunar Lander

## Instructional Objectives
- To learn about and practice Verilog implementations of common arithmetic operations.
- To learn about and practice implementing and integrating complex modules.
- To practice implementation of sequential state machines.

## Step 0: Prelab


### Step (1): A half-adder [10 points]

Construct a half-adder module. The module should be named ha. It should have two single-bit inputs named a and b. It should have two single-bit outputs named s (sum) and co (carry-out).

You can instantiate and test the half-adder module with the following:
```
ha h1(.a(pb[0]), .b(pb[1]), .s(right[0]), .co(right[1]));
```

### Step (2): A full adder built from two half-adders [10 points]

Construct a full adder by instantiating two of the ha half-adder modules you designed for the previous step. You'll need to use an additional OR gate (use a dataflow OR expression) to create the carry-out of the full adder.

The full adder module should be named faha. It should have three input ports named a, b, and ci (carry-in). It should have two output ports named s (sum) and co.

You can instantiate and test the full-adder module with the following:
```
faha f1(.a(pb[0]), .b(pb[1]), .ci(pb[2]), .s(right[0]), .co(right[1]));
```

### Step (3): A full adder built from scratch [10 points]

Construct a full adder by writing dataflow expressions for the outputs or by constructing a case statement for each combination of the inputs. Do not instantiate modules you designed for the previous steps.

The full adder module should be named fa. It should have three input ports named a, b, and ci (carry-in). It should have two output ports named s (sum) and co.

You can instantiate and test the full-adder module with the following:

```
fa f1(.a(pb[0]), .b(pb[1]), .ci(pb[2]), .s(right[0]), .co(right[1]));
```

Make sure that it satisfies the truth table shown in the previous question.

### Step (4): A four-bit full adder [10 points]

Construct a four-bit full adder by creating four instances of the fa module you made in the previous step.

This four-bit full adder module should be named fa4. Inside of this module, you should create four instances of the fa module with the carry-out of each one connected to the carry-in of the next most significant adder. It should have two four-bit input ports named a and b, and a single-bit input named ci (carry-in). It should have a four-bit output port named s (sum) and a single bit output port named co (carry-out).

You can instantiate and test the full-adder module with the following:

```
fa4 f1(.a(pb[3:0]), .b(pb[7:4]), .ci(pb[19]), .s(right[3:0]), .co(right[4]));
```

so that the '3'...'0' buttons represent a four-bit input operand, the '7'...'4' buttons represent the second four-bit input operand, and the 'Z' button is the carry-in. The right[3:0] show the sum, and the right[4] shows the carry-out.

### Step (5): A single-digit BCD adder [10 points]

Construct a single-digit (4-bit) BCD adder. This is just a four-bit binary adder with the correction circuit, which is just another instance of the a four-bit binary adder, as shown in the diagram below. Use the diagram to write the Verilog necessary to implement a BCD adder. (Keep in mind that + means OR, so you need a pipe symbol "|", and that * means AND, so you need an ampersand "&").

This module should be named bcdadd1. Inside this module, create an instance of the fa4 adder you constructed in a previous step. The module should have two four-bit input ports named a and b, and a single-bit input named ci (carry-in). It should have a four-bit output port named s (sum) and a single bit output port named co (carry-out).

You can instantiate and test this module with the following:
```
  logic co;
  logic [3:0] s;
  bcdadd1 ba1(.a(pb[3:0]), .b(pb[7:4]), .ci(pb[19]), .co(co), .s(s));
  ssdec s0(.in(s), .out(ss0[6:0]), .enable(1));
  ssdec s1(.in({3'b0,co}), .out(ss1[6:0]), .enable(1));
  ssdec s5(.in(pb[7:4]), .out(ss5[6:0]), .enable(1));
  ssdec s7(.in(pb[3:0]), .out(ss7[6:0]), .enable(1));
```

so that the '3'...'0' buttons represent a four-bit input operand, the '7'...'4' buttons represent the second four-bit input operand, and the 'Z' button specifies the carry-in. The ss7 and ss5 displays will show the input operands, and the ss1/ss0 combination will show the two-digit decimal sum.

Note the use of the ssdec module, which will require you to import it from an earlier lab. Keep it available during your lab session as well. You do not need to include ssdec in any of your prelab submissions.

### Step (6): A four-digit BCD adder [10 points]

Construct an four-digit (16-bit) BCD adder.

This module should be named bcdadd4. Inside this module, create four instances of the bcdadd1 adder you constructed in the previous step. Chain the carry-out of each one to the carry-in of the next more significant single-digit BCD adder. The module should have two 16-bit input ports named a and b, and a single-bit input named ci (carry-in). It should have a 16-bit output port named s (sum) and a single bit output port named co (carry-out).

It's rather difficult to test something like this by pressing buttons. Instead, create successive iterations of static values in the top module instantiation. For instance, you can instantiate and test this module with the following:

```
  logic co;
  logic [15:0] s;
  bcdadd4 ba1(.a(16'h1234), .b(16'h1111), .ci(0), .co(red), .s(s));
  ssdec s0(.in(s[3:0]),   .out(ss0[6:0]), .enable(1));
  ssdec s1(.in(s[7:4]),   .out(ss1[6:0]), .enable(1));
  ssdec s2(.in(s[11:8]),  .out(ss2[6:0]), .enable(1));
  ssdec s3(.in(s[15:12]), .out(ss3[6:0]), .enable(1));
```

You should see the result 2345 on the seven-segment displays. If you change the inputs to 16'h9876 and 16'h3333, the output should show 3209, and the red LED will be illuminated to indicate carry-out. Be sure to try cases with the ci input port set to 1.

### Step (7): A nine's-complement circuit [10 points]

Construct a BCD nine's-complement circuit. This is a simple combinational module that accepts a four-bit BCD digit, x, and outputs the digit the value 9-x. You can implement it as a case statement.

This module should be named bcd9comp1. It has one four-bit input in and one four-bit output out.

You can instantiate and test this module with the following:

```
  logic [3:0] out;
  bcd9comp1 cmp1(.in(pb[3:0]), .out(out));
  ssdec s0(.in(pb[3:0]), .out(ss0[6:0]), .enable(1));
  ssdec s1(.in(out),     .out(ss1[6:0]), .enable(1));
```

pb[3:0] accept a four-bit BCD digit that will be displayed on ss0. The nine's complement should be displayed on ss1. The sum of the digits displayed on ss0 and ss1 should always be 9. It does not matter what is displayed if the input value is greater than 9 (larger than a BCD number).

### Step (8): A four-digit ten's-complement adder/subtracter [10 points]

Construct a four-digit BCD ten's-complement adder/subtracter module. This is analogous to how you created the 4-bit binary adder/subtracter. With that module, you computed the one's-complement of the second operand to the adder and then added one to it by setting the carry-in of the adder. This was effectively equivalent to adding the two's-complement inverse to perform a subtraction.

In this case, you're going to compute the nine's-complement of each BCD digit (using the bcd9comp1 module you just made), and selectively use that as the input to a four-digit BCD adder (bcdadd4) that you constructed earlier. When you carry one into the bcdadd4, you effectively add the ten's-complement inverse to perform a subtraction.

Of course, the result will be a ten's-complement negative number, which will look very strange. We'll do a better job of displaying that in the lab.
This module should be named bcdaddsub4. It has two 16-bit inputs a and b. It has another one-bit input named op that indicates (0) addition of A+B or (1) subtraction of A-B. It has a 16-bit output named s (sum). There's no need to have a carry-out for this module.

Once again, it's difficult to test this by pressing buttons. Instead, you can repeatedly instantiate and test this module with static operands:

```
  logic [15:0] s;
  bcdaddsub4 bas4(.a(16'h0000), .b(16'h0001), .op(1), .s(s));
  ssdec s0(.in(s[3:0]),   .out(ss0[6:0]), .enable(1));
  ssdec s1(.in(s[7:4]),   .out(ss1[6:0]), .enable(1));
  ssdec s2(.in(s[11:8]),  .out(ss2[6:0]), .enable(1));
  ssdec s3(.in(s[15:12]), .out(ss3[6:0]), .enable(1));
```

For this example, the 7-segment displays should show 9999, which is the ten's complement way of saying -1.

## Introduction
You have been tasked with the great responsibility of writing an arithmetic unit for a lander headed for the Moon! We will have you implement adder/subtractor modules in order to realize an arithmetic logic unit for this lander. This unit, unlike the regular one that's in most CPUs, will be used to calculate the altitude, vertical velocity, and fuel of such a lander probe.

For the context of this experiment, we will make the following simplifying assumptions:

- The lander starts at some height over the Moon, and the gravity of the Moon, at 5 ft/s<super>2</super>, will cause the lander to start falling towards the ground.
- The force of gravity is counteracted by the lander's thrust setting, which can be set anywhere between 0 to 9 ft/s<super>2</super>. As a result, you could turn off the thrusters to free fall towards the Moon (0 ft/s2), or engage them at highest thrust (9 ft/s<super>2</super>).
- Your lander will either crash or land. It will crash if the downward lander velocity is larger than 30 ft/s or the thrust is higher than 5 - otherwise, it will land.

**What's happening?** The lunar lander starts 4500 feet above the Moon. The initial thrust is set to 4, and gravity is set to 5, so you start picking up speed at the rate of (4 - 5) = 1 ft/s<super>2</super>. As downward velocity increases, your altitude starts dropping. The thrust is then adjusted to 0, in order to maximize the effect of gravity on the lander, and therefore pick up speed faster.

Around the point where the velocity reaches -80 to -90 ft/s, we set a thrust of 5 ft/s to counteract gravity, and therefore keep our velocity constant.

At 1500 ft, we set full thrust by setting it to 9 ft/s<super>2</super>, in order to start decreasing our downward velocity so that we don't crash due to our high velocity. Once we reach a downward velocity less than 30 ft/s, we can set thrust back to 5 to let the lander continue descent at a constant velocity.

Notice that when the altitude reaches a value near zero, the green light turns on to indicate that we have safely landed. If our velocity was greater than 30 ft/s, or the thrust was bigger than 5 ft/s<super>2</super>, we would have crashed.

Understanding the physics behind this isn't terribly crucial to the experiment, since your main focus will just be the implementation of the physics itself. This is an example of a design where you may be asked to implement something you may not fully understand, so you would try to stick with the parametrics given to you.

## Step 0: Prelab

- Read the entire lab document.
- Do the [prelab assignment](https://engineering.purdue.edu/ece270/submit/?item=prelab13) on the course web page.

## Instantiating the Lunar Lander on the simulator before your lab

If you're here after finishing your prelab, and you'll like to try it out on the simulator, perform the following steps:

- Copy the **bcdaddsub4** module (and the modules it depends on) from your prelab, and your **ssdec** module from lab 8, to a new tab called lab13.sv beneath the top module.
- Complete Step 1 further down on this page to set up a slower clock and instantiate the lunar lander.
- Import the Lunar Lander design by clicking on the gear icon next to your workspace name, and ticking the box for "lunarlander.sv". This tells the simulator to include the overall Lunar Lander controller that you instantiate later.
- Finally, press Simulate.

## Step 1: Instantiate the Lunar Lander, set up a slower clock, and demonstrate it

**Run the ece270-setup script to get the necessary files for lab13.**

Open the lab 13 folder inside the ece270 folder and double-click on lunarlander.sv. Copy the **bcdaddsub4** module (and the modules it depends on) from your prelab, and your **ssdec** module from lab 8 beneath the top module.

The **lunarlander** module, if clocked at 100 Hz, will probably run too fast for you to properly read the altitude/velocity/fuel values as they update on every loop through the state machine. Thus, we actually allow for two clock ports in the module - one for the regular 100 Hz **hz100** clock in the top module, and a clock divided from **hz100** that the module will use to simulate the landing. We use the slower clock to allow for easier viewing of lander parameters as they update, and use the hz100 clock to update the thrust.

**Note that when you actually run your design and try to change the thrust, it will only change upon the next rising edge of the slower clock, and not immediately - this is intentionally done to avoid setup time violations.**

Using knowledge from previous labs, implement a slower clock in the **top** module, and connect it to a new logic signal, hzX. The frequency is up to you - keep in mind that you don't want it too fast that you can't read the values as they update, and you don't want it too slow that you and your TA end up awkwardly watching the board waiting for the lander to land. We used 4 Hz.

Then, instantiate the lunar lander module as follows:

```
lunarlander #(16'h800, 16'h4500, 16'h0, 16'h5) ll (
  .hz100(hz100), .clk(hzX), .rst(reset), .in(pb[19:0]), .crash(red), .land(green),
  .ss({ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0})
);
```

If you're directly using the instantiation above, your "lander" will do the following:

- It will appear 4500 feet above the moon, so your altitude will show 4500.
- It will stay in the same exact spot, since thrust and gravity are set equal to each other at 5 ft/s2. Velocity was initialized to 0, so it'll stay that way until you change the thrust.
- It will consume fuel (or gas on the display) at the rate of 5 units/clock cycle. The fuel should not run out, otherwise you will no longer be able to turn on your lander's thrusters!

> Try toggling the display selectors to show altitude/velocity/fuel/thrust using Z/Y/X/W respectively, and use them to try to land your shuttle as shown in the video. >If your design works the same way as the video on the top of the page (not necessarily with the exact same values), great job! Attempt a crash as well, and show both > scenarios to a TA to get checked off.
> 
> You don't need to submit anything in your post-lab.

## Step 2: Clean up your lab station and log out

> If you find your lab station unresponsive, **do not restart your computer**. Notify a TA and we'll take care of it.

Ensure that your station is free of breadboard debris like small jumper wires and resistors. Pull the oscilloscope/DMM cables up above the monitors so they don't hang in front of the monitor, and be sure that you have logged out of your lab station. Your TA should confirm that your station is clean and logged out.
