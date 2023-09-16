module AddersTree(In1, In2, In3, In4, In5, In6, In7, In8, bias, Q);
  input [14:0] In1, In2, In3, In4, In5, In6, In7, In8, bias;
  output [20:0] Q;

  wire [20:0] I1 = {In1[14], 6'd0, In1[13:0]};
  wire [20:0] I2 = {In2[14], 6'd0, In2[13:0]};
  wire [20:0] I3 = {In3[14], 6'd0, In3[13:0]};
  wire [20:0] I4 = {In4[14], 6'd0, In4[13:0]};
  wire [20:0] I5 = {In5[14], 6'd0, In5[13:0]};
  wire [20:0] I6 = {In6[14], 6'd0, In6[13:0]};
  wire [20:0] I7 = {In7[14], 6'd0, In7[13:0]};
  wire [20:0] I8 = {In8[14], 6'd0, In8[13:0]};
  wire [20:0] B = {bias[14], 6'd0, bias[13:0]};

  wire [20:0] T9, T10, T11, T12, T13, T14, T15, temp_result;

  Adder adder1(I1, I2, T9);
  Adder adder2(I3, I4, T10);
  Adder adder3(I5, I6, T11);
  Adder adder4(I7, I8, T12);

  Adder adder5(T9, T10, T13);
  Adder adder6(T11, T12, T14);

  Adder adder7(T13, T14, T15);

  Adder adder8(T15, B, temp_result);

  assign Q = temp_result;

endmodule