module ActivationFunction(In, Q);
  input [20:0] In;
  output [7:0] Q;
  wire [7:0] temp_input = In[15:9];
  assign Q = (In[20] == 1'b1) ? 8'd0 : {1'b0, temp_input};
endmodule