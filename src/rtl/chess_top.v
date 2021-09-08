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

		input wire Reset,

		output wire ld0,
		output wire ld1,
		output wire ld2,
		output wire ld3
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
assign game_logic_clk = DIV_CLK[11]; // 24.4 kHz 
assign debounce_clk = DIV_CLK[11]; // 24.4 kHz; needs to match game_logic for the single clock pulses

/* Init debouncer */
wire BtnC_pulse, BtnU_pulse, BtnR_pulse, BtnL_pulse, BtnD_pulse;
debounce L_debounce(
	.CLK(debounce_clk), .RESET(Reset),
	.Btn(BtnL), .Btn_pulse(BtnL_pulse));
debounce R_debounce(
	.CLK(debounce_clk), .RESET(Reset),
	.Btn(BtnR), .Btn_pulse(BtnR_pulse));
debounce U_debounce(
	.CLK(debounce_clk), .RESET(Reset),
	.Btn(BtnU), .Btn_pulse(BtnU_pulse));
debounce D_debounce(
	.CLK(debounce_clk), .RESET(Reset),
	.Btn(BtnD), .Btn_pulse(BtnD_pulse));
debounce C_debounce(
	.CLK(debounce_clk), .RESET(Reset),
	.Btn(BtnC), .Btn_pulse(BtnC_pulse));


/* Piece Definitions */
localparam PIECE_NONE 	= 3'b000;
localparam PIECE_PAWN	= 3'b001;
localparam PIECE_KNIGHT	= 3'b010;
localparam PIECE_BISHOP	= 3'b011;
localparam PIECE_ROOK	= 3'b100;
localparam PIECE_QUEEN	= 3'b101;
localparam PIECE_KING	= 3'b110;

localparam COLOR_WHITE	= 0;
localparam COLOR_BLACK	= 1;

reg [3:0] board[63:0];

wire [255:0] passable_board;

genvar i;
generate for (i=0; i<64; i=i+1) begin: BOARD
	assign passable_board[i*4+3 : i*4] = board[i];
end
endgenerate

/* Init game logic module and its output wires */
wire[5:0] board_change_addr;
wire[3:0] board_change_piece;
wire[5:0] cursor_addr;
wire[5:0] selected_piece_addr;
wire hilite_selected_square;
wire[3:0] logic_state;
wire board_change_en_wire;
wire is_in_initial_state;

chess_logic logic_module(
	.CLK(game_logic_clk), 
	.RESET(Reset),
	.board_input(passable_board),

	.board_out_addr(board_change_addr),
	.board_out_piece(board_change_piece),
	.board_change_en_wire(board_change_en_wire),
	.cursor_addr(cursor_addr),
	.selected_addr(selected_piece_addr),
	.hilite_selected_square(hilite_selected_square),

	.BtnU(BtnU_pulse), .BtnL(BtnL_pulse), .BtnC(BtnC_pulse),
	.BtnR(BtnR_pulse), .BtnD(BtnD_pulse),
	.state(logic_state), .move_is_legal(Ld4), .is_in_initial_state(is_in_initial_state)
	);
	
always @(posedge game_logic_clk)
begin 
	if (Reset != 1) begin 
		if (board_change_en_wire == 1)  
		begin
			board[board_change_addr] <= board_change_piece;
		end
	end
	if (is_in_initial_state)
	begin
		board[6'b111_000] <= { COLOR_WHITE, PIECE_ROOK };
		board[6'b111_001] <= { COLOR_WHITE, PIECE_KNIGHT };
		board[6'b111_010] <= { COLOR_WHITE, PIECE_BISHOP };
		board[6'b111_011] <= { COLOR_WHITE, PIECE_QUEEN };
		board[6'b111_100] <= { COLOR_WHITE, PIECE_KING };
		board[6'b111_101] <= { COLOR_WHITE, PIECE_BISHOP };
		board[6'b111_110] <= { COLOR_WHITE, PIECE_KNIGHT };
		board[6'b111_111] <= { COLOR_WHITE, PIECE_ROOK };
		
		board[6'b110_000] <= { COLOR_WHITE, PIECE_PAWN };
		board[6'b110_001] <= { COLOR_WHITE, PIECE_PAWN };
		board[6'b110_010] <= { COLOR_WHITE, PIECE_PAWN };
		board[6'b110_011] <= { COLOR_WHITE, PIECE_PAWN };
		board[6'b110_100] <= { COLOR_WHITE, PIECE_PAWN };
		board[6'b110_101] <= { COLOR_WHITE, PIECE_PAWN };
		board[6'b110_110] <= { COLOR_WHITE, PIECE_PAWN };
		board[6'b110_111] <= { COLOR_WHITE, PIECE_PAWN };
		
		board[6'b101_000] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b101_001] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b101_010] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b101_011] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b101_100] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b101_101] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b101_110] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b101_111] <= { COLOR_WHITE, PIECE_NONE };
		
		board[6'b100_000] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b100_001] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b100_010] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b100_011] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b100_100] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b100_101] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b100_110] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b100_111] <= { COLOR_WHITE, PIECE_NONE };
		
		board[6'b011_000] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b011_001] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b011_010] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b011_011] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b011_100] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b011_101] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b011_110] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b011_111] <= { COLOR_WHITE, PIECE_NONE };
		
		board[6'b010_000] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b010_001] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b010_010] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b010_011] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b010_100] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b010_101] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b010_110] <= { COLOR_WHITE, PIECE_NONE };
		board[6'b010_111] <= { COLOR_WHITE, PIECE_NONE };
		
		board[6'b001_000] <= { COLOR_BLACK, PIECE_PAWN };
		board[6'b001_001] <= { COLOR_BLACK, PIECE_PAWN };
		board[6'b001_010] <= { COLOR_BLACK, PIECE_PAWN };
		board[6'b001_011] <= { COLOR_BLACK, PIECE_PAWN };
		board[6'b001_100] <= { COLOR_BLACK, PIECE_PAWN };
		board[6'b001_101] <= { COLOR_BLACK, PIECE_PAWN };
		board[6'b001_110] <= { COLOR_BLACK, PIECE_PAWN };
		board[6'b001_111] <= { COLOR_BLACK, PIECE_PAWN };
		
		board[6'b000_000] <= { COLOR_BLACK, PIECE_ROOK };
		board[6'b000_001] <= { COLOR_BLACK, PIECE_KNIGHT };
		board[6'b000_010] <= { COLOR_BLACK, PIECE_BISHOP };
		board[6'b000_011] <= { COLOR_BLACK, PIECE_QUEEN };
		board[6'b000_100] <= { COLOR_BLACK, PIECE_KING };
		board[6'b000_101] <= { COLOR_BLACK, PIECE_BISHOP };
		board[6'b000_110] <= { COLOR_BLACK, PIECE_KNIGHT };
		board[6'b000_111] <= { COLOR_BLACK, PIECE_ROOK };
	end
end

assign { ld3, ld2, ld1, ld0 } = logic_state; // useful for debugging, show state machine on LEDs
	
endmodule
