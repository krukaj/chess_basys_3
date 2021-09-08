// By kaja kruszewska


module input_debounce(
	input CLK,         // should be at about 24.4 kHz
	input RESET,
    input Btn,
    output reg Btn_pulse);

localparam INIT = 3'b000, WQ = 3'b001, SCEN_St = 3'b010, CCR = 3'b011, WFCR = 3'b100;
reg[2:0] state;

localparam max_i = 2000; // should yield a wait time of approx 0.25s
reg[13:0] I;

always @(posedge CLK, posedge RESET)
begin
	if (RESET) begin
		Btn_pulse <= 0;
	end
	else begin
		
	end
end

endmodule