# Combinational Building Blocks

## Instructional Objectives

- To practice encoding digital circuit design into Verilog and simulating it before physical construction.
- To learn about combinational building blocks, specifically, a decoder and practice implementing a system of combinational functions using decoders.

## Introduction

A *decoder* is a combinational device that accepts a compact binary-encoded input and activates at most one output. It is useful as a selector, and this is the most common idiom for its use. When creating a digital system, you will use a decoder when you have an N-bit binary-encoded value and you want to select one of 2<sup>N</sup>-1 things. The decoder does this selection process.

This selection mechanism is another way of expressing the *minterm* number corresponding to a set of literals. If the inputs to a 3-to-8 decoder correspond to literals X,Y, and Z, where X is connected to the most significant input, the eight outputs, numbered y0 – y7, would be activated in a way that would indicate the minterm representation of the input. For instance, if XYZ = 110, this is the binary representation of 6, and the output y6 would be active to reflect that. This would be represented by the product term X\*Y\*Z'.

### Implementing logic functions

By using a decoder as a minterm generator, a sum-of-products expression can be easily realized. For a decoder with active-high outputs, each output is effective the AND of the literal symbols that constitute each minterm. These would be summed by using an OR gate so that each input is connected to the minterm output of each product term of the expression. For instance, if the desired function to realize is X'\*Y\*Z + X\*Y'\*Z, these product terms are represented by the minterms 3 and 5, respectively. By connecting OR gate inputs to the y3 and y5 outputs of the decoder, the OR gate output would realize the function.

### Decoders with active-low outputs

If a decoder with active-high outputs, as just described, whose outputs represent the AND of literal product elements, can be used with an OR gate to produce a sum-of-products expression, then we can use DeMorgan's Law to turn the AND-OR tree into a NAND-NAND tree. A decoder with inverted outputs can be thought of as a NAND of the literal product components. If another NAND is used to "sum" multiple outputs together, the result is the NAND-NAND equivalent of the sum-of-products expression.

For the previous example, to implement X'\*Y\*Z + X\*Y'\*Z + X\*Y\*Z, we know that a 3-to-8 decoder with active-low outputs represents (X'\*Y\*Z)' with output 3, (X\*Y'\*Z)' with output 5, and (X\*Y\*Z)' with output 7. By using an enclosing NAND for all three terms, we get:

```
((X'*Y*Z)' * (X*Y'*Z)' * (X*Y*Z)' )'

```     
Which, by a single application of DeMorgan's Law is equivalent to:

```
(X'*Y*Z) + (X*Y'*Z) + (X*Y*Z)
```      

### Implementing the complement of a function

The complement of an expression can also be realized by using an AND gate instead of a NAND. This is useful when realizing a function where most of the available minterms are used. It is then more efficient to implement the complement of the function by selecting the minterms that are not used. For instance, for the function:

```
F(X,Y,Z) = X'*Y'*Z' + X'*Y'*Z + X'*Y*Z' + X'*Y*Z + X*Y'*Z + X*Y*Z'
```

You may notice that there are six product terms. The only two missing are X\*Y'\*Z' and X\*Y\*Z. Implementing the complement is easy:

```          
F'(X,Y,Z) = X*Y'*Z' + X*Y*Z
````

By inverting the output of F'(X,Y,Z), we implement the desired function:

```          
F(X,Y,Z) = ( X*Y'*Z' + X*Y*Z )'
```

For a decoder with active-low outputs, efficient implementation of the complement of the sum-of-products expression is done using an AND gate instead of a NAND gate.

### Details about the 74HC138

The 74HC138 is a 3-to-8 decoder with active-low outputs, and it can be used in this manner. It also has three *enable* inputs. All of these enable inputs must be properly set for any of the outputs to become active. Two of the enable inputs, e1 and e2, are active-low, and the third, e3, is active-high. For any output to be active (low) e1 and e2 must be low, and e3 must be high.

### Building a 4-to-16 decoder from two 74HC138 chips
The three enable signals are arranged as they are to allow easy creation of a larger decoder. For instance, consider the case where two 74HC138 chips are used, with selection signals S,T,U connected to the 3 inputs of each. A fourth selection signal, R, could be added by connecting (0,R,1) to e1,e2,e3 of one chip, and connecting (0,0,R) to e1,e2,e3 of the second chip. This means that the first chip's outputs will be enabled when R is low (to make e2 active), and the second chip's outputs will be enabled when R is high (to make e3 active). The result is a 4-to-16 decoder, where the first chips eight outputs represent minterms 0 – 7, and the second chip's outputs represent minterms 8 – 15.

The image below shows the initial circuit to construct for the lab experiment. Each of the two 74HC138 chips is configured so that only one of them will have an active output, based on the state of the R input. Given the 16 active-low output terms, a three-input NAND gate can be used to implement any sum-of-products function with three product terms.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156424146-2778aba8-ce4b-4bcf-91d0-ae23be85ad40.png" alt="4-16 decoder" width=500>
</p>

## Step 0: Prelab

The prelab assignment lists the sum-of-products expression for each of the eight functions you will construct for this lab experiment. You will realize each of these functions in the Verilog simulator using a provided model for the 74HC138 chip.

## Step 1: Construct the system described in the prelab

Using the specifications for the eight functions found in the prelab, construct a system to realize the eight functions. Start with the circuit shown above. Use either a 74HC10 triple 3-input NAND gate or a 74HC08 two-input AND gate to implement each function.

Connect a LED (of any color) with a 150Ω series resistor to the output of each NAND or AND gate. Carefully verify that your circuitry implements each function properly. E.g., if F3 is supposed to implement a function that is the sum of minterms 3, 9, and 14, ensure that it lights the LED only when the RSTU buttons are in one of these states: 0011, 1001, or 1110.

As you can see, in the picture below, neatness is a good idea, but not very practical for an undertaking like this. Wire one function at a time. Test it. Then move on to the next function.

<p align=center>
  <img src="https://user-images.githubusercontent.com/37441514/156424284-4e77e77a-639f-4b7a-9a6d-a22e02603de6.png" alt="example wiring" width=600>
</p>

> **Note: Your functions will be wired differently than pictured above. Do not copy the example wiring.**

### Create a completion code and submit it

When you are satisfied with the correctness of your implementation, connect the AD2 to your circuit to test it. Autolab will evaluate the result of each of your eight functions to all 16 combinations of the inputs, R,S,T, and U.

The AD2 pin connections are as follows:

- DIO 3: R
- DIO 2: S
- DIO 1: T
- DIO 0: U
- DIO 8: F0
- DIO 9: F1
- DIO 10: F2
- DIO 11: F3
- DIO 12: F4
- DIO 13: F5
- DIO 14: F6
- DIO 15: F7

Be sure to connect the AD2 DIO wires to the chip inputs and outputs. If there are resistors or LEDs between the chips and the DIO leads, you may experience problems.

Once you have confirmed your values using [autolab](lab7.lnx.labtest), make sure to submit the completion code in your post-lab.
