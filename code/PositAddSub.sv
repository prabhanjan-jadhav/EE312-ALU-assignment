/*
Addition and Subtraction Module
Overview:
Input: Two 8-bit Posit numbers for addition or subtraction.
Output: An 8-bit Posit number representing the result of the operation.
Explanation:
  ● Posit Decoders: Two instances of the PositDecoder module decode the Posit inputs into their components.
  ● Total Exponent Calculation: The total exponent is calculated by adding the regime and exponent for each Posit number.
  ● Significand Alignment: The significands are aligned based on their exponents to prepare for arithmetic operations.
  ● Arithmetic Operation: Depending on the add_sub signal, either addition or subtraction is performed.
  ● Normalization: The result is normalized to fit into the Posit format, handling any potential overflow.
*/

module PositAddSub(
    input [7:0] posit1,
    input [7:0] posit2,
    input add_sub, // 0 for addition, 1 for subtraction
    output [7:0] result
);
    wire sign1, sign2;
    wire [2:0] regime1, regime2;
    wire [2:0] exponent1, exponent2;
    wire [1:0] significand1, significand2;

    // Instantiate Posit decoders for both inputs
    PositDecoder decoder1(.posit(posit1), .sign(sign1), .regime(regime1), .exponent(exponent1), .significand(significand1));
    PositDecoder decoder2(.posit(posit2), .sign(sign2), .regime(regime2), .exponent(exponent2), .significand(significand2));

    // Internal signals for the arithmetic process
    wire [2:0] total_exponent1, total_exponent2;
    wire [7:0] aligned_significand1, aligned_significand2;
    wire [7:0] sum;
    wire overflow;
    wire [2:0] result_exponent;
    wire [1:0] result_significand;

    // Calculate total exponent (regime + exponent)
    assign total_exponent1 = regime1 + exponent1;
    assign total_exponent2 = regime2 + exponent2;

    // Align significands based on exponents
    // Considering 8-bit significands for simplicity in alignment
    align_significands align1(.significand(significand1), .exponent_diff(total_exponent1 - total_exponent2), .aligned_significand(aligned_significand1));
    align_significands align2(.significand(significand2), .exponent_diff(total_exponent2 - total_exponent1), .aligned_significand(aligned_significand2));

    // Perform addition or subtraction
    assign sum = add_sub ? (aligned_significand1 - aligned_significand2) : (aligned_significand1 + aligned_significand2);

    // Handle overflow and normalize the result
    normalize_result normalizer(.sum(sum), .overflow(overflow), .result_exponent(result_exponent), .result_significand(result_significand));

    // Construct the result Posit
    assign result = {sign1, result_exponent, result_significand};

endmodule

// Helper modules for alignment and normalization 
module align_significands(
    input [1:0] significand,
    input [2:0] exponent_diff,
    output reg [7:0] aligned_significand
);

    always @(significand or exponent_diff) begin
        if (exponent_diff[2]) begin
            aligned_significand = significand << exponent_diff;
        end
        else begin
            aligned_significand = significand >> -exponent_diff[2:0];
        end

        // Pad with zeros to fit 8-bit aligned significand
        aligned_significand = aligned_significand & 8'hFF;

        // Debug prints
        $display("significand = %b, exponent_diff = %b, aligned_significand = %b", significand, exponent_diff, aligned_significand);
    end

endmodule


module normalize_result(
    input [7:0] sum,
    output reg overflow,
    output reg [2:0] result_exponent,
    output reg [1:0] result_significand
);

    always @(sum) begin
        // Detecting overflow
        overflow = (sum[7] == 1'b1);

        // Normalizing the result
        if (overflow) begin
            // In case of overflow, adjust the result
            result_significand = sum[7:6]; // Take the most significant bits
            result_exponent = 3'b111; // Maximum exponent in case of overflow
        end else begin
            // In the normal case
            result_significand = sum[1:0]; // Take the least significant bits
            result_exponent = sum[4:2]; // Middle bits as exponent
        end
    end

endmodule
