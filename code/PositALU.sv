/*
Integrated ALU Module
The final integrated ALU module for the Posit number system, as developed, is a comprehensive unit capable of performing both arithmetic and logical operations. Below is a description of its key components and functionalities:
Description
1. Inputs:
  a. Posit1 and Posit2: These are the two 8-bit Posit operands on which the ALU performs operations.
  b. Opcode: A 3-bit code that determines the operation to be performed by the ALU. The opcode is decoded to select between arithmetic and logical operations.
2. Internal Modules:
  a. Arithmetic Modules:
    i. PositAddSub: Handles both addition and subtraction of Posit numbers.
    ii. PositMul: Manages multiplication of Posit numbers.
    iii. PositDiv: Executes division operations on Posit numbers.
  b. Logical Operations Module (PositLogicalOps): This module performs logical operations (AND, OR, XOR, NOT) directly on the 8-bit Posit operands without decomposing them into their constituent parts.
3. Operation Selection: Based on the opcode, the ALU selects the appropriate operation:
    a. 000-011: Arithmetic operations (Add, Sub, Mul, Div).
    b. 100-111: Logical operations (AND, OR, XOR, NOT).
4. Result Generation: The ALU outputs an 8-bit Posit number as the result of the selected operation.
*/

module PositALU(
    input [7:0] posit1,
    input [7:0] posit2,
    input [2:0] opcode,  // Expanded opcode (3 bits)
    output reg [7:0] result
);

    wire [7:0] add_result, sub_result, mul_result, div_result;

    // Instantiate arithmetic operation modules
    PositAddSub adder(.posit1(posit1), .posit2(posit2), .add_sub(0), .result(add_result));
    PositAddSub subtractor(.posit1(posit1), .posit2(posit2), .add_sub(1), .result(sub_result));
    PositMul multiplier(.posit1(posit1), .posit2(posit2), .result(mul_result));
    PositDiv divider(.posit1(posit1), .posit2(posit2), .result(div_result));


    wire [7:0] logical_result;

    // Instantiate Logical Operations module
    PositLogicalOps logicalOps(.posit1(posit1), .posit2(posit2), .logical_opcode(opcode[1:0]), .result(logical_result));

    // Modify the always block to include logical operations
    always @(opcode, add_result, sub_result, mul_result, div_result, logical_result) begin
        case(opcode)
            3'b000: result = add_result;
            3'b001: result = sub_result;
            3'b010: result = mul_result;
            3'b011: result = div_result;
            3'b100, 3'b101, 3'b110, 3'b111: result = logical_result;  // Logical operations
            default: result = 8'b00000000;
        endcase
    end
endmodule

PositALU_tb.sv
module test_PositALU;
    reg [7:0] posit1, posit2;
    reg [2:0] opcode;
    reg [7:0] expected_result;  // Declare expected_value as a reg
    wire [7:0] result;

    // Instantiate the ALU
    PositALU uut (
        .posit1(posit1),
        .posit2(posit2),
        .opcode(opcode),
        .result(result)
    );

    // Rest of the test bench...
    
    initial begin
    	$dumpfile("my_PositALU_tb.vcd");
		$dumpvars(0, test_PositALU);
		// Example test case: Addition
		posit1 = 8'b00000001;  // Replace with specific Posit value
		posit2 = 8'b00000001;  // Replace with specific Posit value
		expected_result = 8'b00000010; // Replace with specific Posit value
		opcode = 3'b000;     // Opcode for addition
		#10;                 // Wait for the operation to complete

		// Check the result and display
		if (result != expected_result)  // Replace expected_result with the correct one
			$display("Addition Test failed: posit1 = %b, posit2 = %b, result = %b", posit1, posit2, result);
		else
			$display("Addition Test passed");

		// Example test case: Subtraction
		posit1 = 8'b00000010;  // Replace with specific Posit value
		posit2 = 8'b00000001;  // Replace with specific Posit value
		expected_result = 8'b00000001; // Replace with specific Posit value
		opcode = 3'b001;     // Opcode for subtraction
		#10;

		// Check the result and display
		if (result != expected_result)
			$display("Subtraction Test failed: posit1 = %b, posit2 = %b, result = %b", posit1, posit2, result);
		else
			$display("Subtraction Test passed");
	end

endmodule
