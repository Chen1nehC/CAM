`timescale 1ns / 1ps

module CAM_Subarray_Exp_TB;

    reg  [15:0] data_in;
    reg         update_signal;
    reg  [9:0]  cmp_addr;
    reg  [3:0]  ppg_addr;
    reg  [1:0]  cmp_data;
    reg  [1:0]  ppg_data;
    reg  [15:0] tag_in;
    wire [15:0] tag_out;
    reg         addr_select;
    reg  [2:0]  operation_mode;
    reg         chip_enable;
    reg         acc_en;
    reg         CLK;
    reg         rst;
    reg         write_done;

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
        .CLK(CLK),
        .rst(rst),          
        .write_done(write_done)
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
        // **波形文件**
        $fsdbDumpfile("CAM_Subarray_Exp.fsdb");
        $fsdbDumpvars(0, CAM_Subarray_Exp_TB);

        // 初始化信号
        CLK = 0;
        rst = 0;
        chip_enable = 1;
        acc_en = 0;
        data_in = 16'b1111_1111_1111_1111;
        update_signal = 1;
        tag_in = 16'b1010_1010_1010_1010;
        cmp_addr = 10'b00001_00000;
        ppg_addr = 4'b0100;
        cmp_data = 2'b01;
        ppg_data = 2'b10;
        

        // 通过任务 (task) 初始化 mem
        initialize_mem();

        // **复位**
        #20 rst = 1;  // 解除复位

        // data_in 直接写入
        addr_select = 1;
        operation_mode = 3'b000;
        #20 print_mem();

        // update_signal 控制写入 (结合 tag_in 作为掩码)
        addr_select = 0;
        operation_mode = 3'b001;
        #20 print_mem();

        // 先进行一次普通搜索，存入 tag_out
        acc_en = 1;  // 使能 acc_en
        operation_mode = 3'b010; // cmp_addr[4:0] 进行 search
        cmp_addr = 10'b00001_00000;
        cmp_data = 2'b01;
        #20; // 等待一个时钟周期
        $display("First tag_out: %b", tag_out);

        // 再进行第二次搜索，应该和前一次结果做 OR
        operation_mode = 3'b010; // cmp_addr[4:0] 进行 search
        cmp_addr = 10'b00001_00000;
        cmp_data = 2'b00;
        #20; // 等待一个时钟周期
        $display("Second tag_out: %b", tag_out);

        $finish;
    end

endmodule
