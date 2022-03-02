# Measurement of Electrical and Timing Characteristics of Logic Gates

## Instructional Objectives
- To exercise construction techniques by constructing a complex circuit to achieve a useful purpose.
- To learn the purpose of electronic measurement devices like multimeters and oscilloscopes.
- To learn how to use those devices.
- To learn how to measure logic signal propagation times using an oscilloscope.

## Introduction
**For this lab, you will need your lab kit, the extra digital chips, and an AD2. Please read the entire document to determine what chips you may need, if any, and use them to complete circuit construction.**

You will construct an adder circuit that can be used to take two numbers as an input, and add them to produce a result. In addition, this lab will focus on calculating the propagation delay of individual gates, as well as the delay between first input and the change in output.

## Step 0: Prelab
- Do the prelab assignment on the course web page.
- Read this entire lab document so you can anticipate how long it will take to complete.
- **Build the circuits in Steps 1+2, and 3 (1 and 2 share circuits.)**

## Step 1: Inverter Threshold Voltage Measurements
In this experiment, you will determine your 74HC04 inverter's transition voltage thresholds (V<sub>T-</sub> and V<sub>T+</sub>). When the input voltage crosses this transition point (crossing either from high-to-low or low-to-high), the inverter will switch outputs accordingly.

To do so, use the waveform generator of the AD2 to set up a sine wave to use as an input to an inverter. Use the Scope tool on Waveforms to view both the input and the output of the inverter. When the inverter output switches from high to low, you know that the input has reached the V<sub>T+</sub> threshold to recognize it as a "high". When the inverter output switches from low to high, you know that the input has reached the V<sub>T-</sub> threshold to recognize it as a low.

### Procedure
Follow these steps to obtain your threshold voltage measurements:

1. Wire a 74HC04 inverter chip on your breadboard. Be sure to connect the power and ground pins to the appropriate buses. If you want to, you may connect the AD2 V+ and one of the Ground pins directly to the integrated circuit.
2. Invoke the WaveForms application and associate it with the AD2 system. In the "Welcome" menu, select the "Supplies". Select a supply voltage of 3.3 V, and **enable** the output.
3. Invoke the "Wavegen" tool in the WaveForms "Welcome" menu. Configure it as follows:
    - Type: Sine **(Feel free to use Triangle instead)**
    - Frequency: 1 kHz
    - Period: 1 ms
    - Amplitude: 1 V
    - Offset: 1 V
    - Symmetry: 50 %
    - Phase: 0°
  
      **And press the "Run" button to make it start.**

      The result should be a wave that varies from 0V to 2V. The 1 kHz frequency is slow enough that the propagation delay for the inverter is *negligible* compared to the wave change. This means that if you view the input and output on top of each other, the point at which the output transitions will be very close in time to the point where the input threshold is reached which caused the output transition. (In other words, if you used a high frequency input, there would be a visible delay on the scope between the input level that caused a transition and the output transition. Slow is good for this measurement.)

4. Connect the W1 pin of the AD2 to the input of one of the six inverters of the 74HC04.
5. Connect channel 1 of the Scope tool on Waveforms to the chosen input pin on your the inverter. Connect the positive pin(1+) to the input pin, and the negative pin (1-) to ground.
6. Connect channel 2 of the Scope tool on Waveforms to the corresponding output pin on your inverter. Connect the positive pin(2+) to the output pin, and the negative pin (2-) to ground.
7. Press the Auto Set button to get a clear view of the sine wave on your input (channel 1), and the resulting square wave on your output (channel 2).

The result should look something like the following:

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156279696-8e18be32-8d42-455d-92b6-b575027e6b29.png" alt="ad2 waveform" width=600> <br>
</p>

The yellow trace is channel 1 (inverter input), and the blue trace is channel 2 (inverter output). Be sure you are able to see a full cycle of the input and output waveforms. You may adjust the scope output by zooming in or out.

Now, press the X Cursors button on your Scope tool. Add two X Cursors and adjust them such that the X cursors coincide with where the blue output waveform falls and rises. Press the Y cursors on your Scope tool. Add two Y Cursors and adjust them such that they are where the placement of the X cursors coincides with the input waveform. It should look like the following:

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156279833-09f88c33-6426-4712-9ce3-e95e0131ed62.png" alt="inverted output" width=600> <br>
</p>

### Some notes on observations
Every inverter is different! No inverter is perfect! Your display should look vaguely like the one shown above, but it need not be exactly the same.

> Read the long note about the [counterfeit inverters](https://engineering.purdue.edu/ece270/refs/counterfeit/). If you have one of these inverters, you will see a slightly different pattern. **This is not a bad thing**. Even though the inverters are counterfeit, they still work well as digital inverters. You only see unexpected results because they're being subjected to slowly-changing analog levels.

### Step deliverables
> Once you have a scope view **similar to the second picture**, take note of the Y1 and Y2 readings on the top right of your Scope - these are the V<sub>T+</sub> and V<sub>T-</sub> attributes for your 74HC04. To export the Scope results, go to File -> Export. Select the Image tab to export this as a PNG file, change the Source to "Oscilloscope" on the export page and [submit it](./screenshots/step1_deliverable.png), along with the transition voltage values. **The cursors with the values measured should be clearly shown in your postlab submission to receive points for this step.**

## Step 2: Schmitt Inverter Voltage Threshold Measurements

In a real circuit, the closeness of the two transition points of the inverter would be problematic while dealing with input voltages that may fluctuate across these two close points. The Schmitt trigger is a special comparator circuit that overcomes this problem by effectively "cleaning" such noisy analog signals and converting it into a clean digital one, as the nature of this inverter causes the two transition points to be further away from each other, requiring low-to-high and high-to-low transitions on the input signal to be more pronounced if the output is to change.

### Measurement Procedure

The easiest way to obtain the measurements for Step 2 is to remove the 74HC04 inverter and replace it with a 74HC14 Schmitt-trigger inverter. The resulting graph should look similar to the one pictured below.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156280526-7e01bb36-7e98-442e-9d09-1ecb0bd8344d.png" alt="Schmitt trigger inverter" width=600>
</p>

The yellow trace is channel 1 (inverter input), and the blue trace is channel 2 (inverter output). Be sure you are able to see a full cycle of the input and output waveforms. You may adjust the Scope by zooming in or out.

Using the same instructions as the last step, set up the cursors in order to get the transition voltages for the 74HC14 gate now. It should look somewhat like the following:

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156280635-dc00da4a-d3a7-4bc5-90e2-b20e6d536138.png" alt="Schmitt trigger" width=600>
</p>

### Step Deliverables

> Once you have a scope view **similar to the second picture**, take note of the Y1 and Y2 readings on the top right of your Scope - these are the V<sub>T+</sub> and V<sub>T-</sub> attributes for your 74HC14. To export the Scope results, go to File -> Export. Select the Image tab to export this as a PNG file, change the Source to "Oscilloscope" on the export page and [submit it](./screenshots/step2_deliverable.png), along with the transition voltage values. **The cursors with the values measured should be clearly shown in your postlab submission to receive points for this step.**

## Step 3: Circuit Construction and Test

For this step, you will construct a digital system known as an *adder*. It adds two binary numbers to produce a binary sum. It is one of the most common combinational circuits. It is not necessary to fully understand the operation of this system, although it is not too difficult to do so if you want to. We use this system for two reasons:

- It has a well-defined set of inputs and outputs. This allows construction to be verified correct in a straightforward manner.
- It has a long path of gates so that a change in a single input will have to propagate through multiple gates, in sequence, before it affects an output. This creates a long *path delay* that allows us to appreciate the total amount of delay in the circuit as a result of many gates connected in series.

The kind of adder built is a two-bit adder. It accepts an input of two two-bit binary numbers (as well as a *carry-in* and produces a three-bit binary result. A two-bit binary adder can be constructed from two one-bit *full adders*.

### The Full Adder

A full adder accepts two one-bit binary inputs, as well as a *carry-in* and produces a one-bit sum and a *carry-out*. The carry-out can be thought as the upper bit of a two-bit sum. If the all three of the inputs are one, then the decimal sum of those bits should be 3. This is represented as a binary 11. This binary sum can be represented with two bits.

The truth table for the two outputs of the full adder can be easily derived using knowledge of conventional addition. In the table below, A and B are the one-bit binary inputs. Cin is the carry-in. All three of these inputs are *summed* together to produce the decimal sum. The binary representation of the decimal sum is represented by Cout and S.

For instance, if the A,B,Cin inputs are 1,0,1, the number of 1-bits in the input is 2. The binary representation of 2 is 10, so Cout=1 and S=0. 

<table align=center>
  <thead>
    <tr>
      <th colspan=3 align=center>Inputs</th>
        <th align=center>Decimal</th>
        <th colspan=2 align=center>Outputs</th>
        </tr>
        <tr>
          <th>A</th>
          <th>B</th>
          <th>C<sub>in</sub></th>
          <th>Sum</th>
          <th>C<sub>out</sub></th>
          <th>S</th>
        </tr>
  </thead>
  <tbody>
    <tr>
      <td align=center>0</td>
      <td align=center>0</td>
      <td align=center>0</td>
      <td align=center>0</td>
      <td align=center>0</td>
      <td align=center>0</td>
    </tr>
    <tr>
      <td align=center>0</td>
      <td align=center>0</td>
      <td align=center>1</td>
      <td align=center>1</td>
      <td align=center>0</td>
      <td align=center>1</td>
    </tr>
    <tr>
      <td align=center>0</td>
      <td align=center>1</td>
      <td align=center>0</td>
      <td align=center>1</td>
      <td align=center>0</td>
      <td align=center>1</td>
    </tr>
    <tr>
      <td align=center>0</td>
      <td align=center>1</td>
      <td align=center>1</td>
      <td align=center>2</td>
      <td align=center>1</td>
      <td align=center>0</td>
    </tr>
    <tr>
      <td align=center>1</td>
      <td align=center>0</td>
      <td align=center>0</td>
      <td align=center>1</td>
      <td align=center>0</td>
      <td align=center>1</td>
    </tr>
    <tr>
      <td align=center>1</td>
      <td align=center>0</td>
      <td align=center>1</td>
      <td align=center>2</td>
      <td align=center>1</td>
      <td align=center>0</td>
    </tr>
    <tr>
      <td align=center>1</td>
      <td align=center>1</td>
      <td align=center>0</td>
      <td align=center>2</td>
      <td align=center>1</td>
      <td align=center>0</td>
    </tr>
    <tr>
      <td align=center>1</td>
      <td align=center>1</td>
      <td align=center>1</td>
      <td align=center>3</td>
      <td align=center>1</td>
      <td align=center>1</td>
    </tr>
  </tbody>
</table>

The Boolean functions for this truth table is realized by the following circuit:

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156282885-533d4565-0234-44ea-8b37-c2d99ee87902.png" alt="schematic" width=600>
</p>

Again, you are not expected to understand the derivation of this circuit. You may visually inspect it to make sure that it realizes the functions shown by the truth tables.

### Applying DeMorgan's Law

You may notice that the full adder has two XOR gates, two AND gates, and an OR gate. There is, however, no OR gate in your parts kit. This is an excellent opportunity to demonstrate an application of DeMorgan's Law. Let's take only the AND-OR portion of the full adder and transform it.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156282976-e39e103d-3a3b-4fe8-8d2b-3027ee04ad5d.png" alt="DeMorgan's Law" width=600>
</p>

We can add inversion bubbles to each side of the AND-OR connection. When we do so we have NAND gates, and an OR gate with inverted inputs. DeMorgan's Law tells us that

        X' + Y' == (X · Y)'
        
so an OR gate with two inverted inputs is *equivalent* to a NAND gate. The leftmost figure of the diagram, above, shows the final result of the DeMorgan's Law transform. An AND-OR tree can always be transformed into a NAND-NAND tree. This is a helpful thing to realize, and it will be useful in future exercises.

### Chaining adders

Typically, multiple one-bit full adders can be *chained* together to form a multi-bit adder. This is done by dividing the binary addition into the 1's place, the 2's place, the 4's place, the 8's place, and so on for as many powers of two as needed. The carry-out from the 1's place is used as the carry-in for the 2's place. The carry-out from the 2's place is used as the carry-in for the 4's place.

A two-bit adder would be chained as shown below.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156283378-99803ce2-4171-4aef-9a2b-2702837c7a82.png" alt="2 bit adder" width=600>
</p>

And, of course, we could replace the AND-OR tree with a NAND-NAND tree to form a circuit that can be built with the components in your digital parts kit.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156283462-20da8e80-1155-453a-83d3-657dd226a74e.png" alt="2 bit adder in kit" width=600>
</p>

The **full schematic of the circuit to build for this lab is shown below**. Four buttons are used to provide the two two-bit inputs A1,A0 and B1,B0. The inputs are naturally in the "low" state unless a button is pressed to set them to the "high" state. The carry-in is held low by a pull-down resistor (you must use 10K ohm resistors). Points are labeled where the AD2 will be connected.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156283549-e40067fb-e53b-4bff-b578-e30720855e3e.png" alt="full schematic" width=600>
</p>

At first glance at this schematic, it may look like this could take a very long time to assemble. All that is required is some planning and guidelines for where to put things to make the implementation as quick and convenient as possible. You are welcome (and encouraged) to do your own implementation. Otherwise, you may follow the step-by-step instructions below.

### Insert chips and push buttons

Insert the chips and push buttons in the order and placement shown below. Note the hole numbers on the breadboard. You may use these numbers as a guide. The chips are places precisely so that wires can be inserted between them. Add the 10k pull-down resistors to the push buttons in the locations shown. Finally, connect each chip and push button to the power and ground buses. (All the ground buses are connected together and all the power buses are connected together on the other side of the board.)

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156283640-22d4af50-0bc4-4f02-b446-fe45907c9a09.png" alt="push buttons and chips" width=600>
</p>

### Wire full adder "0"

Next, wire full adder "0". It will done entirely on the lower side of the chips. Your wire kit contains lengths of wires that are identifiable by color. Choose the right color, and you have the right length of wire. If you find the precise hole to place one end of the wire, the other end will naturally fit into the other appropriate spot. The A0 button on the right is connected by the gray wire to the A input of the XOR gate. The B0 button on the left is connected by the purple wire to the B input of the NAND gate. The A and B inputs of the NAND gate and XOR gate are connected together by the white wires. In this way, the A and B connections easily span the adder.

Add two LEDs with series 150 Ω resistors. Let the green one represent S0 (the least significant bit of the sum — AKA the one's place). Let the yellow LED represent Cout0, the intermediate carry result. You can use this to test that the carry out of adder "0" is working correctly.

Finally, notice that the new 10KΩ resistor in the center. It is connected to the Cin0 input of the AND gate. The Cin0 is connected to the Cin0 input of the XOR gate by the gray wire that runs between them.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156283757-a45c3e6b-6217-40e4-b492-17177e435812.png" alt="full adder 0" width=600>
</p>

### 
Test full adder "0"
Don't wire anything else yet. Apply a 4.5V power supply, and test this circuit with the B0 and A0 push buttons.

- If neither B0 nor A0 are pressed, no LEDs are illuminated. This represents the sum zero.
- If either one of B0 or A0 are pressed (but not both), the green LED should illuminate. This represents the sum one.
- If both B0 and A0 are pressed, the yellow LED should illuminate. This represents the sum two.
- You might temporarily connect the Cin0 input to power either by running a wire to it or moving the other terminal of the resistor to the power bus. Upon doing so, the sums should be one higher than they were for the cases above. When both buttons are pressed, both LEDs should illuminate to represent the sum three. (Remember to restore Cin0 so that no LEDs are lit when no buttons are pressed.)

### Wire full adder "1"

Wire adder "1" on the "upper" side of the chips exactly as the bottom side, but slide each wire to the right by one hole as shown in the figure below. (Remember that the logic gates on the "upper" side are one position to the left of the gates on the "lower" side.)

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156283896-8bbd8c61-2cd0-4700-b672-7ba671da2fbc.png" alt="full adder 1" width=600>
</p>

### Chain adder "0" to "1"

Notice that, instead of adding a pull-down resistor to the Cin input of the adder "1", a crooked wire connects Cout0 of the lower adder to Cin1 of the upper adder. This chains the adders together.

### Test full adder "1"

Add the LEDs for S1 and S2 (Cout1) to the upper adder as shown in the picture below. The LEDs, from left to right represent Cout0 (yellow), S2, S1, and S0. You should be able to read the full sum by looking at the binary pattern on S2,S1,S0 and it should represent the addition of the inputs.

Connect buttons B1 and A0 to their inputs with long green and orange wires. It may help to bend corners into the wires to keep them from looping around your breadboard.

Apply 4.5V to the system, and test it thoroughly. If you press all four buttons (which represents a three on each input), you should see the green LEDs show the binary pattern 1 1 0, which represents the decimal quantity six. If you temporarily connect the Cin0 input to power, it will add one more of any of the combinations you try. With all buttons pressed (3 + 3) and Cin0 pulled high (+1) the end result should be all three green LEDs illuminated (a sum of 7).

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156284048-5d20f383-1d70-4c16-b4b6-ad1b92fc5246.png" alt="chain adders 0 and 1" width=600>
</p>

### Verify your circuit with [Autolab](./lab2.win.labtest)

> Since you will be constructing your circuit at home, we will provide an option to use AutoLab on your personal computer. Download the application [here](https://engineering.purdue.edu/ece270/lab/autolab/). **Please read the instructions carefully in order to make AutoLab work on your computer.**

Connect the AD2 according to the following table:

<table align=center>
  <thead>
    <th align=center>AD2 Pin</th>
    <th align=center>Adder</th>
  </thead>
  <tbody>
    <tr>
      <td align=center>DIO 0</td>
      <td align=center>A0</td>
    </tr>
    <tr>
      <td align=center>DIO 1</td>
      <td align=center>A1</td>
    </tr>
    <tr>
      <td align=center>DIO 2</td>
      <td align=center>B0</td>
    </tr>
    <tr>
      <td align=center>DIO 3</td>
      <td align=center>B1</td>
    </tr>
    <tr>
      <td align=center>DIO 4</td>
      <td align=center>C<sub>in</sub>0</td>
    </tr>
    <tr>
      <td align=center>DIO 8</td>
      <td align=center>S0</td>
    </tr>
    <tr>
      <td align=center>DIO 9</td>
      <td align=center>S1</td>
    </tr>
    <tr>
      <td align=center>DIO 10</td>
      <td align=center>S2</td>
    </tr>
    <tr>
      <td align=center>DIO 11</td>
      <td align=center>C<sub>out</sub>0</td>
    </tr>
  </tbody>
</table
  
<b>Make sure that you connect DIO 8 through DIO 11 to the gate outputs rather than the LEDs.</b> You'll get strange results if you don't.

Turn off WaveForms, invoke AutoLab, download the appropriate lab2.labtest file from above, and run the testbench. It will try all 32 possible inputs and check that the values on the Cout0, S2, S1, and S0 are as expected. If there is a discrepancy, it will report it in the log. If all 32 input combinations produce the expected value on a particular output, you pass the test for that output. The tests are reported near the bottom of the log.

> Submit the confirmation code received on Autolab to the postlab assignment page

## Step 4: Propagation Delay Measurements

Consider a case where only buttons B1 and B0 are pressed. In such a case, only S1 and S0 are illuminated. While they are still pressed, if you press A0, it will cause S1 and S0 to turn off and S2 and Cout0 (yellow) to illuminate instead. This exercises a few long delay paths of the circuit, shown below.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156285125-7b8226cb-4c75-4b48-ae5c-1eed6b8095c9.png" alt="propogation delay" width=600>
</p>

When A0 is pressed, the lights *appear* to all change simultaneously, but the paths taken to change S0, Cout0, S1, and S2 involve transiting different numbers of gates. This means that the change will occur for these outputs at different times. The difference in times is too fast for you to see with your eyes, but not too fast for the AD2.

### Using the pattern generator and logic analyzer

Configure the AD2 to assert B1 and B0 and continually toggle A0 while monitoring each of the affected outputs. To do so, you can set up the "Patterns" tool to assert the inputs and the "Logic" tool to view the result. Do so as follows:

- In the WaveForms "Supplies" tool, select a voltage of 4.5 V, and make sure it is enabled.
- In the WaveForms "Welcome" menu, invoke the "Patterns" tool.
- In the Patterns tool, add three new signals:
    - Add signal DIO 2 with Output "OS", Type "Constant", and Parameter1 "1".
    - Add signal DIO 3 with Output "OS", Type "Constant", and Parameter1 "1".
    - Add signal DIO 0 with Output "OS", Type "Clock", and Parameter1 "5 Hz".
     
  Press **"Run"** and you should see the LEDs blink.
  
- In the WaveForms "Welcome" menu, invoke the "Logic" tool.
- In the Logic tool, add five new signals:
    - Add signal DIO 0 (A0), and set the T field to "Rise" so that when the Trigger: is "Normal" and in "Simple" mode at the top of the Logic tool, it will be triggered by the rising edge of DIO 0.
    - Add signal DIO 11 (Cout0), and set the T field to "X".
    - Add signal DIO 8 (S0), and set the T field to "X".
    - Add signal DIO 9 (S1), and set the T field to "X".
    - Add signal DIO 10 (S2), and set the T field to "X".
    
  Press **"Run"** and you should see five traces.
  
The order of signals added to the Logic tool is deliberate. You should see a trace that looks similar to the graph below.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156285484-f3616610-ee60-4b54-a0c9-a72e6569d374.png" alt"logic analyzing" width=600>
</p>

### What are these slopes in the Logic tool trace?

Recall that the minimum time between samples taken by the AD2 is 10 ns. The slopes presented in the Logic tool trace graph are a fiction. These are shown to demonstrate the uncertainty of the measurements between different points. For instance, a sample was taken that indicated DIO 0 (A0) was low, and in the next sample it was high. Since DIO 0 was the trigger source, the first sample where it was high was regarded a time 0. 20 ns later, a sample of DIO 11 was taken where it was low. Another 10 ns later, the sample for DIO 11 was high. A slope was drawn for DIO 11 between the 20 ns and 30 ns points to indicate that the precise time of transition is unknown. The the S0, S1, and S2 outputs on DIO 8 - 10 transition so close together that their times cannot be distinguished by the AD2. How can the timing differences be observed? The right way would be to purchase a more expensive oscilloscope with a much faster sample rate. For educational purposes, there is a different way to see the timing differences.

### Change the supply voltage

Each tool window in Waveforms has an icon in the upper right to "Dock/Undock Window". Click the icon in the Logic tool to undock it so that it appears in a separate window from the main WaveForms application. Meanwhile, switch to the Supplies tool and *slide* the voltage from 4.5 V down to 2.0 V. The LEDs will be very dim at this point, but you don't need to see them. Watch the traces in the Logic tool as you change the supply voltage. Notice how the transitions get farther apart as the supply voltage decreases. Which transition occurs first: S0 or S1?

### Submission of Logic tool trace

Reduce the size of the undocked Logic tool to be just large enough to see the traces and transitions of DIO 0, 11, 8, 9, and 10. You will be exporting a trace of the logic tool in both image and data format. To export a trace of the Logic tool go to File > Export, or pressing Ctrl+E. Select the Image tab to export an image, save the file, and upload it into your postlab submission. Repeat the previous steps but select the Data tab instead to export the [data file](screenshots/step3_logic_data.csv), save and upload it.

> **Ensure that the time and date and serial number are visible on the exported image, make it a PNG format file, and do not make a screenshot. Also, ensure the CSV format file is exported. You will not receive credit otherwise.** Upload both files to the postlab and answer the relevant questions. **Note: The minimum delay should be measured from the endpoint of the input signal (A0) to the starting point of the output signal(Cout0,S0,S1,S2). The maximum delay should be measured from the starting point of the input signal (A0) to the endpoint of the output signal(Cout0,S0,S1,S2).**

### Measure the path delay

Connect the Scope's channel 1 (1+) to the A0 signal, and ensure that its negative pin (1-) is connected to ground. Connect the the Scope's channel 2 pin (2+) to the S2 signal, and ensure that its negative pin (2-) is also connected to ground. In WaveForms, change the frequency on DIO 0 to 50 kHz, and press Auto Set on the Scope Tool. The result should look similar to the figure below.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156285977-e66bcdab-eb76-4aaf-81bd-a2deaeccc6e7.png" alt="path delay" width=600>
</p>

Once you have verified that it looks similar, zoom in until you see the delay between the input waveform on A0 and the output waveform on S2. Using the Cursors as in steps 1 & 2, measure this delay by using the midpoint method - time from the center of the transition on the input to the time of the center of the transition of the output. It should be similar to the following.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156286071-720b767a-919c-4697-a67e-3e1998c61ab1.png" alt="path delay" width=600>
</p>

Remember that all gates, all wires, all breadboards, and all AD2s are different. Your graph will be too.

> Once you have a scope view **similar to the second picture**, measure the propagation delay using the midpoint method. To export the Scope results, go to File -> Export. Select the Image tab to export this as a PNG file, change the Source to "Oscilloscope" on the export page and [submit it](./screenshots/step4_deliverable.png), along with the propagation delay. **The cursors with the values measured should be clearly shown in your postlab submission to receive points for this step**
