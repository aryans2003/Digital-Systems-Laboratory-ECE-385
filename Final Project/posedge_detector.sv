module posedge_detector(input logic clk, flag, reset,
                       output logic sync);
    logic button_ff, button_ff2;
    logic button_edge;
    always_ff @(posedge clk or posedge reset) 
    begin
        if(reset)
            begin
                button_ff <= flag;
                button_ff2 <= flag;
            end
        else
            begin
                button_ff <= flag;
                button_ff2 <= button_ff;
            end
    end
    assign sync = button_ff && ~button_ff2; 
endmodule
