/*
Decoding and Input Conditioning
Overview:
Input: 8-bit Posit number.
Output: Decomposed components (sign, regime, exponent, significand).
Explanation:
  ● Sign: Extracted directly from the most significant bit.
  ● Regime: Detected by scanning bits for a transition from the sign bit. The regime length varies based on the transition point.
  ● Exponent: Extracted following the regime bits, adjusted for regime length.
  ● Significand: Extracted after the exponent, adjusted for regime and exponent lengths.
*/
module PositDecoder(
    input [7:0] posit,
    output reg sign,
    output reg [2:0] regime,
    output reg [2:0] exponent,
    output reg [1:0] significand
);
    integer i;

    always @(posit) begin
        // Decode sign
        sign = posit[7];

        // Decode regime
        regime = 3'b000; // Initialize regime
        for (i = 6; i >= 0; i = i - 1) begin
            if (posit[i] != sign) begin
                regime = 6 - i;
                // to break set i to invalid value to end the loop
                i=-1;
            end
        end

	if (i>=0) begin
		// Decode exponent
		exponent = posit[i-1 -: 3]; // Adjust index as per regime length

		// Decode significand
		significand = posit[i-4 -: 2]; // Adjust index as per regime and exponent length
	end
    end
endmodule
