`timescale 1ns / 1ps

module tb_CAM_Top_Eng;

    // Signal Definition
    reg rst_n;
    reg CLK;
    reg [31:0] data_in_0;
    reg [31:0] data_in_1;
    reg [4:0] cmp_addr_1;
    reg [4:0] cmp_addr_2;
    reg [1:0] ppg_addr_1;
    reg [1:0] ppg_addr_2;
    reg cmp_data_1;
    reg cmp_data_2;
    reg ppg_data_1;
    reg ppg_data_2;
    reg [7:0] exp_in_1;
    reg [7:0] exp_in_2;
    reg [4:0] state_ctrl;
    reg acc_en;
    reg [31:0] chip_enable;
    reg SEARCH_2row;
    reg [2:0] ppg_addr_msb;
    wire [5:0] sum_0;
    wire [5:0] sum_1;
    
    reg [4:0] Emax_0;
    reg [4:0] Emax_1;
    real input_0;
    real input_1;
    real part_sum_0;
    real part_sum_1;
    real final_result_0;
    real final_result_1;

    // instantiate CAM_Top module
    CAM_Top_Eng uut (
        .rst_n(rst_n),
        .CLK(CLK),
        .data_in_0(data_in_0),
        .data_in_1(data_in_1),
        .cmp_addr_1(cmp_addr_1),
        .cmp_addr_2(cmp_addr_2),
        .ppg_addr_1(ppg_addr_1),
        .ppg_addr_2(ppg_addr_2),
        .cmp_data_1(cmp_data_1),
        .ppg_addr_msb(ppg_addr_msb),
        .cmp_data_2(cmp_data_2),
        .ppg_data_1(ppg_data_1),
        .ppg_data_2(ppg_data_2),
        .exp_in_1(exp_in_1),
        .exp_in_2(exp_in_2),
        .state_ctrl(state_ctrl),
        .acc_en(acc_en),
        .chip_enable(chip_enable),
        .SEARCH_2row(SEARCH_2row),
        .sum_0(sum_0),
        .sum_1(sum_1)
    );

    // Clock generation
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;  // 100MHz
    end

    // Simulation process
    initial begin
        // Initialization signal
        rst_n = 0; data_in_0 = 32'b0; data_in_1 = 32'b0;
        cmp_addr_1 = 5'b0; cmp_addr_2 = 5'b0; ppg_addr_1 = 2'b0; ppg_addr_2 = 2'b0;
        cmp_data_1 = 0; cmp_data_2 = 0; ppg_data_1 = 0; ppg_data_2 = 0; exp_in_1 = 8'b0; exp_in_2 = 8'b0; 
        state_ctrl = 5'b0;     
        acc_en = 0;
        chip_enable = 32'b0;  // Disabled by default
        SEARCH_2row = 0;
        ppg_addr_msb = 0;

        // Reset
        #10 rst_n = 1;

        //mem is all reset
        clear_mem(0); clear_mem_exp_max(1);
        clear_mem(2); clear_mem(3); clear_mem(4); clear_mem(5); clear_mem(6); clear_mem(7); clear_mem(8); clear_mem(9); clear_mem(10); clear_mem(11); clear_mem(12); clear_mem(13); clear_mem(14); clear_mem(15);
        clear_mem(16); clear_mem_exp_max(17);
        clear_mem(18); clear_mem(19); clear_mem(20); clear_mem(21); clear_mem(22); clear_mem(23);clear_mem(24); clear_mem(25); clear_mem(26); clear_mem(27); clear_mem(28); clear_mem(29); clear_mem(30); clear_mem(31);

        /* Example 1:
        Input1[0]:  0_00011_11000_00000 (1.5  X 2^3 = 12.0)
        Input1[1]:  0_00011_10100_00000 (1.25 X 2^3 = 10.0)
        Input1[2]:  0_00001_11000_00000 (1.5  X 2^1 =  3.0)
        Input1[3]:  0_00010_11000_00000 (1.5  X 2^2 =  6.0)

        Input2[0]:  0_00011_10100_00000 (1.25 X 2^3 = 10.0)
        Input2[1]:  0_00011_10010_00000 (1.125 X 2^3 = 9.0)
        Input2[2]:  0_00000_11000_00000 (1.5  X 2^0 =  1.5)
        Input2[3]:  0_00011_10000_00000 (1.0  X 2^3 =  8.0)

        Ideal Output = Input1 * Input2 = 120 + 90 + 4.5 + 48 = 262.5

        Example 2:
        Input3[0]:  0_00011_11100_00000 (1.75 X 2^3 = 14.0)
        Input3[1]:  0_00001_10100_00000 (1.25 X 2^1 =  2.5)
        Input3[2]:  0_00011_11000_00000 (1.5  X 2^3 = 12.0)
        Input3[3]:  0_00010_11000_00000 (1.5  X 2^2 =  6.0)

        Input4[0]:  0_00001_10100_00000 (1.25 X 2^1 =  2.5)
        Input4[1]:  0_00010_10000_00000 (1.0  X 2^2 =  4.0)
        Input4[2]:  0_00000_11000_00000 (1.5  X 2^0 =  1.5)
        Input4[3]:  0_00010_11000_00000 (1.5  X 2^2 =  6.0)

        Ideal Output = Input3 * Input4 = 35 + 10 + 18 + 36 = 99.0
        */
        
        // test if the result is right
        input_0 = 262.5; input_1 = 99.0;

        // State 0: Write data from mem4[cmp_addr_1] to mem9[cmp_addr_1]
        // Set conditions: Ttag=0, FB=0, acc=0, Lshift=0, Rshift=0, Ftag=0, we=1
        
        // Write row 0, the 1st and 3rd vector
        cmp_addr_1 = 5'd0;  
        cmp_addr_2 = 5'd0;  
        state_ctrl = 5'd0;

        chip_enable[4] = 1; // Vector 1 written by mem4
        chip_enable[20] = 1; // Vector 3 written by mem20
        data_in_0 = 32'b1101_0000_0000_0000_0000_0000_0000_0000;  
        data_in_1 = 32'b1011_0000_0000_0000_0000_0000_0000_0000; 
        #10;
        chip_enable[4] = 0;
        chip_enable[20] = 0;

        chip_enable[5] = 1; // Vector 1 written by mem5
        chip_enable[21] = 1; //  Vector 3 written by mem21
        data_in_0 = 32'b1110_0000_0000_0000_0000_0000_0000_0000;  
        data_in_1 = 32'b1110_0000_0000_0000_0000_0000_0000_0000;  
        #10;
        chip_enable[5] = 0;
        chip_enable[21] = 0;

        chip_enable[6] = 1; // Vector 1 written by mem6
        chip_enable[22] = 1; //  Vector 3 written by mem22
        data_in_0 = 32'b1111_0000_0000_0000_0000_0000_0000_0000;  
        data_in_1 = 32'b1111_0000_0000_0000_0000_0000_0000_0000;  
        #10;
        chip_enable[6] = 0;
        chip_enable[22] = 0;

        chip_enable[7] = 1; // Vector 1 written by mem7
        chip_enable[23] = 1; //  Vector 3 written by mem23
        data_in_0 = 32'b1011_0000_0000_0000_0000_0000_0000_0000;  
        data_in_1 = 32'b1011_0000_0000_0000_0000_0000_0000_0000;  
        #10;
        chip_enable[7] = 0;
        chip_enable[23] = 0;

        chip_enable[8] = 1; // Vector 1 written by mem8
        chip_enable[24] = 1; //  Vector 3 written by mem24
        data_in_0 = 32'b0100_0000_0000_0000_0000_0000_0000_0000;   
        data_in_1 = 32'b1100_0000_0000_0000_0000_0000_0000_0000;  
        #10;
        chip_enable[8] = 0;
        chip_enable[24] = 0;
        
        // Write row 1, the 2nd and 4th vector
        cmp_addr_1 = 5'd1;  
        cmp_addr_2 = 5'd1; 
        state_ctrl = 5'd0;

        chip_enable[4] = 1; // Vector 2 written by mem4
        chip_enable[20] = 1; // Vector 4 written by mem20
        data_in_0 = 32'b1101_0000_0000_0000_0000_0000_0000_0000;  
        data_in_1 = 32'b0101_0000_0000_0000_0000_0000_0000_0000;  
        #10;
        chip_enable[4] = 0;
        chip_enable[20] = 0;

        chip_enable[5] = 1; // Vector 2 written by mem5
        chip_enable[21] = 1; // Vector 4 written by mem21
        data_in_0 = 32'b1101_0000_0000_0000_0000_0000_0000_0000;  
        data_in_1 = 32'b1000_0000_0000_0000_0000_0000_0000_0000;  
        #10;
        chip_enable[5] = 0;
        chip_enable[21] = 0;

        chip_enable[6] = 1; // Vector 2 written by mem6
        chip_enable[22] = 1; // Vector 4 written by mem22
        data_in_0 = 32'b1111_0000_0000_0000_0000_0000_0000_0000;  
        data_in_1 = 32'b1111_0000_0000_0000_0000_0000_0000_0000;  
        #10;
        chip_enable[6] = 0;
        chip_enable[22] = 0;

        chip_enable[7] = 1; // Vector 2 written by mem7
        chip_enable[23] = 1; // Vector 4 written by mem23
        data_in_0 = 32'b0010_0000_0000_0000_0000_0000_0000_0000;  
        data_in_1 = 32'b0011_0000_0000_0000_0000_0000_0000_0000;  
        #10;
        chip_enable[7] = 0;
        chip_enable[23] = 0;

        chip_enable[8] = 1; // Vector 2 written by mem8
        chip_enable[24] = 1; // Vector 4 written by mem24
        data_in_0 = 32'b1000_0000_0000_0000_0000_0000_0000_0000;  
        data_in_1 = 32'b1000_0000_0000_0000_0000_0000_0000_0000;  
        #10;
        chip_enable[8] = 0;
        chip_enable[24] = 0;

        chip_enable[9] = 1; // Vector 2 written by mem9
        chip_enable[25] = 1; // Vector 4 written by mem25
        data_in_0 = 32'b0100_0000_0000_0000_0000_0000_0000_0000;  
        data_in_1 = 32'b0000_0000_0000_0000_0000_0000_0000_0000;  
        #10;
        chip_enable[9] = 0;
        chip_enable[25] = 0;

        // State 1:FB_search_and_update_block, first test the search update of S for the exponential parts mem1 to mem5, S is stored in the first row of meta data
        // Set conditions: Ttag=0, FB=1, acc=0, Lshift=0, Rshift=0, Ftag=0, we=0
        SEARCH_2row = 1; // Search 1_0
        state_ctrl = 5'd1; cmp_addr_1 = 5'd0; cmp_addr_2 = 5'd1; cmp_data_1 = 1; cmp_data_2 = 0;
        ppg_addr_msb = 0;
         chip_enable[1] = 1; chip_enable[2] = 1; chip_enable[3] = 1; chip_enable[4] = 1; chip_enable[5] = 1; 
        chip_enable[17] = 1; chip_enable[18] = 1; chip_enable[19] = 1; chip_enable[20] = 1; chip_enable[21] = 1; 
        #10;
        chip_enable[1] = 0; chip_enable[2] = 0; chip_enable[3] = 0; chip_enable[4] = 0; chip_enable[5] = 0;
        chip_enable[17] = 0; chip_enable[18] = 0; chip_enable[19] = 0; chip_enable[20] = 0; chip_enable[21] = 0; 

        SEARCH_2row = 1; // Search 0_1
        state_ctrl = 5'd1; cmp_addr_1 = 5'd0; cmp_addr_2 = 5'd1; cmp_data_1 = 0; cmp_data_2 = 1;
        ppg_addr_msb = 0;
        chip_enable[1] = 1; chip_enable[2] = 1; chip_enable[3] = 1; chip_enable[4] = 1; chip_enable[5] = 1; 
        chip_enable[17] = 1; chip_enable[18] = 1; chip_enable[19] = 1; chip_enable[20] = 1; chip_enable[21] = 1;
        #10;
        chip_enable[1] = 0; chip_enable[2] = 0; chip_enable[3] = 0; chip_enable[4] = 0; chip_enable[5] = 0;
        chip_enable[17] = 0; chip_enable[18] = 0; chip_enable[19] = 0; chip_enable[20] = 0; chip_enable[21] = 0; 
        
        // State 2:L_search_and_update_block, first test the search update of C for the exponential parts mem1 to mem5, C is stored in the second line of meta data
        // Set conditions: Ttag=0, FB=0, acc=0, Lshift=1, Rshift=0, Ftag=0, we=0
        SEARCH_2row = 1;
        state_ctrl = 5'd2; cmp_addr_1 = 5'd0; cmp_addr_2 = 5'd1; cmp_data_1 = 1; cmp_data_2 = 1;
        ppg_addr_msb = 1;
        chip_enable[1] = 1; chip_enable[2] = 1; chip_enable[3] = 1; chip_enable[4] = 1; chip_enable[5] = 1; 
        chip_enable[17] = 1; chip_enable[18] = 1; chip_enable[19] = 1; chip_enable[20] = 1; chip_enable[21] = 1;
        #10;
        chip_enable[1] = 0; chip_enable[2] = 0; chip_enable[3] = 0; chip_enable[4] = 0; chip_enable[5] = 0;
        chip_enable[17] = 0; chip_enable[18] = 0; chip_enable[19] = 0; chip_enable[20] = 0; chip_enable[21] = 0; 

        // State 1 + state 2, exponential parts mem1 to mem5 serially modify C and S to obtain Esum, Esum is stored in the third row of meta data
        // Search for 1_0, 0_1, 1_1 for each bit to update C and S in meta data
        cmp_addr_1 = 5'd0;  cmp_addr_2 = 5'd0;
         
        state_ctrl = 5'd1; ppg_addr_msb = 2; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 1; ppg_data_2 = 0; chip_enable[5] = 1; chip_enable[21] = 1;#10;chip_enable[5] = 0; chip_enable[21] = 0;
        state_ctrl = 5'd1; ppg_addr_msb = 2; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 0; ppg_data_2 = 1; chip_enable[5] = 1; chip_enable[21] = 1;#10;chip_enable[5] = 0; chip_enable[21] = 0;
        state_ctrl = 5'd2; ppg_addr_msb = 1; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 1; ppg_data_2 = 1; chip_enable[5] = 1; chip_enable[21] = 1;#10;chip_enable[5] = 0; chip_enable[21] = 0;

        state_ctrl = 5'd1; ppg_addr_msb = 2; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 1; ppg_data_2 = 0; chip_enable[4] = 1; chip_enable[20] = 1;#10;chip_enable[4] = 0; chip_enable[20] = 0;
        state_ctrl = 5'd1; ppg_addr_msb = 2; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 0; ppg_data_2 = 1; chip_enable[4] = 1; chip_enable[20] = 1;#10;chip_enable[4] = 0; chip_enable[20] = 0;
        state_ctrl = 5'd2; ppg_addr_msb = 1; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 1; ppg_data_2 = 1; chip_enable[4] = 1; chip_enable[20] = 1;#10;chip_enable[4] = 0; chip_enable[20] = 0;
        
        state_ctrl = 5'd1; ppg_addr_msb = 2; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 1; ppg_data_2 = 0; chip_enable[3] = 1; chip_enable[19] = 1;#10;chip_enable[3] = 0; chip_enable[19] = 0;
        state_ctrl = 5'd1; ppg_addr_msb = 2; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 0; ppg_data_2 = 1; chip_enable[3] = 1; chip_enable[19] = 1;#10;chip_enable[3] = 0; chip_enable[19] = 0;
        state_ctrl = 5'd2; ppg_addr_msb = 1; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 1; ppg_data_2 = 1; chip_enable[3] = 1; chip_enable[19] = 1;#10;chip_enable[3] = 0; chip_enable[19] = 0;

        state_ctrl = 5'd1; ppg_addr_msb = 2; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 1; ppg_data_2 = 0; chip_enable[2] = 1; chip_enable[18] = 1;#10;chip_enable[2] = 0; chip_enable[18] = 0;
        state_ctrl = 5'd1; ppg_addr_msb = 2; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 0; ppg_data_2 = 1; chip_enable[2] = 1; chip_enable[18] = 1;#10;chip_enable[2] = 0; chip_enable[18] = 0;
        state_ctrl = 5'd2; ppg_addr_msb = 1; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 1; ppg_data_2 = 1; chip_enable[2] = 1; chip_enable[18] = 1;#10;chip_enable[2] = 0; chip_enable[18] = 0;
        
        state_ctrl = 5'd1; ppg_addr_msb = 2; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 1; ppg_data_2 = 0; chip_enable[1] = 1; chip_enable[17] = 1;#10;chip_enable[1] = 0; chip_enable[17] = 0;
        state_ctrl = 5'd1; ppg_addr_msb = 2; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 0; ppg_data_2 = 1; chip_enable[1] = 1; chip_enable[17] = 1;#10;chip_enable[1] = 0; chip_enable[17] = 0;
        state_ctrl = 5'd2; ppg_addr_msb = 1; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 1; ppg_data_2 = 1; chip_enable[1] = 1; chip_enable[17] = 1;#10;chip_enable[1] = 0; chip_enable[17] = 0;

        // State 4 to state 8, carry each bit of Esum to the highest exponent bit
        ppg_addr_msb = 2;
        state_ctrl = 5'd8;#10;
        state_ctrl = 5'd7;#10;
        state_ctrl = 5'd6;#10;
        state_ctrl = 5'd5;#10;
        state_ctrl = 5'd4;#10;

        // State 9, which has to be output bit by bit to the adder to find the maximum exponent value
        state_ctrl = 5'd9;
        ppg_addr_1 = 0; @(posedge CLK); #1; $display("sum0 = %d, sum1 = %d", sum_0, sum_1);
        ppg_addr_1 = 1; @(posedge CLK); #1; $display("sum0 = %d, sum1 = %d", sum_0, sum_1);
        ppg_addr_1 = 2; @(posedge CLK); #1; $display("sum0 = %d, sum1 = %d", sum_0, sum_1);
        ppg_addr_1 = 3; @(posedge CLK); #1; $display("sum0 = %d, sum1 = %d", sum_0, sum_1);
        ppg_addr_1 = 4; @(posedge CLK); #1; $display("sum0 = %d, sum1 = %d", sum_0, sum_1);

        // Suppose now that the maximum value Emax is found, and next search Emax -m + i one by one, with a right shift operation on mansa 1, alternating states 30 and 3
        Emax_0 = 8'b00000110;
        Emax_1 = 8'b00000100;
        state_ctrl = 5'd30;
        ppg_addr_msb = 0;
        exp_in_1 = Emax_0 - 4;
        exp_in_2 = Emax_1 - 4;
        #20; 
        //$display("MSBtotag_1 = %b", uut.MSBtotag_1);$display("MSBtotag_2 = %b", uut.MSBtotag_2);
        state_ctrl = 5'd3; cmp_addr_1 = 0; 
        ppg_addr_msb = 0; 
        chip_enable[5]=1;chip_enable[6]=1;chip_enable[7]=1;chip_enable[8]=1;chip_enable[9]=1;chip_enable[10]=1;chip_enable[11]=1;chip_enable[12]=1;chip_enable[13]=1;chip_enable[14]=1;
        chip_enable[21]=1;chip_enable[22]=1;chip_enable[23]=1;chip_enable[24]=1;chip_enable[25]=1;chip_enable[26]=1;chip_enable[27]=1;chip_enable[28]=1;chip_enable[29]=1;chip_enable[30]=1;
        #10;chip_enable[5]=0;chip_enable[6]=0;chip_enable[7]=0;chip_enable[8]=0;chip_enable[9]=0;chip_enable[10]=0;chip_enable[11]=0;chip_enable[12]=0;chip_enable[13]=0;chip_enable[14]=0;
        chip_enable[21]=0;chip_enable[22]=0;chip_enable[23]=0;chip_enable[24]=0;chip_enable[25]=0;chip_enable[26]=0;chip_enable[27]=0;chip_enable[28]=0;chip_enable[29]=0;chip_enable[30]=0;

        state_ctrl = 5'd30;
        ppg_addr_msb = 0;
        exp_in_1 = Emax_0 - 3;
        exp_in_2 = Emax_1 - 3;
        #20; 
        //$display("MSBtotag_1 = %b", uut.MSBtotag_1);$display("MSBtotag_2 = %b", uut.MSBtotag_2);
        state_ctrl = 5'd3; cmp_addr_1 = 0; 
        ppg_addr_msb = 0; 
        chip_enable[5]=1;chip_enable[6]=1;chip_enable[7]=1;chip_enable[8]=1;chip_enable[9]=1;chip_enable[10]=1;chip_enable[11]=1;chip_enable[12]=1;chip_enable[13]=1;chip_enable[14]=1;
        chip_enable[21]=1;chip_enable[22]=1;chip_enable[23]=1;chip_enable[24]=1;chip_enable[25]=1;chip_enable[26]=1;chip_enable[27]=1;chip_enable[28]=1;chip_enable[29]=1;chip_enable[30]=1;
        #10;chip_enable[5]=0;chip_enable[6]=0;chip_enable[7]=0;chip_enable[8]=0;chip_enable[9]=0;chip_enable[10]=0;chip_enable[11]=0;chip_enable[12]=0;chip_enable[13]=0;chip_enable[14]=0;
        chip_enable[21]=0;chip_enable[22]=0;chip_enable[23]=0;chip_enable[24]=0;chip_enable[25]=0;chip_enable[26]=0;chip_enable[27]=0;chip_enable[28]=0;chip_enable[29]=0;chip_enable[30]=0;

        state_ctrl = 5'd30;
        ppg_addr_msb = 0;
        exp_in_1 = Emax_0 - 2;
        exp_in_2 = Emax_1 - 2;
        #20; 
        //$display("MSBtotag_1 = %b", uut.MSBtotag_1);$display("MSBtotag_2 = %b", uut.MSBtotag_2);
        state_ctrl = 5'd3; cmp_addr_1 = 0; 
        ppg_addr_msb = 0; 
        chip_enable[5]=1;chip_enable[6]=1;chip_enable[7]=1;chip_enable[8]=1;chip_enable[9]=1;chip_enable[10]=1;chip_enable[11]=1;chip_enable[12]=1;chip_enable[13]=1;chip_enable[14]=1;
        chip_enable[21]=1;chip_enable[22]=1;chip_enable[23]=1;chip_enable[24]=1;chip_enable[25]=1;chip_enable[26]=1;chip_enable[27]=1;chip_enable[28]=1;chip_enable[29]=1;chip_enable[30]=1;
        #10;chip_enable[5]=0;chip_enable[6]=0;chip_enable[7]=0;chip_enable[8]=0;chip_enable[9]=0;chip_enable[10]=0;chip_enable[11]=0;chip_enable[12]=0;chip_enable[13]=0;chip_enable[14]=0;
        chip_enable[21]=0;chip_enable[22]=0;chip_enable[23]=0;chip_enable[24]=0;chip_enable[25]=0;chip_enable[26]=0;chip_enable[27]=0;chip_enable[28]=0;chip_enable[29]=0;chip_enable[30]=0;

        state_ctrl = 5'd30;
        ppg_addr_msb = 0;
        exp_in_1 = Emax_0 - 1;
        exp_in_2 = Emax_1 - 1;
        #20; 
        //$display("MSBtotag_1 = %b", uut.MSBtotag_1);$display("MSBtotag_2 = %b", uut.MSBtotag_2);
        state_ctrl = 5'd3; cmp_addr_1 = 0; 
        ppg_addr_msb = 0; 
        chip_enable[5]=1;chip_enable[6]=1;chip_enable[7]=1;chip_enable[8]=1;chip_enable[9]=1;chip_enable[10]=1;chip_enable[11]=1;chip_enable[12]=1;chip_enable[13]=1;chip_enable[14]=1;
        chip_enable[21]=1;chip_enable[22]=1;chip_enable[23]=1;chip_enable[24]=1;chip_enable[25]=1;chip_enable[26]=1;chip_enable[27]=1;chip_enable[28]=1;chip_enable[29]=1;chip_enable[30]=1;
        #10;chip_enable[5]=0;chip_enable[6]=0;chip_enable[7]=0;chip_enable[8]=0;chip_enable[9]=0;chip_enable[10]=0;chip_enable[11]=0;chip_enable[12]=0;chip_enable[13]=0;chip_enable[14]=0;
        chip_enable[21]=0;chip_enable[22]=0;chip_enable[23]=0;chip_enable[24]=0;chip_enable[25]=0;chip_enable[26]=0;chip_enable[27]=0;chip_enable[28]=0;chip_enable[29]=0;chip_enable[30]=0;

        state_ctrl = 5'd30;
        ppg_addr_msb = 0;
        exp_in_1 = Emax_0;
        exp_in_2 = Emax_1;
        #20; 
        //$display("MSBtotag_1 = %b", uut.MSBtotag_1); $display("MSBtotag_2 = %b", uut.MSBtotag_2);// Finally, to find Emax_0 and Emax_1, we do not need to shift to the right, but only need to modify MSBtotag

        // For the case of MSBtotag = 0, that is, the elements with too small index part are all zeroed out
        state_ctrl = 5'd1;
        SEARCH_2row = 1'b0;
        ppg_addr_msb = 0; 
        chip_enable[6]=1;chip_enable[7]=1;chip_enable[8]=1;chip_enable[9]=1;chip_enable[10]=1;chip_enable[11]=1;chip_enable[12]=1;chip_enable[13]=1;chip_enable[14]=1;chip_enable[15]=1;
        chip_enable[22]=1;chip_enable[23]=1;chip_enable[24]=1;chip_enable[25]=1;chip_enable[26]=1;chip_enable[27]=1;chip_enable[28]=1;chip_enable[29]=1;chip_enable[30]=1;chip_enable[31]=1;
        #10;chip_enable[6]=0;chip_enable[7]=0;chip_enable[8]=0;chip_enable[9]=0;chip_enable[10]=0;chip_enable[11]=0;chip_enable[12]=0;chip_enable[13]=0;chip_enable[14]=0;chip_enable[15]=0;
        chip_enable[22]=0;chip_enable[23]=0;chip_enable[24]=0;chip_enable[25]=0;chip_enable[26]=0;chip_enable[27]=0;chip_enable[28]=0;chip_enable[29]=0;chip_enable[30]=0;chip_enable[31]=0;

        //Print the image of the mantissa part
        print_mem(6);
        print_mem(7);
        print_mem(8);
        print_mem(9);
        print_mem(10);

        // Bit by bit data processing + bit by bit adder output
        cmp_addr_1 = 0;
        cmp_addr_2 = 1;
        ppg_addr_msb = 0;
        SEARCH_2row = 1'b0;
        part_sum_0 <= 0; part_sum_1 <= 0;
        state_ctrl = 5'd10; #10; // First dot product partial product calculation
        state_ctrl = 5'd20; @(posedge CLK); #1; $display("For 1st bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0; part_sum_1 <= part_sum_1 + sum_1;
        state_ctrl = 5'd21; @(posedge CLK); #1; $display("For 2nd bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/2.0; part_sum_1 <= part_sum_1 + sum_1/2.0;
        state_ctrl = 5'd22; @(posedge CLK); #1; $display("For 3rd bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/4.0; part_sum_1 <= part_sum_1 + sum_1/4.0;
        state_ctrl = 5'd23; @(posedge CLK); #1; $display("For 4th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/8.0; part_sum_1 <= part_sum_1 + sum_1/8.0;
        state_ctrl = 5'd24; @(posedge CLK); #1; $display("For 5th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/16.0; part_sum_1 <= part_sum_1 + sum_1/16.0;
        state_ctrl = 5'd25; @(posedge CLK); #1; $display("For 6th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/32.0; part_sum_1 <= part_sum_1 + sum_1/32.0;
        state_ctrl = 5'd26; @(posedge CLK); #1; $display("For 7th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/64.0; part_sum_1 <= part_sum_1 + sum_1/64.0;
        state_ctrl = 5'd27; @(posedge CLK); #1; $display("For 8th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/128.0; part_sum_1 <= part_sum_1 + sum_1/128.0;
        state_ctrl = 5'd28; @(posedge CLK); #1; $display("For 9th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/256.0; part_sum_1 <= part_sum_1 + sum_1/256.0;
        state_ctrl = 5'd29; @(posedge CLK); #1; $display("For 10th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/512.0; part_sum_1 <= part_sum_1 + sum_1/512.0;
        $display("For 1st calculate: part_sum_0 = %f, part_sum_1 = %f", part_sum_0, part_sum_1);
        final_result_0 = part_sum_0; final_result_1 = part_sum_1;
        $display("For 1st calculate: final_result_0 = %f, final_result_1 = %f", final_result_0, final_result_1);

        
        part_sum_0 <= 0; part_sum_1 <= 0;
        state_ctrl = 5'd11; #10; // The second dot product partial product is computed
        state_ctrl = 5'd20; @(posedge CLK); #1; $display("For 1st bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0; part_sum_1 <= part_sum_1 + sum_1;
        state_ctrl = 5'd21; @(posedge CLK); #1; $display("For 2nd bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/2.0; part_sum_1 <= part_sum_1 + sum_1/2.0;
        state_ctrl = 5'd22; @(posedge CLK); #1; $display("For 3rd bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/4.0; part_sum_1 <= part_sum_1 + sum_1/4.0;
        state_ctrl = 5'd23; @(posedge CLK); #1; $display("For 4th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/8.0; part_sum_1 <= part_sum_1 + sum_1/8.0;
        state_ctrl = 5'd24; @(posedge CLK); #1; $display("For 5th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/16.0; part_sum_1 <= part_sum_1 + sum_1/16.0;
        state_ctrl = 5'd25; @(posedge CLK); #1; $display("For 6th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/32.0; part_sum_1 <= part_sum_1 + sum_1/32.0;
        state_ctrl = 5'd26; @(posedge CLK); #1; $display("For 7th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/64.0; part_sum_1 <= part_sum_1 + sum_1/64.0;
        state_ctrl = 5'd27; @(posedge CLK); #1; $display("For 8th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/128.0; part_sum_1 <= part_sum_1 + sum_1/128.0;
        state_ctrl = 5'd28; @(posedge CLK); #1; $display("For 9th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/256.0; part_sum_1 <= part_sum_1 + sum_1/256.0;
        state_ctrl = 5'd29; @(posedge CLK); #1; $display("For 10th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/512.0; part_sum_1 <= part_sum_1 + sum_1/512.0;
        $display("For 2nd calculate: part_sum_0 = %f, part_sum_1 = %f", part_sum_0, part_sum_1);
        final_result_0 = final_result_0 + part_sum_0/2.0; final_result_1 = final_result_1 + part_sum_1/2.0;
        $display("For 2nd calculate: final_result_0 = %f, final_result_1 = %f", final_result_0, final_result_1);

        part_sum_0 <= 0; part_sum_1 <= 0;
        state_ctrl = 5'd12; #10; // Third dot product partial product calculation
        state_ctrl = 5'd20; @(posedge CLK); #1; $display("For 1st bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0; part_sum_1 <= part_sum_1 + sum_1;
        state_ctrl = 5'd21; @(posedge CLK); #1; $display("For 2nd bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/2.0; part_sum_1 <= part_sum_1 + sum_1/2.0;
        state_ctrl = 5'd22; @(posedge CLK); #1; $display("For 3rd bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/4.0; part_sum_1 <= part_sum_1 + sum_1/4.0;
        state_ctrl = 5'd23; @(posedge CLK); #1; $display("For 4th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/8.0; part_sum_1 <= part_sum_1 + sum_1/8.0;
        state_ctrl = 5'd24; @(posedge CLK); #1; $display("For 5th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/16.0; part_sum_1 <= part_sum_1 + sum_1/16.0;
        state_ctrl = 5'd25; @(posedge CLK); #1; $display("For 6th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/32.0; part_sum_1 <= part_sum_1 + sum_1/32.0;
        state_ctrl = 5'd26; @(posedge CLK); #1; $display("For 7th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/64.0; part_sum_1 <= part_sum_1 + sum_1/64.0;
        state_ctrl = 5'd27; @(posedge CLK); #1; $display("For 8th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/128.0; part_sum_1 <= part_sum_1 + sum_1/128.0;
        state_ctrl = 5'd28; @(posedge CLK); #1; $display("For 9th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/256.0; part_sum_1 <= part_sum_1 + sum_1/256.0;
        state_ctrl = 5'd29; @(posedge CLK); #1; $display("For 10th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/512.0; part_sum_1 <= part_sum_1 + sum_1/512.0;
        $display("For 3rd calculate: part_sum_0 = %f, part_sum_1 = %f", part_sum_0, part_sum_1);
        final_result_0 = final_result_0 + part_sum_0/4.0; final_result_1 = final_result_1 + part_sum_1/4.0;
        $display("For 3rd calculate: final_result_0 = %f, final_result_1 = %f", final_result_0, final_result_1);

        part_sum_0 <= 0; part_sum_1 <= 0;
        state_ctrl = 5'd13; #10; // The fourth dot product partial product is computed
        state_ctrl = 5'd20; @(posedge CLK); #1; $display("For 1st bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0; part_sum_1 <= part_sum_1 + sum_1;
        state_ctrl = 5'd21; @(posedge CLK); #1; $display("For 2nd bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/2.0; part_sum_1 <= part_sum_1 + sum_1/2.0;
        state_ctrl = 5'd22; @(posedge CLK); #1; $display("For 3rd bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/4.0; part_sum_1 <= part_sum_1 + sum_1/4.0;
        state_ctrl = 5'd23; @(posedge CLK); #1; $display("For 4th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/8.0; part_sum_1 <= part_sum_1 + sum_1/8.0;
        state_ctrl = 5'd24; @(posedge CLK); #1; $display("For 5th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/16.0; part_sum_1 <= part_sum_1 + sum_1/16.0;
        state_ctrl = 5'd25; @(posedge CLK); #1; $display("For 6th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/32.0; part_sum_1 <= part_sum_1 + sum_1/32.0;
        state_ctrl = 5'd26; @(posedge CLK); #1; $display("For 7th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/64.0; part_sum_1 <= part_sum_1 + sum_1/64.0;
        state_ctrl = 5'd27; @(posedge CLK); #1; $display("For 8th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/128.0; part_sum_1 <= part_sum_1 + sum_1/128.0;
        state_ctrl = 5'd28; @(posedge CLK); #1; $display("For 9th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/256.0; part_sum_1 <= part_sum_1 + sum_1/256.0;
        state_ctrl = 5'd29; @(posedge CLK); #1; $display("For 10th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/512.0; part_sum_1 <= part_sum_1 + sum_1/512.0;
        $display("For 4th calculate: part_sum_0 = %f, part_sum_1 = %f", part_sum_0, part_sum_1);
        final_result_0 = final_result_0 + part_sum_0/8.0; final_result_1 = final_result_1 + part_sum_1/8.0;
        $display("For 4th calculate: final_result_0 = %f, final_result_1 = %f", final_result_0, final_result_1);

        part_sum_0 <= 0; part_sum_1 <= 0;
        state_ctrl = 5'd14; #10; // The fifth dot product partial product is computed
        state_ctrl = 5'd20; @(posedge CLK); #1; $display("For 1st bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0; part_sum_1 <= part_sum_1 + sum_1;
        state_ctrl = 5'd21; @(posedge CLK); #1; $display("For 2nd bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/2.0; part_sum_1 <= part_sum_1 + sum_1/2.0;
        state_ctrl = 5'd22; @(posedge CLK); #1; $display("For 3rd bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/4.0; part_sum_1 <= part_sum_1 + sum_1/4.0;
        state_ctrl = 5'd23; @(posedge CLK); #1; $display("For 4th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/8.0; part_sum_1 <= part_sum_1 + sum_1/8.0;
        state_ctrl = 5'd24; @(posedge CLK); #1; $display("For 5th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/16.0; part_sum_1 <= part_sum_1 + sum_1/16.0;
        state_ctrl = 5'd25; @(posedge CLK); #1; $display("For 6th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/32.0; part_sum_1 <= part_sum_1 + sum_1/32.0;
        state_ctrl = 5'd26; @(posedge CLK); #1; $display("For 7th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/64.0; part_sum_1 <= part_sum_1 + sum_1/64.0;
        state_ctrl = 5'd27; @(posedge CLK); #1; $display("For 8th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/128.0; part_sum_1 <= part_sum_1 + sum_1/128.0;
        state_ctrl = 5'd28; @(posedge CLK); #1; $display("For 9th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/256.0; part_sum_1 <= part_sum_1 + sum_1/256.0;
        state_ctrl = 5'd29; @(posedge CLK); #1; $display("For 10th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/512.0; part_sum_1 <= part_sum_1 + sum_1/512.0;
        $display("For 5th calculate: part_sum_0 = %f, part_sum_1 = %f", part_sum_0, part_sum_1);
        final_result_0 = final_result_0 + part_sum_0/16.0; final_result_1 = final_result_1 + part_sum_1/16.0;
        $display("For 5th calculate: final_result_0 = %f, final_result_1 = %f", final_result_0, final_result_1);

        part_sum_0 <= 0; part_sum_1 <= 0;
        state_ctrl = 5'd15; #10; // Sixth dot product partial product calculation
        state_ctrl = 5'd20; @(posedge CLK); #1; $display("For 1st bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0; part_sum_1 <= part_sum_1 + sum_1;
        state_ctrl = 5'd21; @(posedge CLK); #1; $display("For 2nd bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/2.0; part_sum_1 <= part_sum_1 + sum_1/2.0;
        state_ctrl = 5'd22; @(posedge CLK); #1; $display("For 3rd bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/4.0; part_sum_1 <= part_sum_1 + sum_1/4.0;
        state_ctrl = 5'd23; @(posedge CLK); #1; $display("For 4th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/8.0; part_sum_1 <= part_sum_1 + sum_1/8.0;
        state_ctrl = 5'd24; @(posedge CLK); #1; $display("For 5th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/16.0; part_sum_1 <= part_sum_1 + sum_1/16.0;
        state_ctrl = 5'd25; @(posedge CLK); #1; $display("For 6th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/32.0; part_sum_1 <= part_sum_1 + sum_1/32.0;
        state_ctrl = 5'd26; @(posedge CLK); #1; $display("For 7th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/64.0; part_sum_1 <= part_sum_1 + sum_1/64.0;
        state_ctrl = 5'd27; @(posedge CLK); #1; $display("For 8th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/128.0; part_sum_1 <= part_sum_1 + sum_1/128.0;
        state_ctrl = 5'd28; @(posedge CLK); #1; $display("For 9th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/256.0; part_sum_1 <= part_sum_1 + sum_1/256.0;
        state_ctrl = 5'd29; @(posedge CLK); #1; $display("For 10th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/512.0; part_sum_1 <= part_sum_1 + sum_1/512.0;
        $display("For 6th calculate: part_sum_0 = %f, part_sum_1 = %f", part_sum_0, part_sum_1);
        final_result_0 = final_result_0 + part_sum_0/32.0; final_result_1 = final_result_1 + part_sum_1/32.0;
        $display("For 6th calculate: final_result_0 = %f, final_result_1 = %f", final_result_0, final_result_1);

        part_sum_0 <= 0; part_sum_1 <= 0;
        state_ctrl = 5'd16; #10; // The seventh dot product partial product is computed
        state_ctrl = 5'd20; @(posedge CLK); #1; $display("For 1st bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0; part_sum_1 <= part_sum_1 + sum_1;
        state_ctrl = 5'd21; @(posedge CLK); #1; $display("For 2nd bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/2.0; part_sum_1 <= part_sum_1 + sum_1/2.0;
        state_ctrl = 5'd22; @(posedge CLK); #1; $display("For 3rd bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/4.0; part_sum_1 <= part_sum_1 + sum_1/4.0;
        state_ctrl = 5'd23; @(posedge CLK); #1; $display("For 4th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/8.0; part_sum_1 <= part_sum_1 + sum_1/8.0;
        state_ctrl = 5'd24; @(posedge CLK); #1; $display("For 5th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/16.0; part_sum_1 <= part_sum_1 + sum_1/16.0;
        state_ctrl = 5'd25; @(posedge CLK); #1; $display("For 6th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/32.0; part_sum_1 <= part_sum_1 + sum_1/32.0;
        state_ctrl = 5'd26; @(posedge CLK); #1; $display("For 7th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/64.0; part_sum_1 <= part_sum_1 + sum_1/64.0;
        state_ctrl = 5'd27; @(posedge CLK); #1; $display("For 8th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/128.0; part_sum_1 <= part_sum_1 + sum_1/128.0;
        state_ctrl = 5'd28; @(posedge CLK); #1; $display("For 9th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/256.0; part_sum_1 <= part_sum_1 + sum_1/256.0;
        state_ctrl = 5'd29; @(posedge CLK); #1; $display("For 10th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/512.0; part_sum_1 <= part_sum_1 + sum_1/512.0;
        $display("For 7th calculate: part_sum_0 = %f, part_sum_1 = %f", part_sum_0, part_sum_1);
        final_result_0 = final_result_0 + part_sum_0/64.0; final_result_1 = final_result_1 + part_sum_1/64.0;
        $display("For 7th calculate: final_result_0 = %f, final_result_1 = %f", final_result_0, final_result_1);

        part_sum_0 <= 0; part_sum_1 <= 0;
        state_ctrl = 5'd17; #10; // The eighth dot product partial product is computed
        state_ctrl = 5'd20; @(posedge CLK); #1; $display("For 1st bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0; part_sum_1 <= part_sum_1 + sum_1;
        state_ctrl = 5'd21; @(posedge CLK); #1; $display("For 2nd bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/2.0; part_sum_1 <= part_sum_1 + sum_1/2.0;
        state_ctrl = 5'd22; @(posedge CLK); #1; $display("For 3rd bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/4.0; part_sum_1 <= part_sum_1 + sum_1/4.0;
        state_ctrl = 5'd23; @(posedge CLK); #1; $display("For 4th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/8.0; part_sum_1 <= part_sum_1 + sum_1/8.0;
        state_ctrl = 5'd24; @(posedge CLK); #1; $display("For 5th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/16.0; part_sum_1 <= part_sum_1 + sum_1/16.0;
        state_ctrl = 5'd25; @(posedge CLK); #1; $display("For 6th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/32.0; part_sum_1 <= part_sum_1 + sum_1/32.0;
        state_ctrl = 5'd26; @(posedge CLK); #1; $display("For 7th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/64.0; part_sum_1 <= part_sum_1 + sum_1/64.0;
        state_ctrl = 5'd27; @(posedge CLK); #1; $display("For 8th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/128.0; part_sum_1 <= part_sum_1 + sum_1/128.0;
        state_ctrl = 5'd28; @(posedge CLK); #1; $display("For 9th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/256.0; part_sum_1 <= part_sum_1 + sum_1/256.0;
        state_ctrl = 5'd29; @(posedge CLK); #1; $display("For 10th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/512.0; part_sum_1 <= part_sum_1 + sum_1/512.0;
        $display("For 8th calculate: part_sum_0 = %f, part_sum_1 = %f", part_sum_0, part_sum_1);
        final_result_0 = final_result_0 + part_sum_0/128.0; final_result_1 = final_result_1 + part_sum_1/128.0;
        $display("For 8th calculate: final_result_0 = %f, final_result_1 = %f", final_result_0, final_result_1);

        part_sum_0 <= 0; part_sum_1 <= 0;
        state_ctrl = 5'd18; #10; // Ninth dot product partial product calculation
        state_ctrl = 5'd20; @(posedge CLK); #1; $display("For 1st bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0; part_sum_1 <= part_sum_1 + sum_1;
        state_ctrl = 5'd21; @(posedge CLK); #1; $display("For 2nd bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/2.0; part_sum_1 <= part_sum_1 + sum_1/2.0;
        state_ctrl = 5'd22; @(posedge CLK); #1; $display("For 3rd bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/4.0; part_sum_1 <= part_sum_1 + sum_1/4.0;
        state_ctrl = 5'd23; @(posedge CLK); #1; $display("For 4th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/8.0; part_sum_1 <= part_sum_1 + sum_1/8.0;
        state_ctrl = 5'd24; @(posedge CLK); #1; $display("For 5th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/16.0; part_sum_1 <= part_sum_1 + sum_1/16.0;
        state_ctrl = 5'd25; @(posedge CLK); #1; $display("For 6th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/32.0; part_sum_1 <= part_sum_1 + sum_1/32.0;
        state_ctrl = 5'd26; @(posedge CLK); #1; $display("For 7th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/64.0; part_sum_1 <= part_sum_1 + sum_1/64.0;
        state_ctrl = 5'd27; @(posedge CLK); #1; $display("For 8th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/128.0; part_sum_1 <= part_sum_1 + sum_1/128.0;
        state_ctrl = 5'd28; @(posedge CLK); #1; $display("For 9th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/256.0; part_sum_1 <= part_sum_1 + sum_1/256.0;
        state_ctrl = 5'd29; @(posedge CLK); #1; $display("For 10th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/512.0; part_sum_1 <= part_sum_1 + sum_1/512.0;
        $display("For 9th calculate: part_sum_0 = %f, part_sum_1 = %f", part_sum_0, part_sum_1);
        final_result_0 = final_result_0 + part_sum_0/256.0; final_result_1 = final_result_1 + part_sum_1/256.0;
        $display("For 9th calculate: final_result_0 = %f, final_result_1 = %f", final_result_0, final_result_1);

        part_sum_0 <= 0; part_sum_1 <= 0;
        state_ctrl = 5'd19; #10; // Tenth dot product partial product calculation
        state_ctrl = 5'd20; @(posedge CLK); #1; $display("For 1st bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0; part_sum_1 <= part_sum_1 + sum_1;
        state_ctrl = 5'd21; @(posedge CLK); #1; $display("For 2nd bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/2.0; part_sum_1 <= part_sum_1 + sum_1/2.0;
        state_ctrl = 5'd22; @(posedge CLK); #1; $display("For 3rd bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/4.0; part_sum_1 <= part_sum_1 + sum_1/4.0;
        state_ctrl = 5'd23; @(posedge CLK); #1; $display("For 4th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/8.0; part_sum_1 <= part_sum_1 + sum_1/8.0;
        state_ctrl = 5'd24; @(posedge CLK); #1; $display("For 5th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/16.0; part_sum_1 <= part_sum_1 + sum_1/16.0;
        state_ctrl = 5'd25; @(posedge CLK); #1; $display("For 6th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/32.0; part_sum_1 <= part_sum_1 + sum_1/32.0;
        state_ctrl = 5'd26; @(posedge CLK); #1; $display("For 7th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/64.0; part_sum_1 <= part_sum_1 + sum_1/64.0;
        state_ctrl = 5'd27; @(posedge CLK); #1; $display("For 8th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/128.0; part_sum_1 <= part_sum_1 + sum_1/128.0;
        state_ctrl = 5'd28; @(posedge CLK); #1; $display("For 9th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/256.0; part_sum_1 <= part_sum_1 + sum_1/256.0;
        state_ctrl = 5'd29; @(posedge CLK); #1; $display("For 10th bit: sum0 = %d, sum1 = %d", sum_0, sum_1); part_sum_0 <= part_sum_0 + sum_0/512.0; part_sum_1 <= part_sum_1 + sum_1/512.0;
        $display("For 10th calculate: part_sum_0 = %f, part_sum_1 = %f", part_sum_0, part_sum_1);
        final_result_0 = final_result_0 + part_sum_0/512.0; final_result_1 = final_result_1 + part_sum_1/512.0;
        $display("For 10th calculate: final_result_0 = %f, final_result_1 = %f", final_result_0, final_result_1);

        $display("Considering the exp: final_result_0 = %f, final_result_1 = %f", final_result_0 * (1 << Emax_0), final_result_1 * (1 << Emax_1));
         if (abs(input_0 - (final_result_0 * (1 << Emax_0))) / input_0 < 0.05 && abs(input_1 - (final_result_1 * (1 << Emax_1))) / input_1 < 0.05) 
            $display("The result is CORRECT!");
        else 
            $display("The result is INCORRECT!");

        //print_mem_exp_max(1);
        //print_mem(2);
        //print_mem(3);
        //print_mem(4);
        //print_mem(5);
        
        // End simulation
        $finish;
    end

    // A function that calculates absolute values
    function [31:0] abs;
        input [31:0] value;
        begin
            if (value[31] == 1)  
                abs = -value;  
            else
                abs = value;  
        end
    endfunction


    task print_mem; // Print a subarray of size 36x32
        input integer mem_idx;
        integer i, j;
        begin
            $display("\n------ Memory %0d (36x32) ------", mem_idx);
            for (i = 0; i < 36; i = i + 1) begin
                $write("[%2d] ", i);
                for (j = 31; j >= 0; j = j - 1) begin
                    case (mem_idx)
                        0 : $write("%b ", uut.mem0[i][j]);
                        2 : $write("%b ", uut.mem2[i][j]);
                        3 : $write("%b ", uut.mem3[i][j]);
                        4 : $write("%b ", uut.mem4[i][j]);
                        5 : $write("%b ", uut.mem5[i][j]);
                        6 : $write("%b ", uut.mem6[i][j]);
                        7 : $write("%b ", uut.mem7[i][j]);
                        8 : $write("%b ", uut.mem8[i][j]);
                        9 : $write("%b ", uut.mem9[i][j]);
                        10: $write("%b ", uut.mem10[i][j]);
                        11: $write("%b ", uut.mem11[i][j]);
                        12: $write("%b ", uut.mem12[i][j]);
                        13: $write("%b ", uut.mem13[i][j]);
                        14: $write("%b ", uut.mem14[i][j]);
                        15: $write("%b ", uut.mem15[i][j]);
                        16: $write("%b ", uut.mem16[i][j]);
                        18: $write("%b ", uut.mem18[i][j]);
                        19: $write("%b ", uut.mem19[i][j]);
                        20: $write("%b ", uut.mem20[i][j]);
                        21: $write("%b ", uut.mem21[i][j]);
                        22: $write("%b ", uut.mem22[i][j]);
                        23: $write("%b ", uut.mem23[i][j]);
                        24: $write("%b ", uut.mem24[i][j]);
                        25: $write("%b ", uut.mem25[i][j]);
                        26: $write("%b ", uut.mem26[i][j]);
                        27: $write("%b ", uut.mem27[i][j]);
                        28: $write("%b ", uut.mem28[i][j]);
                        29: $write("%b ", uut.mem29[i][j]);
                        30: $write("%b ", uut.mem30[i][j]);
                        31: $write("%b ", uut.mem31[i][j]);
                        default: $write("X "); // Illegal number
                    endcase
                end
                $display();
            end
            $display("-------------------------------\n");
        end
    endtask


    task print_mem_exp_max; // Print a subarray of size 40x32
        input integer mem_idx;
        integer i, j;
        begin
            $display("\n------ Memory %0d (40x32) ------", mem_idx);
            for (i = 0; i < 40; i = i + 1) begin
                $write("[%2d] ", i);
                for (j = 31; j >= 0; j = j - 1) begin
                    case (mem_idx)
                        1 : $write("%b ", uut.mem1[i][j]);  
                        17: $write("%b ", uut.mem17[i][j]);
                        default: $write("X "); // Illegal number
                    endcase
                end
                $display();
            end
            $display("-------------------------------\n");
        end
    endtask


    task clear_mem; // Initialize a subarray of size 36x32
        input integer mem_idx;
        integer i, j;
        begin
            for (i = 0; i < 36; i = i + 1) begin
                for (j = 31; j >= 0; j = j - 1) begin
                    case (mem_idx)
                        0: uut.mem0[i][j]  <= 0;
                        2: uut.mem2[i][j]  <= 0;
                        3: uut.mem3[i][j]  <= 0;
                        4: uut.mem4[i][j]  <= 0;
                        5: uut.mem5[i][j]  <= 0;
                        6: uut.mem6[i][j]  <= 0;
                        7: uut.mem7[i][j]  <= 0;
                        8: uut.mem8[i][j]  <= 0;
                        9: uut.mem9[i][j]  <= 0;
                        10: uut.mem10[i][j] <= 0;
                        11: uut.mem11[i][j] <= 0;
                        12: uut.mem12[i][j] <= 0;
                        13: uut.mem13[i][j] <= 0;
                        14: uut.mem14[i][j] <= 0;
                        15: uut.mem15[i][j] <= 0;
                        16: uut.mem16[i][j] <= 0;
                        18: uut.mem18[i][j] <= 0;
                        19: uut.mem19[i][j] <= 0;
                        20: uut.mem20[i][j] <= 0;
                        21: uut.mem21[i][j] <= 0;
                        22: uut.mem22[i][j] <= 0;
                        23: uut.mem23[i][j] <= 0;
                        24: uut.mem24[i][j] <= 0;
                        25: uut.mem25[i][j] <= 0;
                        26: uut.mem26[i][j] <= 0;
                        27: uut.mem27[i][j] <= 0;
                        28: uut.mem28[i][j] <= 0;
                        29: uut.mem29[i][j] <= 0;
                        30: uut.mem30[i][j] <= 0;
                        31: uut.mem31[i][j] <= 0;
                        default: ;
                    endcase
                end
            end
        end
    endtask

    task clear_mem_exp_max; // Initialize a subarray of size 40x32
        input integer mem_idx;
        integer i, j;
        begin
            for (i = 0; i < 40; i = i + 1) begin
                for (j = 31; j >= 0; j = j - 1) begin
                    case (mem_idx)
                        1: uut.mem1[i][j]  <= 0;
                        17: uut.mem17[i][j]  <= 0;                        
                        default: ;
                    endcase
                end
            end
        end
    endtask
endmodule