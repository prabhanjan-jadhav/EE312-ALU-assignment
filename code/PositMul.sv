/*
Multiplication Module
Overview:
Input: Two 8-bit Posit numbers to be multiplied.
Output: An 8-bit Posit number representing the product.
Explanation:
    ● Posit Decoders: Two instances of the PositDecoder module decode the inputs into their respective components.
    ● Output Sign: The sign of the product is determined by the XOR of the signs of the inputs.
    ● Total Exponent Calculation: The total exponent for the product is the sum of the exponents of the inputs.
    ● Significand Multiplication: The significands of the inputs are multiplied.
    ● Normalization: The product is normalized to ensure it fits the Posit format, using the normalize_product helper module.
    ● Result Construction: The result is constructed from the normalized components.
*/
module PositMul(
    input [7:0] posit1,
    input [7:0] posit2,
    output [7:0] result
);
    wire sign1, sign2;
    wire [2:0] regime1, regime2;
    wire [2:0] exponent1, exponent2;
    wire [1:0] significand1, significand2;

    // Instantiate Posit decoders for both inputs
    PositDecoder decoder1(.posit(posit1), .sign(sign1), .regime(regime1), .exponent(exponent1), .significand(significand1));
    PositDecoder decoder2(.posit(posit2), .sign(sign2), .regime(regime2), .exponent(exponent2), .significand(significand2));

    // Calculate the output sign
    wire result_sign;
    assign result_sign = sign1 ^ sign2; // XOR for multiplication sign

    // Calculate the total exponent for the product
    wire [4:0] total_exponent;
    assign total_exponent = regime1 + exponent1 + regime2 + exponent2;

    // Multiply the significands
    wire [3:0] product_significand;
    assign product_significand = significand1 * significand2; // Simple multiplication

    // Normalize the result
    wire [2:0] normalized_exponent;
    wire [1:0] normalized_significand;
    normalize_product normalizer(.product_exponent(total_exponent), .product_significand(product_significand), .normalized_exponent(normalized_exponent), .normalized_significand(normalized_significand));

    // Construct the result Posit
    assign result = {result_sign, normalized_exponent, normalized_significand};

endmodule

// Helper module for normalizing the product 
module normalize_product(
    input [4:0] product_exponent,
    input [3:0] product_significand,
    output reg [2:0] normalized_exponent,
    output reg [1:0] normalized_significand
);

    always @(product_exponent or product_significand) begin
        // Normalizing the product
        if (product_significand[3] == 1'b1) begin
            // If the most significant bit of significand is 1, right shift it
            normalized_significand = product_significand[3:2];
            normalized_exponent = product_exponent + 1; // Increment exponent due to shifting
        end else begin
            // Use the most significant bits of the product_significand
            normalized_significand = product_significand[2:1];
            normalized_exponent = product_exponent;
        end

        // Adjust the normalized exponent to fit in 3 bits
        // This is a simple form of overflow handling
        if (normalized_exponent > 3'b111) begin
            normalized_exponent = 3'b111;
        end
    end

endmodule
