
module fc2
#(
    parameter ISIZE = 10,
    parameter LSIZE = 10,
    parameter [(LSIZE*ISIZE - 1):0] valid = {1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0},
    parameter integer NUM_VALID [LSIZE-1:0] = '{5,5,5,6,6,6,5,6,8,6},
    parameter threshold = 0

)
(
    clk,
	rst,
	g_input,
	e_input,
	o
);


input clk;
input rst;
input bit [ISIZE-1:0] g_input;
input bit [(LSIZE*ISIZE-1):0] e_input;

output bit [LSIZE-1:0] o;

bit [(LSIZE*ISIZE-1):0] xnorresults;


genvar gi, gj;
generate
    for (gi=0; gi<LSIZE; gi=gi+1) begin : genbit
        for (gj=0; gj<ISIZE; gj=gj+1) begin : genbit2
            if (valid[(gi*ISIZE + gj)] == 1'b1)
            begin
                assign xnorresults[(gi*ISIZE + gj)] = g_input[gj] ~^ e_input[(gi*ISIZE + gj)];
            end
        end
    end
endgenerate

shortint signed popcount [LSIZE-1:0];
shortint unsigned i;
shortint unsigned j;
shortint unsigned k;
bit [LSIZE-1:0] tempresult;

always @* begin
for (i=0; i<LSIZE; i=i+1) begin
    popcount[i] = 0;
    for (j=0; j<ISIZE; j=j+1) begin
        popcount[i] = popcount[i] + xnorresults[(i*ISIZE + j)];
    end
    popcount[i] = 2*popcount[i];
end

for (k=0; k<LSIZE; k=k+1) begin
    tempresult[k] = (popcount[k] > (threshold + NUM_VALID[k]));
end
end

assign o = tempresult;
endmodule
 
    