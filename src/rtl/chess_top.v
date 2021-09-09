`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Kaja Kruszewska
// 
// Create Date:    18:07:14 07/09/2021
// Design Name: 
// Module Name:    chess_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module chess_top(
      	input wire clk, // ClkPort will be the board's 100MHz clk
		input wire BtnL, input wire BtnU, input wire BtnD,input wire BtnR, BtnC,
		input wire Reset // For reset   
    );
	 

/* Clocking */
//input clk;
reg[26:0] DIV_CLK;
wire full_clock;
BUFGP CLK_BUF(full_clock, clk);

always @(posedge full_clock, posedge Reset)
begin
	if (Reset) DIV_CLK <= 0;
	else DIV_CLK <= DIV_CLK + 1'b1;
end

wire game_logic_clk, vga_clk, debounce_clk;
assign debounce_clk = DIV_CLK[11]; // 24.4 kHz; needs to match game_logic for the single clock pulses

/* Init debouncer */

wire BtnC_pulse, BtnU_pulse, BtnR_pulse, BtnL_pulse, BtnD_pulse;
debounce L_debounce (
        .clk (debounce_clk), .reset (Reset), 
        .sw (BtnL), .db_level (), .db_tick (BtnL_pulse));
debounce R_debounce (
        .clk (debounce_clk), .reset (Reset), 
        .sw (BtnR), .db_level (), .db_tick (BtnR_pulse));
debounce U_debounce (
        .clk (debounce_clk), .reset (Reset), 
        .sw (BtnU), .db_level (), .db_tick (BtnU_pulse));
debounce D_debounce (
        .clk (debounce_clk), .reset (Reset), 
        .sw (BtnD), .db_level (), .db_tick (BtnD_pulse));
debounce C_debounce (
        .clk (debounce_clk), .reset (Reset), 
        .sw (BtnC), .db_level (), .db_tick (BtnC_pulse));
endmodule
