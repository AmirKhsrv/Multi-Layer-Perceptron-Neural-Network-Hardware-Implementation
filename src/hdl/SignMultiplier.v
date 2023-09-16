module SignMultiplier(A, B, Q);
  input [7:0] A, B;
  output [14:0] Q;
  wire [13:0] temp_result;

  assign temp_result = A[6:0] * B[6:0];
  assign Q = (A == 8'd0 || B == 8'd0) ? 15'd0 :
             ((A[7] == 1'b1 && B[7] == 1'b0) || (B[7] == 1'b1 && A[7] == 1'b0)) ? {1'b1, temp_result} : {1'b0, temp_result};
endmodule