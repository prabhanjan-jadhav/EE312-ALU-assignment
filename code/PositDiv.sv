/*
Division Module
Overview:
Input: Two 8-bit Posit numbers, dividend and divisor.
Output: An 8-bit Posit number representing the quotient.
Explanation:
  ● Posit Decoders: Decode the dividend and divisor into their components.
  ● Output Sign: The sign of the quotient is determined by the XOR of the signs of the dividend and divisor.
  ● Total Exponent Calculation: The total exponent for the quotient is the difference between the exponents of the dividend and divisor.
  ● Significand Division: The significands are divided. To ensure precision, they are extended before division.
  ● Normalization: The quotient is normalized using the normalize_quotient helper module.
  ● Result Construction: The result is assembled from the normalized components.
*/
module PositDiv(
    input [7:0] posit1,  // Dividend
    input [7:0] posit2,  // Divisor
    output [7:0] result  // Quotient
);
    wire sign1, sign2;
    wire [2:0] regime1, regime2;
    wire [2:0] exponent1, exponent2;
    wire [1:0] significand1, significand2;
	
	wire [3:0] extended_significand1, extended_significand2;
	extend_significands extend1(.significand(significand1), .extended_significand(extended_significand1));
	extend_significands extend2(.significand(significand2), .extended_significand(extended_significand2));

    // Instantiate Posit decoders for both inputs
    PositDecoder decoder1(.posit(posit1), .sign(sign1), .regime(regime1), .exponent(exponent1), .significand(significand1));
    PositDecoder decoder2(.posit(posit2), .sign(sign2), .regime(regime2), .exponent(exponent2), .significand(significand2));

    // Calculate the output sign
    wire result_sign;
    assign result_sign = sign1 ^ sign2; // XOR for division sign

    // Calculate the total exponent for the quotient
    wire [4:0] total_exponent;
    assign total_exponent = regime1 + exponent1 - (regime2 + exponent2);

    // Divide the significands
    wire [1:0] quotient_significand;
    // Simple division, assuming significands are extended to prevent loss of precision
    assign quotient_significand = extended_significand1 / extended_significand2;

    // Normalize the result
    wire [2:0] normalized_exponent;
    wire [1:0] normalized_significand;
    normalize_quotient normalizer(.quotient_exponent(total_exponent), .quotient_significand(quotient_significand), .normalized_exponent(normalized_exponent), .normalized_significand(normalized_significand));

    // Construct the result Posit
    assign result = {result_sign, normalized_exponent, normalized_significand};

endmodule

// Helper modules for extending significands and normalizing the quotient
module extend_significands(
    input [1:0] significand,
    output reg [3:0] extended_significand
);

    always @(significand) begin
        // Extend the 2-bit significand to 4 bits
        // Padding with zeros on the left to maintain precision
        extended_significand = {2'b00, significand};
    end

endmodule


module normalize_quotient(
    input [4:0] quotient_exponent,
    input [1:0] quotient_significand,
    output reg [2:0] normalized_exponent,
    output reg [1:0] normalized_significand
);

    always @(quotient_exponent or quotient_significand) begin
        // Normalizing the quotient
        // Assuming the quotient_significand is already the result of division
        normalized_significand = quotient_significand;

        // Adjust the normalized exponent to fit in 3 bits
        // Simple form of underflow/overflow handling
        if (quotient_exponent > 3'b111) begin
            normalized_exponent = 3'b111; // Cap at maximum if overflow
        end else if (quotient_exponent[4] == 1'b1) begin
            normalized_exponent = 3'b000; // Set to minimum if underflow
        end else begin
            normalized_exponent = quotient_exponent[2:0]; // Normal case
        end
    end

endmodule
