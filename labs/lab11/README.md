# Counters, Shift Registers, and Verdle!

## Instructional Objectives

- To learn how to implement counters and shift registers in the context of a larger design.
- To learn how to use the Verilog simulator to synthesize and simulate digital logic circuits.
- To learn how to synthesize and simulate a design on the FPGA breakout board.

## Introduction
This lab will be your first complex design lab in Verilog. Labs like these will require you to implement a set of submodules that will exercise your knowledge of Verilog syntax, combinational and sequential devices, and how to apply the former to implement the latter.

In the interest of keeping things interesting, we'll have you implement a game for a lab. By now, most of you have heard of, tried and played (and possibly gotten tired of) the online word puzzle called Wordle. If you're out of the loop, Wordle is a game where you have to guess a five-letter word in six guesses. You can try out the game yourself [here](https://www.nytimes.com/games/wordle/index.html).

For this lab, we're playing **Verdle** - Verilog Wordle! We'll make the following changes.

- Instead of five letters, we'll use six. This is primarily a cosmetic decision.
- Instead of six guesses, we'll have infinite guesses. This will make it easier to implement and test.

You'll play this game by using the **UART** (universal asynchronous receiver/transmitter) that comes with the FPGA. This allows us to make use of all the letters A-Z, rather than A-F on the FPGA board itself.

You will be expected to design some support submodules to implement the game. A comprehensive block diagram showing all the modules that will be used in your design are shown below. We'll explain some of these in detail below.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/162127703-1634f750-55aa-4f81-8e62-b37a57bd3c43.png" alt="algorithm" width=600>
</p>

- **ice40hx8k** is the highest module in this diagram that will instantiate the top module.
- The **UART peripheral** is a device most commonly used in embedded systems to transmit and receive data over a serial port. We provide the necessary Verilog to make it work with our game.
- The **top** module should be famililar to you - this is where you will instantiate the main Verdle game module.
- **verdle** contains a controller for the game, composed of a very large finite state machine (FSM), but since that may be too large for a first design lab, we'll have you implement some simpler submodules first. It instantiates four other support submodules for the game - **verifier**, **charbuf**, **printer**, **ssdisplay** - two of which you will implement.
- **verifier** has two purposes - to set the initial word to guess, and to compare the entered word to the initially set word.
- **charbuf** is a shift register to store the characters that you will enter while trying to guess the word.
- **printer** is fundamentally a type of parallel-in-serial-out shift register (which takes an 8-bit bus, and then on every clock edge, sends each bit of the data out on a 1-bit serial output). This module is responsible for sending messages, and echoing back the characters you type to guess your word.
- Finally, **ssdisplay** will make use of six seven-segment displays on the FPGA to show "good job" or "try again" depending on whether the words matched.

## Step 0.5: Software Setup

Run the **ece270-setup** command on your computer by either double-clicking the shortcut on your desktop, or by opening a terminal and typing ~ece270/bin/setup. This should set up the lab11 folder in your ece270 folder.

## Step 1: Integrate all your submodules and play Verdle!

Open the lab11 folder inside the ece270 folder, and double-click on top.sv. Copy in all the submodules you wrote for your prelab, and run the verify target (it should execute "make clean; make verify").

Then, add the following instantiation to your top module.

```
verdle v (
  .clk(hz100), .rst(reset),
  .txready(txready), .rxready(rxready),
  .txclk(txclk), .rxclk(rxclk), 
  .rxdata(rxdata),
  .txdata(txdata),
  .ssout({ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0})
);
```

> Make sure to get checked off for your demo before you leave!
> 
> No need to save anything in your postlab...

## Step 2: Clean up your lab station and log out

> If you find your lab station unresponsive, **do not restart the computer**. Notify a TA and we'll take care of it.

Ensure that your station is free of breadboard debris like small jumper wires and resistors. Pull the oscilloscope/DMM cables up above the monitors so they don't hang in front of the monitor, and be sure that you have logged out of your lab station. Your TA should confirm that your station is clean and logged out.
