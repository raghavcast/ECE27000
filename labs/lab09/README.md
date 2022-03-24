# Introduction to Sequential Logic

## Instructional Objectives

- To learn the basic functionality of an edge-triggered D flip-flop.
- To learn how to construct structural state machines in Verilog.
- To learn how to construct structural state machines with discrete logic.

## Introduction

In the past two labs, you build combinational logic systems, with Verilog and discrete logic, took a set of inputs and converted it into a specific type of output. With Verilog you've seen in homework how to connect these modules to produce a relatively more useful larger design.

However, you may notice that such designs aren't all that useful in the bigger context of digital design, especially when you consider that these designs can't actually store anything. This lab is an exploration into **sequential logic**, the component of digital design that allows us to write designs capable of maintaining or **storing**, state information.

You will test some simple sequential circuits. You will verify the operation of a typical edge-triggered D flip-flop, specify similar circuits using Verilog to try on the FPGA simulator, and with the understanding of the sequential logic devices discussed, implement a ring counter with Verilog and again with discrete logic.

## Step 0: Prelab

- Read the entire lab document.
- Do the prelab assignment on the course web page.

### Step 0.1: Construct a flip-flop test circuit

Falstad is a simple circuit simulator that allows you to mock up circuits on a website. We've embedded a version of it for you to use, as well as [instructions](https://engineering.purdue.edu/ece270/notes/falstad) on how to use it. We recommend watching the video on that page before tackling this assignment.

Construct and test the following circuit with a D-type flip-flop. To draw a flip-flop like this, choose Draw ... Digital Chips ... Add D Flip-Flop. Draw a flip-flop, and then double-click on it to get the dialog box that allows you to enable Set and Reset pins.

For the inputs, select Draw ... Logic Gates, Input and Output ... Add Logic Input.

To create labels, select Draw ... Outputs and Labels ... Add Labeled Node.

Be sure to press 'Save' further down on the page to preserve the circuit you have created.

### Step 0.2: Construct timing diagram

Graph the signals that result for the circuit you drew for Step 1 of the prelab. Assume that the propagation delay is much shorter than the step size of 1 second per division. In other words, when an input causes an output transition, you will see it at the same time as the signal that caused the transition. You should also assume that the initial state of the Q output of the flip-flop is 0.

### Step 0.3: Construct a four-flip-flop ring counter

Construct and test the following circuit with four D-type flip-flops. Be sure to press 'Save' further down on the page to preserve the circuit you have created. Make sure that the result of your circuit acts like a ring counter when the input labeled Clk has a positive edge transition.

### Step 0.4: Instantiate structural flip-flops in Verilog

Next, you will simulate a ring counter using Verilog. Let's do so in a manner more similar to how you will construct your lab experiment. In your lab experiment, you will use two 74HC74 dual-D-type flip-flops. Each of these chips contains two flip-flops. Each of those flip-flops has an **active-low** asynchronous reset (also called "clear") and an **active-low** asynchronous set (also called "preset").

Although a Verilog simulator can model any kind of logic, the Verilog simulator is strictly limited to disallow anything not supported by the FPGA we use for the class. For example, our simulator will not allow a flip-flop with **both** an asynchronous reset and a asynchronous set. Each flip-flop can have **either** a reset or a set.

We will use the two models provided for the 74HC74 in the course References directory. One of them has an active-low reset 'rn' and the other has an active-low set 'sn'. Each one has 'd', 'c', 'q', and 'qn' lines for the data input, clock input, Q output and inverted output, respectively. You can see the implementation of these modules as well. There are Verilog constructs that you likely have not seen before. For now, you can just use each model as an "opaque" box.

For this exercise, create a new simulator workspace named "lab9". Rename the default file tab from "template.sv" to "prelab4.sv". Start with the standard **top** module provided by the simulator. Append the module definitions for **hc74_reset** and **hc74_set** below **top**.

In the **top** module, create an instance of **hc74_reset** and connect its clock to pb\[0\], connect its data input to pb\[1\], and connect its non-inverted output (q) to right\[0\]. Connect its active-low asynchronous reset (rn) to the 'W' button (pb\[16\]). Use <shift>-click to press and hold the 'W' button to make sure pb\[16\] is high. With this, you have a system where the right\[0\] LED illuminates after a rising edge of the clock (0 button) when the '1' button is held down. If the right\[0\] is on, it is cleared the instant the 'W' button is released. This is the nature of an active-low reset.
  
Next, in the **top** module, create an instance of **hc74_set** and connect its clock to pb\[0\], connect its data input to pb\[1\], and connect its non-inverted output (q) to right\[1\]. Connect its active-low asynchronous set (sn) to the 'W' button (pb\[16\]). Use <shift>-click to press and hold the 'W' button to make sure pb\[16\] is high. With this, you have a system where the right\[1\] LED illuminates after a rising edge of the clock (0 button) when the '1' button is held down. If the right\[1\] is off, it is set the instant the 'W' button is released. This is the nature of an active-low set.

Test your system throroughly. Submit all three modules in the textbox below.

### Step 0.5: Create a 4-bit ring counter in Verilog 
  
Next, create a new file tab in the "lab9" workspace. (Make sure that you have "File simulation" selected rather than "Workspace simulation"!) Call the new file "prelab5.sv". In it, you will again start with the standard **top** module, add the **hc74_reset** and **hc74_set** modules, and then modify the contents of the top module.

In the top module, create a single instance of the **74hc_set** module and three instances of the **74hc_reset** module. Use whatever additional signals you need to create a ring counter similar to step 3, above. The active-low asynchronous set and reset ports should be connected to the 'W' button. The clock port on each flip-flop should be connected to the '0' button. The 'q' outputs of the flip-flops should be connected to right\[3:0\]. The system should work as follows:

- When the 'W' button is **released** (pb\[16\] goes low), the right[0] LED should light. The right\[3:1\] LEDs should turn off. This means that the flip-flop with the set/preset port should have its 'q' output connected to right[0]. All the flip-flops with reset/clear ports should be connected to right\[3:2\].
- While the 'W' button is held down (pb\[16\] remains high), each rising edge of the clock (pb\[0\]) will cause the next LED to the left to light up. This is to say, the pattern on right\[3:0\] should advance like so:

``` 
0001
0010
0100
1000
0001
0010
...
```
  
Once you have thoroughly tested your Verilog design, submit all three modules in the text box below.

Ready for the lab experiment? You will need:

- (2) 74HC74 dual D flip-flops
- (1) 74HC14 hex inverter with Schmitt-trigger inputs
- (4) LEDs (your choice of color)
- (4) 150 Ohm resistors
- (2) push buttons
- (3) 1K Ohm resistors
- (1) .1uF ceramic capacitor
- Optional:
  - LMC555 timer, resistors, and potentiometer from master lab kit
  
## Step 1: Build a 4-bit ring counter with discrete logic

  **This is a complex circuit. Before you jump into circuit-building, read the entire step, including the subsection "Tips for building a circuit" before you reach for your breadboard.**

  Consider the following circuit diagram, which is similar to one you simulated in the prelab. It implements a 4-bit ring counter. The theory of operation is that a reset button is connected to all of the flip-flops -- to either the set or reset inputs -- so that the system can be initialized to the 0001 state. When the clock button is pressed, the pattern rotates to the left: 0010, 0100, 1000, 0001, 0010, ...
  
<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/159822369-2861fcab-e0f3-4b59-87c3-cbb7368a47ca.png" alt="4-bit ring counter" width=700>
</p>

Each flip-flop in the diagram is implemented with half of a 74HC74 chip. This chip's set and reset inputs are *active-low*. This means that the "ResetN" signal is normally high. It goes low, when the button is pressed, to initialize the system. Note the way in which this signal is connected to set and reset pins of the flip-flops to initialize the system to 0001.

The Schmitt-trigger inverter whose output is connected to the clock is implemented with a 74HC14 chip. Notice the scary mess of resistors and capacitors in the lower right corner. What's this doing here? This is not an ECE 20007 lab!

Push buttons are mechanical devices that tend to *bounce*. This means that, each time a push button is pressed once, instead of cleaning switching from off-to-on, the button will have random off-on-off-on-off-on transitions. Each button press will look like multiple button presses. These random transitions are too fast to be seen by humans, but the clock of a flip-flop is sensitive to these quick transitions. Using a regular (bouncy) push button will cause multiple rising edges for the flip-flops. This will cause the system to advance by more than one state for a button press.

To avoid producing multiple transitions, a button connected to a clock must be *debounced*. This is the circuitry for doing so. The important thing to understand is that the R-C network slows the change of the input to the Schmitt-trigger inverter so that it does not register quickly as an on or off. Most logic gate inputs have problems with metastability when an input voltage level slowly transitions throught the *indeterminate voltage region*, but the Schmitt-trigger input is tolerant of the slowly-changing input since it has two threshold values.

When you get your circuit working, you might try removing the capacitor from the R-C circuit to see how it acts when the inverter input is not smoothed. You should see the ring counter sometimes advance by more than one state when the clock button is pressed. Sometimes, there is *parasitic capacitance* and other electrical factors that cause the inverter input to be smoothed even without additional capacitance.

### Tips for building your circuit
  
You should plan your circuit before starting to wire it up. Build it incrementally. First, wire the R-C circuit and the clock button. Use a spare Schmitt-trigger inverter with a LED with a 150Ω series resistor and a long wire as a *logic probe*. You can use this to test any signal.
  
<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/159822634-5d987e9e-69b5-4dda-804a-ea78e0d955ec.png" alt="logic probe" width=500>
</p>

Next, connect the inverter output to the clock input of each of the four flip-flops. Connect LEDs and series resistors to the Q output of each flip-flop.

Next, each flip-flop should have a single unused S and R input. Wire each one high.

Next, connect the useful S and R inputs of each flip-flop to the reset button. Use the logic probe to make sure that the reset signal is normally high and goes low when the reset button is pressed.

Finally, connect each Q<sub>x</sub> to D<sub>x+1</sub> and Q<sub>3</sub> to D<sub>0</sub>. Test your circuit thoroughly.
  
## Step 2: Test your circuit
  
Once your circuit works, connect your AD2 to the *test points* labeled in the circuit diagram as follows:

- DIO 0: ResetN
- DIO 1: ClkN
- DIO 2: Q0
- DIO 3: Q1
- DIO 4: Q2
- DIO 5: Q3

And ensure that the power and ground of the supply is connected to the appropriate power rails. You might manually test the inputs using the StaticIO tool. Once you have the circuit working as expected, use [Autolab](./lab9.lnx.labtest) to produce a confirmation code.
  
## Step 3: Submit your confirmation code
  
Once you have a completion code that indicates the quality of your work, upload it to the postlab page.
  
## Step 4: (Optional) Construct a periodic clock

One of the most common questions students ask when building circuits is how to build a low-speed periodic clock circuit. Your master lab kit contains everything you need to do this. Use the 8-pin LMC555 timer to build a bistable oscillator with the following circuit:
  
<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/159822958-b198ef10-3914-4163-98a4-10723540c3a0.png" alt="clock using 555 timer" width=400>
</p>
  
The circuit will produce a signal on pin 3 that can be used to drive an LED or use in place of the clock button for your lab experiment. By adjusting potentiometer R1, the frequency can be adjusted (roughly) between 4–8 Hz. A great deal has been written about the 555 timer. You can calculate the components needed for other frequencies using a popular [calculator page](http://www.555-timer-circuits.com/calculator.html).
