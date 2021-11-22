module cpu_tb;

    reg clk, reset, s, load;
    reg [15:0] in;
    wire [15:0] out;
    wire N,V,Z,w;

    cpu DUT(clk, reset, s, load, in, out, N, V, Z, w);

    initial begin
        forever begin
            clk = 1'b1; #5;
            clk = 1'b0; #5;
        end
    end

    initial begin
        reset = 1'b1;#10;

        reset = 1'b0;
        load = 1'b0; #10; // nothing should change

        // MOV R0, #7
        // 1101000000000111
        in = 16'b1101000000000111;
        load = 1'b1;
        #10; // load instruction in
        load = 1'b0;
        s = 1'b1; 
        #20; // now do these instructions, 2 clock cycles + 1 for load = 3 clock cycles for moving number into reg
        s = 1'b0;

        // MOV R3, R0, LSL #1
        // 1100000001101000
        in = 16'b1100000001101000;
        load = 1'b1;
        #10; // load instruction in
        load = 1'b0;
        s = 1'b1; 
        #40; // now do these instructions, 4 clock cycles +1 for load = 5 clock cycles for this instruction
        s = 1'b0;

        // MOV R1, #2
        // 1101000100000010
        in = 16'b1101000100000010;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #20; // now do these instructions, 2 clock cycles + 1 for load = 3 clock cycles for moving number into reg
        s = 1'b0;
        
        // ADD R2,R1,R0,LSL#1 should be 16
        // 1010000101001000
        in = 16'b1010000101001000;
        load = 1'b1;
        #10; // load instruction in
        load = 1'b0;
        s = 1'b1; 
        #60; // now do these instructions
        s = 1'b0;

        // ADD R4,R3,R2,LSR#1 should be 14+8 = 22
        // 1010001110010010
        in = 16'b1010001110010010;
        load = 1'b1;
        #10; // load instruction in
        load = 1'b0;
        s = 1'b1; 
        #60; // now do these instructions
        s = 1'b0;

        // MOV R1, #69
        // 1101000101000101
        in = 16'b1101000101000101;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #20; // now do these instructions, 2 clock cycles + 1 for load = 3 clock cycles for moving number into reg
        s = 1'b0;

        // MVN R0,R0, LSL#1 should be 1111110001 = -(2*7) = -14
        // 1011100000001000
        in = 16'b1011100000001000;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #40; // total 5 clock cycles for MVN
        s = 1'b0;

        // AND R0,R0, LSL#1 should be 1111110001 = -(2*7) = -14
        // 1011000000001000
        in = 16'b1011000000001000;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #60; // now do these instructions, 6 clock cycles + 1 for load = 7 clock cycles for AND
        s = 1'b0;



        // CMP R1,R1 TEST for 0
        // 1010100100000001
        in = 16'b1010100100000001;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #70; // needs 8 total clk cycles
        s = 1'b0;
        if (DUT.N == 1'b0) $display("PASS");
        else begin
            $display("FAIL, N not updated for %b",in);
        end

        if (DUT.V == 1'b0) $display("PASS");
        else begin
            $display("FAIL, V not updated for %b",in);
        end

        if (DUT.Z == 1'b1) $display("PASS");
        else begin
            $display("FAIL, Z not updated for %b",in);
        end


        // CMP R1,R2, LSR#1  TEST for normal input
        // 1010100100010010
        in = 16'b1010100100010010;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #70; // needs 8 total clk cycles
        s = 1'b0;
        if (DUT.N == 1'b0) $display("PASS");
        else begin
            $display("FAIL, N not updated for %b",in);
        end

        if (DUT.V == 1'b0) $display("PASS");
        else begin
            $display("FAIL, V not updated for %b",in);
        end

        if (DUT.Z == 1'b0) $display("PASS");
        else begin
            $display("FAIL, Z not updated for %b",in);
        end

        // CMP R2,R1, LSR#1  TEST for negative result and no overflow 16-69
        // 1010101000000001
        in = 16'b1010101000000001;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #70; // needs 8 total clk cycles
        s = 1'b0;
        if (DUT.N == 1'b1) $display("PASS");
        else begin
            $display("FAIL, N not updated for %b",in);
        end

        if (DUT.V == 1'b0) $display("PASS");
        else begin
            $display("FAIL, V not updated for %b",in);
        end

        if (DUT.Z == 1'b0) $display("PASS");
        else begin
            $display("FAIL, Z not updated for %b",in);
        end
        
        // MOV R5, #1
        in = 16'b1101010100000001;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #20; // now do these instructions, 2 clock cycles + 1 for load = 3 clock cycles for moving number into reg
        s = 1'b0;

        // MOV R6, #2
        in = 16'b1101011000000010;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #20; // now do these instructions, 2 clock cycles + 1 for load = 3 clock cycles for moving number into reg
        s = 1'b0;

        // MVN R5,R5
        // 1011100010100101
        in = 16'b1011100010100101;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #40; // total 5 clock cycles for MVN
        s = 1'b0;

        // CMP R5,R6, LSR#1  TEST for -1-(2) which apparently isnt overflow
        // 1010110100000110
        in = 16'b1010110100000110;
        load = 1'b1;#10; // load instruction in
        load = 1'b0;
        s = 1'b1;
        #70; // needs 8 total clk cycles
        s = 1'b0;
        if (DUT.N == 1'b1) $display("PASS");
        else begin
            $display("FAIL, N not updated for %b",in);
        end

        if (DUT.V == 1'b0) $display("PASS");
        else begin
            $display("FAIL, V not updated for %b",in);
        end

        if (DUT.Z == 1'b0) $display("PASS");
        else begin
            $display("FAIL, Z not updated for %b",in);
        end



        #10;
        $stop;
    end


endmodule
