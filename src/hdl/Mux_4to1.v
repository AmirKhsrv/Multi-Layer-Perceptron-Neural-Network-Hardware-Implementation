module Mux_4to1 #(parameter N = 32) (s, J0, J1, J2, J3, W);
    input [1:0] s;
    input [N-1:0] J0, J1, J2, J3;
    output [N-1:0] W;
	assign W = (s == 2'b00) ? J0 :
               (s == 2'b01) ? J1 :
               (s == 2'b10) ? J2 :
               (s == 2'b11) ? J3 : J0;
endmodule 