/*
 * CAM_Subarray 模块概述
 * 本模块实现了一个基于 CAM (Content Addressable Memory) 结构的子阵列。
 * - 主要功能包括数据存储、更新、搜索匹配等操作。
 * - 存储结构为 32x36 的二维存储阵列，每行存储 36-bit 数据，但实际仅使用 16-bit，其余 16-bit 保留空置。
 * - 采用 operation_mode 控制不同操作模式，包括数据写入、更新和搜索匹配。
 * - 通过 tag_in 作为掩码，实现按位更新。
 * - 采用 cmp_addr 和 ppg_addr 作为地址输入，支持多种匹配搜索模式。
 * - operation_mode 说明:
 *   - 000: data_in 直接输入到 cmp_addr 或 ppg_addr 指定的存储单元。
 *   - 001: 按位更新存储数据，结合 tag_in 作为掩码。
 *   - 010: 搜索 cmp 中的第一个地址及对应数据。
 *   - 011: 搜索 ppg 中的第一个地址及对应数据。
 *   - 100: 搜索 cmp 中的第一个和第二个地址及对应数据。
 *   - 101: 搜索 ppg 中的第一个和第二个地址及对应数据。
 *   - 110: 搜索 cmp 第一个地址及 ppg 第一个地址及对应数据。
 * - Author: Chenshuo Jia
 * - Date: 2025/03/11
 * - Email: jiacs21@mails.tsinghua.edu.cn
 */

`timescale 1ns / 1ps

module CAM_Subarray (
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
    input  wire        rst,           // 复位信号，低有效
    output reg         write_done,    // **新增**：写入或更新完成信号

    // 电源和时钟
    input  wire CLK                   // 时钟信号
);

    // 数据存储 (36x32 结构，每行仍然32-bit，但只用16-bit)
    reg [1151:0] mem; // 存储 36*32 位数据
    

    always @(posedge CLK or negedge rst) begin
        if (!rst) begin
            tag_out        <= 16'b0;
            write_done     <= 1'b0;
        end else begin
            // 默认拉低
            write_done <= 1'b0;

            if (chip_enable) begin
                if (!write_done) begin // 只在未写过的情况下写
                    case (operation_mode)
                        3'b000: begin // 直接写
                            if (addr_select) begin
                                mem[(ppg_addr[1:0] + 32) * 32 +: 16] <= data_in;
                            end else begin
                                mem[cmp_addr[4:0] * 32 +: 16] <= data_in;
                            end
                            write_done <= 1'b1;
                        end

                        3'b001: begin // 更新
                            if (addr_select) begin
                                mem[(ppg_addr[1:0] + 32) * 32 +: 16] <= 
                                    (mem[(ppg_addr[1:0] + 32) * 32 +: 16] & ~tag_in) | 
                                    ({16{update_signal}} & tag_in);
                            end else begin
                                mem[cmp_addr[4:0] * 32 +: 16] <= 
                                    (mem[cmp_addr[4:0] * 32 +: 16] & ~tag_in) | 
                                    ({16{update_signal}} & tag_in);
                            end
                            write_done <= 1'b1;
                        end

                        // 搜索不改
                        3'b010: tag_out <= (mem[cmp_addr[4:0] * 32 +: 16] ~^ {16{cmp_data[0]}});
                        3'b011: tag_out <= (mem[(ppg_addr[1:0] + 32) * 32 +: 16] ~^ {16{ppg_data[0]}});
                        3'b100: tag_out <= (mem[cmp_addr[4:0] * 32 +: 16] ~^ {16{cmp_data[0]}}) &
                                            (mem[cmp_addr[9:5] * 32 +: 16] ~^ {16{cmp_data[1]}});
                        3'b101: tag_out <= (mem[(ppg_addr[1:0] + 32) * 32 +: 16] ~^ {16{ppg_data[0]}}) &
                                            (mem[(ppg_addr[3:2] + 32) * 32 +: 16] ~^ {16{ppg_data[1]}});
                        3'b110: tag_out <= (mem[cmp_addr[4:0] * 32 +: 16] ~^ {16{cmp_data[0]}}) &
                                            (mem[(ppg_addr[1:0] + 32) * 32 +: 16] ~^ {16{ppg_data[0]}});
                        default: tag_out <= 16'b0;
                    endcase
                end
            end else begin
                write_done <= 1'b0; // chip_enable 低，允许下一次写入
            end
        end
    end
endmodule