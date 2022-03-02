# Investigation of Timing Hazards

## Instructional Objectives

- To learn what causes timing hazards in combinational logic circuits, how hazards due to single input changes can be eliminated, and what happens if more than one input is - allowed to change simultaneously.
- To review how to implement a simple logic function using discrete CMOS ICs.

## Introduction
This lab will be intended to teach you about the risks of implementing Boolean expressions that exhibit timing hazards, causing glitches on the circuit output. You will first read the instructions for the prelab, including what to draw in Kicad 6 Eeschema for the schematic, how to draw out the Karnaugh map for the expression implemented by the circuit, and how to construct a timing diagram for an example of such a glitch.

You will then proceed to Step 1 to construct the circuit implementing an expression that causes one type of glitch on the output, then observe this glitch with the help of the Logic panel on your AD2.

You will resolve this glitch in Step 2 by adding a consensus term to your circuit, demonstrate that it resolves the glitch by submitting a second screenshot, and show that by oscillating two specific inputs, we can still cause a glitch (albeit a different kind).

## Step 0: Prelab

- Read the **entire** lab document.
- Do the prelab assignment on the course web page. Instructions are given below.

### Step 0.1: Construct a schematic for a glitchy 2:1 multiplexer

You will implement the following schematic for the Boolean function F(X,Y,Z) = (X*Z') + (Y*Z) using Kicad 6 Eeschema in your pre-lab submission. You are only permitted to use the following gates: 2-input NAND (74HC00), 3-input NAND (74HC10), NOT (74HC14), so you will need to modify the schematic shown below to use these gates before you [submit it in the pre-lab](./lab4_schematic.kicad_sch).

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156304536-3ae7295d-36e3-4859-a6a4-0b3fb9ba4509.png" alt="schematic" width=600>
</p>

This schematic implements a 2:1 multiplexer, which is essentially an electronic "selector switch" that routes either one of the data inputs, X or Y, to F based on the select line signal, Z.

While drawing the schematic, keep the following in mind:

- As you change the schematic to only use the gates above, you should arrive at an equivalent schematic that substitutes the OR gate producing F with a NAND gate. For this particular gate, **make sure to use the 3-input NAND**. You will only use the third input in the next step, so for now, tie the third input to a logical high. This will temporarily convert the 3-input NAND to a 2-input NAND, since it implements the expression (A * B * 1)' which is just (A * B)'. Also, Make sure to use global labels as shown in the picture above for your inputs and output ports.
- When building your circuit, in some cases, you will not see a glitch unless you add more inverters in front of Z to increase the delay of Z'. Make sure that you add **odd numbers of inverters** so that you always get Z'. At worst, you shouldn't need more than 5 inverters (or the entire 74HC14 chip).

### Step 0.2: Construct a Karnaugh map for the multiplexer

Find the Boolean expression from the circuit in the schematic above, and generate the truth table for this expression. **You will also submit this truth table in your post-lab**. With the values that you find for F (the output of the expression), you will construct a Karnaugh map as taught in lecture , find all prime implicants and classify them essential or otherwise.

Here's helpful hints on how to set up the Karnaugh map with the tool on the pre-lab submission page:

- You will be set up with a blank Karnaugh map. While you are in "Edit Mode", you will be able to copy the values from your truth table to the corresponding cells of the K-map. Move your cursor over the cell you want to modify so that your cursor changes to a pointing hand (much like what you would see when clicking a hyperlink) and click, making it editable. Enter the corresponding value from the truth table (it will only accept 1, 0 or d for don't care), and repeat the process for each cell. Keyboard enthusiasts can use Tab and Shift-Tab to jump between cells when entering the values for each cell, if preferred.

  To help you find the corresponding cell, we have also included a "Show minterm" option to view the cell's minterm number.

- Once you have entered the values from your truth table, you will draw circles on the K-map to indicate the prime implicants on it. To do this, click the button "In Edit Mode" to switch it to "In Circle Mode". In this mode, you should not be able to edit the values when you click on the cells. Instead, you will perform click-n-drag motions to draw circles around all the common terms.
- The tool detects which cells you are trying to circle by determining the best fit around the circles that you move over with your mouse, as shown below. As a result, the circles that get drawn will always contain a number of cells that is of the form 2<sup>n</sup>, as is expected in K-maps. If you make a mistake while drawing a circle, don't fret - each circle will have a corresponding circle selector button that appears above the K-map. You can use this circle selector to delete the circle.
- In larger K-maps, you may find that you need to draw circles around the corners, or at least into the other side. The tool can detect this if you move your cursor out of the borders of the K-map itself, as shown below. Use this to draw circles across boundaries if needed.
- A key property that you must indicate for each of these circles is whether they are essential or non-essential prime implicants. With the K-map tool, you can indicate whether each prime implicant (i.e. a circle) is essential or not using the "Toggle prime implicant type" button at the top of the tool, as shown below. By default, each newly created circle will be assumed to be an essential prime implicant. Notice how changing the type will also change the circle's overall color when selected, making it easily distinguishable from prime implicants of the opposite type.

**Using these instructions, make sure to place values from the aforementioned truth table into the K-map, change modes, draw circles to indicate the prime implicants and set their types. Ensure that your submission has been saved before continuing.** The circle colors are only there to help you distinguish between circles when you select them, so don't worry if you see that the circles go back to being colorless upon saving.

### Step 0.3: Construct timing diagram to find timing hazard

In this step, you will fill out the timing diagram presented to you in the pre-lab submission, which should look like the following:

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156305606-370e9733-f2e7-4bae-ac16-10bd5cc45c32.png" alt="timing hazard" width=600>
</p>

How to use this interface to complete this step:

- The signals that are already drawn (X, Y and Z) are provided to you since they are input signals to the circuit above. You will use these to determine the waveforms for Z', (X*Z')', (YZ)', and F, which are currently set as blank.
- Each signal is divided into time steps, each 5 nanoseconds long and highlighted in light gray. Clicking on the time step for a certain signal will set it to a logical high/1.
- Clicking the time step again will set it to a logical low/0, therefore toggling it. If you take a look at buttons next to "Force Value" on top, you will see that "T" (for toggle) has been selected. This means that when you click a time step with your mouse, it will be set to its opposite value (i.e. 1 will become 0, 0 will become 1).
- Clicking and dragging through the waveform for this signal will set all blank time steps to 1, and will toggle already-set time steps to their opposite values.
- You can also click-n-drag a fixed value across the time steps so you can set them to a fixed value like 0, 1 or blank (using CLR) regardless of what value the time step was set to.

You may have noticed that there already exist red X'es in the first few time steps for each of the waveforms to be filled out. These indicate that the value of the waveform at those points are "unknown", since we do not know the previous values of the inputs X, Y and Z before time zero. Naturally, you should not have to change these. If you accidentally change them, use the picture above to take note of where the X values were, and use the Force Value setting to set those time steps to X.

As you draw the waveform, assume that each gate has a propagation delay of 5 ns (even if you've used additional inverters for Z'). As a result, each signal should be time-adjusted by the corresponding propagation delay for the gate that implements it.

**Using these instructions, fill out the Z', (X*Z')', (YZ)' and F waveforms by setting time steps to 1 and/or 0 accordingly. The resulting waveform on F should contain two static-1 glitches (so the waveform should be 1/high throughout, except for two specific time steps where the output "glitches" to 0/low.)**

## Step 1: Implement schematic as circuit and observe glitch

Using the 74HC00 for 2-input NAND gates, a 74HC14 for the inverters, and a 74HC10 for the 3-input NAND gates, you will construct the circuit from the schematic you drew in Step 0.1. Place and wire the logic chips, connecting the circuit inputs to the corresponding AD2 pins as follows - X to 0, Y to 1, Z to 2 and F to 3. You can rearrange these if you'd like, but ensure that you keep your new order in mind as you follow the rest of the instructions.

To set up your AD2, do the following:

- Open Waveforms with your AD2 connected. Ensure that you are using your AD2 and not the demo one by checking that the connected device has a serial number that looks like this, and does not have the word DEMO in it.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156305871-26e18d32-d5a1-47db-8b7f-7a52876e8043.png" alt="AD2" width=300>
</p>

- On the sidebar, select the "Supplies" tool. There are two buttons on the left side of the Supply Tool window that enable the positive and negative supplies. Turn off the Negative Supply (V-). Make sure that the "Positive Supply (V+)" is still On. Set the slider for the Positive Supply (or type in the box) for **2.0V**. At the top of the window is the "Master Enable" button. Click it to turn on the supply.

  If you're wondering why the voltage should be 2.0 V instead of a more conventional one like 3.3 V or 5 V, it's because we're undervolting the gates to make them use the worst-case propagation delay to reliably view our glitch on the output. Higher voltages would mean a smaller propagation delay, resulting in a smaller displacement of (X*Z')' which would prevent the glitch from occurring. It also invalidates the need to use more than one inverter.

- Now, open the StaticIO menu from the Welcome tab. You should see two rows of buttons numbered 15 through 0. Since you've connected X, Y, Z to 0, 1, 2, you will turn them into sliding switches as shown below. Leave 3 as an LED since that will be used to check F. Keep each of the input switches at zero.

  Now that your circuit is wired up, and the X,Y,Z inputs and F output are connected to your AD2, change the inputs to induce a change in F. Use the truth table that you had to use for the K-map in your prelab to verify your circuit output.

  Once you have verified that your circuit is correct, attach a second wire connecting pin 2 to pin W1. Go back to StaticIO and change pin 2 back to an LED.

  This last part is extremely important because W1 will now be used to generate a waveform for the Z signal, and leaving pin 2 as a switch will not allow the waveform to run.

- Back on the Welcome page, click on the Wavegen menu, and for Channel 1 (W1), set the following options in the window that appears:
  - Type: Square
  - Amplitude: 1 V
  - Offset: 1 V
  - Frequency: 200 kHz
  - Symmetry: 50%
  
  Ensure that your window now looks like this, and then click Run to turn it on.
  
<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156306158-0a109c25-e420-4ca2-9528-0837a657611f.png" alt="square wave" width=600>
</p>

- Verify that the Wavegen is working properly by going back to the StaticIO panel, and setting either X or Y to 1 to see the output flickering on pin 3. Once you verify that your Wavegen is working properly, **set both X and Y to 1**
- Back on the Welcome page, open the Logic tool. Click the green plus button on the top left button, and add the signals DIO 2 and 3. Double-click the name column of each of these signals, and change them to the signals they're connected to (Z for DIO 2 and F for DIO 3). Click Run, and you should see the static-1 glitch on the waveform for F. It should look like the following:

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156306340-8ac23a80-8990-4e20-9de8-1991eac9c136.png" alt="logic" width=600>
</p>

**Export the logic trace by going to File -> Export and selecting Image. Your exported image should have your serial number visible.**

> If you're not seeing a glitch, a possible fix is to try to use longer wires in the path between Z and ZP, utilizing the wires' inherent inductance to add a relatively small propagation delay. Also consider adding more wires in the path, such as between W1 and Z, and from Z to the first inverter producing ZP. **Ensure that you use 74HC14 NOT the 74HC04.**
>
> Also ensure that your supply voltage is at **2.0 V** and that your wavegen is at **200 kHz** (try changing the values to one within the range of 10 kHz and 1 MHz to see if they make a difference).
>
> **Show the static-1 glitch you observe to your TA to recieve points for Step 1 and submit the [exported image](Screenshots%20and%20data/step%201.2%20deliverable.png)**

## Step 2: Add consensus term and find another glitch

By now, with the results of the waveform that you drew in the pre-lab, and your observations on the Logic Analyzer, you should have visually confirmed that the glitch is caused by the anomaly where both (X*Z')' and (YZ)' are high at the same time, significantly long enough that the output F also becomes low.

In this step, you will add a consensus term to eliminate this glitch. The picture below shows a version of the former schematic updated to use the consensus term.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156306734-930d6dd6-c865-418b-b56e-b648ff2f4ab9.png" alt="schematic" width=600>
</p>

Modify your circuit accordingly. This should be easy at this point if you made sure to use the 3-input NAND as we indicated to you while you were building your schematic for the pre-lab. Simply remove the third input connected to a logical high, and connect it to the output of a 2-input NAND gate implementing the XY term.

Ensure that your power supply, waveform generator and logic tools on your AD2 are still running, and check the waveforms on your logic tool. It should look like the following:

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156306814-5fed99d7-0fa6-4c22-b437-486da71a2ce8.png" alt="concensus plot logic" width=600>
</p>

The addition of the consensus term should therefore remove the glitches from the output, leaving the output at a stable high.

**Export the logic trace by going to File -> Export and selecting Image. Your exported image should have your serial number visible.**

> **Show that the static-1 glitch is eliminated once the consensus term is added to your TA to recieve points for Step 2.1 and submit the [exported image](Screenshots%20and%20data/step%202.1%20deliverable.png).**

You may be surprised (or perhaps, not so much) to know that even the addition of a consensus term does not necessarily mean the circuit is no longer prone to other kinds of glitches. You can observe the other kind of glitch possible in circuits - caused by a static-0 hazard - by doing the following:
- Disconnect the X input from the 0 pin on your AD2. Connect it to the W1 pin, so that now both X and Z are connected to W1 and will therefore both oscillate.
- Go into the StaticIO panel, and change the X input (the 0 pin) back to an LED. This is required so that setting the X input to an oscillating waveform is not affected by the - AD2 asserting a value via the StaticIO panel.
- Set the input Y to zero in the StaticIO panel.
- Head back into your respective Logic Tool/Analyzer window, and observe the new kind of glitch on the output (DIO 3). It should look like the following: 

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156307128-3350d1d7-f4e3-44d7-a01e-df9e95b91c40.png" alt="static-0 logic" width=600>
</p>

Note that the output has now changed to zero/logical low, and the glitches are the points where the output switches to high for a few moments before immediately returning to a logical low. This is a static-0 hazard.

**Export the logic trace by going to File -> Export and selecting Image. Your exported image should have your serial number visible.**

> Show the static-0 glitch to your TA to recieve points for Step 2.2 and submit the [exported image](Screenshots%20and%20data/step%202.2%20deliverable.png)

You will start implementing hardware with SystemVerilog next week. Make sure to get an account on the course simulator hosted at <https://verilog.ecn.purdue.edu> in this week so that you can iron out issues if you have any and are consequently ready for Lab 5 next week.
