module Controller (
	input clk, rst,
	input start,
	output reg finish,
	output reg layer_sel,
	output reg input_en,
	output [2:0] input_sel,
	output pu_res_en1,
	output pu_res_en2,
	output [1:0] pu_res_w_addr,
	output [4:0] addrW1,
	output [2:0] addrW2,
	output [1:0] addrB1,
	output addrB2,
	output treeAdd_bias_sel,
	output pipe_regs_flush,
	input results_ready,
	input mem_ready);

	reg [2:0] ns, ps;
	reg last_neuron_batch;
	reg flush;

	localparam [2:0] Idle = 3'd0, Init = 3'd1, Layer1 = 3'd2, Siwtch = 3'd3, Layer2 = 3'd4, Flush_Compare = 3'd5;

	always@(posedge clk, posedge rst) begin
		if(rst) ps = 3'b000;
		else ps <= ns;
	end

	always@(ps, results_ready, mem_ready, start)begin
		{layer_sel, input_en, flush, finish} = 4'd0;
		case(ps)
			Idle: {finish, input_en} = start ? 2'b01 : 2'b10;
			Init: flush = mem_ready ? 1'b0 : 1'b1;
			Siwtch: {layer_sel, flush} = 2'b11;
			Layer2: layer_sel = 1'b1;
			Flush_Compare: {layer_sel, flush} = 2'b11;
		endcase
	end

	always@(ps, results_ready, mem_ready, start)begin
		ns = Idle;
		case(ps)
			Idle: ns = start ? Init : Idle;
			Init: ns = mem_ready ? Layer1 : Init;
			Layer1: ns = results_ready & last_neuron_batch ? Siwtch : Layer1;
			Siwtch: ns = Layer2;
			Layer2: ns = results_ready & last_neuron_batch ? Flush_Compare : Layer2;
			Flush_Compare: ns = Idle;
		endcase
	end
	
	wire [2:0] N_P_itr1;
	wire [1:0] B_N_itr1, N_R_addr;
	wire [1:0] N_P_itr2;
	wire B_N_itr2, N_P_co1, B_N_co1, N_P_co2, B_N_co2, N_R_addr_co;
	

	Counter #(3) neuron_process_iterator1(clk, rst, ~results_ready, 1'b1, flush, 3'd0, N_P_itr1, N_P_co1);
	Counter #(2) batch_neurons_iterator1(clk, rst, N_P_co1, 1'b1, flush, 2'd0, B_N_itr1, B_N_co1);
	Counter #(2) neuron_process_iterator2(clk, rst, ~results_ready, 1'b1, flush, 2'd0, N_P_itr2, N_P_co2);
	Counter #(1) batch_neurons_iterator2(clk, rst, N_P_co2, 1'b1, flush, 1'd0, B_N_itr2, B_N_co2);
	
	Counter #(2) neurons_res_addr_count(clk, rst, results_ready, 1'b1, flush, 2'd0, N_R_addr, N_R_addr_co);


	assign addrW1 = {B_N_itr1, N_P_itr1};
	assign addrW2 = {B_N_itr2, N_P_itr2};
	assign addrB1 = B_N_itr1;
	assign addrB2 = B_N_itr2;
	assign input_sel = (layer_sel) ? N_P_itr2 : N_P_itr1;
	
	assign treeAdd_bias_sel = (layer_sel) ? N_P_co2 : N_P_co1;
	assign pipe_regs_flush = flush;

	assign pu_res_w_addr = N_R_addr;
	assign pu_res_en1 = results_ready & ~layer_sel;
	assign pu_res_en2 = results_ready & layer_sel;

	always @(posedge clk, posedge rst) begin
		if(rst) last_neuron_batch <= 1'b0;
		else if(flush) last_neuron_batch <= 1'b0;
		else if((B_N_co1 & ~layer_sel | B_N_co2 & layer_sel) & results_ready) last_neuron_batch <= 1'b1;
	end
	
endmodule
