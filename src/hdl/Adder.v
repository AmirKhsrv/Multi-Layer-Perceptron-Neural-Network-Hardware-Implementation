module Adder(A, B, Q);
  input [20:0] A, B;
  output [20:0] Q;

  wire [20:0] temp_result, data_A, data_B;

  assign data_A = (A[20] == 1'b1) ? ~{1'b0,A[19:0]} + 21'd1 : A;
  assign data_B = (B[20] == 1'b1) ? ~{1'b0,B[19:0]} + 21'd1 : B;

  wire [20:0] temp = ~temp_result + 21'd1;
  assign temp_result = data_A + data_B;
  assign Q = (temp_result[20] == 1'b1) ? {1'b1,temp[19:0]} : temp_result;

endmodule