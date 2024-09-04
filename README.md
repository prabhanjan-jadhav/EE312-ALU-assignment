# 8-bit Arithmetic Logic Unit (ALU) for the Posit Number System

## Introduction

This project implements an 8-bit Arithmetic Logic Unit (ALU) designed specifically for the Posit number system. The Posit number system, introduced by Dr. John L. Gustafson in 2017, is an alternative to the traditional IEEE 754 floating-point format. Posits provide a more uniform distribution of representable numbers and feature tapered precision, which varies smoothly depending on the number's magnitude. This makes Posits particularly advantageous for high-performance computing and applications requiring high numerical precision.

## Features

- **Posit Number System Support**: The ALU is designed to work with the Posit number system, handling 8-bit Posit numbers with accuracy and efficiency.
- **Arithmetic Operations**: The ALU supports addition, subtraction, multiplication, and division.
- **Logical Operations**: The ALU can perform logical operations, including AND, OR, XOR, and NOT.
- **Modular Design**: The ALU is composed of individual modules for decoding, arithmetic operations, logical operations, and result normalization, promoting modularity and scalability.

## Project Structure

### Modules

1. **Decoding and Input Conditioning**:
    - **Functionality**: Decodes 8-bit Posit numbers into their components: sign, regime, exponent, and significand.
    - **Input**: 8-bit Posit number.
    - **Output**: Decomposed components.

2. **Arithmetic Operations**:
    - **Addition and Subtraction**:
        - Decodes the Posit inputs.
        - Aligns significands based on exponents.
        - Performs the addition or subtraction.
        - Normalizes the result.
    - **Multiplication**:
        - Multiplies two Posit numbers.
        - Normalizes the product.
    - **Division**:
        - Divides two Posit numbers using a combination of polynomial and iterative approximation.
        - Normalizes the quotient.

3. **Logical Operations**:
    - **Supported Operations**: AND, OR, XOR, NOT.
    - **Simpler Implementation**: These operations do not require Posit decomposition.

4. **Integrated ALU Module**:
    - Combines all arithmetic and logical operations.
    - Selects operation based on a 3-bit opcode.
    - Outputs the 8-bit Posit result.

### Testbench

- The testbench (`PositALU_tb.sv`) verifies the functionality of the ALU through simulation using the Icarus Verilog toolchain.

## Verilog Code Execution

To simulate and verify the ALU's functionality, use the following commands:

```bash
$ iverilog -o PositALU_tb.vvp PositALU_tb.sv PositALU.sv PositAddSub.sv PositMul.sv PositDiv.sv PositLogicalOps.sv PositDecoder.sv
$ vvp PositALU_tb.vvp
```

## References

- [Gustafson, J.L. (2017). Beating Floating Point.](http://www.johngustafson.net/pdfs/BeatingFloatingPoint.pdf)
- [Anatomy of a Posit Number](https://www.johndcook.com/blog/2018/04/11/anatomy-of-a-posit-number/)
- [IEEE Explore Paper on Posit Arithmetic](https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=8715262)
- [Posit Standard 2.0](https://posithub.org/docs/posit_standard-2.pdf)
- [Posit HDL Arithmetic](https://github.com/manish-kj/Posit-HDL-Arithmetic/tree/master)

## Conclusion

This project demonstrates the design and implementation of a versatile 8-bit ALU tailored for the Posit number system, showcasing its potential for use in applications that demand high numerical precision and performance.
