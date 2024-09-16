//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Given Code - SLC-3 core
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 06-09-2020
//	  Revised 03-02-2021
//    Xilinx vivado
//    Revised 07-25-2023 
//------------------------------------------------------------------------------

module register(

	input					Clk, Reset, Load,
	input					[15:0] D,
	output logic            [15:0] Data_Out
    );
	
    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) 
			  Data_Out <= 16'b0000000000000000;
		 else if (Load)
			  Data_Out <= D;
    end
	
					
endmodule

module register1(

	input					Clk, Reset, Load,
	input					D,
	output logic            Data_Out
    );
	
    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) 
			  Data_Out <= 1'b0;
		 else if (Load)
			  Data_Out <= D;
    end
	
					
endmodule

module register3(

	input					Clk, Reset, Load,
	input					[2:0] D,
	output logic            [2:0] Data_Out
    );
	
    always_ff @ (posedge Clk)
    begin
	 	 if (Reset) 
			  Data_Out <= 3'b000;
		 else if (Load)
			  Data_Out <= D;
    end
	
					
endmodule

module Reg_Unit{
	input logic load, Clk, Reset,
    input logic [15:0] BUS_in,
    input logic [2:0] DR_select,
    input logic [2:0] SR1_MUX_OUT,
    input logic [2:0] SR2_MUX_OUT,
    output logic [15:0] SR1, 
	output logic [15:0] SR2
	);
    
    logic[15:0] R0, R1, R2, R3, R4, R5, R6, R7;
    logic[7:0] LSS;
    
    always_comb
    begin
        unique case(DR_select)
            3'b000  : LSS = 8'b00000001 & {8{load}};
            3'b001  : LSS = 8'b00000010 & {8{load}};
            3'b010  : LSS = 8'b00000100 & {8{load}};
            3'b011  : LSS = 8'b00001000 & {8{load}};
            3'b100  : LSS = 8'b00010000 & {8{load}};
            3'b101  : LSS = 8'b00100000 & {8{load}};
            3'b110  : LSS = 8'b01000000 & {8{load}};
            3'b111  : LSS = 8'b10000000 & {8{load}};
        endcase
        unique case(SR1_MUX_OUT)
            3'b000  : SR1 = R0;
            3'b001  : SR1 = R1;
            3'b010  : SR1 = R2;
            3'b011  : SR1 = R3;
            3'b100  : SR1 = R4;
            3'b101  : SR1 = R5;
            3'b110  : SR1 = R6;
            3'b111  : SR1 = R7;
        endcase
        unique case(SR2_MUX_OUT)
            3'b000  : SR2 = R0;
            3'b001  : SR2 = R1;
            3'b010  : SR2 = R2;
            3'b011  : SR2 = R3;
            3'b100  : SR2 = R4;
            3'b101  : SR2 = R5;
            3'b110  : SR2 = R6;
            3'b111  : SR2 = R7;
        endcase
    end
    
    register R0(.Clk(Clk), .Reset(Reset), .Load(LSS[0]), .D(BUS_in), .Data_Out(R0));
  	register R1(.Clk(Clk), .Reset(Reset), .Load(LSS[1]), .D(BUS_in), .Data_Out(R1));
    register R2(.Clk(Clk), .Reset(Reset), .Load(LSS[2]), .D(BUS_in), .Data_Out(R2));
    register R3(.Clk(Clk), .Reset(Reset), .Load(LSS[3]), .D(BUS_in), .Data_Out(R3));
    register R4(.Clk(Clk), .Reset(Reset), .Load(LSS[4]), .D(BUS_in), .Data_Out(R4));
    register R5(.Clk(Clk), .Reset(Reset), .Load(LSS[5]), .D(BUS_in), .Data_Out(R5));
    register R6(.Clk(Clk), .Reset(Reset), .Load(LSS[6]), .D(BUS_in), .Data_Out(R6));
    register R7(.Clk(Clk), .Reset(Reset), .Load(LSS[7]), .D(BUS_in), .Data_Out(R7));
    
endmodule
}

module MEM2IOMux(    
input logic S, 
input logic [15:0] Bus,
input logic [15:0] Data_to_CPU,	
output logic [15:0] Q_Out
);
	always_comb
		begin
		    case(S) 
					1'b0	:	Q_Out <= Bus;
					1'b1	:	Q_Out <= Data_to_CPU;	
			endcase
		end
endmodule

module PC_Mux(    
    input logic [1:0] S, 
	input logic [15:0] PC1, 
	input logic	[15:0] BUS, 
	input logic	[15:0] ADDER,
    output logic [15:0] Q_Out
);
	always_comb
		begin
		    case(S) 
					2'b00 :	Q_Out <= PC1;
					2'b01 :	Q_Out <= BUS;
					2'b11 : Q_Out <= 16'hxxxx ; 
					2'b10 : Q_Out <= ADDER;
			endcase
		end

endmodule

module ADDR2_Mux(    
    input logic [1:0] S, 
	input logic [15:0] IR10, //ALREADY SIGN EXTENDED TO 16 BIT
	input logic	[15:0] IR8, 
	input logic	[15:0] IR5,
	input logic	IR0,
    output logic [15:0] Q_Out
);
	always_comb
		begin
		    case(S) 
					2'b00 :	Q_Out <= IR0;
					2'b01 :	Q_Out <= IR5;
					2'b11 : Q_Out <= IR8; 
					2'b10 : Q_Out <= IR10;
			endcase
		end

endmodule

module ADDR1_Mux(    
    input logic S, 
	input logic [15:0] PC, 
	input logic	[15:0] SR1_Out, 
    output logic [15:0] Q_Out
);
	always_comb
		begin
		    case(S) 
					2'b0 :	Q_Out <= PC;
					2'b1 :	Q_Out <= SR1_Out;
			endcase
		end

endmodule

module ADDER(
    input  logic [15:0] ADDR2, ADDR1,
    output logic [15:0] ADDER);					 
    always_comb
	 begin
       ADDER = ADDR2 + ADDR1;
    end 
endmodule

module SR1_Mux(    
    input logic S, 
	input logic [2:0] IR86, 
	input logic	[2:0] IR119, 
    output logic [2:0] Q_Out
);
	always_comb
		begin
		    case(S) 
					2'b0 :	Q_Out <= IR119;
					2'b1 :	Q_Out <= IR86;
			endcase
		end

endmodule

module SR2_Mux(    
    input logic S, 
	input logic [15:0] SEXTI4, 
	input logic	[15:0] SR2_OUT, 
    output logic [15:0] Q_Out
);
	always_comb
		begin
		    case(S) 
					2'b0 :	Q_Out <= SEXTI4;
					2'b1 :	Q_Out <= SR2_OUT;
			endcase
		end

endmodule

module DR_Mux(    
    input logic S, 
	input logic [2:0] THREEONES, 
	input logic	[2:0] IR119, 
    output logic [2:0] Q_Out
);
	always_comb
		begin
		    case(S) 
					2'b0 :	Q_Out <= IR119;
					2'b1 :	Q_Out <= THREEONES;
			endcase
		end

endmodule

module ALU(
    input logic [15:0] SR1OUT,
    input logic [15:0] SR2MUXOUT,
    input logic [1:0] ALUK,
    output logic [15:0] ALUOUT
    );
    always_comb begin
        case(ALUK)
            2'b00: ALUOUT = SR1OUT+SR2MUXOUT;
            2'b01: ALUOUT = SR1OUT&SR2MUXOUT;
            2'b10: ALUOUT = ~SR1OUT;
            2'b11: ALUOUT = SR1OUT;
         endcase
    end
endmodule

module NZP(
    input logic [15:0] BUS,
    output logic [3:0] CC_Logic
    );
    assign CC_Logic[2] = BUS[15];
    assign CC_Logic[1] = ~(BUS[15] | BUS[14] | BUS[13] | BUS[12] | BUS[11] | BUS[10] | BUS[9] | BUS[8] | BUS[7] | BUS[6] | BUS[5] | BUS[4] | BUS[3] | BUS[2] | BUS[1] | BUS[0]);
    assign CC_Logic[0] = (~BUS[15])&(BUS[14] | BUS[13] | BUS[12] | BUS[11] | BUS[10] | BUS[9] | BUS[8] | BUS[7] | BUS[6] | BUS[5] | BUS[4] | BUS[3] | BUS[2] | BUS[1] | BUS[0]);
endmodule

module pathdata(
    input logic GateMDR,
    input logic [15:0] MDR,
    input logic GateALU,
    input logic [15:0] ALU,
    input logic GatePC,
    input logic [15:0] PC,
    input logic GateMARMUX,
    input logic [15:0] MARMUX,
    output logic [15:0] BUS
    );
    logic [3:0] temp_control;
    assign temp_control = {GateMARMUX, GatePC, GateALU, GateMDR};
    always_comb begin
        case(temp_control)
            4'b1000: BUS = MARMUX;
            4'b0100: BUS = PC;
            4'b0010: BUS = ALU;
            4'b0001: BUS = MDR;
            4'b0000: BUS = 16'bx;
            default: BUS = 16'b0;
        endcase
    end
endmodule

module slc3(
	input logic [15:0] SW,
	input logic	Clk, Reset, Run, Continue,
	output logic [15:0] LED,
	input logic [15:0] Data_from_SRAM,
	output logic OE, WE,
	output logic [7:0] hex_seg,
	output logic [3:0] hex_grid,
	output logic [7:0] hex_segB,
	output logic [3:0] hex_gridB,
	output logic [15:0] ADDR,
	output logic [15:0] Data_to_SRAM
);

// Internal connections
logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED;
logic GatePC, GateMDR, GateALU, GateMARMUX;
logic SR2MUX, ADDR1MUX, MARMUX;
logic BEN, MIO_EN, DRMUX, SR1MUX, Logic2_OUT;
logic [1:0] PCMUX, ADDR2MUX, ALUK;
logic [2:0] CC_Logic1, Logic2_Out;
logic [15:0] MDR_In;
logic [15:0] MAR, MDR, IR, PC;
logic [15:0] pcmuxout;
logic [3:0] hex_4[3:0]; 

// pathdata tempbus(
//     .GateMDR(GateMDR),
//     .MDR(MDR),
//     .GateALU(1'b0),
//     .ALU(16'h0000),
//     .GatePC(GatePC),
//     .PC(PC),
//     .GateMARMUX(1'b0),
//     .MARMUX(16'b0000000000000000),
//     .BUS(bus1)
// );
//mux outputs
logic [15:0] ADDR1_MUX_OUT, ADDR2_MUX_OUT, ADDR_OUT, SR2_MUX_OUT, SR2_OUT, SR1_OUT, ALU_OUT;
logic [2:0] SR1_MUX_OUT, SR2;

//BUS and PC
logic [15:0] BUS, PC;
logic [15:0] MIO_Out;
logic [15:0] bus1;
logic [15:0] PC_Mux_Out;

//assign MAR to ADDR as shown in LC3 DATAPATH
assign ADDR_OUT = MAR;
assign MIO_EN = OE; //OUTPUT ENABLE FROM PART 1
assign LED=IR;

 NZP nzp_module (
    .BUS(BUS),
    .CC_Logic(CC_Logic1)
  );
 assign Logic2_OUT = (IR[11]&CC_Logic1[2])||(IR[10]&CC_Logic1[1])||(IR[9]&CC_Logic1[0]); //inputted to BEN
mux16 MDRmux(.select(MIO_EN), .A(BUS), .B(MDR_In), .Q(MDR_Intermediate));
// MAR register
register MARreg(.Clk(Clk), .Reset(Reset), .Load(LD_MAR), .D(BUS), .Data_Out(MAR));

// MDR register
register MDRreg(.Clk(Clk), .Reset(Reset), .Load(LD_MDR), .D(MDR_In), .Data_Out(MDR));

// IR register


//SR1MUX
SR1_Mux SR1_MUX1(.S(SR1MUX), .IR86(IR[8:6]), .IR119(IR[11:9]), .Q(SR1_MUX_OUT));
//DRMUX
//mux16 #(3) DR_MUX(.select(DRMUX), .A(3'b111), .B(IR[11:9]), .Q(DR_select));
//SR2MUX
SR2_Mux SR2_MUX1(.S(SR2MUX), .SEXTI4({{11{IR[4]}}, IR[4:0]}), .SR2_OUT(SR2_OUT), .Q(SR2_MUX_OUT));
//ADDR1MUX
ADDR1_Mux ADDR1(.S(ADDR1MUX), .PC(PC), .SR1_Out(SR1_OUT), .Q_Out(ADDR1_MUX_OUT));
//ADDR2MUX
ADDR2_Mux ADDR2(.S(ADDR2MUX), .IR0(16'b0), .IR5({{10{IR[5]}}, IR[5:0]}), .IR8({{7{IR[8]}}, IR[8:0]}), .IR10({{5{IR[10]}}, IR[10:0]}), .Q_Out(ADDR2_MUX_OUT));
//SIGN EXTEND THE INPUTS TO MATCH THE 15:0
ADDER ADDER_FIN (.S(ADDR), .ADDR2(ADDR2_MUX_OUT), .ADDR1(ADDR1_MUX_OUT), .Q_Out(ADDR_OUT));
 

register memaddreg(.Clk(Clk), .Reset(Reset), .Load(LD_MAR), .D(bus1), .Data_Out(MAR));

MEM2IOMUX m(.S(MIO_EN), .Bus(bus1), .Data_to_CPU(MDR_In), .Q_Out(MIO_Out));
register memdatareg(.Clk(Clk), .Reset(Reset), .Load(LD_MDR), .D(MIO_Out), .Data_Out(MDR));


PC_Mux PC_Mux0(.S(PCMUX), .PC1(PC+16'b0000000000000001), .BUS(bus1), .ADDER(16'b0000000000000000), .Q_Out(pcmuxout));
register pcvar(.Clk(Clk), .Reset(Reset), .Load(LD_PC), .D(pcmuxout), .Data_Out(PC));
register instructreg(.Clk(Clk), .Reset(Reset), .Load(LD_IR), .D(bus1), .Data_Out(IR)); 


// Instantiate the rest of your modules here according to the block diagram of the SLC-3
// including your register file, ALU, etc..


// Our I/O controller (note, this plugs into MDR/MAR)

Mem2IO memory_subsystem(
    .*, .Reset(Reset), .ADDR(ADDR), .Switches(SW),
    .HEX0(hex_4[0][3:0]), .HEX1(hex_4[1][3:0]), .HEX2(hex_4[2][3:0]), .HEX3(hex_4[3][3:0]), 
    .Data_from_CPU(MDR), .Data_to_CPU(MDR_In),
    .Data_from_SRAM(Data_from_SRAM), .Data_to_SRAM(Data_to_SRAM)
);

// State machine, you need to fill in the code here as well
ISDU state_controller(
	.*, .Reset(Reset), .Run(Run), .Continue(Continue),
	.Opcode(IR[15:12]), .IR_5(IR[5]), .IR_11(IR[11]),
   .Mem_OE(OE), .Mem_WE(WE)
);

register IRreg(.Clk(Clk), .Reset(Reset), .Load(LD_IR), .D(BUS), .Data_Out(IR));

// Logic2_Out register
register3 CC_reg(.Clk(Clk), .Reset(Reset), .Load(LD_CC), .D(CC_Logic1), .Data_Out(Logic2_Out));

//BEN register (1 bit)
register1 BEN_reg(.Clk(Clk), .Reset(Reset), .Load(LD_BEN), .D(Logic2_Out), .Data_Out(BEN));

HexDriver HexA (
    .clk(Clk),
    .reset(Reset),
    .in({hex_4[3][3:0],  hex_4[2][3:0], hex_4[1][3:0], hex_4[0][3:0]}),
    .hex_seg(hex_seg),
    .hex_grid(hex_grid)
);

HexDriver HexB (
    .clk(Clk),
    .reset(Reset),
    .in({IR[15:12], IR[11:8], IR[7:4], IR[3:0]}),
    .hex_seg(hex_segB),
    .hex_grid(hex_gridB)
);

// You may use the second (right) HEX driver to display additional debug information
// For example, Prof. Cheng's solution code has PC being displayed on the right HEX

	
endmodule
