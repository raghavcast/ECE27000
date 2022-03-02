# Implmentation of Boolean Expressions as Circuits

## Instructional Objectives

- To learn how to implement simple logic functions using discrete 74HC-series components.
- To learn how to use Boolean algebraic simplification to change a circuit's realization.
- To see a motivating reason to learn more circuit minimization and mapping techniques that can be used to improve the performance of a Boolean function realization.

**For this lab, you will need your lab kit and AD2, and you may find it helpful to install the KiCAD software suite on your own computer to use Eeschema at home. You will build the circuit you describe in the prelab, and you will verify its operation with Autolab.** In the prelab, fill out the truth table for the following Boolean function(s), convert them to NAND-NAND and NOR-NOR versions, ands draw a schematic using only inverters, 2-input NOR, 2-input NAND, 3-input NAND, and a 2-input AND gates in Eeschema.

```
F1(W,X,Y,Z) = X·Z' + W'·X + W'·Y + Y·Z'

F2(W,X,Y,Z) = (X'·Y')' · (W·Z)'
```

With the help of your prelab schematic, you will build the actual circuit, again using only the aforementioned gates. **Your circuit must be ready to test by the time you arrive at your lab section. Building and debugging can take an inordinate amount of time, and prevent you from finishing the lab.**

## Step 0: Prelab

- Read the **entire** lab document, including Steps 0.x below.
- Do the prelab assignment on the course web page.
- Build the circuit from your schematic **before** your lab section.

### Step 0.1: Evaluate the Truth Table for F1(W,X,Y,Z) and F2(W,X,Y,Z)

Fill in the truth table for F1(W,X,Y,Z) and F2(W,X,Y,Z) in the prelab submission. These Boolean functions are logically equivalent, so either one can be used to build the truth table. The other can be used to check its correctness.

### Step 0.2: Convert F1 to a NAND-NAND implementation

Use DeMorgan's Law to convert F1 into an expression that can be implemented by four 2-input NAND gates and a 4-input NAND gate.

### Step 0.3: Convert F2 to a NOR-NOR implementation

Use DeMorgan's Law to convert F2 into an expression that can be implemented by three 2-input NOR gates.

### Step 0.4: Schematic of F1 and F2

Implement the converted NAND-NAND and NOR-NOR functions as a schematic in Eeschema, and submit it in the prelab submission. Your schematic must present a detailed plan of how you will use the chips in your kit to implement the circuit. In particular, you must ensure the following:

- Each gate symbol must clearly indicate which pin numbers it will use. You must change the Unit on the gate symbol so that the pin numbers are not the same for different gate symbols.
- Each gate symbol must be labeled as Unx, where 'n' is a number to indicate that it belongs to a specific chip, and 'x' is the Unit of the gate symbol. For example, if you add four 74HC00 gate symbols, and you intend to use all four of them on the same 74HC00 chip, you must label them as U1A, U1B, U1C and U1D respectively. For U1A, the pins would be 1,2 and 3. For U1B, the pins would be numbered 4,5,6, and so on. The symbols should look like **Subschematic 1** below.
- For the 74HC10 and 74HC08, you may need to use 74LS10 and 74LS08 since the HC versions do not exist in the Eeschema symbol libraries. The chip numbers should still match.
- You must specify the inputs with the Label option, which can be accessed by pressing the L key or going to Place > Label in the top bar.
- Your schematic must be clean and orderly. All added wires must be useful, i.e. connected between two components, not placed without purpose. All components must be labeled with the Unx format as specified above, and be of the correct type. The labels used for gate inputs W, X, Y and Z must be easily readable.
- For the 4-input NAND gate, you may choose one of two options:
    - Use one gate of a 74HC10 3-input NAND gate and one gate of a 74HC08 AND gate. This is probably the easiest to understand, although it requires the addition of an extra chip to produce the intermediate result. (**Subschematic 2**)

    - Use all three gates of a 74HC10 triple 3-input NAND gate chip. (**Subschematic 3**) Use one of the gates as an inverter by wiring all three inputs together or connecting two of the inputs to VCC. That "inverter" is used to invert the output of another 3-input NAND gate to form a 3-input AND gate. Only two inputs of this "3-input AND gate" will be used. The third input should either be connected to VCC or redundantly connected to one of the other inputs. An input for a gate whose output is being used should never be left unconnected. An unconnected input is not always low. It will float unpredictably between high and low states and cause you great puzzlement.

<img align=left src="https://user-images.githubusercontent.com/37441514/156287098-347c86b3-691d-43c8-bbaf-bb5418ed72fc.png" alt="Subschematic 1" width=150>
<img align=center src="https://user-images.githubusercontent.com/37441514/156287157-c4eba873-831f-4bbe-b99f-fccf9c1144ec.png" alt="Subschematic 2" width=300>
<img align=right src="https://user-images.githubusercontent.com/37441514/156287205-565283d8-3ee4-4460-b0ee-66323418347f.png" alt="Subschematic 3" width=300> 
<br> <br> <br> <br> <br> <br> <br> <br> <br> <br> <br> <br> <br>  

  These alternatives are typical ones you would consider if you were creating a real device, so thinking about how you want to do them is a realistic exercise. There are two considerations to keep in mind:
    1. Using a 2-input AND gate will mean adding an extra chip to your design. That will result in some additional power consumption and space requirements.
    2. Using two 3-input NAND gates to build a 2-input AND gate will result in a slower gate than using a 74HC08 AND gate. (A 74HC10 has a longer propagation delay than a 74HC08, and it takes two of these gates. The result is more than twice as slow as a 74HC08 AND gate.)
    
There is no 4-input NAND gate in your lab kit, so implement it using a 3-input NAND gate for which one of its inputs is a 2-input AND gate (or the 3-input NANDs, if you're doing option 2). All four of the 2-input NAND gate outputs can then be accommodated. The two NAND gate outputs to connect to the AND/3-NAND gate(s) should be those that combine the X/Z' and W'/X signals. Those are the first two terms in the F1 function. From the standpoint of logical equivalence, it does not matter which NAND outputs are connected to the AND/3-NAND inputs. We want to specifically connect these two NAND gates to the AND/3-NAND gates to have a predictable timing model.

**Ensure that your schematic follows the design rules outlined above, and upload your schematic file to the prelab. Failure to follow directions will cost you points.**

## Step 1: Implement schematic as circuit

Implement the F1 and F2 functions with discrete logic chips.

- Use four push buttons to implement the W, X, Y, and Z literal inputs for your circuit. Use 1KΩ or 10KΩ pull-down resistors as you did in lab 2 to make the buttons produce a proper high-or-low logic level.
- Use a green LED with a series 150Ω resistor as an indicator for the F1 output.
- Use a red LED with a series 150Ω resistor as an indicator for the F2 output.
- Use a 74HC00 for 2-input NAND gates, a 74HC10 for 3-input NAND gates, a 74HC02 for the 2-input NOR gates, and a 74HC04 for the inverters, and (optionally) a 74HC08 for the AND gate should you choose option 1.

**PLAN** the layout of your circuit. Ask yourself questions like "Which chips do I want to have close together?" "How long are the wires that I have on hand to build this?" **This is where a detailed and accurate schematic will help greatly.**

Since F2 requires the smallest number of gates, it may be easiest to wire and verify it first. When F1 is built, F2 can be used to check its correctness against the truth table in the prelab.

Connect the power supply of the AD2 to your circuit and apply 4.5 V to it. Check that the outputs of all combinations of W, X, Y, and Z inputs produce the correct output.

In the WaveForms StaticIO form, configure DIO 3, DIO 2, DIO 1, and DIO 0 to be "Switch > Open Source (1/Z)". These will be used as the W,X,Y,Z inputs. They will either output a logic high or be left open (in the "high-Z" state). The pull-down resistors on the push buttons will pull them low when they are left open.

Make the following connections between AD2 pins and your constructed circuit:

- DIO 3: W push button
- DIO 2: X push button
- DIO 1: Y push button
- DIO 0: Z push button
- DIO 8: F1 NAND output determined by XZ subterm
- DIO 9: F1 NAND output determined by WX subterm
- DIO 10: F1 NAND output determined by WY subterm
- DIO 11: F1 NAND output determined by YZ subterm
- DIO 12: F2 NOR output determined by XY subterm
- DIO 13: F2 NOR output determined by WZ subterm
- DIO 14: F1 output
- DIO 15: F2 output

Use the switches for DIO 3 – 0 to set values for W,X,Y,Z and verify that the outputs seen for DIO 14 and DIO 15 are the same in each case, and match the truth table. The patterns visible on DIO 8 – 13 may not make much sense. They will be used for verifying your circuit.

### Verifying F1, F2 and subterms with Autolab

> Since you will be constructing your circuit at home, we will provide an option to use AutoLab on your personal computer. Download the application [here](https://engineering.purdue.edu/ece270/lab/autolab/). **Please read the instructions carefully in order to make AutoLab work on your computer.**

Using the AD2 wiring you completed in the previous step, use [Autolab](./lab3.win.labtest) to verify your wiring of F1, F2, and all of the NAND and NOR intermediate terms. You will need to turn off the WaveForms program or select a "DEMO" device in order to allow Autolab to interact with the AD2.

> Show your TA your AutoLab verification to receive full credit. You will receive points for each correctly implemented intermediate term and output.

## Step 2: Trace the timing of F1 and F2 circuits

Once you have passed Autolab verification, turn off Autolab and reinvoke WaveForms. Invoke the Pattern tool, and use the green "+" icon to add a **bus**. Set the members to be DIO 3 – DIO 0, with "Binary" format. DIO 3 should be automatically set as the MSB (most significant bit).

Once the bus is added, set the Output type to be "OS" (Open Source), the Type to be "Binary Counter", and Parameter1 to be "10 Hz". This will cause the W,X,Y,Z inputs to be set to 0000, 0001, 0010, ..., 1110, 1111, 0000, and so on, repeatedly. This can be used to repeatedly exercise the inputs. **Press "Run" to start the binary counter on DIO 3 – 0.**

Invoke the Logic tool to get a trace of the outputs as they change. Add two buses as follows:

- Add a bus of four wires, DIO 3 – DIO 0. The MSB should automatically be set to DIO 3 (W). The combined four-bit value of the four wires will be shown at the top. (0000, 0001, 0010, ..., 1110, 1111)
- The 'T' field next to the name DIO 3 is the Trigger type. Set the trigger type for DIO 3 to "Fall". This will cause the logic trace to start displaying a new scan when it sees the W signal change from 1 to 0. That will happen when the WXYZ value changes from 1111 to 0000.
- Add another bus of eight wires, DIO 15 – 8. The MSB should automatically be set to DIO 15. The combined eight-bit value of the eight wires will be shown above the signal values.

As the Pattern tool scans all combinations of WXYZ at 10 Hz, you will see the result of the truth table for those input values displayed for DIO 15 and DIO 14. When you press "Run", the result should look similar to the picture below.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156288336-341b3653-90a5-4527-8c73-2833f0d5707e.png" alt="patterns tool" width=600>
</p>

Lower the supply voltage to 2.0 V (to show the slowest possible timing). Set the Pattern tool's Parameter1 field to **10 MHz** to make the gate delays significant with respect to the period of the repeating pattern. In the Logic tool, zoom in enough to be able to see the four-bit pattern for the DIO 3–0 bus at the top of the screen. Make the window large enough to see all 16 values of the input variables. An example is shown below.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156288447-92c721d7-e4bd-4425-8f85-98150289f250.png" alt="patterns tool" width=600>
</p>

Wow! What a mess! This is actually a very real-world timing analysis. Notice that, now, the waveforms for F1 and F2 (DIO 14 and DIO 15) are no longer perfectly aligned with each other. The other signals representing intermediate NAND and NOR outputs occur at seemingly random times.

Also note that when WXYZ changes from 1111 to 0000, there are several V-shaped outputs on the traces for DIO 8 – 13. These are called glitches. They are the result of gate inputs changing nearly simultaneously. One change causes the gate output to go low, and another change with a slightly longer propagation delay causes the gate output to go high again.

> Some students don't see much of anything when they look at the input and output signals in the Logic tool. In particular, some of the inputs never vary at all. Instead, they are continually shown in the "high" state. If this is happening for you, it is because the pull-down resistors are not be strong enough to overcome the leakage current for your gate inputs. (This might be because the gates are [not quite authentic](https://engineering.purdue.edu/ece270/refs/counterfeit/).) Just change the "Output Type" in the Patterns tool to "PP" (Push-Pull) instead of "OS" (Open Source). This will force DIO 3 – 0 to drive these signals high or low instead of just high or high-Z. It will also mean that you cannot simultaneously use the push buttons, but you're probably not using those at this point.
> 
> You will need to do the same thing for Step 3, below.

### Capture and upload a trace

Capture a trace of the Logic tool output with a 2.0 V Supply voltage and a 10 MHz Pattern rate. Upload it to the postlab. Remember the guidelines for uploading traces:

- Resize the WaveForms window just large enough to read the four-bit values for the bus values for all 16 combinations of the WXYZ inputs. Captured images that are too large will be rejected.
- Ensure that your AD2 serial number and the date/time are shown in the trace capture.
- Capture the trace using the WaveForms "File > Export" menu option. **Do not make a screenshot.**
- Save the capture as a PNG file.

> Demonstrate the running Logic tool at 4.5 V and 2.0 V to your TA to receive a checkoff for this step.

## Step 3: Estimate the path delay of F1 and F2 circuits

**Continue to use the 2.0 V supply voltage**. Reconfigure the Pattern tool to examine the timing when W, X, and Z are all Z/low, and Y alternates between high and low. To do this, remove the bus containing DIO 3 – 0. Re-add each signal separately. Set DIO 3, 2, and 0 as Output=OS, Type=Constant, Parameter1=Z (pulled low by pull-down resistors). Set DIO 1 to be Output=OS, Type=Clock, Parameter1=1 kHz. It should look similar to the figure below.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156288907-05e96c48-3ffe-45da-b016-d3a95bf04a89.png" alt="logic" width=600>
</p>

Reconfigure the Logic tool to trigger on the rising edge of DIO 1. Turn off the "T" trigger field for DIO 3. Zoom in on the image to be able to estimate the time between the low-to-high edge of DIO 1 (Y) and the low-to-high transition of DIO 15 (F2) and DIO 14 (F1). Capture this Logic tool trace, and upload it.

Use the Logic tool trace to estimate the path delay between Y and F1 and Y and F2, with the help of the Cursors tool under View > Cursors. Add one cursor at where DIO 1 rises, and another cursor at the point where F1/F2 reaches a stable value. The ΔX between the cursors should then be your total path delay. Do this for both F1 and F2, and upload the path delays to the post-lab submission. Make sure to answer the remaining questions.

> Show both the delays between Y->F1 and Y->F2 from your running Logic tool to your TA to receive a checkoff for this step.

## Step 4: Postlab Submission

Answer the remaining questions in the postlab submission.

## Step 5: Clean your lab station and log out

Ensure that your station is free of breadboard debris like small jumper wires and resistors. Pull the oscilloscope/DMM cables up above the monitors so they don't hang in front of the monitor, and be sure that you have logged out of your lab station. Your TA should confirm that your station is clean and logged out.
