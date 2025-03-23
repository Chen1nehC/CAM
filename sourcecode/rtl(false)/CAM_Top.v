`timescale 1ns / 1ps

module CAM_Top (
    input  wire        rst,
    input  wire        CLK,
    input  wire [15:0] data_in,
    input  wire        update_signal,
    input  wire [9:0]  cmp_addr,
    input  wire [3:0]  ppg_addr,
    input  wire [1:0]  cmp_data,
    input  wire [1:0]  ppg_data,
    input  wire [7:0]  exp_in,
    input  wire [2:0]  state_ctrl,  // 000 idle, 001 write
    input  wire [4:0]  sa_ctrl,
    input  wire        acc_en,
    output wire [15:0] tag_out
);

    // 内部寄存器
    reg [15:0] chip_enable;
    reg [15:0] tag_in;
    reg addr_select;
    reg [2:0] operation_mode;
    wire [9:0] cmp_addr_reg;

    // 数据存储控制信号
    wire done_store;
    wire done_all_store;

    // write_done 信号
    wire [15:0] write_done_all;
    wire        write_ack;

    assign write_ack = |(write_done_all & chip_enable);  

    // 数据存储模块
    CAM_Data_Store u_data_store (
        .rst(rst),
        .CLK(CLK),
        .cmp_addr_high(cmp_addr[9:5]),
        .data_in(data_in),
        .num_vectors(4'd1), 
        .write_ack(write_ack),
        .chip_enable(chip_enable),
        .cmp_addr_reg(cmp_addr_reg),
        .done(done_store),
        .done_all(done_all_store)
    );

    // 符号位子阵列
    CAM_Subarray u_cam_sign (
        .data_in(data_in),
        .update_signal(update_signal),
        .cmp_addr(cmp_addr_reg),
        .ppg_addr(ppg_addr),
        .cmp_data(cmp_data),
        .ppg_data(ppg_data),
        .tag_in(tag_in),
        .tag_out(tag_out),
        .addr_select(addr_select),
        .operation_mode(operation_mode),
        .chip_enable(chip_enable[0]),
        .rst(rst),
        .write_done(write_done_all[0]),
        .CLK(CLK)
    );

    // 指数位子阵列
    CAM_Subarray_Exp u_cam_exp (
        .data_in(data_in),
        .update_signal(update_signal),
        .cmp_addr(cmp_addr),
        .ppg_addr(ppg_addr),
        .cmp_data(cmp_addr_reg),
        .ppg_data(ppg_data),
        .tag_in(tag_in),
        .tag_out(tag_out),
        .addr_select(addr_select),
        .operation_mode(operation_mode),
        .chip_enable(chip_enable[1]),
        .rst(rst),
        .write_done(write_done_all[1]),
        .acc_en(acc_en),
        .CLK(CLK)
    );

    // 其他子阵列 (2~15)
    genvar i;
    generate
        for (i = 2; i < 16; i = i + 1) begin: CAM_Subarray_Instances
            CAM_Subarray u_cam_subarray (
                .data_in(data_in),
                .update_signal(update_signal),
                .cmp_addr(cmp_addr),
                .ppg_addr(ppg_addr),
                .cmp_data(cmp_addr_reg),
                .ppg_data(ppg_data),
                .tag_in(tag_in),
                .tag_out(tag_out),
                .addr_select(addr_select),
                .operation_mode(operation_mode),
                .chip_enable(chip_enable[i]),
                .rst(rst),
                .write_done(write_done_all[i]),
                .CLK(CLK)
            );
        end
    endgenerate

    // **Top层状态定义**
    localparam IDLE       = 2'b00;
    localparam WAIT_DONE  = 2'b01;

    reg [1:0] top_state;
    reg [1:0] next_top_state;

    // **状态机过程**
    always @(negedge rst or posedge CLK) begin
        if (!rst) begin
            top_state       <= IDLE;
            addr_select     <= 1'b0;
            tag_in          <= 16'b0;
            operation_mode  <= 3'b000;
        end else begin
            top_state <= next_top_state;

            case (top_state)
                IDLE: begin          
                    // 进入 STORE 模式
                    if (state_ctrl == 3'b001) begin
                        operation_mode <= 3'b000; // 写入模式信号，可自行定义
                        next_top_state <= WAIT_DONE;
                    end else begin
                        next_top_state <= IDLE;
                    end
                end

                WAIT_DONE: begin
                    if (done_all_store) begin
                        next_top_state <= IDLE; // 全部向量写完，回到 IDLE
                        state_ctrl <=3'b000;
                    end else begin
                        next_top_state <= WAIT_DONE;
                    end
                end
                default: next_top_state <= IDLE;
            endcase
        end
    end

   

endmodule
