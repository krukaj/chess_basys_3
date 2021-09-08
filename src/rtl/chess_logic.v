`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Kaja Kruszewska
// 
// Create Date:    14:00:01 8/09/2016 
// Design Name: 
// Module Name:    chess_logic 
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
module chess_logic( 
    CLK, RESET,
    board_input,
    board_out_addr,
    board_out_piece,
	 board_change_en_wire,
    BtnL, // All button inputs shall have been debounced & made a single clk pulse outside this module
    BtnU,
    BtnR,
    BtnD,
    BtnC,
    cursor_addr,
    selected_addr,
    hilite_selected_square,
	 state, move_is_legal, is_in_initial_state
    );

/* Inputs */
input wire CLK, RESET;
input wire BtnL, BtnU, BtnR, BtnD, BtnC;

input wire [255:0] board_input;

wire [3:0] board[63:0];

genvar i;
generate for (i=0; i<64; i=i+1) begin: BOARD
	assign board[i] = board_input[i*4+3 : i*4];
end
endgenerate

/* Outputs */ 
// outputs for communicating with the board register in top
output reg[5:0] board_out_addr;
output reg[3:0] board_out_piece;
reg board_change_enable; // signal the board reg in top to write the new piece to the addr
output wire board_change_en_wire;
assign board_change_en_wire = board_change_enable;

// outputs for communicating with the VGA module
output reg[5:0] cursor_addr;
output reg[5:0] selected_addr;
output wire hilite_selected_square;

localparam INITIAL = 3'b000,
    PIECE_SEL = 3'b001, PIECE_MOVE= 3'b010,
    WRITE_NEW_PIECE = 3'b011, ERASE_OLD_PIECE = 3'b100;

output wire is_in_initial_state;
assign is_in_initial_state = (state == INITIAL);

// wires for the contents of the board input
wire[3:0] cursor_contents, selected_contents;
assign cursor_contents = board[cursor_addr]; // contents of the cursor square
assign selected_contents = board[selected_addr]; // contents of the selected square

/* Piece Definitions */
localparam PIECE_NONE   = 3'b000;
localparam PIECE_PAWN   = 3'b001;
localparam PIECE_KNIGHT = 3'b010;
localparam PIECE_BISHOP = 3'b011;
localparam PIECE_ROOK   = 3'b100;
localparam PIECE_QUEEN  = 3'b101;
localparam PIECE_KING   = 3'b110;

localparam COLOR_WHITE  = 0;
localparam COLOR_BLACK  = 1;

/* DPU registers */
reg player_to_move;

output reg move_is_legal; // signal will be generated in combinational logic

/* State Machine Definition */
// use encoded-assignment

output reg[2:0] state;
assign hilite_selected_square = (state == PIECE_MOVE);

//reg castle_state;

/* State Machine NSL and OFL */

endmodule
