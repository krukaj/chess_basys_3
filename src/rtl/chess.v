`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: kaja kruszewska
// 
// Create Date:    17:37:14 07/09/2021 
// Design Name: 
// Module Name:    chess 
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
module chess(
      	input wire clk,
		input wire rst,  
		
		input wire [4:0] btn,

		output wire vga_hsync,
		output wire vga_vsync, 
		output wire [2:0] vga_r,
		output wire [2:0] vga_g,
		output wire [1:0] vga_b
    );

wire clk_25MHz;
wire locked;

clk_main u_clk_main (
		.clk(clk),
		.reset(rst),

		.locked(locked),
		.clk_25MHz(clk_25MHz),
		.clk_65MHz());

wire Reset;

reset_main u_reset_main (
        .clk(clk_25MHz),
        .locked(locked),

        .reset_out(Reset));

genvar i;

wire [4:0] Btn_pulse;

generate for (i = 0;i < 5;i = i + 1) begin
	debounce u_debounce(
	.clk(clk_25MHz), .rst(Reset),
	.Btn(btn[i]), .Btn_pulse(Btn_pulse[i]));
end
endgenerate

reg [3:0] board[63:0];
wire [255:0] passable_board;

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
wire board_change_en_wire;
wire is_in_initial_state;

logic_unit u_logic_unit (
	.clk(clk_25MHz), 
	.rst(Reset),
	.board_input(passable_board),

	.board_out_addr(board_change_addr),
	.board_out_piece(board_change_piece),
	.board_change_en_wire(board_change_en_wire),
	.cursor_addr(cursor_addr),
	.selected_addr(selected_piece_addr),
	.hilite_selected_square(hilite_selected_square),

	.BtnU(Btn_pulse[1]), .BtnL(Btn_pulse[2]), .BtnC(Btn_pulse[0]),
	.BtnR(Btn_pulse[3]), .BtnD(Btn_pulse[4]),
	.state(), .move_is_legal(), .is_in_initial_state(is_in_initial_state)
	);
	
always @(posedge clk_25MHz)
begin 
	if (Reset != 1) begin 
		if (board_change_en_wire == 1)  
		begin
			board[board_change_addr] <= board_change_piece;
		end
	end
	if (is_in_initial_state)
	begin
		board[6'b111_000] <= { 1'b0, 3'b100 };
		board[6'b111_001] <= { 1'b0, 3'b010 };
		board[6'b111_010] <= { 1'b0, 3'b011 };
		board[6'b111_011] <= { 1'b0, 3'b101 };
		board[6'b111_100] <= { 1'b0, 3'b110 };
		board[6'b111_101] <= { 1'b0, 3'b011 };
		board[6'b111_110] <= { 1'b0, 3'b010 };
		board[6'b111_111] <= { 1'b0, 3'b100 };
		
		board[6'b110_000] <= { 1'b0, 3'b001 };
		board[6'b110_001] <= { 1'b0, 3'b001 };
		board[6'b110_010] <= { 1'b0, 3'b001 };
		board[6'b110_011] <= { 1'b0, 3'b001 };
		board[6'b110_100] <= { 1'b0, 3'b001 };
		board[6'b110_101] <= { 1'b0, 3'b001 };
		board[6'b110_110] <= { 1'b0, 3'b001 };
		board[6'b110_111] <= { 1'b0, 3'b001 };
		
		board[6'b101_000] <= { 1'b0, 3'b000 };
		board[6'b101_001] <= { 1'b0, 3'b000 };
		board[6'b101_010] <= { 1'b0, 3'b000 };
		board[6'b101_011] <= { 1'b0, 3'b000 };
		board[6'b101_100] <= { 1'b0, 3'b000 };
		board[6'b101_101] <= { 1'b0, 3'b000 };
		board[6'b101_110] <= { 1'b0, 3'b000 };
		board[6'b101_111] <= { 1'b0, 3'b000 };
		
		board[6'b100_000] <= { 1'b0, 3'b000 };
		board[6'b100_001] <= { 1'b0, 3'b000 };
		board[6'b100_010] <= { 1'b0, 3'b000 };
		board[6'b100_011] <= { 1'b0, 3'b000 };
		board[6'b100_100] <= { 1'b0, 3'b000 };
		board[6'b100_101] <= { 1'b0, 3'b000 };
		board[6'b100_110] <= { 1'b0, 3'b000 };
		board[6'b100_111] <= { 1'b0, 3'b000 };
		
		board[6'b011_000] <= { 1'b0, 3'b000 };
		board[6'b011_001] <= { 1'b0, 3'b000 };
		board[6'b011_010] <= { 1'b0, 3'b000 };
		board[6'b011_011] <= { 1'b0, 3'b000 };
		board[6'b011_100] <= { 1'b0, 3'b000 };
		board[6'b011_101] <= { 1'b0, 3'b000 };
		board[6'b011_110] <= { 1'b0, 3'b000 };
		board[6'b011_111] <= { 1'b0, 3'b000 };
		
		board[6'b010_000] <= { 1'b0, 3'b000 };
		board[6'b010_001] <= { 1'b0, 3'b000 };
		board[6'b010_010] <= { 1'b0, 3'b000 };
		board[6'b010_011] <= { 1'b0, 3'b000 };
		board[6'b010_100] <= { 1'b0, 3'b000 };
		board[6'b010_101] <= { 1'b0, 3'b000 };
		board[6'b010_110] <= { 1'b0, 3'b000 };
		board[6'b010_111] <= { 1'b0, 3'b000 };
		
		board[6'b001_000] <= { 1'b1, 3'b001 };
		board[6'b001_001] <= { 1'b1, 3'b001 };
		board[6'b001_010] <= { 1'b1, 3'b001 };
		board[6'b001_011] <= { 1'b1, 3'b001 };
		board[6'b001_100] <= { 1'b1, 3'b001 };
		board[6'b001_101] <= { 1'b1, 3'b001 };
		board[6'b001_110] <= { 1'b1, 3'b001 };
		board[6'b001_111] <= { 1'b1, 3'b001 };

		board[6'b000_000] <= { 1'b1, 3'b100 };
		board[6'b000_001] <= { 1'b1, 3'b010 };
		board[6'b000_010] <= { 1'b1, 3'b011 };
		board[6'b000_011] <= { 1'b1, 3'b101 };
		board[6'b000_100] <= { 1'b1, 3'b110 };
		board[6'b000_101] <= { 1'b1, 3'b011 };
		board[6'b000_110] <= { 1'b1, 3'b010 };
		board[6'b000_111] <= { 1'b1, 3'b100 };
		
	end
end

display_unit u_display_unit (
	.clk(clk_25MHz), 
	.rst(Reset),
	.hsync(vga_hsync), // direct outputs to VGA monitor
	.vsync(vga_vsync),
	.r(vga_r),
	.g(vga_g),
	.b(vga_b),
	.board_in(passable_board), // the 64x4 array for the board contents
	.cursor_addr(cursor_addr), // 6 bit address showing what square to hilite
	.select_addr(selected_piece_addr), // 6b address showing the address of which piece is selected
	.select_en(hilite_selected_square)); // binary flag to show a selected piece

endmodule
