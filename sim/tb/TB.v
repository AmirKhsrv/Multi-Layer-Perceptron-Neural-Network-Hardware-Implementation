`timescale 1ps/1ps
module CostumizedTV(address, data_out);
	input [9:0] address;
	output [62*8 - 1:0] data_out;

	reg [7:0] mem [46500 - 1:0];
	wire [62*8 - 1:0] concated_data [750:0];

	initial $readmemh("./file/te_data_sm.dat", mem);

	genvar i,j;
	generate
		for (i = 0; i < 750; i = i + 1) begin
			for(j = 0; j < 62; j = j + 1) begin
				assign concated_data[i][(j+1)*8 - 1 : j*8] = mem[i*62 + j];
			end
		end
	endgenerate
	assign data_out = concated_data[address];
endmodule

module TB();
    reg clk = 0, rst = 0, start = 0;
    wire [62*8-1 : 0] input_data;
    wire finish;
    wire [3:0] result, test_label;
    reg [9:0] test_addr;

	CostumizedTV test_data(test_addr, input_data);
    NeuralNetwork uut(clk, rst, start, input_data, finish, result);
	Memory #("./file/te_lable_sm.dat", 10, 4) test_labels(clk, 1'b0, test_addr, 4'd0, test_label);

	real start_t;
	real true_predicted = 0;
	integer count = 0, total = 100;
	always @(finish) begin
		if(finish == 1'b1 && $time > 200 && $time > start_t + 70) begin
			// if (^result === 1'bx) $display("test %d : output is X --- expected %d", test_addr + 1, test_label);
			// $display("test %d : output is %d --- expected %d", test_addr + 1, result, test_label);
			if(result == test_label) true_predicted = true_predicted + 1;
			if(count < total - 1) begin
				count = count + 1;
				test_addr = $realtime % 750;
			end
			else begin
				$display("accuracy =  %f | total tests = %d", (true_predicted / total), total);
				#10 $stop;
			end
			#20 start = 1; start_t = $time;
			#10 start = 0;
		end
	end
    always #5 clk = ~clk;
	initial begin
		# 10 rst = 1;
		# 20 rst = 0;
		test_addr = 10'd0;
		start = 1; start_t = $time;
		#10 start = 0; 
    end
	
endmodule
