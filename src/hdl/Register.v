module Register #(parameter N = 8) (clk, rst, ld_en, init, PL, Q);
    input clk, rst, ld_en, init;
    input [N-1:0] PL;
    output reg [N-1:0] Q;

    always @(posedge clk, posedge rst) begin
        if(rst) Q <= N'('d0);
        else if(init)  Q <= {(N-1)'('d0), 1'b0};
        else if(ld_en) Q <= PL;
    end
endmodule