// By Kaja Kruszewska


module debounce(
	input wire clk,         // should be at about 24.4 kHz
	input wire rst,
    input wire Btn,
    output reg Btn_pulse);


localparam INIT = 3'b000, WQ = 3'b001, SCEN_St = 3'b010, CCR = 3'b011, WFCR = 3'b100;
reg[2:0] state;

localparam max_i = 2000; // should yield a wait time of approx 0.25s
reg[13:0] I;

always @(posedge clk)
begin
	if (rst) begin
		Btn_pulse <= 0;
		state <= INIT;
		I <= 0;
	end
	else begin
		case (state)
			INIT:
			begin
				if (Btn) state <= WQ;
				// else remain

				I <= 0;
			end

			WQ:
			begin
				if (!Btn) state <= INIT;
				else if (I == max_i) begin 
					state <= SCEN_St;
					Btn_pulse <= 1;
				end
				// else remain

				I <= I + 1;
			end

			SCEN_St:
			begin
				state <= CCR;

				Btn_pulse <= 0;
				I <= 0;
			end

			CCR:
			begin
				if (!Btn) state <= WFCR;
				// else remain

				I <= 0;
			end

			WFCR:
			begin
				if (Btn) state <= CCR;
				else if (I == max_i) state <= INIT;
				// else remain

				I <= I + 1;
			end
		endcase
	end
end

endmodule