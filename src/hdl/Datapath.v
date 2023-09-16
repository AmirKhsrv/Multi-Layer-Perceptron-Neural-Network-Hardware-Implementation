
module Datapath(
	input clk, rst,
	input layer_sel,
	input input_en,
	input [2:0] input_sel,
	input [62*8-1:0] input_data,
	input [4:0] addrW1,
	input [2:0] addrW2,
	input [1:0] addrB1,
	input addrB2,
	input treeAdd_bias_sel,
	input pu_res_en1,
	input pu_res_en2,
	input [1:0] pu_res_w_addr, 
	input pipe_regs_flush,
	output results_ready,
	output mem_ready,
	output [3:0] model_result);

	wire [63:0] pu_results;
	wire [8*8-1:0] pu_inputs;
	wire [64*8-1:0] pu_weights_in;
	wire [8*8 - 1 : 0] pu_bias_in;

	wire [64*8-1:0] final_result;
	
	
	Comparator comp(.in(final_result[10*8-1:0]), .maxIndex(model_result), .maxVal());

	DataProvider dataProvider(clk, rst, layer_sel, input_en, input_sel, pu_results, pu_res_en1, 
							pu_res_en2, pu_res_w_addr, input_data, pu_inputs, pu_weights_in, 
							pu_bias_in, mem_ready, addrW1, addrW2, addrB1, addrB2, final_result);
    
	PU pu1(.clk(clk), .rst(rst), .results_ready(results_ready), .pipe_regs_flush(pipe_regs_flush), .in_data(pu_inputs), .weights(pu_weights_in[8*8-1:0]), .bias(pu_bias_in[7:0]), .treeAdd_bias_sel(treeAdd_bias_sel), .result(pu_results[1*8-1:0]));
	PU pu2(.clk(clk), .rst(rst), .results_ready(results_ready), .pipe_regs_flush(pipe_regs_flush), .in_data(pu_inputs), .weights(pu_weights_in[16*8-1:8*8]), .bias(pu_bias_in[15:8]), .treeAdd_bias_sel(treeAdd_bias_sel), .result(pu_results[2*8-1:1*8]));
	PU pu3(.clk(clk), .rst(rst), .results_ready(results_ready), .pipe_regs_flush(pipe_regs_flush), .in_data(pu_inputs), .weights(pu_weights_in[24*8-1:16*8]), .bias(pu_bias_in[23:16]), .treeAdd_bias_sel(treeAdd_bias_sel), .result(pu_results[3*8-1:2*8]));
	PU pu4(.clk(clk), .rst(rst), .results_ready(results_ready), .pipe_regs_flush(pipe_regs_flush), .in_data(pu_inputs), .weights(pu_weights_in[32*8-1:24*8]), .bias(pu_bias_in[31:24]), .treeAdd_bias_sel(treeAdd_bias_sel), .result(pu_results[4*8-1:3*8]));
	PU pu5(.clk(clk), .rst(rst), .results_ready(results_ready), .pipe_regs_flush(pipe_regs_flush), .in_data(pu_inputs), .weights(pu_weights_in[40*8-1:32*8]), .bias(pu_bias_in[39:32]), .treeAdd_bias_sel(treeAdd_bias_sel), .result(pu_results[5*8-1:4*8]));
	PU pu6(.clk(clk), .rst(rst), .results_ready(results_ready), .pipe_regs_flush(pipe_regs_flush), .in_data(pu_inputs), .weights(pu_weights_in[48*8-1:40*8]), .bias(pu_bias_in[47:40]), .treeAdd_bias_sel(treeAdd_bias_sel), .result(pu_results[6*8-1:5*8]));
	PU pu7(.clk(clk), .rst(rst), .results_ready(results_ready), .pipe_regs_flush(pipe_regs_flush), .in_data(pu_inputs), .weights(pu_weights_in[56*8-1:48*8]), .bias(pu_bias_in[55:48]), .treeAdd_bias_sel(treeAdd_bias_sel), .result(pu_results[7*8-1:6*8]));
	PU pu8(.clk(clk), .rst(rst), .results_ready(results_ready), .pipe_regs_flush(pipe_regs_flush), .in_data(pu_inputs), .weights(pu_weights_in[64*8-1:56*8]), .bias(pu_bias_in[63:56]), .treeAdd_bias_sel(treeAdd_bias_sel), .result(pu_results[8*8-1:7*8]));

endmodule

module DataProvider(input clk, rst, layer_sel, input_en, input [2:0] input_sel, input [63:0] pu_results, 
 					input pu_res_en1, pu_res_en2, input [1:0] pu_res_w_addr, 
					input [62*8-1:0] input_data, output [8*8-1:0] pu_inputs, 
					output [64*8-1:0] pu_weights_in, output [8*8 - 1 : 0] pu_bias_in, output mem_ready,
					output [4:0] addrW1, output [2:0] addrW2, output [1:0] addrB1, output addrB2,
					output [64*8-1:0] final_result);

	wire [64*8 - 1 : 0]  W1_out;
	wire [64*8 - 1 : 0]  W2_out;
	wire [8*8 - 1 : 0]  B1_out;
	wire [8*8 - 1 : 0]  B2_out;
	
	wire [64*8-1:0] pu_inputs2;
	wire [64*8-1:0] pu_inputs1;
	wire [64*8-1:0] pu_in_seled;

	Register #(64*8) initial_inputs(clk, rst, input_en, 1'b0, {16'd0,input_data}, pu_inputs1);
	
	assign pu_in_seled = (layer_sel) ?  {272'd0, pu_inputs2[30*8-1:0]} : pu_inputs1;
	Mux_8to1 #(8*8) mux8to1(input_sel, pu_in_seled[64*8-1:56*8], pu_in_seled[56*8-1:48*8],
					 pu_in_seled[48*8-1:40*8], pu_in_seled[40*8-1:32*8],
					 pu_in_seled[32*8-1:24*8], pu_in_seled[24*8-1:16*8], 
					 pu_in_seled[16*8-1:8*8], pu_in_seled[8*8-1:0], pu_inputs);

	
	wire ready1, ready2, ready3, ready4;
	W1Memory w1mem(clk, rst, addrW1, W1_out, ready1);
	W2Memory w2mem(clk, rst, addrW2, W2_out, ready2);
	B1Memory b1mem(clk, rst, addrB1, B1_out, ready3);
	B2Memory b2mem(clk, rst, addrB2, B2_out, ready4);

	assign mem_ready = ready1 & ready2 & ready3 & ready4;

	assign pu_weights_in = (layer_sel) ? W2_out : W1_out;
	assign pu_bias_in = (layer_sel) ? B2_out : B1_out;

	UnitMemory #(2, 1, 8*8) puResultsMem1(clk, pu_res_en1, 1'b0, pu_res_w_addr, pu_results, pu_inputs2[32*8-1:0]);
	UnitMemory #(2, 1, 8*8) puResultsMem2(clk, pu_res_en2, 1'b0, pu_res_w_addr, pu_results, final_result[32*8-1:0]);

	// initial begin
	// 	$monitor("t=%3d pu_inputs2=%h \n",$time, pu_inputs2[32*8-1:0]);
	// end
endmodule
