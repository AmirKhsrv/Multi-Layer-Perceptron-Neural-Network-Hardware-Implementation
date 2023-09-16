module Comparator (in, maxIndex, maxVal);
    input [10*8-1:0] in;
    output reg [3:0] maxIndex;
    output [7:0] maxVal;
    
    reg [7:0] currMax;

    always @(in) begin
        currMax = in[10*8-1:9*8];
        maxIndex = 4'b1001;
        if(in[9*8-1:8*8] > currMax) begin maxIndex = 4'b1000; currMax = in[9*8-1:8*8]; end
        if(in[8*8-1:7*8] > currMax) begin maxIndex = 4'b0111; currMax = in[8*8-1:7*8]; end
        if(in[7*8-1:6*8] > currMax) begin maxIndex = 4'b0110; currMax = in[7*8-1:6*8]; end
        if(in[6*8-1:5*8] > currMax) begin maxIndex = 4'b0101; currMax = in[6*8-1:5*8]; end
        if(in[5*8-1:4*8] > currMax) begin maxIndex = 4'b0100; currMax = in[5*8-1:4*8]; end
        if(in[4*8-1:3*8] > currMax) begin maxIndex = 4'b0011; currMax = in[4*8-1:3*8]; end
        if(in[3*8-1:2*8] > currMax) begin maxIndex = 4'b0010; currMax = in[3*8-1:2*8]; end
        if(in[2*8-1:1*8] > currMax) begin maxIndex = 4'b0001; currMax = in[2*8-1:1*8]; end
        if(in[1*8-1:0] > currMax) begin maxIndex <= 4'b0000; currMax = in[1*8-1:0]; end
    end
    assign maxVal = currMax;
endmodule