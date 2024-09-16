module control_unit(input logic Clk, M, Reset, Run, 
                  output logic Shift, LoadA, fselect, ClearA
                  );
    
    enum logic [4:0] {ResetTrigger, A0, S0, A1, S1, A2, S2, A3, S3,
                      A4, S4, A5, S5, A6, S6, Sub, S7, Hold, Clear}  curr_state, next_state;
 
    always_ff  @ (posedge Clk)
        begin 
              if (Reset) 
                    curr_state <= ResetTrigger;
              else
                    curr_state <= next_state;
        end
  
    always_comb
        begin
            next_state = curr_state;
        
            unique case (curr_state)
                ResetTrigger : if (Run) 
                                next_state = Clear;
       
                Clear    : next_state = A0 ;
                
                A0    : next_state = S0 ; 
                S0  : next_state = A1; 
 
                A1    : next_state = S1 ;
                S1  : next_state = A2; 
        
                A2    : next_state = S2 ;      
                S2  : next_state = A3; 
        
                A3    : next_state = S3 ;      
                S3  : next_state = A4;
        
                A4    : next_state = S4 ;      
                S4  : next_state = A5;
        
                A5    : next_state = S5 ;      
                S5  : next_state = A6;
        
                A6    : next_state = S6 ;      
                S6  : next_state = Sub;
        
                Sub : next_state = S7 ;
                S7  : next_state = Hold; 
        
                Hold : if (~Run)
                         next_state = ResetTrigger ;
            endcase
            
            unique case (curr_state)
                ResetTrigger : begin
                                Shift = 0 ;
                                fselect = 0;
                                LoadA = 0;
                                ClearA = 0;
                              end
       
                A0    : begin
                                Shift = 0 ;
                                fselect = 0 ;
                                LoadA = M;
                                ClearA = 0;
                              end
        
                S0  : begin
                                Shift = 1 ;
                                fselect = 0 ;
                                LoadA = 0 ;
                                ClearA = 0;
                              end
        
                A1    : begin
                                Shift = 0 ;
                                fselect = 0;
                                LoadA = M ;
                                ClearA = 0;
                              end
       
                S1  :  begin
                                Shift = 1;
                                fselect = 0 ;
                                LoadA = 0;
                                ClearA = 0;
                              end
        
                A2    : begin
                                Shift = 0;
                                fselect = 0;
                                LoadA =M ;
                                ClearA = 0;
                              end
                                
                S2  : begin
                                Shift = 1;
                                fselect = 0 ;
                                LoadA = 0;
                                ClearA = 0;
                              end 
        
                A3    : begin
                                Shift =0 ;
                                fselect =0 ;
                                LoadA = M;
                                ClearA = 0;
                              end
                                    
                S3  : begin
                                Shift = 1;
                                fselect = 0;
                                LoadA =0 ;
                                ClearA = 0;
                              end                           
        
                A4    : begin
                                Shift =0 ;
                                fselect =0 ;
                                LoadA =M ;
                                ClearA = 0;
                              end
                              
                S4  : begin
                                Shift =1 ;
                                fselect = 0;
                                LoadA = 0;
                                ClearA = 0;
                              end
        
                A5    : begin
                                Shift =0 ;
                                fselect = 0;
                                LoadA = M;
                                ClearA = 0;
                              end
                
                S5  : begin
                                Shift =1 ;
                                fselect = 0;
                                LoadA = 0;
                                ClearA = 0;
                              end
        
                A6    : begin
                                Shift =0 ;
                                fselect =0 ;
                                LoadA = M;
                                ClearA = 0;
                              end      
      
                S6  : begin
                                Shift = 1;
                                fselect = 0;
                                LoadA = 0;
                                ClearA = 0;
                              end
        
                Sub : begin
                                Shift =0 ;
                                fselect = 1;
                                LoadA = M ;
                                ClearA = 0;
                              end
                              
                S7  : begin
                                Shift = 1;
                                fselect = 0;
                                LoadA = 0;
                                ClearA = 0;
                              end
        
                Hold : begin 
                        Shift = 0;
                        fselect = 0;
                        LoadA = 0;
                        ClearA = 0;
                        end
        
                Clear : begin 
                        Shift = 0;
                        fselect = 0;
                        LoadA = 0;
                        ClearA = 1;
                        end
            endcase
        end
endmodule
