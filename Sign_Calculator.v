`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.07.2021 12:57:48
// Design Name: 
// Module Name: Sign_Calculator
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Sign_Calculator(
    input clk, Clear,
    input [1:0]M,S,
    input  [3:0] A, B,
    output reg signed [7:0] Cal_out
    );
    
    parameter Start_state = 3'd0, Comp_state = 3'd1, Mode_state = 3'd2, Add_state = 3'd3, Sub_state = 3'd4, Mult_state = 3'd5, Div_state = 3'd6, Out_state = 3'd7;
    
    reg [2:0]ns;
    reg [7:0] Abr,Bbr;
    
    always @(posedge clk)
    begin
        if (Clear)
        begin
            ns <= Start_state;
            Cal_out <= 0;
        end
        else
        begin
            case(ns)
            Start_state : if(Clear == 0)  ns <= Comp_state;
                          else            ns <= Start_state;
                          
            Comp_state : if(S[0] == 0 && S[1] == 0) 
                         begin
                            Abr <= A;
                            Bbr <= B;
                            ns <= Mode_state;
                         end
                                     
                         else if(S[0] == 1 && S[1] == 0)  
                          begin
                             Abr <= (~A) + 1;
                             Bbr <= B;
                             ns <= Mode_state;
                          end
                         else if(S[0] == 0 && S[1] == 1) 
                          begin
                             Abr <= A ;
                             Bbr <= (~B) + 1;
                             ns <= Mode_state;
                          end
                         else if(S[0] == 1 && S[1] == 1)
                         begin
                             Abr <= (~A) + 1;
                             Bbr <= (~B) + 1;
                             ns <= Mode_state;
                          end  
                          
                         else            ns <= Start_state;
                          
            Mode_state : if(M[0] == 0 && M[1] == 0)  ns <= Add_state;
            
                         else if(M[0] == 1 && M[1] == 0)  ns <= Sub_state;
                         
                         else if(M[0] == 0 && M[1] == 1)  ns <= Mult_state;
                         
                         else if(M[0] == 1 && M[1] == 1)  ns <= Div_state;
                         
                         else            ns <= Start_state;   
             Add_state : if(Clear == 0)  
                         begin 
                            Cal_out <= Abr + Bbr;
                            ns <= Out_state;
                         end
                         else   ns <= Start_state;
             Sub_state : if(Clear == 0)  
                         begin 
                              Cal_out <= Abr - Bbr;
                              ns <= Out_state;
                         end
                         else   ns <= Start_state;
             Mult_state : if(Clear == 0)  
                         begin 
                              Cal_out <= Abr * Bbr;
                              ns <= Out_state;
                          end
                          else   ns <= Start_state;
             Div_state : if(Clear == 0)  
                          begin 
                             Cal_out <= Abr / Bbr;
                             ns <= Out_state;
                          end
                          else   ns <= Start_state;
             Out_state  : begin $display("OUTPUT = %0d",Cal_out);
                          Cal_out <= 0;
                          ns <= Start_state; end
            endcase
        end
    end
endmodule
