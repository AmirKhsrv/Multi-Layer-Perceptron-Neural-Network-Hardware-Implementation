module Memory #(parameter FILE_NAME = "mem.txt", ADDRESS_SPACE = 8, WORD_SIZE = 8) (clk, write_en, address, data_in, data_out);
	input clk, write_en;
	input [ADDRESS_SPACE - 1:0] address;
	input [WORD_SIZE - 1:0] data_in;
	output [WORD_SIZE - 1:0] data_out;

	reg [WORD_SIZE-1:0] mem [2**ADDRESS_SPACE-1:0];

	initial $readmemh(FILE_NAME, mem);

	always @(posedge clk) begin
		if(write_en) mem[address] <= data_in;
	end
	assign data_out = mem[address];

endmodule

module UnitMemory #(parameter WORD_ADDR_S = 3, ADDRESS_S = 3, UNIT_S = 8)(clk, write_en, address, unit_addr, data_in, data_out);
	input clk, write_en;
	input [ADDRESS_S - 1:0] address;
	input [WORD_ADDR_S-1:0] unit_addr;
	input [UNIT_S-1:0] data_in;
	output reg [UNIT_S * 2**WORD_ADDR_S - 1:0] data_out;

	reg [UNIT_S-1:0] mem [2**ADDRESS_S-1:0][2**WORD_ADDR_S-1:0];
	wire [UNIT_S * 2**WORD_ADDR_S - 1:0] concat_outputs [2**ADDRESS_S-1:0];

	always @(posedge clk) begin
		if(write_en) mem[address][unit_addr] <= data_in;
	end
	
	genvar i, j;
	generate
		for(i = 0; i < 2**ADDRESS_S; i = i+1)
			for(j = 0; j < 2**WORD_ADDR_S; j = j+1)
				assign concat_outputs[i][(j+1)*UNIT_S-1 : j*UNIT_S] = mem[i][j];
	endgenerate

	assign data_out = concat_outputs[address];
endmodule

module W1Memory (clk, rst, address, data_out, ready);
	input clk, rst;
	output ready;
	input [4:0] address;
	output [64 * 8 - 1:0] data_out;
	
	wire [10:0] init_addr;
	wire [$clog2(1680)-1:0] f_address;
	wire [4:0] addr = (ready) ? address : {init_addr[10:9], init_addr[5:3]};
	wire [5:0] byte_addr = {init_addr[8:6], init_addr[2:0]};
	wire [7:0] f_data_out;
	
	Memory #("./file/w1_sm.dat", $clog2(1680), 8) file_content(clk, 1'b0, f_address, 8'd0, f_data_out);
	UnitMemory #(6, 5, 8) w1_mem(clk, ~ready, addr, byte_addr, f_data_out, data_out);

	Counter #(11) UM_W_addr_count(.clk(clk), .rst(rst), .enable(~ready), .mode(1'b1), .load_en(1'b0), .PL(), .Q(init_addr), .c_out(ready));
	Counter #(11) F_R_addr_count(.clk(clk), .rst(rst), .enable(~(addr[2:0]==3'b111 & byte_addr[2:1]==2'b11)), .mode(1'b1), .load_en(1'b0), .PL(), .Q(f_address), .c_out());
endmodule

module W2Memory (clk, rst, address, data_out, ready);
	input clk, rst;
	output ready;
	input [2:0] address;
	output [64 * 8 - 1:0] data_out;
	
	wire [8:0] init_addr;
	wire [$clog2(300)-1:0] f_address;
	wire [2:0] addr = (ready) ? address : {init_addr[8], init_addr[4:3]};
	wire [5:0] byte_addr = {init_addr[7:5], init_addr[2:0]};
	wire [7:0] f_data_out;
	
	Memory #("./file/w2_sm.dat", $clog2(300), 8) file_content(clk, 1'b0, f_address, 8'd0, f_data_out);
	UnitMemory #(6, 3, 8) w2_mem(clk, ~ready, addr, byte_addr, f_data_out, data_out);

	Counter #(9) UM_W_addr_count(.clk(clk), .rst(rst), .enable(~ready), .mode(1'b1), .load_en(1'b0), .PL(), .Q(init_addr), .c_out(ready));
	Counter #(9) F_R_addr_count(.clk(clk), .rst(rst), .enable(~(addr[1:0]==2'b11 & byte_addr[2:1]==2'b11)), .mode(1'b1), .load_en(1'b0), .PL(), .Q(f_address), .c_out());
endmodule

module B1Memory (clk, rst, address, data_out, ready);
	input clk, rst;
	output ready;
	input [1:0] address;
	output [8 * 8 - 1:0] data_out;
	
	wire [4:0] f_address;
	wire [1:0] addr = (ready) ? address : f_address[4:3];
	wire [2:0] byte_addr = f_address[2:0];
	wire [7:0] f_data_out;
	
	Memory #("./file/b1_sm.dat", 5, 8) file_content(clk, 1'b0, f_address, 8'd0, f_data_out);
	UnitMemory #(3, 2, 8) b1_mem(clk, ~ready, addr, byte_addr, f_data_out, data_out);

	Counter #(5) F_R_addr_count(.clk(clk), .rst(rst), .enable(~ready), .mode(1'b1), .load_en(1'b0), .PL(), .Q(f_address), .c_out(ready));
endmodule

module B2Memory (clk, rst, address, data_out, ready);
	input clk, rst;
	output ready;
	input address;
	output [8 * 8 - 1:0] data_out;
	
	wire [3:0] f_address;
	wire  addr = (ready) ? address : f_address[3];
	wire [2:0] byte_addr = f_address[2:0];
	wire [7:0] f_data_out;
	
	Memory #("./file/b2_sm.dat", 4, 8) file_content(clk, 1'b0, f_address, 8'd0, f_data_out);
	UnitMemory #(3, 1, 8) b2_mem(clk, ~ready, addr, byte_addr, f_data_out, data_out);

	Counter #(4) F_R_addr_count(.clk(clk), .rst(rst), .enable(~ready), .mode(1'b1), .load_en(1'b0), .PL(), .Q(f_address), .c_out(ready));
endmodule

