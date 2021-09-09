// File: vga_timing.v
// This is the vga timing design for Lab #3 generats
// signals that control the screen .

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps
// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_timing (
                input  wire clk,
                input  wire rst,

                output wire [9:0] vcount,
                output wire vsync, 
                output wire [9:0] hcount,
                output wire hsync,
                output reg inDisplayArea  
        );

        localparam HOR_TOTAL_TIME = 799;
        localparam VER_TOTAL_TIME = 524;
        localparam HOR_BLANK_START = 639;
        localparam VER_BLANK_START = 479;
        localparam HOR_SYNC_START = 655;
        localparam VER_SYNC_START = 489;
        localparam HOR_SYNC_TIME = 96;
        localparam VER_SYNC_TIME = 2;

        reg [9:0] horizontal_counter;
        reg [9:0] vertical_counter;
        reg horizontal_sync;
        reg horizontal_blank;
        reg vertical_sync;
        reg vertical_blank;

        reg [9:0] horizontal_counter_nxt;
        reg [9:0] vertical_counter_nxt;
        reg horizontal_sync_nxt ; 
        reg vertical_sync_nxt ;
        

        always @(posedge clk)
                if(rst)
                        inDisplayArea <= 1'b0;
                else
                        inDisplayArea <= (horizontal_counter < 640) && (vertical_counter < 80);


        // Synchronical logic
        always @(posedge clk) begin
                if(rst) begin
                        horizontal_sync    <=  1'b0;
                        vertical_sync      <=  1'b0;
                        vertical_counter   <=  12'b0;
                        horizontal_counter <= 12'b0;
                end else begin
                        horizontal_sync    <= horizontal_sync_nxt;
                        vertical_sync      <= vertical_sync_nxt;
                        horizontal_counter <= horizontal_counter_nxt;
                        vertical_counter   <= vertical_counter_nxt;
                        
                end
        end


        // Combinational logic
        always @* begin 
        if (horizontal_counter == HOR_TOTAL_TIME) begin
                horizontal_counter_nxt = 0;
                if (vertical_counter == VER_TOTAL_TIME)
                        vertical_counter_nxt = 0;
                else
                        vertical_counter_nxt = vertical_counter + 1;
                if (vertical_counter >= VER_SYNC_START && vertical_counter < (VER_SYNC_START + VER_SYNC_TIME))
                        vertical_sync_nxt  = 1'b1;
                else
                        vertical_sync_nxt  = 1'b0;
        end else begin
                horizontal_counter_nxt = horizontal_counter + 1;
                vertical_counter_nxt   = vertical_counter;
                vertical_sync_nxt      =vertical_sync;
        end 
        if (horizontal_counter >= HOR_SYNC_START && horizontal_counter < (HOR_SYNC_START + HOR_SYNC_TIME ))
                horizontal_sync_nxt  = 1'b1;
        else
                horizontal_sync_nxt  = 1'b0;
        end

        assign   hcount = horizontal_counter;
        assign   vcount = vertical_counter;
        assign   hsync  = horizontal_sync;
        assign   vsync  = vertical_sync;

endmodule
