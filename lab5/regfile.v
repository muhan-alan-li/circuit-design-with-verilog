module regfile (data_in, writenum, write, readnum, clk, data_out);
    input [15:0] data_in;
    input [2:0] writenum, readnum;
    input clk, write;
    output [15:0] data_out;

    wire [7:0] regSel;
    Dec38 writeDec(writenum, regSel);

    wire[7:0] load;
    assign load = regSel & {8{write}};

    wire[15:0] R0, R1, R2, R3, R4, R5, R6, R7;
    regLoad #(16) reg0(data_in, load[0], clk, R0);
    regLoad #(16) reg1(data_in, load[1], clk, R1);
    regLoad #(16) reg2(data_in, load[2], clk, R2);
    regLoad #(16) reg3(data_in, load[3], clk, R3);
    regLoad #(16) reg4(data_in, load[4], clk, R4);
    regLoad #(16) reg5(data_in, load[5], clk, R5);
    regLoad #(16) reg6(data_in, load[6], clk, R6);
    regLoad #(16) reg7(data_in, load[7], clk, R7);

    wire[7:0] readSel;
    Dec38 readDec(readnum, readSel);
    MUX8bit16 readMUX(R0, R1, R2, R3, R4, R5, R6, R7, readSel, data_out);

endmodule

module MUX8bit16(ain, bin, cin, din, ein, fin, gin, hin, sel, out);
    input [15:0] ain, bin, cin, din, ein, fin, gin, hin;
    input [7:0] sel;
    output reg [15:0] out;

    always@(*)begin
        case(sel)
            8'b00000001 : out = ain;
            8'b00000010 : out = bin;
            8'b00000100 : out = cin;
            8'b00001000 : out = din;
            8'b00010000 : out = ein;
            8'b00100000 : out = fin;
            8'b01000000 : out = gin;
            8'b10000000 : out = hin;
            default : out = {16{1'bx}};
        endcase  
    end
    
endmodule