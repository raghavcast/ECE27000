# Encoders and Multiplexers

## Instructional Objectives

- To understand the basic operation of encoders, decoders and multiplexers.
- To understand how to rewrite digital designs in Verilog to implement them on a simulated FPGA with breakout board.

## Introduction

An important part of hardware design is to be able to encapsulate and reuse code as ‘modules’ — specifically in Verilog. 
In this lab, you will practice implementing such building blocks and integrate them into an overall design. 
You will practice building a multiplexer with hardware to solidify your knowledge about this system in particular.

## Step 0: Prelab

- Read the **entire** lab document.
- Do the prelab assignment on the course web page.
- Build your 4-to-1 mux and verify it with AutoLab **before your lab section**, and submit the completion code in your prelab.

### Step 0.1: Implementing a 4-to-1 multiplexer in Verilog

Create a new file in the "lab8" workspace and rename it "step1.sv". In the top module, create an instance of a 4-to-1 multiplexer like so:

```
mux4to1 u1(.sel(pb[1:0]), .d(pb[7:4]), .y(green));
```

That is all you need to add to the top module. 
The goal of this exercise is to create a system that allows you to specify four values on buttons 7–4 and then select one of them with buttons 1 and 0.

Immediately below the top module, create a module named **mux4to1** with ports

- **output logic y**,
- **input logic [3:0]d**,
- **input logic [1:0]sel**,

In it, implement a 4-to-1 multiplexer. Here is an example of a 2-to-1 multiplexer in Verilog:

```
module mux2to1 (
    output logic y,
    input logic [1:0] d,
    input logic sel
);

  assign y = ~sel & d[0] |
              sel & d[1];

endmodule
```

You will have four 'd' inputs instead of two, and two 'sel' inputs instead of one, but the principle is the same.

Test your module well. Use \<shift\>-click on push buttons 7–4 to set the d[3:0] inputs to a persistent value. 
Then use buttons 1 and 0 to "select" one of those inputs. If buttons 7–4 are set to 1110, then pressing the 1 and 0 buttons as follows will show the result on the green LED:

<table align=center>
  <thead>
    <th align=center>sel[1]</th>
    <th align=center>sel[0]</th>
    <th align=center>green LED</th>
  </thead>
    <tr>
      <td align=center>0</td>
      <td align=center>0</td>
      <td align=center>0</td>
    </tr>
    <tr>
      <td align=center>0</td>
      <td align=center>1</td>
      <td align=center>1</td>
    </tr>
    <tr>
      <td align=center>1</td>
      <td align=center>0</td>
      <td align=center>0</td>
    </tr>
    <tr>
      <td align=center>1</td>
      <td align=center>1</td>
      <td align=center>1</td>
    </tr>
  <tbody>
    
  </tbody>
</table>

And you can see that sel[1:0] are the inputs and green is the output for an OR function. 
Changing d[3:0] to 0110 would implement an XOR function. 
Any two-variable Boolean expression can be implemented with a 4-to-1 mux. 
This is why multiplexers are used in an FPGA. 
The FPGA we use for this course is filled with 16-to-1 multiplexers that can naturally implement any 4-variable Boolean expression. 
These "logic cells" can be interconnected to form extremely complex designs.

When you have tested your design well, submit the file (including modules **top** and **mux4to1**).

### Step 0.2: Implement a 16-to-4 basic encoder in Verilog [10 points]

Create a SystemVerilog file in the "lab8" workspace of the simulator. Rename it "step2.sv". In the top module create a single instance:

```
enc16to4 u1(.in(pb[15:0]), .out(right[3:0]), .strobe(green));
```

Below the **top** module, create a new module named **enc16to4** with the following ports (in any order you like):
- **input logic [15:0] in**
- **output logic [3:0] out**
- **output logic strobe**

An encoder is a basic device that uses the 16-bit input to determine which of the 4 outputs to turn on. 
It "encodes" the input into the output by activating the binary encoding that corresponds to its number. Consider the example of an 8-to-3 encoder below:

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/157534752-7d8dc7d0-7197-447e-a35a-c2045ea82d11.png" alt="8to3enc" width=500>
</p>

In this example, input I7 has been turned on, while the rest of the inputs I6 through I0 remain off. 
The 3-bit binary form of this number is 3'b111, and so the encoder outputs 1 on all of its outputs. 
**Take note that this encoder does not have a strobe, but you are asked to implement one for this step.**

Follow this pattern to build a basic encoder with sixteen inputs, four outputs, and a strobe output signal. 
When any single input is asserted, the strobe output should be asserted, with the outputs indicating the binary encoding of the input as explained in the example above. 
For example, if in[5] is pressed, the strobe signal should be asserted, and the value of out[3:0] should be 4'b0101.

A basic encoder has a deficiency that multiple input assertions will result in a composite output. 
For instance, if in[5] and in[9] were asserted at the same time, the out signal will be 4'b1101 (which is the bitwise 'OR' of 4'b0101 and 4'b1001).
**We specifically want to see this behavior in your design, so you will not get any points if you submit a priority encoder, or other such device that ignores inputs in any way.** 
An effect of this deficiency is exhibited in the example of the 8-to-3 decoder below - observe that the inputs I5 and I2 are asserted, but the output shows 3'b111, or 7, which is obviously neither 5 nor 2.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/157535076-8c53febf-97bb-4b36-9541-8e2fea3310ca.png" alt="8to3enc" width=700>
</p>

To implement this module, set it up so that:
 
- out[3] is 1 when any of in[15:8] are asserted
- out[2] is 1 when any of in[15:12] or in[7:4] are asserted
- out[1] is 1 when any of in[15:14], in[11:10], in[7:6], in[3:2], are asserted
- out[0] is 1 when any of the odd-numbered elements of **in** are asserted

To test your design, press any of the push buttons from 'F' – '0'. You should see the binary-encoded result on the four rightmost red LEDs. 
When any of those sixteen buttons are pressed, the green center LED should also light up. In a later exercise, you will have a more intuitive way of testing your encoder.

When you have tested your design well, submit the file (including modules **top** and **enc16to4**).

### Step 0.3: Implement a 16-to-4 priority encoder in Verilog [10 points]

Create a SystemVerilog file in the "lab8" workspace of the simulator. Rename it "step3.sv". In the top module create a single instance:

```
prienc16to4 u1(.in(pb[15:0]), .out(right[3:0]), .strobe(green));
```

Below the **top** module, create a new module named **prienc16to4** with the following ports (in any order you like):

- **input logic [15:0] in**
- **output logic [3:0] out**
- **output logic strobe**

A priority encoder overcomes the deficiency with multiple input assertions that we saw in the previous step. 
For instance, if in[5] and in[9] were asserted at the same time, the out signal will be 4'b1001 since nine is greater than five.

You will build this priority encoder with sixteen inputs, four outputs, and a strobe output signal. 
When any single input is asserted, the strobe output should be asserted, and the binary encoding of the input. 
For instance, if in[5] is pressed, the strobe signal should be asserted, and the value of out[3:0] should be 4'b0101.

To implement this module, we provide an 8-to-3 priority encoder below. 
Modify it to have a four-bit output. 
**Be sure to use the port names and the module name listed above!**

```
/* 8-to-3 Priority Encoder */
module pri_enc(
  input logic [7:0] I,  // 7 - 0: highest - lowest priority
  output logic [2:0] E, // Encoded output
  output logic G        // Strobe output (asserted when any input)
);      

assign {E,G} = I[7] == 1 ? 4'b1111 /* Input 7 is high */ :
               I[6] == 1 ? 4'b1101 /* Input 6 is high */ :
               I[5] == 1 ? 4'b1011 /* Input 5 is high */ :
               I[4] == 1 ? 4'b1001 /* Input 4 is high */ :
               I[3] == 1 ? 4'b0111 /* Input 3 is high */ :
               I[2] == 1 ? 4'b0101 /* Input 2 is high */ :
               I[1] == 1 ? 4'b0011 /* Input 1 is high */ :
               I[0] == 1 ? 4'b0001 /* Input 0 is high */ :
                           4'b0000; // Nothing pressed.
endmodule
```

To test your design, press any of the push buttons from 'F' – '0'. 
You should see the binary-encoded result on the four rightmost red LEDs. 
When any of those sixteen buttons are pressed, the green center LED should also light up. 
If you press two or more buttons simultaneously, the higher value button will determine the value output from the encoder. 
In a later exercise, you will have a more intuitive way of testing your encoder.

When you have tested your design well, submit the file (including modules **top** and **prienc16to4**).

### Step 0.4: Implement a 4-to-1 multiplexer with discrete logic

Using discrete logic on a breadboard, implement the 4-to-1 mux shown in the schematic below.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/157535746-431881fa-c8ea-4c8b-bb83-ad5585f4756c.png" alt="circ-schem" width=600>
</p>
  
This schematic includes *test points* that are the intended connection points for the D3, D2, D1, D0, S1, S0, and Y signals. 
These are the points at which you should connect the AD2. 
There is also an unusual three-point terminal to the left of each resistor. 
That is meant to be the configuration for each D<sub>x</sub> input. 
You should arrange your resistors so that you can easily connect them to either V<sub>DD</sub> or ground. 
For example, consider the following wiring example:

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/157536085-622a05fb-23b4-48c2-9217-4395767ae738.png" alt="resistor 3pin" width=600>
</p>

Here, a resistor can be removed and adjusted to connect to either of the two power rails. 
For the picture, above, the D[3:0] inputs are set to 1110. 
In this case, the multiplexer is configured to act as an OR gate. 
The S[1:0] are the inputs to the OR gate, and the Y signal (not shown) is the output of the OR gate. 
The black squares roughly show the locations that the AD2 should be plugged in to.

Plan your work — perhaps print a copy of the schematic, and write pin numbers on the gate inputs and outputs. 
Wire your chips incrementally, testing as you go. 
Set the configuration resistors and manually test that your multiplexer produces the correct output. 
You might try setting only one of the Dx inputs to be high at a time, and make sure that only one of the four input combinations produces a '1' output.

### Test your work

Once you have determined that your circuit works correctly, attach the AD2 in the following way:

- connect AD2 DIO[3:0] to multiplexer inputs D[3:0], respectively
- connect AD2 DIO[5:4] to multiplexer inputs S[1:0], respectively
- connect AD2 DIO6 to multiplexer output Y

Use the [Autolab application](lab8.win.labtest) and the testbench to check your wiring and produce a completion code.

> **Once you produce a completion code, make sure to submit it before your lab section in your prelab submission.**

## Step 1: Implement a seven-segment decoder submodule in Verilog

Run the ece270-setup command again by double-clicking the shortcut on your desktop. 
A lab08 folder should now be added to the ece270 folder in your home directory. 
Inside it, open top.sv, and write a new module below the top module with the following specifications:

**From your prelab, copy the prienc16to4 module to your top.sv file, as you will use it to simplify testing for your ssdec module.**

- Module name: ssdec
- Module instance name: sd
    - **This is very important! The module and instance names must match!**
- Module ports:
    - **in**: 4-bit input port
    - **enable**: 1-bit input port
    - **out**: 7-bit output port
- Top module instance connections:
    - **in**: Connected to pb[3:0]
    - **enable**: Connected to 1'b1
    - **out**: Connected to ss0[6:0]

The module instance must start with:

```
ssdec sd (...
```

Follow the development shown [here](https://engineering.purdue.edu/ece270/lab/lab8/sssdec.pdf) on how to build a seven-segment display decoder. 
This module has four data inputs and a 7-bit output. 
It configures the outputs so that a four bit binary value is displayed as a hexadecimal digit on a 7-segment display. 
The third port, enable, determines if any of the outputs are asserted. If enable is not asserted, the output should remain off. 
This is a convenient way to turn off the entire digit if needed.

The 7-bit output, when connected to one of ss0, ss1... ss6 or ss7 must look like this for the corresponding value of the input:

     _         _    _         _    _    _    _    _    _         _         _    _ 
    | |    |   _|   _|  |_|  |_   |_     |  |_|  |_|  |_|  |_   |     _|  |_   |_  
    |_|    |  |_    _|    |   _|  |_|    |  |_|    |  | |  |_|  |_   |_|  |_   |   
     
Once you have written the submodule and instantiated it in the top module with the connections as explained above, test your design. 
Run "make cram" as you did for lab 4, correct any errors, and observe the behavior on the FPGA. 
Press any of the push buttons from 'F' – '0'. 
You should see the corresponding hexadecimal digit on the rightmost seven-segment display.

Once that you have verified that your design is working for all combinations of pb[3:0], you can connect the input of your ssdec to the output of the priority encoder you wrote for your prelab (prienc16to4). 
Also connect the ssdec enable port to the strobe output of the decoder. 
(If you're confused about how to connect the ports of two separate instances, recall how to use an intermediate signal/bus to connect the ports). 
This will allow us to simply press one button (0 through F) to see the digit on the display.

> **Demonstrate your new ssdec module to your TA to get checked off. Show that pressing 0 shows 0 on ss0, 1 shows 1, 2 shows 2, and so on.**

## Step 2: Verify your seven-segment decoder submodule in GTKwave

Verifying your ssdec module is crucial because you will use it in nearly every lab from here on out. 
To ensure it meets our expectations, we will run it against a testbench to check if it functions correctly.

In Kate, if it doesn't exist already, add the "make verify" target to your Build output tab, and execute it. 
If you have no errors, a trace waveform should appear, similar to the one below:

<p align=center>
    <img src="https://user-images.githubusercontent.com/37441514/157537814-5faf025d-670e-4fad-90a6-ef2f65e3e035.png" alt="verify waveforms" width=600>
</p>

The first half of the testbench checks that the enable of your ssdec is functioning properly - the output should be low when the enable is also low, regardless of the changing input "in". 
The second half turns on that enable port, and then cycles through the input between 0 and 15, which produces the respective seven-segment code accordingly.

> **Once you have verified your ssdec module and shown it to your TA, save it in your postlab submission.**

## Step 3: Clean up and log out

After logging out, make sure to take everything you brought with you on your way out. 
Notify a TA as you are leaving to ensure that you do not lose points on the lab. 
**Please do not restart the lab machine. If you are having trouble logging out, do not leave until you have notified a TA of your issue to avoid losing points on the lab.**
