# Counters, State Machines, and Hangman 

## Instructional Objectives

- To learn about and practice implementing binary counters.
- To learn about using counters as pre-scalers for clocks.
- To learn how to implement sequential state machines.
- To learn how to accurately design and test submodules for an unspecified larger design.

## Introduction

This lab will have you develop a binary up counter, and make modifications to it to give it the capability of counting both up and down and counting to a variable limit, then using it as a prescaler for the hz100 clock signal that you may have noticed in the top module template.

The 'hz100' signal toggles at a frequency of 100 Hz (hence the name) and is capable of being used in designs that require accurate clock signals, such as stopwatches and timers. We can build these devices with the help of counters, and use these devices to build (hopefully) fun games. :)

## Step 0: Prelab

- Read the **entire** lab document.
- Do the [prelab assignment](https://engineering.purdue.edu/ece270/submit/?item=prelab12) on the course web page.

## Step 1: Modify prelab counter to add up/down counting mode

**Re-run the ece270-setup script to get a lab12 folder, which will contain the files necessary to implement your design.**

**At this point, you should have a verified counter that is able to count to 8'd99 as indicated by the output, and upon reaching 8'd99, will restart at zero on the next clock toggle. The counter must be a module named count8du, and the only additional line in your top module must be the module instantiation of count8du, i.e. all counter-based logic must be in your count8du module and not your top module.**

For this step, you will modify the count8du module that you wrote in the prelab to be able to make it count up or down based on a new input. To start, add a new 1-bit input called **DIR** to your module's port header (alongside input logic CLK, RST, enable, and output logic [7:0] out). In the module instantiation in your top module, add the DIR port and connect it to pb[17].

Copy the count8du module you wrote in the prelab below your top module in your top.sv file/simulator tab. In the always_comb block of your module, modify your logic so that:

- If DIR is equal to zero, the value of next_Q is updated to Q - 1. If the value of Q is zero, next_Q should be equal to 8'd99.
- Else, if DIR is equal to one, the value of next_Q is updated to Q + 1. If the value of Q is 8'd99, next_Q should be equal to 0.

Ensure that your design matches the output shown below. Similar to how you ensured that your design counted to 8'd99 and then started again at 0 in your prelab, ensure that your counter goes all the way from 8'd99 to 0 when counting down, and from 0 to 8'd99 when counting up, and restarts accordingly. 

> **Show your design on the FPGA to your TA to receive a checkoff.** TAs will ensure that your design is able to count both up and down by pressing and releasing pb[17] respectively.

## Step 2: Modify prelab counter to count to an arbitrary number N

For this step, you will modify the count8du module from the previous step to make it count to any number N (inclusive), rather than just 8'd99. To start, add a new 8-bit input called **MAX** to your module's port header and in the module instantiation in your top module, add the MAX port and connect it to a Verilog literal 8'd49.

Since you already have logic in place to set next_Q to a specific value (8'd99) from earlier, all you have to do is replace those occurrences of 8'd99 with MAX.

As a result, your counter should now reset to zero twice as fast as the previous version. 

> **Show your design on the FPGA to your TA to receive a checkoff.** TAs will ensure that your design is able to count to a specific value by specifying it in the code and watching the flashed design.

We recommend changing MAX in the top module to different values to see if the counter correctly counts to and from the specified limit.

## Step 3: Use your counter as a hz100 clock prescaler and verify it

**For this step, it is extremely crucial that your instance name for count8du in the top module from the previous step is c8_1 - if it is not, your code will not be correctly verified!**

Now that we have a counter capable of changing direction and value limit, we can use this as a prescaler for the hz100 signal. If you wanted to make a stopwatch, for example, a prescaler could theoretically divide down the frequency of the hz100 signal (intuitively, you should know it is 100 Hz, or one can say that the signal goes high every 0.01 seconds) to smaller values like 50, 25, 10 or even 1 Hz, turning the counter into a second-timer.

In your top module, create two 1-bit signals called **flash** and **hz1**, and an 8-bit bus called **ctr**. Replace **right** in the **count8du** out port connection with **ctr**, and change **DIR** to 1'b0 so you don't have to hold down the buttons.

In order to flash a signal at 1 Hz, we can check if the counter reaches a specific value given a known clock speed. In our case, we have a 100 Hz clock in **hz100**. If we count to 99, we know that it takes 100 clock cycles to reach that value from 0, so reaching 99 means a full second has passed.

However, we only have a very short period of time before that 99 changes to 0. On the simulator, this results in a weird pulse signal that looks unreliable to use as a clock signal somewhere else. We will therefore use a toggle flip-flop that will be ON for half the period, and OFF for the other half, as our clock.

To do this, create an always_ff block with **hz100** as the clock signal and **reset** as the reset signal. In it, set hz1 to 0 if **reset** is high, otherwise set it to the expression "ctr == 8'd49". (Why 49 and not 99? Try both values after you've fully written the code. Which one gives you a 1 Hz clock?)

Create a second always_ff block with **hz1** as the clock, and **reset** as the reset signal. In it, set **flash** to 0 if reset is high, otherwise set it to the inverse of **flash**.

Connect **flash** to blue, and run your code. You should see a 1 Hz flash on the blue LED in the center of the FPGA.

Finally, run "make verify" to do a final check of your count8du module. It should look like this: 

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/163573572-a27aebf0-ad9d-4f10-b8ab-9ae989734bc5.png" alt="traces" width=600>
</p>

**If you are doing this on the simulator, make sure to do this when you get to lab.**

> **Show the verification waveform to your TA, as well as the 1-Hz-flashing blue LED to get credit for this step.**

## Step 4: Integrate your submodules into the Hangman game

**Before starting this step, copy the ssdec module that you built for lab below your top module, in the file/simulator tab that you're working in.**

If you haven't played this before, Hangman is a very simple game where you guess a unknown word with a limited number of tries. On the FPGA board, we'll use words made from the letters A, B, C, D, E, F. If you look at the pushbuttons, you'll understand why we have this odd limitation. We'll limit it to six tries - two free tries + the length of the word - and have you try guessing different words.

We've only given you the ability to instantiate the module in your code, but not actually read the module yourself.

To set it up:

- If you're doing this in the lab, all you need to do is write the instantiation below in your top module. Hangman is available as hangman.json (a gate-level netlist generated from our code) in your lab12 folder.
- If you are doing this on the simulator, make sure to add the hangman module to your workspace file list by going to the workspace settings (the gear icon on the workspace tab) and ticking the box for "hangman.sv", in addition to writing the instantiation below in your top module.

Write the following instantiation into your top module and simulate/run "make cram".
```
hangman hg (.hz100(hz100), .reset(pb[19]), .hex(pb[15:10]), .ctrdisp(ss7[6:0]), .letterdisp({ss3[6:0], ss2[6:0], ss1[6:0], ss0[6:0]}), .win(green), .lose(red), .flash(flash));
```
You should see a counter on ss7 initialized to 6. Try guessing the word by pressing the A-F pushbuttons. If you pick a letter, the game will check if you pressed a letter that exists in the word, and display the letter if it exists. Notice the counter will decrease by 1 with each try.

You win the game if you manage to guess the full word before the six tries are up, when the green LED will flash at 1 Hz - this is possible because of the counter you wrote! You lose if you reach zero and did not manage to find all the letters, as a result of which the red LED will flash at 1 Hz. You can try a new word by pressing "Z".

> **Show your TA your working design. Let the TA know if you enjoyed the design, and if you'd like to see more. In your post-lab submission, submit the top and count8du modules.**

