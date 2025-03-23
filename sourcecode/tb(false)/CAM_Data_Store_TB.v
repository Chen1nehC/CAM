`timescale 1ns / 1ps

module CAM_Data_Store_TB;

    // 输入信号
    reg rst;
    reg CLK;
    reg [9:5] cmp_addr_high;
    reg [15:0] data_in;
    reg [3:0] num_vectors;
    reg write_ack;

    // 输出信号
    wire [15:0] chip_enable;
    wire [9:0] cmp_addr_reg;
    wire done;
    wire done_all;

    // 实例化
    CAM_Data_Store uut (
        .rst(rst),
        .CLK(CLK),
        .cmp_addr_high(cmp_addr_high),
        .data_in(data_in),
        .num_vectors(num_vectors),
        .write_ack(write_ack),
        .chip_enable(chip_enable),
        .cmp_addr_reg(cmp_addr_reg),
        .done(done),
        .done_all(done_all)
    );

    // 生成时钟
    always #5 CLK = ~CLK; // 10ns 时钟周期

    initial begin
        // **波形文件**
        $fsdbDumpfile("CAM_Data_Store.fsdb");
        $fsdbDumpvars(0, CAM_Data_Store_TB);

        // 初始化
        CLK = 0;
        rst = 0;
        data_in = 16'b0;
        #10;
        cmp_addr_high = 5'b00001; // 任意高位地址
        num_vectors = 4'd2;
        write_ack = 0;



        // 开始写入第一个向量
        @(posedge CLK);
        data_in = 16'b1110_0010_0110_1111;

        rst = 1; // 拉高，复位完成
        #60;

        // 模拟 16 个子模块的写入和应答
        repeat (16) begin
            @(posedge CLK);
            write_ack = 1; // 模拟子模块写入完成
            @(posedge CLK);
            write_ack = 0; // 拉低，等待下一个
            #30;
        end


        // 写入第二个向量
        @(posedge CLK);
        data_in = 16'b1111_1000_1001_1011;

        #30;

        repeat (16) begin
            @(posedge CLK);
            write_ack = 1;
            @(posedge CLK);
            write_ack = 0;
            #30;
        end

        #20;
        $stop;
        $finish;
    end

endmodule
