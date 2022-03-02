# Simple Designs in Verilog

## Instructional Objectives
- To learn how to convert a given digital circuit design into Verilog.
- To learn how to use the Verilog simulator to synthesize and simulate these designs.
- To learn how to write a design that can drive the output LEDs based on the values asserted via the input pushbuttons of the virtual FPGA breakout board.
- To learn how to use a waveform viewer to read signal traces to provide a better understanding of outputs changing in response to changing inputs.

## Introduction

In this lab, you will design a very simple Verilog module to display characters on the seven-segment display on the ice40HX8K Evaluation Board that will be on your lab bench when you go for your lab section. You will start by writing basic code to connect buttons to the seven segments on a seven-segment display, create a bar graph display module, and implement a simple 3-to-8 decoder.

## Step 0: Prelab

- If you haven't already, register for access to the [ECE 270 Verilog FPGA simulator](https://verilog.ecn.purdue.edu/), and take the tutorial.
- Use the simulator to write your prelab code on your own computer - it does not have to be done in lab.
- Read the **entire** lab document.
- Do the prelab assignment on the course web page.

> ### STOP HERE. Please read the following note in its entirety.
> There is an important distinction that students typically fail to make between Verilog and other computer languages:
> 
> **Verilog is not a programming language, it is a hardware description language.**
> 
> When you are writing Verilog code, you are **not writing a traditional program** - you are **designing hardware**. Not keeping this in mind will cause serious problems in understanding higher-level design concepts, influencing your approach to future design labs for the worse.

> ### STOP HERE. Please read the following note in its entirety.
> Every semester, there ends up being a code submission that utilizes SystemVerilog code taken from outside ECE 270, which results in an academic dishonesty violation when another student uses the same source unintentionally, or otherwise.
> 
> For your own sake, please do not use resources from outside the class to try to learn SystemVerilog, at least for the next five labs. In addition to a possible academic dishonesty violation, the code you might try to use may not even be supported in the simulator or may be beyond the scope of what is needed for the course.
> 
> **You should be reading the notes, re-reading them, attending lectures, looking for similar questions or asking them on Piazza, and then finally asking course staff in office hours.**
> 
> **You should *not* be asking other students or people outside of course staff for help**. This is a class aimed at developing every individual student's personal understanding of digital design, which is not possible if you end up working together on a lab. Set aside enough time to work on your labs so that you aren't tempted to ask for or use help from unauthorized sources.

## Step 1: Light up LED segments with button presses

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156309198-3e0a58f5-29b7-4308-a0e7-527116d10a2d.png" alt="ss" width=100>
</p>

The figure above shows the named segments of the eight SS seven-segment displays present on the display. The pin numbers on the display are just for your information. The display is made up of seven segments, each with its own pin, as well as a decimal point (DP), also with its own segment. When you connect a pin for a segment to power (and add the necessary grounds) the segment will light up.

You can write Verilog to do this. Write code to connect 7 buttons (pb[6:0]) to the seven segments of ss0(ss0[6:0]). This should be implemented in the 'top' module. The decimal point is the 8th bit of the seven-segment display, but we will not be using that in this lab. If written correctly, pressing pb[0] will light up segment A, pb[1] will light up segment B, pb[2] will light up segment C, and so on.

> **Demonstrate the code you wrote to your TA to receive a checkoff. It should be on the FPGA, not the web simulator**

## Step 2: Implement and verify a module for a bar graph display

**Do not remove any of your code from the previous step.**

In your top.sv file, create a new module named 'bargraph' that has two ports:

- a 16-bit input bus port named 'in'
- and a 16-bit output bus port named 'out'

Within the module, use dataflow assignments so that if in[n] is pressed, the bits out[n], out[n-1]... until out[0] are set to '1' (or a logic high). In other words, if in[15] is asserted, the bits out[15], out[14], out[13]... out[1], out[0] are all asserted. If in[8] is asserted, out[8], out[7]... out[1], out[0] are asserted, while out[15], out[14]... out[9] are all turned off.

In the 'top' module, create an instance of the 'bargraph' module. You get to choose the instance name for it. Use name-based port connections. Connect pb[15:0] to the bargraph instance's 'in' port. Connect {left[7:0],right[7:0]} to the bargraph instance's 'out' port.

The end result of this instantiation is that pressing the 'F' button will illuminate all 16 of the left and right LEDs, pressing the '0' button will illuminate only right[0], and any button between 'F' and '0' will turn on that number of LEDs + 1.

The details of implementation of the 'bargraph' module is up to you. The suggested method of implementation is to use an OR expression for each of the 'out' elements. The out[0] output will be the result of the OR of 16 inputs. The out[1] output will be the result of an OR of 15 inputs. If you know how to use Verilog reduction operators, you may do so. If you don't, ask a TA.

> **Show your working design on the FPGA to a TA to receive a checkoff for this step.**

## Step 3: Implement a module for a 3-to-8 decoder

**Do not remove any of your code from the previous step.**

In your top.sv file, implement a 3-to-8 decoder. The specifics for this decoder are:

- The name of the module should be 'decode3to8'.
- Outputs of the decoder module should be active-high.
- There is one 3-bit input port named 'in'.
- There is one 8-bit output port named 'out'.
- There is no *enable* line for this decoder. Therefore, exactly one of its outputs is always asserted.

The decoder should be constructed so that out[0] signal is asserted if and only if the in[2:0] bus value is 3'b000, the out[1] signal is asserted if and only if the in[2:0] bus value is 3'b001, and so on up to out[7]. Implementation details are left to you, but you are encouraged to use the format provided below as a guide:

```
 assign out[0] = ~in[2]&~in[1]&~in[0];  // bus value 3'b000
 assign out[1] = ~in[2]&~in[1]&in[0];   // bus value 3'b001
 ....
 ```
 
 Create an instance of the 'decode3to8' module in your 'top' module. Use an instance name of your choosing. Make the following connections:

- Connect pb[2:0] to the instance's 'in' port.
- Connect each of the decimal points on the seven-segment displays (ss7, ... , ss0) to the 'out' port. The decimal point is element 7 of each of the ssx buses. You will need to concatenate element 7 of each bus into a single 8-bit bus connected to the 'out' port. You might need to think about this for a while.

The end result is that if no buttons are pressed, the decimal point of ss0 should be illuminated. If button 0 is pressed, to send a 3'b001 to the decoder input, the decimal point of ss1 should illuminate (and the decimal point of ss0 should turn off). If buttons '2', '1', and '0' are pressed, only the decimal point of ss7 should be illuminated.

> **Show your working design to a TA to receive a checkoff for this step.**

## Step 4: Verify your first Verilog submodules

Designing hardware in Verilog is often complemented with a verification step. Verifying hardware is incredibly important because bugs in hardware are not as easily fixed with a software update - once the hardware has been fabricated onto silicon, any hardware "bugs" are literally set in stone. Companies invest just as much into hardware design as much as they do its verification, in order to insure their bottom line.

Since you are only learning Verilog for the first time, we will provide the necessary tools to verify your code. Verification is done by writing a testbench file that instantiates your top module, driving inputs and reading outputs, and printing out any unexpected output values with error messages. For this lab, we provide the testbenches needed to verify the modules you just wrote.

Once you have checked off your modules with a TA, add a new target to Kate's Build Output menu with the title 'verify', and with the command 'make clean; make verify'. Click the checkbox for this new target, and then run the command.

If you see any "ERROR"s in the Kate Build Output, you'll need to figure out what your modules are missing. This is how you **verify** your modules.

If all is well, you should see the same compilation output, but instead of flashing your design to the FPGA, a new window should appear similar to the picture below:

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156309784-fb26a141-eb4c-4d80-8991-5a01eae231a5.png" alt="verification of output" width=600>
</p>

There are two tests that run in the testbench - one for the bargraph module, and the other for the decoder module. What you are seeing is a waveform made up of **traces** - the red or green lines that indicate if a certain signal is high or low.

Scroll down to look at the value of the pushbuttons are. Try to match the inputs to how you would physically push the buttons - for example, for the bargraph tests, observe how only 1 bit of pb is on at a time, starting from pb[0] and ending at pb[15]. This is effectively the same as pressing pushbuttons 0 through F in order, one by one.

Scroll back up, and observe how the inputs are changing the outputs - if you correctly implemented your module, the outputs should match the ones shown in the picture above. This part verifies your bargraph module.

The testbench then waits a bit, then starts running a binary counter on pb[3:0] - note the specific pattern on the corresponding bits under pb, and note the outputs that it produces on the decimal points of the ssX displays. This part verifies the decoder module.

> **Show both trace outputs to your TA to receive checkoffs for this step.**

## Step 5: Post-lab submission

All of the modules and instances for steps 1, 2, and 3 can coexist. Once you have confirmed your modules are working properly and *simultaneously*, submit the entirety of your [top.sv file](top.sv).

## Step 6: Clean up your lab station and log out

> If you find your lab station unresponsive, **do not restart the computer**. Notify a TA and we'll take care of it.

Ensure that your station is free of breadboard debris like small jumper wires and resistors. Pull the oscilloscope/DMM cables up above the monitors so they don't hang in front of the monitor, and be sure that you have logged out of your lab station. Your TA should confirm that your station is clean and logged out.
