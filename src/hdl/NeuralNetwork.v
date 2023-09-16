module NeuralNetwork(input clk, rst, start, input [62*8-1:0] input_data, 
                    output finish, output [3:0] model_result);

	wire layer_sel;
	wire input_en;
	wire [2:0] input_sel;
	wire pu_res_en1;
	wire pu_res_en2;
	wire [1:0] pu_res_w_addr;
	wire [4:0] addrW1;
	wire [2:0] addrW2;
	wire [1:0] addrB1;
	wire addrB2;
	wire treeAdd_bias_sel;
	wire pipe_regs_flush;
	wire results_ready;
	wire mem_ready;

    Datapath datapath(
        .clk(clk), .rst(rst),
        .layer_sel(layer_sel),
        .input_en(input_en),
        .input_sel(input_sel),
        .input_data(input_data),
        .addrW1(addrW1),
        .addrW2(addrW2),
        .addrB1(addrB1),
        .addrB2(addrB2),
        .treeAdd_bias_sel(treeAdd_bias_sel),
        .pu_res_en1(pu_res_en1),
        .pu_res_en2(pu_res_en2),
        .pu_res_w_addr(pu_res_w_addr), 
        .pipe_regs_flush(pipe_regs_flush),
        .results_ready(results_ready),
        .mem_ready(mem_ready),
        .model_result(model_result)
    );

    Controller controller(
        .clk(clk), .rst(rst),
        .layer_sel(layer_sel),
        .input_en(input_en),
        .input_sel(input_sel),
        .addrW1(addrW1),
        .addrW2(addrW2),
        .addrB1(addrB1),
        .addrB2(addrB2),
        .treeAdd_bias_sel(treeAdd_bias_sel),
        .pu_res_en1(pu_res_en1),
        .pu_res_en2(pu_res_en2),
        .pu_res_w_addr(pu_res_w_addr), 
        .pipe_regs_flush(pipe_regs_flush),
        .results_ready(results_ready),
        .mem_ready(mem_ready),
        .start(start),
        .finish(finish)
    );

endmodule