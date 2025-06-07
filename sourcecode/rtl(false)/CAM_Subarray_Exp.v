/*
 * CAM_Subarray_Exp 模块概述
 * 本模块实现了一个基于 CAM (Content Addressable Memory) 结构的子阵列。
 * - 相比于 CAM_Subarray，这个版本包含更多的 meta data，支持存储 FP 的 8 个指数位，并具有或门累加功能。
 * - 主要功能包括数据存储、更新、搜索匹配等操作。
 * - 存储结构为 32x40 的二维存储阵列，每行存储 40-bit 数据，总计 1280-bit。
 * - 采用 operation_mode 控制不同操作模式，包括数据写入、更新和搜索匹配。
 * - 通过 tag_in 作为掩码，实现按位更新。
 * - 采用 cmp_addr 和 ppg_addr 作为地址输入，支持多种匹配搜索模式。
 * - Author: Chenshuo Jia
 * - Date: 2025/03/11
 * - Email: jiacs21@mails.tsinghua.edu.cn
 */

`timescale 1ns / 1ps

module CAM_Subarray_Exp (
    // 数据接口
    input  wire [15:0] data_in,       // 16-bit 向量数据写入
    input  wire        update_signal, // 1-bit update 信号
    input  wire [9:0]  cmp_addr,      // 10-bit 向量地址
    input  wire [3:0]  ppg_addr,      // 4-bit ppg 地址
    input  wire [1:0]  cmp_data,      // 2-bit 搜索数据
    input  wire [1:0]  ppg_data,      // 2-bit ppg 数据
    input  wire [15:0] tag_in,        // 16-bit tag 输入
    output reg  [15:0] tag_out,       // 16-bit tag 输出
    input  wire        addr_select,   // 地址来源选择信号 (0: cmp_addr, 1: ppg_addr)
    input  wire [2:0]  operation_mode, // 操作模式选择信号

    // 控制信号
    input  wire        chip_enable,   // 片选信号
    input  wire        acc_en,        // 或门累加使能
    input  wire        rst,           // 复位信号，低有效
    output reg         write_done,     // **新增**：写入或更新完成信号
    // 电源和时钟
    input  wire        CLK            // 时钟信号
);

    // 数据存储 (40x32 结构，每行仍然 32-bit，但仅使用 16-bit)
    reg [1279:0] mem; // 存储 40*32 位数据
    reg [15:0] tag_out_prev; // 记录上一周期的 tag_out 值

    always @(posedge CLK or negedge rst) begin
        if (!rst) begin
            tag_out        <= 16'b0;
            write_done     <= 1'b0;
            tag_out_prev   <= 16'b0;
        end else begin
            // 默认拉低
            write_done <= 1'b0;

            if (chip_enable) begin
                if (!write_done) begin // 只在未写过的情况下写
                    case (operation_mode)
                        3'b000: begin // data_in 直接输入
                            if (addr_select) begin
                                mem[(ppg_addr[1:0] + 32) * 32 +: 16] <= data_in;
                            end else begin
                                mem[cmp_addr[4:0] * 32 +: 16] <= data_in;
                            end
                            write_done <= 1'b1; // 写完
                        end
                        3'b001: begin // update_signal 控制写入逻辑 (结合 tag_in 作为掩码)
                            if (addr_select) begin
                                mem[(ppg_addr[1:0] + 32) * 32 +: 16] <= (mem[(ppg_addr[1:0] + 32) * 32 +: 16] & ~tag_in) | ({16{update_signal}} & tag_in);
                            end else begin
                                mem[cmp_addr[4:0] * 32 +: 16] <= (mem[cmp_addr[4:0] * 32 +: 16] & ~tag_in) | ({16{update_signal}} & tag_in);
                            end
                            write_done <= 1'b1; // 写完
                        end
                        3'b010: tag_out = (mem[cmp_addr[4:0] * 32 +: 16] ~^ {16{cmp_data[0]}});
                        3'b011: tag_out = (mem[(ppg_addr[1:0] + 32) * 32 +: 16] ~^ {16{ppg_data[0]}});
                        3'b100: tag_out = (mem[cmp_addr[4:0] * 32 +: 16] ~^ {16{cmp_data[0]}}) &
                                        (mem[cmp_addr[9:5] * 32 +: 16] ~^ {16{cmp_data[1]}});
                        3'b101: tag_out = (mem[(ppg_addr[1:0] + 32) * 32 +: 16] ~^ {16{ppg_data[0]}}) &
                                        (mem[(ppg_addr[3:2] + 32) * 32 +: 16] ~^ {16{ppg_data[1]}});
                        3'b110: tag_out = (mem[cmp_addr[4:0] * 32 +: 16] ~^ {16{cmp_data[0]}}) &
                                        (mem[(ppg_addr[1:0] + 32) * 32 +: 16] ~^ {16{ppg_data[0]}});
                        default: tag_out = 16'b0;
                    endcase
                end
                 // **累加部分单独处理**
                if (acc_en) begin
                    tag_out <= tag_out | tag_out_prev;
                    tag_out_prev <= tag_out | tag_out_prev; // 关键：保持历史累积
                end else begin
                    tag_out_prev <= tag_out_prev; // 保持不变
                end

            end else begin
                write_done <= 1'b0; // chip_enable 低，允许下一次写入
            end
        end
    end

endmodule
