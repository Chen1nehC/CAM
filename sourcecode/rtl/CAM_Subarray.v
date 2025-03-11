/*
 * CAM_Subarray 模块概述
 * 本模块实现了一个基于 CAM (Content Addressable Memory) 结构的子阵列。
 * - 主要功能包括数据存储、更新、搜索匹配等操作。
 * - 存储结构为 32x36 的二维存储阵列，每行存储 32-bit 数据，总计 1152-bit。
 * - 采用 `operation_mode` 控制不同操作模式，包括数据写入、更新和搜索匹配。
 * - 通过 `tag_in` 作为掩码，实现按位更新。
 * - 采用 `cmp_addr` 和 `ppg_addr` 作为地址输入，支持多种匹配搜索模式。
 * - Author: Chenshuo Jia
 * - Date: 2025/03/11
 * - Email: jiacs21@mails.tsinghua.edu.cn
 */
`timescale 1ns / 1ps

module CAM_Subarray (
    // 数据接口
    input  wire [31:0] data_in,       // 32-bit 向量数据写入
    input  wire        update_signal, // 1-bit update 信号
    input  wire [9:0]  cmp_addr,      // 10-bit 向量地址
    input  wire [5:0]  ppg_addr,      // 6-bit ppg 地址
    input  wire [1:0]  cmp_data,      // 2-bit 搜索数据
    input  wire [1:0]  ppg_data,      // 2-bit ppg 数据
    input  wire [31:0] tag_in,        // 32-bit tag 输入
    output reg  [31:0] tag_out,       // 32-bit tag 输出
    input  wire        addr_select,   // 地址来源选择信号 (0: cmp_addr, 1: ppg_addr)
    input  wire [2:0]  operation_mode, // 操作模式选择信号

    // 控制信号
    input  wire        chip_enable,   // 片选信号

    // 电源和时钟
    input  wire CLK                   // 时钟信号
);

    // 数据存储 (32x36 结构)
    reg [1151:0] mem; // 存储 32*36 位数据
    
    always @(posedge CLK) begin
        if (chip_enable) begin
            case (operation_mode)
                3'b000: begin // data_in 直接输入
                    if (addr_select) begin
                        mem[(ppg_addr[2:0] + 32) * 32 +: 32] <= data_in;
                    end else begin
                        mem[cmp_addr[4:0] * 32 +: 32] <= data_in;
                    end
                end
                3'b001: begin // update_signal 控制写入逻辑 (结合 tag_in 作为掩码)
                    if (addr_select) begin
                        mem[(ppg_addr[2:0] + 32) * 32 +: 32] <= (mem[(ppg_addr[2:0] + 32) * 32 +: 32] & ~tag_in) | ({32{update_signal}} & tag_in);
                    end else begin
                        mem[cmp_addr[4:0] * 32 +: 32] <= (mem[cmp_addr[4:0] * 32 +: 32] & ~tag_in) | ({32{update_signal}} & tag_in);
                    end
                end
                3'b010: tag_out = (mem[cmp_addr[4:0] * 32 +: 32] ~^ {32{cmp_data[0]}});
                3'b011: tag_out = (mem[(ppg_addr[2:0] + 32) * 32 +: 32] ~^ {32{ppg_data[0]}});
                3'b100: tag_out = (mem[cmp_addr[4:0] * 32 +: 32] ~^ {32{cmp_data[0]}}) &
                                   (mem[cmp_addr[9:5] * 32 +: 32] ~^ {32{cmp_data[1]}});
                3'b101: tag_out = (mem[(ppg_addr[2:0] + 32) * 32 +: 32] ~^ {32{ppg_data[0]}}) &
                                   (mem[(ppg_addr[5:3] + 32) * 32 +: 32] ~^ {32{ppg_data[1]}});
                3'b110: tag_out = (mem[cmp_addr[4:0] * 32 +: 32] ~^ {32{cmp_data[0]}}) &
                                   (mem[(ppg_addr[2:0] + 32) * 32 +: 32] ~^ {32{ppg_data[0]}});
                default: tag_out = 32'b0;
            endcase
        end
    end

endmodule