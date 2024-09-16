module nine_bit_register(
    input logic Clk, 
                Reset, 
                Shift_In, 
                Load, 
                Shift_En,
    input logic [8:0] Data_in,
    output logic [8:0] Data_Out,
    output logic Shift_Out
    
);
    always_ff @(posedge Clk)
    begin
        if (Reset)
            Data_Out <= 9'h0;
        else if (Load)
            Data_Out <= Data_in;
        else if (Shift_En)
            Data_Out <= {Shift_In, Data_Out[8:1]};
    end

    assign Shift_Out = Data_Out[0];
endmodule
