# Introduction to Verilog on an ice40HX8K FPGA

## Instructional Objectives

- To learn how to use the Verilog simulator to synthesize and simulate digital logic circuits.
- To learn how to synthesize and simulate a design on the FPGA breakout board.

## Introduction
Verilog is an industry-standard hardware description language. Originally developed to simulate hardware designs, Verilog has since been standardized as a way to write hardware modules in a format similar to the popular C programming language. In industry, it is used by ASIC designers to create and/or optimize hardware like memory, device controllers, processors and peripherals for embedded computers like microcontrollers. A realistic, industry-level hardware design written in Verilog can contain up to thousands of submodules, which can be mapped onto devices like C/PLDs and – in the case of ECE 270 – FPGAs.

A field-programmable gate array – or FPGA – is a device containing a large number of programmable logic cells that can be configured to behave like a given design in Verilog, VHDL, or other hardware description language. It can be reprogrammed multiple times (up to a limit) with any kind of Verilog design, assuming the design fits the FPGA constraints, like the number of available input/output pins. For the purposes of this class, you will be using the ice40HX8K FPGA, due to its ease of use and availability of actively developed open-source software.

## Step 0: Prelab

- If you haven't already, register for access to the [ECE 270 Verilog simulator](https://verilog.ecn.purdue.edu/) and take the tutorial.
- Read the **entire** lab document.
- Do the prelab assignment on the course web page.

### Step 0.5: Software setup

Re-run the ece270-setup script as you did for previous labs. Open a file manager, go to your home folder, then ece270, and you should see a lab05 folder. Open it. You should see some files, including a "top.sv". This file is where your code will go.

The others include support code needed to make your top module portable to your FPGA. There is also a Makefile which you will run later to actually perform the needed compilation, synthesis and flashing actions to get the test design on to the FPGA.

To edit top.sv, you may use any editor you wish by downloading it and placing it in a convenient location. If you have no preference, your lab station comes with a code editor named Kate. You can open Kate by right-clicking on top.sv, clicking "Open with other application", and in the window that appears, select Kate.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156307590-ed99fb42-6a15-4460-ad16-8baf2c4fa1d4.png" alt="Kate viewer" width=300>
</p>

When it opens, you should see the following:

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156307689-be6dd401-6094-4895-a697-8b19000692a5.png" alt="Kate opened" width=600>
</p>

We're now going to set this up so you can easily compile/synthesize and flash your design without having to leave the window. You'll need to add the Build Plugin by going to Settings > Configure Kate > Plugins, and ticking the box for "Build Plugin". Close the window, and click on the newly added "Build Output" tab at the bottom of the window to bring up the list of commands to run - this is where you will add commands to run the Makefile.

Add a target with the title 'cram', and the necessary Makefile command as shown below:

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156307751-5e81f717-3ff8-4acb-9b22-56f738a4d800.png" alt="cram target" width=600>
</p>

Notice the checkbox? That indicates that this is the default target. You can configure Kate to quickly re-compile/synthesize and flash your code by just pressing F2 on your keyboard, which can be configured to run the default target. You can set up the F2 shortcut by clicking on Settings > Configure Shortcuts, searching for "build", clicking "Build Default Target" when it appears, and setting the Custom shortcut to F2.

## Step 1: Run test file and light up LEDs on FPGA

You will test the LEDs on the FPGA to ensure that they all work. To set it up, add a target with the title 'check' and modify the Kate Build Tool to run "make check". Press any of the buttons 0-F and you should see all eight seven-segments light up on the FPGA as shown below:

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156307893-85f4eaaf-68cc-484e-89f9-1893ac247c7b.png" alt="fpga" width=300>
</p>

In addition, press the letters W,X,Y,Z in order to see the RGB LED in the middle light up. When **W** is pressed, blue should light up. When **X** is pressed, green should light up. When **Y** is pressed, red should light up. When **Z** is pressed, all the colors (blue, red and green) should light up which would result in the color white.

> **Demonstrate that all LEDs light up on the FPGA to your TA to receive a checkoff.**

## Step 2: Run demo file and observe behavior on FPGA

The demo program you're going to play is based on a lab from last semester. You may or may not see this again later on in the class, but it is definitely a taste of things to come. If you haven't played it before, Hangman is a very simple game where you guess a unknown word with a limited number of tries. On the FPGA board, we'll use words made from the letters A, B, C, D, E, F. If you look at the pushbuttons on your lab board/virtual simulator board, you'll understand why we have this odd limitation.

We'll limit it to six tries, which is two free tries + the length of the word, and have you try guessing different words. To set it up, add a target with the title 'demo' and modify the Kate Build Tool to run "make demo". What this does is flash a **binary** file, which contains the necessary data to "configure" your FPGA to set up the Hangman game in hardware. You should see a counter on ss7 initialized to 6.

Try guessing the word by pressing the A-F pushbuttons. If you pick a letter, the game will check if you pressed a letter that exists in the word, and display the letter if it exists. Notice the counter will decrease by 1 with each try. You win the game if you manage to guess the full word before the six tries are up, when the green LED will flash at 1 Hz. You lose if you reach zero and did not manage to find all the letters, as a result of which the red LED will flash at 1 Hz. You can try a new word by pressing "Z". Play as much as you'd like, and let your TA know if you'd like to see more!

> **Demonstrate the hangman game to your TA on the FPGA to receive a checkoff.**

## Step 3: Clean up your lab station and log out

> If you find your lab station unresponsive, **do not restart the computer**. Notify a TA and we'll take care of it.

Ensure that your station is free of breadboard debris like small jumper wires and resistors. Pull the oscilloscope/DMM cables up above the monitors so they don't hang in front of the monitor, and be sure that you have logged out of your lab station. Your TA should confirm that your station is clean and logged out.
