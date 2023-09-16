module Counter #(parameter N=8) (clk, rst, enable, mode, load_en, PL, Q, c_out);
    input clk, rst, load_en, mode, enable;
    input [N-1:0] PL;
    output reg [N-1:0] Q;
    output c_out;

    always @(posedge clk, posedge rst) begin
        if(rst) Q <= N'('d0);
        else if(load_en) Q <= PL;
        else if(enable) Q <= (mode) ? Q + N'('d1) : Q - N'('d1);
    end
    assign c_out = &Q;

endmodule