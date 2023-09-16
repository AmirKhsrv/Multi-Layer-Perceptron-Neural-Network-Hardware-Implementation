module PU(clk, rst, results_ready, pipe_regs_flush, in_data, weights, bias, treeAdd_bias_sel, result);
  input clk, rst;
  input treeAdd_bias_sel;
  input [8*8 - 1:0] in_data, weights;
  input [7:0] bias;
  input pipe_regs_flush;
  output [7:0] result;
  output results_ready;

  wire control_out3;

  // Pipe 1:
  wire [7:0] bias_reged;   wire control_out1;
  wire [8*8 - 1:0] in_data_reged, weights_reged;
  
  Register #(64) in_data_reg(clk, rst, ~control_out3, pipe_regs_flush, in_data, in_data_reged);
  Register #(64) weights_reg(clk, rst, ~control_out3, pipe_regs_flush, weights, weights_reged);
  Register #(8) bias_reg(clk, rst, ~control_out3, pipe_regs_flush, bias, bias_reged);
  Register #(1) control_bits1(clk, rst, ~control_out3, pipe_regs_flush, treeAdd_bias_sel, control_out1);

  // Pipe 2:
  wire [119:0] mult_out;
  wire [14:0] bias_mult_out;
  wire [134:0] tree_in;
  wire control_out2;

  SignMultiplier mult1(in_data_reged[7:0], weights_reged[7:0], mult_out[14:0]);
  SignMultiplier mult2(in_data_reged[15:8], weights_reged[15:8], mult_out[29:15]);
  SignMultiplier mult3(in_data_reged[23:16], weights_reged[23:16], mult_out[44:30]);
  SignMultiplier mult4(in_data_reged[31:24], weights_reged[31:24], mult_out[59:45]);
  SignMultiplier mult5(in_data_reged[39:32], weights_reged[39:32], mult_out[74:60]);
  SignMultiplier mult6(in_data_reged[47:40], weights_reged[47:40], mult_out[89:75]);
  SignMultiplier mult7(in_data_reged[55:48], weights_reged[55:48], mult_out[104:90]);
  SignMultiplier mult8(in_data_reged[63:56], weights_reged[63:56], mult_out[119:105]);
  SignMultiplier bias_mult(bias_reged, 8'd127, bias_mult_out);

  Register #(135) mult_reg(clk, rst, ~control_out3, pipe_regs_flush, {bias_mult_out, mult_out}, tree_in);
  Register #(1) control_bits2(clk, rst, ~control_out3, pipe_regs_flush, control_out1, control_out2);

  // Pipe 3:
  wire [14:0] tree_adder_bias = (control_out2) ? tree_in[134:120] : 15'd0;
  wire [20:0] tree_adders_out;
  AddersTree adders_tree(tree_in[14:0], tree_in[29:15], tree_in[44:30],
                          tree_in[59:45], tree_in[74:60], tree_in[89:75],
                          tree_in[104:90], tree_in[119:105], tree_adder_bias, tree_adders_out);


  wire [20:0] acc_reg_out;
  Accumulator acc_reg(clk, rst, control_out3 | pipe_regs_flush, 1'b1, tree_adders_out, acc_reg_out);
  Register #(1) control_bits3(clk, rst, 1'b1, 1'b0, control_out2, control_out3);
  
  // Pipe 4 (including saving result in register which is not in PU module) :
  assign results_ready = control_out3;
  ActivationFunction Relu(acc_reg_out, result);
 
endmodule