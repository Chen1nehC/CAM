`timescale 1ns / 1ps

module tb_CAM_Top;

    // 信号定义
    reg rst_n;
    reg CLK;
    reg [31:0] data_in;
    reg signal_in;
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
    reg vref;
    reg sampled;
    reg preb;
    reg diff;
    reg acc_en;
    reg [31:0] chip_enable;
    reg SEARCH_2row;
    wire [5:0] sum_0;
    wire [5:0] sum_1;
    
    reg [4:0] Emax_0;
    reg [4:0] Emax_1;
    real part_sum_0;
    real part_sum_1;
    real final_result_0;
    real final_result_1;

    // 实例化CAM_Top模块
    CAM_Top uut (
        .rst_n(rst_n),
        .CLK(CLK),
        .data_in(data_in),
        .signal_in(signal_in),
        .cmp_addr_1(cmp_addr_1),
        .cmp_addr_2(cmp_addr_2),
        .ppg_addr_1(ppg_addr_1),
        .ppg_addr_2(ppg_addr_2),
        .cmp_data_1(cmp_data_1),
        .cmp_data_2(cmp_data_2),
        .ppg_data_1(ppg_data_1),
        .ppg_data_2(ppg_data_2),
        .exp_in_1(exp_in_1),
        .exp_in_2(exp_in_2),
        .state_ctrl(state_ctrl),
        .vref(vref),
        .sampled(sampled),
        .preb(preb),
        .diff(diff),
        .acc_en(acc_en),
        .chip_enable(chip_enable),
        .SEARCH_2row(SEARCH_2row),
        .sum_0(sum_0),
        .sum_1(sum_1)
    );

    // 时钟生成
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;  // 100MHz 时钟周期
    end

    // 仿真过程
    initial begin
        // **波形文件**
        $fsdbDumpfile("CAM_Top.fsdb");
        $fsdbDumpvars(0, tb_CAM_Top);

        // 初始化信号
        rst_n = 0; data_in = 32'b0; signal_in = 0;
        cmp_addr_1 = 5'b0; cmp_addr_2 = 5'b0; ppg_addr_1 = 2'b0; ppg_addr_2 = 2'b0;
        cmp_data_1 = 0; cmp_data_2 = 0; ppg_data_1 = 0; ppg_data_2 = 0; exp_in_1 = 8'b0; exp_in_2 = 8'b0; 
        state_ctrl = 5'b0;
        vref = 0; sampled = 0; preb = 0; diff = 0;     
        acc_en = 0;
        chip_enable = 32'b0;  // 默认不使能
        SEARCH_2row = 0;
        
        // 复位
        #10 rst_n = 1;

        //mem全部清零
        clear_mem(0); clear_mem_exp_max(1);
        clear_mem(2); clear_mem(3); clear_mem(4); clear_mem(5); clear_mem(6); clear_mem(7); clear_mem(8); clear_mem(9); clear_mem(10); clear_mem(11); clear_mem(12); clear_mem(13); clear_mem(14); clear_mem(15);
        clear_mem(16); clear_mem_exp_max(17);
        clear_mem(18); clear_mem(19); clear_mem(20); clear_mem(21); clear_mem(22); clear_mem(23);clear_mem(24); clear_mem(25); clear_mem(26); clear_mem(27); clear_mem(28); clear_mem(29); clear_mem(30); clear_mem(31);

        /* Example:
        Input1[0]:  0_00011_11000_00000 (1.5  X 2^3 = 12.0)
        Input1[1]:  0_00011_10100_00000 (1.25 X 2^3 = 10.0)
        Input1[2]:  0_00001_11000_00000 (1.5  X 2^1 =  3.0)
        Input1[3]:  0_00010_11000_00000 (1.5  X 2^2 =  6.0)

        Input2[0]:  0_00011_10100_00000 (1.25 X 2^3 = 10.0)
        Input2[1]:  0_00011_10010_00000 (1.125 X 2^3 = 9.0)
        Input2[2]:  0_00000_11000_00000 (1.5  X 2^0 =  1.5)
        Input2[3]:  0_00011_10000_00000 (1.0  X 2^3 =  8.0)
        */

        // 状态0:写入数据从 mem4[cmp_addr_1] 到 mem9[cmp_addr_1]
        // 设置条件：Ttag=0, FB=0, acc=0, Lshift=0, Rshift=0, Ftag=0, we=1
        cmp_addr_1 = 5'd0;  // 写入第0行，即第一个向量
        state_ctrl = 5'd0;

        chip_enable[4] = 1; // mem4写入的向量1
        data_in = 32'b1101_0000_0000_0000_0000_0000_0000_0000;  
        #1000;
        chip_enable[4] = 0;
        chip_enable[5] = 1; // mem5写入的向量1
        data_in = 32'b1110_0000_0000_0000_0000_0000_0000_0000;  
        #1000;
        chip_enable[5] = 0;
        chip_enable[6] = 1; // mem6写入的向量1
        data_in = 32'b1111_0000_0000_0000_0000_0000_0000_0000;  
        #1000;
        chip_enable[6] = 0;
        chip_enable[7] = 1; // mem7写入的向量1
        data_in = 32'b1011_0000_0000_0000_0000_0000_0000_0000;  
        #1000;
        chip_enable[7] = 0;
        chip_enable[8] = 1; // mem8写入的向量1
        data_in = 32'b0100_0000_0000_0000_0000_0000_0000_0000;  
        #1000;
        chip_enable[8] = 0;

        cmp_addr_1 = 5'd1;  // 写入第1行，即第二个向量
        state_ctrl = 5'd0;

        chip_enable[4] = 1; // mem4写入的向量2
        data_in = 32'b1101_0000_0000_0000_0000_0000_0000_0000;  
        #1000;
        chip_enable[4] = 0;
        chip_enable[5] = 1; // mem5写入的向量2
        data_in = 32'b1101_0000_0000_0000_0000_0000_0000_0000;  
        #1000;
        chip_enable[5] = 0;
        chip_enable[6] = 1; // mem6写入的向量2
        data_in = 32'b1111_0000_0000_0000_0000_0000_0000_0000;  
        #1000;
        chip_enable[6] = 0;
        chip_enable[7] = 1; // mem7写入的向量2
        data_in = 32'b0010_0000_0000_0000_0000_0000_0000_0000;  
        #1000;
        chip_enable[7] = 0;
        chip_enable[8] = 1; // mem8写入的向量2
        data_in = 32'b1000_0000_0000_0000_0000_0000_0000_0000;  
        #1000;
        chip_enable[8] = 0;
        chip_enable[9] = 1; // mem9写入的向量2
        data_in = 32'b0100_0000_0000_0000_0000_0000_0000_0000;  
        #1000;
        chip_enable[9] = 0;


        // 状态1:FB_search_and_update_block，先针对指数部分 mem1 到 mem5 测试S的搜索更新，S存储在meta data第一行
        // 设置条件：Ttag=0, FB=1, acc=0, Lshift=0, Rshift=0, Ftag=0, we=0
        SEARCH_2row = 1; //搜索1_0
        state_ctrl = 5'd1; cmp_addr_1 = 5'd0; cmp_addr_2 = 5'd1; cmp_data_1 = 1; cmp_data_2 = 0;
        chip_enable[1] = 1; chip_enable[2] = 1; chip_enable[3] = 1; chip_enable[4] = 1; chip_enable[5] = 1; #1000;
        chip_enable[1] = 0; chip_enable[2] = 0; chip_enable[3] = 0; chip_enable[4] = 0; chip_enable[5] = 0;
        
        SEARCH_2row = 1; //搜索0_1
        state_ctrl = 5'd1; cmp_addr_1 = 5'd0; cmp_addr_2 = 5'd1; cmp_data_1 = 0; cmp_data_2 = 1;
        chip_enable[1] = 1; chip_enable[2] = 1; chip_enable[3] = 1; chip_enable[4] = 1; chip_enable[5] = 1; #1000;
        chip_enable[1] = 0; chip_enable[2] = 0; chip_enable[3] = 0; chip_enable[4] = 0; chip_enable[5] = 0;
        
        // 状态2:L_search_and_update_block，先针对指数部分 mem1 到 mem5 测试 C 的搜索更新，C存储在meta data第二行
        // 设置条件：Ttag=0, FB=0, acc=0, Lshift=1, Rshift=0, Ftag=0, we=0
        SEARCH_2row = 1;
        state_ctrl = 5'd2; cmp_addr_1 = 5'd0; cmp_addr_2 = 5'd1; cmp_data_1 = 1; cmp_data_2 = 1;
        chip_enable[1] = 1; chip_enable[2] = 1; chip_enable[3] = 1; chip_enable[4] = 1; chip_enable[5] = 1; #1000;
        chip_enable[1] = 0; chip_enable[2] = 0; chip_enable[3] = 0; chip_enable[4] = 0; chip_enable[5] = 0;

        // 状态1 + 状态2，指数部分 mem1 到 mem5 串行修改C和S，得到Esum，Esum存储在meta data第三行
        // 对于每一位都要搜索1_0, 0_1, 1_1，以此来更新meta data中的C和S
        cmp_addr_1 = 5'd0;  cmp_addr_2 = 5'd0;
         
        state_ctrl = 5'd1; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 1; ppg_data_2 = 0; chip_enable[5] = 1;#1000;chip_enable[5] = 0;
        state_ctrl = 5'd1; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 0; ppg_data_2 = 1; chip_enable[5] = 1;#1000;chip_enable[5] = 0;
        state_ctrl = 5'd2; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 1; ppg_data_2 = 1; chip_enable[5] = 1;#1000;chip_enable[5] = 0;

        state_ctrl = 5'd1; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 1; ppg_data_2 = 0; chip_enable[4] = 1;#1000;chip_enable[4] = 0;
        state_ctrl = 5'd1; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 0; ppg_data_2 = 1; chip_enable[4] = 1;#1000;chip_enable[4] = 0;
        state_ctrl = 5'd2; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 1; ppg_data_2 = 1; chip_enable[4] = 1;#1000;chip_enable[4] = 0;
        
        state_ctrl = 5'd1; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 1; ppg_data_2 = 0; chip_enable[3] = 1;#1000;chip_enable[3] = 0;
        state_ctrl = 5'd1; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 0; ppg_data_2 = 1; chip_enable[3] = 1;#1000;chip_enable[3] = 0;
        state_ctrl = 5'd2; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 1; ppg_data_2 = 1; chip_enable[3] = 1;#1000;chip_enable[3] = 0;

        state_ctrl = 5'd1; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 1; ppg_data_2 = 0; chip_enable[4] = 1;#1000;chip_enable[2] = 0;
        state_ctrl = 5'd1; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 0; ppg_data_2 = 1; chip_enable[4] = 1;#1000;chip_enable[2] = 0;
        state_ctrl = 5'd2; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 1; ppg_data_2 = 1; chip_enable[4] = 1;#1000;chip_enable[2] = 0;
        
        state_ctrl = 5'd1; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 1; ppg_data_2 = 0; chip_enable[4] = 1;#1000;chip_enable[1] = 0;
        state_ctrl = 5'd1; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 0; ppg_data_2 = 1; chip_enable[4] = 1;#1000;chip_enable[1] = 0;
        state_ctrl = 5'd2; ppg_addr_1 = 5'd0; ppg_addr_2 = 5'd1; ppg_data_1 = 1; ppg_data_2 = 1; chip_enable[4] = 1;#1000;chip_enable[1] = 0;

        // 状态4到状态8，搬运每一位的Esum到最高指数位
        state_ctrl = 5'd8;#1000;
        state_ctrl = 5'd7;#1000;
        state_ctrl = 5'd6;#1000;
        state_ctrl = 5'd5;#1000;
        state_ctrl = 5'd4;#1000;

        // 状态9，要逐位输出到加法器来找最大指数值
        state_ctrl = 5'd9;
        ppg_addr_1 = 0; @(posedge CLK); #1; $display("sum0 = %d, sum1 = %d", sum_0, sum_1);
        ppg_addr_1 = 1; @(posedge CLK); #1; $display("sum0 = %d, sum1 = %d", sum_0, sum_1);
        ppg_addr_1 = 2; @(posedge CLK); #1; $display("sum0 = %d, sum1 = %d", sum_0, sum_1);
        ppg_addr_1 = 3; @(posedge CLK); #1; $display("sum0 = %d, sum1 = %d", sum_0, sum_1);
        ppg_addr_1 = 4; @(posedge CLK); #1; $display("sum0 = %d, sum1 = %d", sum_0, sum_1);

        // 假设现在找到最大值Emax，接下来逐个搜索 Emax - m + i，对尾数1进行右移操作，状态 30 和 3 交替进行
        Emax_0 = 8'b00000110;
        Emax_1 = 8'b00000000;
        state_ctrl = 5'd30;
        exp_in_1 = Emax_0 - 4;
        exp_in_2 = Emax_1 - 4;
        #1000; $display("MSBtotag = %b", uut.MSBtotag_1);
        state_ctrl = 5'd3; cmp_addr_1 = 0; 
        chip_enable[5]=1;chip_enable[6]=1;chip_enable[7]=1;chip_enable[8]=1;chip_enable[9]=1;chip_enable[10]=1;chip_enable[11]=1;chip_enable[12]=1;chip_enable[13]=1;chip_enable[14]=1;
        #10;chip_enable[5]=0;chip_enable[6]=0;chip_enable[7]=0;chip_enable[8]=0;chip_enable[9]=0;chip_enable[10]=0;chip_enable[11]=0;chip_enable[12]=0;chip_enable[13]=0;chip_enable[14]=0;

        state_ctrl = 5'd30;
        exp_in_1 = Emax_0 - 3;
        exp_in_2 = Emax_1 - 3;
        #1000; $display("MSBtotag = %b", uut.MSBtotag_1);
        state_ctrl = 5'd3; cmp_addr_1 = 0; 
        chip_enable[5]=1;chip_enable[6]=1;chip_enable[7]=1;chip_enable[8]=1;chip_enable[9]=1;chip_enable[10]=1;chip_enable[11]=1;chip_enable[12]=1;chip_enable[13]=1;chip_enable[14]=1;
        #10;chip_enable[5]=0;chip_enable[6]=0;chip_enable[7]=0;chip_enable[8]=0;chip_enable[9]=0;chip_enable[10]=0;chip_enable[11]=0;chip_enable[12]=0;chip_enable[13]=0;chip_enable[14]=0;

        state_ctrl = 5'd30;
        exp_in_1 = Emax_0 - 2;
        exp_in_2 = Emax_1 - 2;
        #1000; $display("MSBtotag = %b", uut.MSBtotag_1);
        state_ctrl = 5'd3; cmp_addr_1 = 0; 
        chip_enable[5]=1;chip_enable[6]=1;chip_enable[7]=1;chip_enable[8]=1;chip_enable[9]=1;chip_enable[10]=1;chip_enable[11]=1;chip_enable[12]=1;chip_enable[13]=1;chip_enable[14]=1;
        #10;chip_enable[5]=0;chip_enable[6]=0;chip_enable[7]=0;chip_enable[8]=0;chip_enable[9]=0;chip_enable[10]=0;chip_enable[11]=0;chip_enable[12]=0;chip_enable[13]=0;chip_enable[14]=0;

        state_ctrl = 5'd30;
        exp_in_1 = Emax_0 - 1;
        exp_in_2 = Emax_1 - 1;
        #1000; $display("MSBtotag = %b", uut.MSBtotag_1);
        state_ctrl = 5'd3; cmp_addr_1 = 0; 
        chip_enable[5]=1;chip_enable[6]=1;chip_enable[7]=1;chip_enable[8]=1;chip_enable[9]=1;chip_enable[10]=1;chip_enable[11]=1;chip_enable[12]=1;chip_enable[13]=1;chip_enable[14]=1;
        #10;chip_enable[5]=0;chip_enable[6]=0;chip_enable[7]=0;chip_enable[8]=0;chip_enable[9]=0;chip_enable[10]=0;chip_enable[11]=0;chip_enable[12]=0;chip_enable[13]=0;chip_enable[14]=0;

        state_ctrl = 5'd30;
        exp_in_1 = Emax_0;
        exp_in_2 = Emax_1;
        #1000; $display("MSBtotag = %b", uut.MSBtotag_1); // 最后找 Emax_0 和 Emax_1 不需要右移，只需要修改 MSBtotag

        // 对于MSBtotag = 0 的情况，即指数部分太小的元素要全部清零
        state_ctrl = 5'd1;
        SEARCH_2row = 1'b0;
        chip_enable[6]=1;chip_enable[7]=1;chip_enable[8]=1;chip_enable[9]=1;chip_enable[10]=1;chip_enable[11]=1;chip_enable[12]=1;chip_enable[13]=1;chip_enable[14]=1;chip_enable[15]=1;
        #10;chip_enable[6]=0;chip_enable[7]=0;chip_enable[8]=0;chip_enable[9]=0;chip_enable[10]=0;chip_enable[11]=0;chip_enable[12]=0;chip_enable[13]=0;chip_enable[14]=0;chip_enable[15]=0;

        // 打印尾数部分的图像
        print_mem(6);
        print_mem(7);
        print_mem(8);
        print_mem(9);
        print_mem(10);

        // 逐位数据处理 + 逐位加法器输出
        cmp_addr_1 = 0;
        cmp_addr_2 = 1;
        SEARCH_2row = 1'b0;
        part_sum_0 <= 0; part_sum_1 <= 0;
        state_ctrl = 5'd10; #1000; // 第一次点积部分积计算
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
        state_ctrl = 5'd11; #1000; // 第二次点积部分积计算
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
        state_ctrl = 5'd12; #1000; // 第三次点积部分积计算
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
        state_ctrl = 5'd13; #1000; // 第四次点积部分积计算
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
        state_ctrl = 5'd14; #1000; // 第五次点积部分积计算
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
        state_ctrl = 5'd15; #1000; // 第六次点积部分积计算
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
        state_ctrl = 5'd16; #1000; // 第七次点积部分积计算
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
        state_ctrl = 5'd17; #1000; // 第八次点积部分积计算
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
        state_ctrl = 5'd18; #1000; // 第九次点积部分积计算
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
        state_ctrl = 5'd19; #1000; // 第十次点积部分积计算
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
        //print_mem_exp_max(1);
        //print_mem(2);
        //print_mem(3);
        //print_mem(4);
        //print_mem(5);
        
        // 结束仿真
        #20;
        $finish;
    end

    task print_mem; //打印大小为36x32的subarray
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
                        default: $write("X "); // 非法编号
                    endcase
                end
                $display();
            end
            $display("-------------------------------\n");
        end
    endtask


    task print_mem_exp_max; //打印大小为40x32的subarray
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
                        default: $write("X "); // 非法编号
                    endcase
                end
                $display();
            end
            $display("-------------------------------\n");
        end
    endtask


    task clear_mem; //初始化大小为36x32的subarray
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

    task clear_mem_exp_max; //初始化大小为40x32的subarray
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
