module Accumulator (clk, rst, init, load_en, data_in, data_out);
	input clk, rst, init, load_en;
	input [20:0] data_in;
    output reg [20:0] data_out;
    wire [20:0] new_data_out;
    Adder adder(data_in, data_out, new_data_out);

    always @(posedge clk, posedge rst) begin
        if(rst) data_out <= 21'('d0);
        else if(init)  data_out <= 21'('d0);
        else if(load_en) data_out <= new_data_out;
    end
endmodule