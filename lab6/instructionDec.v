module instructionDec(in, nsel, opcode, op, ALUop, sximm5, sximm8, shift, rn, rd, rm);
    input[15:0] in;
    input[] nsel;
    output[2:0] opcode, rn, rd, rm;
    output[1:0] op, ALUop, shift;
    output[15:0] sximm5, sximm8;

    assign opcode = in[15:13];
    assign op     = in[12:11];
    assign ALUop  = in[12:11];
    assign shift  = in[4:3];
    assign rn     = in[10:8];
    assign rd     = in[7:5];
    assign rm     = in[2:0];

    //sign extend
    assign sximm5 = {{11{in[4]}}, in[4:0]};     //this is supposed to be replication operator not sure if implmented correctly
    assign sximm8 = {{8{in[7]}}, in[7:0]};
endmodule