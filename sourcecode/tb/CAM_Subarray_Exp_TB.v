`timescale 1ns / 1ps

module CAM_Subarray_Exp_TB;

    reg  [31:0] data_in;
    reg         update_signal;
    reg  [9:0]  cmp_addr;
    reg  [5:0]  ppg_addr;
    reg  [1:0]  cmp_data;
    reg  [1:0]  ppg_data;
    reg  [31:0] tag_in;
    wire [31:0] tag_out;
    reg         addr_select;
    reg  [2:0]  operation_mode;
    reg         chip_enable;
    reg         acc_en;
    reg         CLK;

    // 实例化被测试模块
    CAM_Subarray_Exp uut (
        .data_in(data_in),
        .update_signal(update_signal),
        .cmp_addr(cmp_addr),
        .ppg_addr(ppg_addr),
        .cmp_data(cmp_data),
        .ppg_data(ppg_data),
        .tag_in(tag_in),
        .tag_out(tag_out),
        .addr_select(addr_select),
        .operation_mode(operation_mode),
        .chip_enable(chip_enable),
        .acc_en(acc_en),
        .CLK(CLK)
    );

    // 时钟信号产生
    always #5 CLK = ~CLK;

    // 观察 mem 的 40x32 结构，注意这张表水平方向上左边为低位，右边为高位，和tag_out正好相反易混淆
    task print_mem;
    integer i, j;
    begin
        $display("\n------ Memory Dump (40x32) ------");
        for (i = 0; i < 40; i = i + 1) begin
            $write("[%2d] ", i);
            for (j = 31; j >= 0; j = j - 1)  // 这里改为从 31 递减到 0
                $write("%b ", uut.mem[i * 32 + j]);
            $display();
        end
        $display("-------------------------------\n");
    end
endtask


    // 任务：初始化 mem 为 0
    task initialize_mem;
        integer i;
        for (i = 0; i < 1280; i = i + 1) begin
            uut.mem[i] = 0;
        end
        $display("Memory initialized to zero.");
    endtask


    initial begin
        // 初始化信号
        CLK = 0;
        chip_enable = 1;
        acc_en = 0;
        data_in = 32'b1111_1111_1111_1111_1111_1111_1111_1111;
        update_signal = 1;
        tag_in = 32'b1010_1010_1010_1010_1010_1010_1010_1010;
        cmp_addr = 10'b00001_00000;
        ppg_addr = 6'b101_100;
        cmp_data = 2'b0_1;
        ppg_data = 2'b1_0;
        

        // 通过任务 (task) 初始化 mem
        initialize_mem();

        // 测试 000 - data_in 直接写入
        addr_select = 1;
        operation_mode = 3'b000;
        #10 print_mem();

        // 测试 001 - update_signal 控制写入 (结合 tag_in 作为掩码)
        addr_select = 0;
        operation_mode = 3'b001;
        #10 print_mem();

        // 测试 010 - cmp_addr[4:0] 进行 search
        operation_mode = 3'b010;
        #10 $display("Tag Out: %b", tag_out);

        // 测试 011 - ppg_addr[2:0] 进行 search
        operation_mode = 3'b011;
        #10 $display("Tag Out: %b", tag_out);

        // 测试 100 - cmp_addr[4:0] 和 cmp_addr[9:5] 进行 search
        operation_mode = 3'b100;
        #10 $display("Tag Out: %b", tag_out);

        // 测试 101 - ppg_addr[2:0] 和 ppg_addr[5:3] 进行 search
        operation_mode = 3'b101;
        #10 $display("Tag Out: %b", tag_out);

        // 测试 110 - cmp_addr[4:0] 和 ppg_addr[2:0] 进行 search
        operation_mode = 3'b110;
        #10 $display("Tag Out: %b", tag_out);

        $finish;
    end

endmodule
