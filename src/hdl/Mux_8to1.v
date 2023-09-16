module Mux_8to1 #(parameter N = 32) (s, J7, J6, J5, J4, J3, J2, J1, J0, W);
    input [2:0] s;
    input [N-1:0] J0, J1, J2, J3, J4, J5, J6, J7;
    output [N-1:0] W;
	assign W = (s == 3'b000) ? J0 :
               (s == 3'b001) ? J1 :
               (s == 3'b010) ? J2 :
               (s == 3'b011) ? J3 :
               (s == 3'b100) ? J4 :
               (s == 3'b101) ? J5 :
               (s == 3'b110) ? J6 :
               (s == 3'b111) ? J7 : J0;
endmodule 