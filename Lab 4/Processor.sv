module Processor (
    input Clk,
    input Reset_Load_Clear,
    input Run,
    input [7:0] SW,
    output logic [7:0] hex_segA,
    output logic [3:0] hex_gridA,
    output logic [7:0] A_val,
    output logic [7:0] B_val,
    output logic X_val
);

    logic Reset_Load_Clear_S, Run_S;
    logic [7:0] SW_S;

    logic [8:0] X_A;
    logic [7:0] A, B;
    logic X;

    logic Shift_En, LoadA, ShiftB, fselect, ClearA, ResetXA;
    logic [8:0] Sum, SW_ext;

    always_comb begin
        X = X_A[8];
        A = X_A[7:0];
        X_val = X;
        A_val = A;
        B_val = B;
    end

    assign SW_ext = {SW_S[7], SW_S};
    assign ResetXA = Reset_Load_Clear_S | ClearA;

    nine_bit_register regXA (
        .Clk(Clk),
        .Reset(ResetXA),
        .Shift_In(X_A[8]),
        .Load(LoadA),
        .Shift_En(Shift_En),
        .Data_in(Sum),
        .Shift_Out(ShiftB),
        .Data_Out(X_A)
    );

    eight_bit_register regB (
        .Clk(Clk),
        .Reset(1'b0),
        .Shift_In(ShiftB),
        .Load(Reset_Load_Clear_S),
        .Shift_En(Shift_En),
        .Data_in(SW_S),
        .Shift_Out(),
        .Data_Out(B)
    );

    nine_bit_adder nb_addr (
        .A(X_A),
        .B(SW_ext),
        .fselect(fselect),
        .Sum(Sum)
    );

    control_unit control (
        .Clk,
        .Reset(Reset_Load_Clear_S),
        .Run(Run_S),
        .M(B[0]),
        .Shift(Shift_En),
        .LoadA(LoadA),
        .fselect(fselect),
        .ClearA(ClearA)
    );

    HexDriver HexA(
        .clk(Clk),
        .reset(Reset_Load_Clear_S),
        .in({A[7:4], A[3:0], B[7:4], B[3:0]}),
        .hex_seg(hex_segA),
        .hex_grid(hex_gridA)
    );

    sync button_sync[1:0] (Clk, {Reset_Load_Clear, Run}, {Reset_Load_Clear_S, Run_S});
    sync SW_sync[7:0] (Clk, SW, SW_S);

endmodule
