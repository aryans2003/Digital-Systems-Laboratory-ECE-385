module nine_bit_adder(
    input fselect,
    input [8:0] A,
    input [8:0] B,
    output [8:0] Sum
    );
    logic [8:0] carry;
    assign carry = B ^ {9{fselect}};
    logic c0, c1, c2, c3, c4, c5, c6, c7;
    
    full_adder adder8(.A(A[8]), .B(carry[8]), .Cin(c7), .Sum(Sum[8]), .Cout());
    full_adder adder7(.A(A[7]), .B(carry[7]), .Cin(c6), .Sum(Sum[7]), .Cout(c7));
    full_adder adder6(.A(A[6]), .B(carry[6]), .Cin(c5), .Sum(Sum[6]), .Cout(c6));
    full_adder adder5(.A(A[5]), .B(carry[5]), .Cin(c4), .Sum(Sum[5]), .Cout(c5));
    full_adder adder4(.A(A[4]), .B(carry[4]), .Cin(c3), .Sum(Sum[4]), .Cout(c4));
    full_adder adder3(.A(A[3]), .B(carry[3]), .Cin(c2), .Sum(Sum[3]), .Cout(c3));
    full_adder adder2(.A(A[2]), .B(carry[2]), .Cin(c1), .Sum(Sum[2]), .Cout(c2));
    full_adder adder1(.A(A[1]), .B(carry[1]), .Cin(c0), .Sum(Sum[1]), .Cout(c1));
    full_adder adder0(.A(A[0]), .B(carry[0]), .Cin(fselect), .Sum(Sum[0]), .Cout(c0));
    
endmodule

module full_adder(
    input logic A,
    input logic B,
    input logic Cin,
    output logic Sum,
    output logic Cout
);
    assign Sum = A ^ B ^ Cin;
    assign Cout = (A & B) | (A & Cin) | (B & Cin);
endmodule
