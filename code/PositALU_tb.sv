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
