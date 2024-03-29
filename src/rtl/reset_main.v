// File: reset_main.v
// This is the module design for Lab #3.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module reset_main (
        input   wire clk,
        input   wire locked,
        output  reg  reset_out
        );

        always @(negedge clk or negedge locked) begin
                if(!locked) begin
                        reset_out <= 1'b1;
                end else begin 
                        reset_out <= 1'b0;
                end
        end
endmodule
