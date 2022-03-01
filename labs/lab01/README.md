# Breadboard Techniques and Logic Function Demonstration

## Instructional Objectives
- To become familiar with the contents of the Digital Parts Kit (DK-2)
- To learn how to build and test digital circuits using the Breadboard Kit (BB-1)
- To learn about basic logic functions such as AND, OR, NOT, NAND, NOR, and XOR

## Step 0: Prelab Preparation:
You should do the following before attempting this lab:

- Read this entire lab document.
- Watch the videos describing how a solderless breadboard works on the References page.
- Identify the 74HC chips mentioned in the prelab assignment on the course web page.

### Software Setup
Get started by logging into your machine. You should already have confirmed last week that you are able to log into an ECN machine. If you have not already run the setup script and generated the shortcuts for Waveforms and other applications, please do so.

Once logged in, plug your AD2 in via USB to the machine you are working on, and open Waveforms with the desktop shortcut. It should open, detect your AD2, and show you a screen that looks like this:

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156120609-8d08a3f5-abbd-4067-ba8e-3df0a03b5b7a.png" alt="Waveforms window." width=600> <br>
  <b>New WaveForms window after detecting AD2</b>
</p>

The AD2 will serve as your lab equipment away from lab - it provides an onboard oscilloscope, power supply, waveform generator, DMM and static IO analyzer, all accessible through the WaveForms software.

To be able to use your device with your own computer, you will need to download WaveForms and other dependencies if needed:

- Download and install the Waveforms software from Digilent <a href="https://store.digilentinc.com/waveforms-download-only/">here</a>. 
  - If you're on a Linux system, you'll additionally need the Adept Runtime which you can download <a href="https://store.digilentinc.com/digilent-adept-2-download-only/">here</a>. 
- Reboot your system, launch the software with your respective device connected via USB and ensure that the software can recognize it.

## Step 1: Power and Ground Jumper Installation
Connect power and ground jumpers on your breadboard(s), as shown in Figure 1. Connect each of the power strips that run between the breadboard sections so that the "red rail" strips are all connected to each other, and the "blue rail" strips are all connected to each other. We will use the adjustable power supply on the Digilent Analog Discovery 2 (AD2) system to power most experiments, typically configuring it for 3.3V.

If it is not already installed, attach the 2x15-wire "flywire" assembly to the AD2. Insert the V+ (red) lead into the red rail of the breadboard system using another wire or the double-ended 1x6 pin assembly that comes with the AD2. Insert any of the ground (**🠋**) (black) leads into the blue rail of the breadboard system in the same way.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156122251-cc4b1d4e-9cc4-4aac-97b1-f52ac9882056.png" alt="power, ground jumper wires" width=600> <br>
  <b>Figure 1: Connection of power and ground jumper wires</b>
</p>

If you have a master lab kit from a previous semester, your lab kit contains several red LEDs that have built-in resistors. If you look closely at the red LEDs, you can see a small black dot inside. That’s the resistor. The vast majority of red LEDs do NOT have a resistor, and the use of such strange devices gives students the false impression that red LEDs can be used safely in circumstances where the voltage would destroy normal LEDs. Therefore, **we will not be using red LEDs with resistors**. We will use normal LEDs (of various colors) that do not have internal series resistors. You should be careful to always use a series resistor, although when using a 3.3V power supply, omitting it may not result in problems.

For this experiment, take one of the green LEDs from your parts kit and connect it in series with a resistor in such a way that current will flow through it when you enable the power supply:

- Each LED has two leads. One is longer than the other.
  - The long lead is the anode. Plug that in to the positive (red) rail of the breadboard.
  - Plug the shorter lead (the cathode) in to the middle of the breadboard.
- Find a 150Ω (any value near this, such as 200Ω, is also fine) from your parts kit and connect it between the cathode of the LED and the negative (blue) rail of the breadboard. Be sure to use the DMM at your station to double check the resistor size.

Once the resistor has been attached in series with the LED, turn on Supplies from your AD2 as follows:

- Open Waveforms with your AD2 connected. Ensure that you are using your AD2 and not the demo one by checking that the connected device has a serial number that looks like this, and does not have the word DEMO in it.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156123008-eb46c5e6-a08a-418d-addd-ac812713950b.png" alt="serial number"> <br>
  <b>Serial number of an example AD2</b>
</p>

- On the sidebar, select the "Supplies" tool. There are two buttons on the left side of the Supply Tool window that enable the positive and negative supplies. Turn off the Negative Supply (V-). Make sure that the "Positive Supply (V+)" is still On. Set the slider for the Positive Supply (or type in the box) for 3.3V. At the top of the window is the "Master Enable" button. Click it to turn on the supply.

Once you have enabled the power supply from your respective device, the LED should illuminate as shown in Figure 2.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156124233-4faee9a4-a10d-4471-bdbd-f28d70d86830.png" alt="power indicator LED" width=600> <br>
  <b>Figure 2: Connection of power indicator LED</b>
</p>

If, for some reason, you omit the resistor, the LED will be extremely bright and get warm. The AD2 power supply may notice excessive current flow and automatically turn off. Even if you did wire the LED and resistor correctly, you might want to test the current limiting feature of the power supply. Enable the power supply and connect a wire between the red and blue rails of the breadboard power strips.

> **Demonstrate this procedure to your TA to recieve points for Step 1.**

## Step 2: Push Button and Pull-Down Resistor Wiring
Insert the two 12mm push buttons into your board, along with the 10KΩ pull-down resistors, as as shown in Figure 3. Connect the upper left pin of each button to the +3.3 VDC power supply (red) rail. Place a 10KΩ – or larger – resistor between the upper right pin of button and the ground (blue) rail.

When using the push buttons, you should know that the upper left and lower left pins are always connected internally. The upper right and lower right pins are always connected internally. When the push button is pressed, the pins on the left are connected to the pins on the right. The large resistor is called a “pull-down” resistor, since it weakly pulls the voltage low. When the button is not pressed, the upper right pin is connected through the resistor to ground. When the button is pressed, the left side is connected to the right side, and strongly pulled to 3.3V. When the button is pressed, there is a small amount of current is wasted through the resistor. The higher the resistor value, the less current is wasted. This is why we want to use a large resistor.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156124523-bcf9e96c-08f8-45e7-80fe-e415cf860f52.png" alt="push buttons and pull-down resistors" width=600> <br>
  <b>Figure 3: Push buttons and pull-down resistors</b>
</p>

In Waveforms, select the "Voltmeter" tool to measure the voltage output. You will notice that there are two channels: channel 1(1+) and channel 2(2+). You can choose either channel to measure the voltage on the resistor connected to the button. Ensure that the channel's negative pin (1- or 2- depending on the channel you choose) is connected to the ground(blue) rail of the breadboard.

>Test each button with the voltmeter on your AD2 to make sure that the voltage on the resistor connected to the button normally measures “0.0 volts” with respect to ground, and measures (approximately) “3.3 volts” when the button is pressed. **Demonstrate this to your TA to receive points for Step 2.**

## Step 3: Inverter and LED Test
You are now ready to demonstrate the functionality of some common logic functions. Locate a 74HC04 (hex inverter) integrated circuit in your DK-2 parts kit.

Normally, such integrated circuits have leads that angle outward from the black package, so they do not naturally fit into the holes like the one on the left side of Figure 4. The first time you use one, you should gently bend the leads on each side by pressing it against a flat surface – such as a table. Visually observe the pins to see if they are straight and that the rows are 0.3 inches apart (like the one on the right in Figure 4). Find the notch on the package that indicates the orientation (as shown in Figure 5). Insert the 74HC04 into the breadboard with the notch on the left side. When the notch is on the left side, pin 1 is the lower left, pin 7 is on the lower right, and pin 14 is on the upper left.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156124944-4f58d278-80d0-4608-a36d-0cbed4e26edb.png" alt="pin angles on DIP" width=600> <br>
  <b>Figure 4: Pin angles</b>
</p>

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156125083-0449d04b-6e98-4fa3-b267-0d5e8e74f99b.png" alt="notch position on DIP" width=600> <br>
  <b>Figure 5: Position of notch on left side of the chip</b>
</p>  

Connect the 74HC04 to power (pin 14) and ground (pin 7). Connect one of the inputs (pin 1) to one of the push button, and connect the corresponding output (pin 2) through a series resistor (about 150Ω again) to the anode of a green LED (connect the cathode of the LED to ground). Verify that the inverter works as anticipated. An illustration of what your board should look like at this point is shown in Figure 6. Notice that the LED on the output of the inverter should be illuminated as long as the button is not pushed.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156125268-dc83e82c-5aa6-4247-8402-167fd5dc58d3.png" alt="inverted LED with push button" width=600> <br>
  <b>Figure 6: Push button, inverter, and LED</b>
</p>  

> To your TA, demonstrate that when an LED connected to the input gate (pin 1) of the inverter is on, an LED connected to the corresponding output gate (pin 2) of the inverter will be off, and vice-versa. **Proving the functionality of your inverter will allow you to receive points for Step 3.**

## Step 4: Wire and verify NAND, NOR, AND, and XOR Gates
At this point, you may disconnect the inverter if you wish - it will not be tested since its functionality is very simple. Repeat Step (3), using a 74HC00 (quad 2-input NAND), 74HC02 (quad 2-input NOR), 74HC08 (quad 2-input AND), and 74HC86 (quad 2-input XOR). Read the <a href="https://engineering.purdue.edu/ece270/refs/">datasheets</a> on the ECE 270 web site’s reference page carefully to find out the function of each of the pins of each integrated circuit. You will need to connect both push buttons to make this work (you can simply attach another wire to the output of the pushbutton you used earlier as one of them). One push button will represent the X input and the other will represent the Y input. Connect each of the corresponding outputs through a series resistor(about 150Ω again) to the anode of an LED(green or yellow) and connect the cathode of the LED to ground. See Figure 7 for an example of how to wire the breadboard. **Note: You are expected to use the datasheets for each IC to build your circuit. Do not try to copy and paste the example wiring or you will run into issues. The figure below should be used for reference only.**

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156125550-22b255ea-a4dd-4c24-88a5-d53aa2fc86fa.png" alt="example wiring, step 4" width=600> <br>
  <b>Figure 7: Example wiring for Step 4</b>
</p>  

Using this circuit, complete the truth table for each of the four functions (NAND, NOR, AND, XOR) in the <a href="https://engineering.purdue.edu/ece270/submit/?item=postlab1">post-lab submission</a>.

**In addition to checking that your values are correct by hand, you will need to use the AutoLab application to programatically check your circuit. If you are working on the lab at home, download the Autolab application for your respective OS <a href="https://engineering.purdue.edu/ece270/lab/autolab/">here.</a>**

This involves making additional connections from your AD2 to your circuit at specific points, invoking the application, specifying your username and the testbench for the week's lab, and running it to get feedback on your circuit. If your circuit was built correctly, all test cases should pass, otherwise you should receive feedback on what gates don't appear to work.

**Before you do this, make sure to close WaveForms beforehand.**

To use AutoLab, first download the testbench for the lab ([Labtestfile downloaded](lab1.win.labtest) on the repository)

Make the following additional connections on your circuit:

Connect the X and Y inputs for each gate to DIO0 and DIO1.

- The NAND gate output should be connected to DIO15.
- The NOR gate output should be connected to DIO14.
- The AND gate output should be connected to DIO13.
- The XOR gate output should be connected to DIO12.

For example, if you are following the wiring shown in the picture, you may plug DIO0 in to the right side of the push button for the X input.

So long as you do not press the buttons, these connections can coexist with your existing circuitry. Figure 8, below, shows an example of the AD2 wired to the circuit using the *flywire* extension. You may use the breadboard adapter instead. It will not affect the test outcome.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156126598-f0bf5580-ff22-4a69-9cc6-3d7c104b791a.png" alt="AD2 wiring" width=600> <br>
  <b>Figure 8: AD2 wiring for Step 5</b>
</p>

Double-click on the AutoLab shortcut on your desktop. (It should appear after you re-ran the ece270-setup command when you entered the lab). The window should look like the one below. Enter your username, detect your AD2, load the testbench you just downloaded, and click Run Testbench after verifying your connections once again.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156126854-75ea961e-bcc7-4bf4-9c85-9e64c55b4381.png" alt="autolab window" width=600> <br>
  <b>Figure 9: AutoLab window</b>
</p>

> When you have recorded and verified the values for the truth tables, ask a TA to review your circuit to ensure that your gates are producing the correct outputs for different combinations of button presses. Show your TA that your circuit was validated by AutoLab. **A circuit with correct outputs will earn you points for Step 4.**

## Step 5: Schematic Capture
Draw a complete schematic of the circuit you implemented for Step (4) using the Eeschema circuit schematic tool. This schematic should include all four gates tested, a resistor and LED for each gate tested, and two push buttons (with pull-down resistors). Your completed schematic should look similar to Figure 10.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156127174-f465bf04-5818-4afa-a747-8da5616ad867.png" alt="schematic example, step 5" width=600> <br>
  <b>Figure 10: Example of the schematic for circuit used in Step 5.</b>
</p>

To open Eeschema, move your cursor to the Applications menu on top of your screen, and type in Eeschema. On first launch, you'll be asked to configure the global symbol library table - just use the recommended option to use the default one.

Some hints:

- Pressing **A** anywhere on the schematic will give you a list of components that you can add to the circuit view. You can also get the same menu by clicking the "Draw" option on the top menu.
- To draw wires, press **W** anywhere on the schematic to change to wire mode. Click once to set a point, move your mouse to the second point, and click again to set it and affix the wire.
- The AND gate in your kit is a 74HC08, which does not appear in Eeschema's symbol table. Use the 74LS08 instead.
- Ensure that all components are labeled with their respective names and/or values by pressing **E** with your mouse over the value to change it.
- To duplicate a component, hover over the component with your cursor and press **C**/right-click and press Duplicate.
- You may need to rotate some components, such as resistors. When you are adding a component attached to your cursor, or if your cursor is hovering over an existing component, press **R** to rotate it.
- Some components may have additional labels not shown in the example above. To clear those, edit the component value to contain only a space so that it appears blank.
- Be careful while making connections - if you see a **green dot** where two wires intersect, it means they're connected. Ensure that you're making any connections that aren't indicated in the example schematic by comparing the large green dots.
- To drag components around, put your cursor over the component, press **G**, move your mouse, and click to release.
- To remove a component, put your cursor over the component, press the **Delete** key, or right click to delete.
- **Connections are easier to make when all wires are perfectly horizontal and vertical. You will lose points if your schematic is not neatly drawn.**

> When you finish the schematic, zoom in so that your schematic is as big as possible on your screen, and **show it to your TA to receive points for Step 5**. Then, save the schematic file somewhere on your computer (ask your TA if you need assistance) and submit it in the post-lab submission.

## Step 6: Clear your lab station
**These instructions must be followed at the end of every lab session to receive a non-zero lab score.**

- Log out of your lab station.
- Ensure that your station workbench is clean for the next student.

**Show your cleared workspace to a TA to confirm completion of this step before you leave.**

