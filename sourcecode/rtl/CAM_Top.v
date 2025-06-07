`timescale 1ns / 1ps

module CAM_Top (
    input  wire        rst_n,
    input  wire        CLK,
    input  wire [31:0] data_in,
    input  wire        signal_in,
    input  wire [4:0]  cmp_addr_1,
    input  wire [4:0]  cmp_addr_2,
    input  wire [1:0]  ppg_addr_1,
    input  wire [1:0]  ppg_addr_2,
    input  wire        cmp_data_1,
    input  wire        cmp_data_2,
    input  wire        ppg_data_1,
    input  wire        ppg_data_2,
    input  wire [7:0]  exp_in_1,
    input  wire [7:0]  exp_in_2,
    input  wire [4:0]  state_ctrl, 
    input  wire        vref,
    input  wire        sampled,
    input  wire        preb,
    input  wire        diff,
    input  wire        acc_en,
    input  wire [31:0] chip_enable,
    input  wire        SEARCH_2row,
    output reg [5:0]  sum_0,
    output reg [5:0]  sum_1
);

reg [15:0] Ttag;
reg        FB;
reg        acc;
reg        Lshift;
reg        Rshift;
reg        Ftag;
reg        we;

always @(*) begin
    // Default values
    Ttag      = 16'b0;
    FB        = 1'b0;
    acc       = 1'b0;
    Lshift    = 1'b0;
    Rshift    = 1'b0;
    Ftag      = 1'b0;
    we        = 1'b0;

    case (state_ctrl)
        5'd0: begin we = 1'b1; end // 写入
        5'd1: begin FB = 1'b1; end// FB开      
        5'd2: begin Lshift = 1'b1; end // Lshift打开       
        5'd3: begin Rshift = 1'b1; end // Rshift打开      
        5'd4: begin Ttag = 16'b00001_0000000000; Ftag = 1'b1; end // 搬运Esum0
        5'd5: begin Ttag = 16'b00010_0000000000; Ftag = 1'b1; end // 搬运Esum1
        5'd6: begin Ttag = 16'b00100_0000000000; Ftag = 1'b1; end // 搬运Esum2
        5'd7: begin Ttag = 16'b01000_0000000000; Ftag = 1'b1; end // 搬运Esum3
        5'd8: begin Ttag = 16'b10000_0000000000; Ftag = 1'b1; end // 搬运Esum4
        5'd9: Ttag = 16'b10000_0000000000; // 找Emax
        5'd10: begin Ttag = 16'b00000_1000000000; Ftag = 1'b1; end // 数据准备0
        5'd11: begin Ttag = 16'b00000_0100000000; Ftag = 1'b1; end // 数据准备1
        5'd12: begin Ttag = 16'b00000_0010000000; Ftag = 1'b1; end // 数据准备2
        5'd13: begin Ttag = 16'b00000_0001000000; Ftag = 1'b1; end // 数据准备3
        5'd14: begin Ttag = 16'b00000_0000100000; Ftag = 1'b1; end // 数据准备4
        5'd15: begin Ttag = 16'b00000_0000010000; Ftag = 1'b1; end // 数据准备5
        5'd16: begin Ttag = 16'b00000_0000001000; Ftag = 1'b1; end // 数据准备6
        5'd17: begin Ttag = 16'b00000_0000000100; Ftag = 1'b1; end // 数据准备7
        5'd18: begin Ttag = 16'b00000_0000000010; Ftag = 1'b1; end // 数据准备8
        5'd19: begin Ttag = 16'b00000_0000000001; Ftag = 1'b1; end // 数据准备9
        5'd20: Ttag = 16'b00000_1000000000; // 累加0
        5'd21: Ttag = 16'b00000_0100000000; // 累加1
        5'd22: Ttag = 16'b00000_0010000000; // 累加2
        5'd23: Ttag = 16'b00000_0001000000; // 累加3
        5'd24: Ttag = 16'b00000_0000100000; // 累加4
        5'd25: Ttag = 16'b00000_0000010000; // 累加5
        5'd26: Ttag = 16'b00000_0000001000; // 累加6
        5'd27: Ttag = 16'b00000_0000000100; // 累加7
        5'd28: Ttag = 16'b00000_0000000010; // 累加8
        5'd29: Ttag = 16'b00000_0000000001; // 累加9
        5'd30: begin Ttag = 16'b10000_0000000000; acc  = 1'b1; Ftag = 1'b1; end // acc + MSB to tag
        default: ; // Do nothing
    endcase
end

reg [31:0] mem0 [0:35];
reg [31:0] mem1 [0:39]; //最高指数位
reg [31:0] mem2 [0:35];
reg [31:0] mem3 [0:35];
reg [31:0] mem4 [0:35];
reg [31:0] mem5 [0:35];
reg [31:0] mem6 [0:35];
reg [31:0] mem7 [0:35];
reg [31:0] mem8 [0:35];
reg [31:0] mem9 [0:35];
reg [31:0] mem10 [0:35];
reg [31:0] mem11 [0:35];
reg [31:0] mem12 [0:35];
reg [31:0] mem13 [0:35];
reg [31:0] mem14 [0:35];
reg [31:0] mem15 [0:35];
reg [31:0] mem16 [0:35];
reg [31:0] mem17 [0:39]; //最高指数位
reg [31:0] mem18 [0:35];
reg [31:0] mem19 [0:35];
reg [31:0] mem20 [0:35];
reg [31:0] mem21 [0:35];
reg [31:0] mem22 [0:35];
reg [31:0] mem23 [0:35];
reg [31:0] mem24 [0:35];
reg [31:0] mem25 [0:35];
reg [31:0] mem26 [0:35];
reg [31:0] mem27 [0:35];
reg [31:0] mem28 [0:35];
reg [31:0] mem29 [0:35];
reg [31:0] mem30 [0:35];
reg [31:0] mem31 [0:35];

genvar i;
integer j;
// 数据直接输入模块
// cmp_addr_1 代表输入向量的地址，默认为0和1
generate
    for (i = 0; i < 32; i = i + 1) begin : mem_write_block
        always @(posedge CLK) begin
            if (Ttag == 16'b0 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b1 && chip_enable[i] == 1'b1) begin
                case (i)
                    0: mem0[cmp_addr_1] <= data_in; 
                    1: mem1[cmp_addr_1] <= data_in;
                    2: mem2[cmp_addr_1] <= data_in;
                    3: mem3[cmp_addr_1] <= data_in;
                    4: mem4[cmp_addr_1] <= data_in;
                    5: mem5[cmp_addr_1] <= data_in;
                    6: mem6[cmp_addr_1] <= data_in;
                    7: mem7[cmp_addr_1] <= data_in;
                    8: mem8[cmp_addr_1] <= data_in;
                    9: mem9[cmp_addr_1] <= data_in;
                    10: mem10[cmp_addr_1] <= data_in;
                    11: mem11[cmp_addr_1] <= data_in;
                    12: mem12[cmp_addr_1] <= data_in;
                    13: mem13[cmp_addr_1] <= data_in;
                    14: mem14[cmp_addr_1] <= data_in;
                    15: mem15[cmp_addr_1] <= data_in;
                    16: mem16[cmp_addr_1] <= data_in;
                    17: mem17[cmp_addr_1] <= data_in;
                    18: mem18[cmp_addr_1] <= data_in;
                    19: mem19[cmp_addr_1] <= data_in;
                    20: mem20[cmp_addr_1] <= data_in;
                    21: mem21[cmp_addr_1] <= data_in;
                    22: mem22[cmp_addr_1] <= data_in;
                    23: mem23[cmp_addr_1] <= data_in;
                    24: mem24[cmp_addr_1] <= data_in;
                    25: mem25[cmp_addr_1] <= data_in;
                    26: mem26[cmp_addr_1] <= data_in;
                    27: mem27[cmp_addr_1] <= data_in;
                    28: mem28[cmp_addr_1] <= data_in;
                    29: mem29[cmp_addr_1] <= data_in;
                    30: mem30[cmp_addr_1] <= data_in;
                    31: mem31[cmp_addr_1] <= data_in;                    
                    default: ;
                endcase
            end
        end
    end
endgenerate

wire [31:0] extended_cmp_data_1;
assign extended_cmp_data_1 = {32{cmp_data_1}}; // 将 cmp_data_1 扩展为 32 位
wire [31:0] extended_cmp_data_2;
assign extended_cmp_data_2 = {32{cmp_data_2}}; // 将 cmp_data_2 扩展为 32 位
wire [31:0] extended_ppg_data_1;
assign extended_ppg_data_1 = {32{ppg_data_1}}; // 将 ppg_data_1 扩展为 32 位
wire [31:0] extended_ppg_data_2;
assign extended_ppg_data_2 = {32{ppg_data_2}}; // 将 ppg_data_2 扩展为 32 位

// FB部分有以下3种情况：
// 1. 用于指数进位的FB代码，SEARCH_2row == 1'b1，mem[32]代表指数位存储的S
// 2. 用于指数进位的FB代码，SEARCH_2row == 1'b1，mem[34]代表指数位最终得到的结果
// 3. 用于尾数右移之后的FB代码，SEARCH_2row == 1'b0，mem[32]代表MSBtotag，做一个“与操作”就可以实现MSBtotag = 0的对应元素全部变为0
generate
    for (i = 0; i < 32; i = i + 1) begin : FB_search_and_update_block
        always @(posedge CLK) begin
            if (Ttag == 16'b0 && FB == 1'b1 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0 && chip_enable[i] == 1'b1) begin 
                    if (SEARCH_2row == 1'b1 & ppg_addr_1 ==0 & ppg_addr_2 == 0) begin                            
                        case (i)
                            // 前16个 subarray 的指数进位（使用cmp控制），计算S
                            1: mem1[32] <= mem1[32] | (~(mem1[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem1[cmp_addr_2] ^ extended_cmp_data_2));
                            2: mem2[32] <= mem2[32] | (~(mem2[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem2[cmp_addr_2] ^ extended_cmp_data_2));
                            3: mem3[32] <= mem3[32] | (~(mem3[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem3[cmp_addr_2] ^ extended_cmp_data_2));
                            4: mem4[32] <= mem4[32] | (~(mem4[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem4[cmp_addr_2] ^ extended_cmp_data_2));
                            5: mem5[32] <= mem5[32] | (~(mem5[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem5[cmp_addr_2] ^ extended_cmp_data_2));
                            // 后16个 subarray 的指数进位（使用cmp控制），计算S
                            17: mem17[32] <= mem17[32] | (~(mem17[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem17[cmp_addr_2] ^ extended_cmp_data_2));
                            18: mem18[32] <= mem18[32] | (~(mem18[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem18[cmp_addr_2] ^ extended_cmp_data_2));
                            19: mem19[32] <= mem19[32] | (~(mem19[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem19[cmp_addr_2] ^ extended_cmp_data_2));
                            20: mem20[32] <= mem20[32] | (~(mem20[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem20[cmp_addr_2] ^ extended_cmp_data_2));
                            21: mem21[32] <= mem21[32] | (~(mem21[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem21[cmp_addr_2] ^ extended_cmp_data_2));
                            default: ;
                        endcase
                    end
                    if (SEARCH_2row == 1'b1 & cmp_addr_1 ==0 & cmp_addr_2 == 0) begin                            
                        case (i)
                            // 前16个 subarray 的指数进位（使用ppg控制），利用C和S计算结果
                            1: mem1[34] <= mem1[34] | (~(mem1[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem1[ppg_addr_2+32] ^ extended_ppg_data_2));
                            2: mem2[34] <= mem2[34] | (~(mem2[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem2[ppg_addr_2+32] ^ extended_ppg_data_2));
                            3: mem3[34] <= mem3[34] | (~(mem3[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem3[ppg_addr_2+32] ^ extended_ppg_data_2));
                            4: mem4[34] <= mem4[34] | (~(mem4[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem4[ppg_addr_2+32] ^ extended_ppg_data_2));
                            5: mem5[34] <= mem5[34] | (~(mem5[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem5[ppg_addr_2+32] ^ extended_ppg_data_2));      
                            // 后16个 subarray 的指数进位（使用ppg控制），利用C和S计算结果
                            17: mem17[34] <= mem17[34] | (~(mem17[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem17[ppg_addr_2+32] ^ extended_ppg_data_2));
                            18: mem18[34] <= mem18[34] | (~(mem18[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem18[ppg_addr_2+32] ^ extended_ppg_data_2));
                            19: mem19[34] <= mem19[34] | (~(mem19[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem19[ppg_addr_2+32] ^ extended_ppg_data_2));
                            20: mem20[34] <= mem20[34] | (~(mem20[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem20[ppg_addr_2+32] ^ extended_ppg_data_2));
                            21: mem21[34] <= mem21[34] | (~(mem21[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem21[ppg_addr_2+32] ^ extended_ppg_data_2));    
                            default: ;
                        endcase
                    end
                    if (SEARCH_2row == 1'b0) begin
                        case (i) 
                            // 前16个 subarray 的尾数移位之后，清除指数太小的元素
                            6: mem6[cmp_addr_1] <= mem6[cmp_addr_1] & mem6[32];
                            7: mem7[cmp_addr_1] <= mem7[cmp_addr_1] & mem7[32];
                            8: mem8[cmp_addr_1] <= mem8[cmp_addr_1] & mem8[32];
                            9: mem9[cmp_addr_1] <= mem9[cmp_addr_1] & mem9[32];
                            10: mem10[cmp_addr_1] <= mem10[cmp_addr_1] & mem10[32];
                            11: mem11[cmp_addr_1] <= mem11[cmp_addr_1] & mem11[32];
                            12: mem12[cmp_addr_1] <= mem12[cmp_addr_1] & mem12[32];
                            13: mem13[cmp_addr_1] <= mem13[cmp_addr_1] & mem13[32];
                            14: mem14[cmp_addr_1] <= mem14[cmp_addr_1] & mem14[32];
                            15: mem15[cmp_addr_1] <= mem15[cmp_addr_1] & mem15[32];
                            // 后16个 subarray 的尾数移位，清除指数太小的元素                               
                            22: mem22[cmp_addr_1] <= mem22[cmp_addr_1] & mem22[32];
                            23: mem23[cmp_addr_1] <= mem23[cmp_addr_1] & mem23[32];
                            24: mem24[cmp_addr_1] <= mem24[cmp_addr_1] & mem24[32];
                            25: mem25[cmp_addr_1] <= mem25[cmp_addr_1] & mem25[32];
                            26: mem26[cmp_addr_1] <= mem26[cmp_addr_1] & mem26[32];
                            27: mem27[cmp_addr_1] <= mem27[cmp_addr_1] & mem27[32];
                            28: mem28[cmp_addr_1] <= mem28[cmp_addr_1] & mem28[32];
                            29: mem29[cmp_addr_1] <= mem29[cmp_addr_1] & mem29[32];
                            30: mem30[cmp_addr_1] <= mem30[cmp_addr_1] & mem30[32];
                            31: mem31[cmp_addr_1] <= mem31[cmp_addr_1] & mem31[32];
                            default: ;
                        endcase
                    end 
            end
        end
    end
endgenerate

// 用于指数进位的左移代码，mem[33]代表指数位存储的C
// cmp_addr_1 和 cmp_addr_2 默认为0和1
generate
    for (i = 0; i < 32; i = i + 1) begin : L_search_and_update_block
        always @(posedge CLK) begin 
            if (Ttag == 16'b0 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b1 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0 && chip_enable[i] == 1'b1) begin 
                    if (SEARCH_2row == 1'b1 & ppg_addr_1 ==0 & ppg_addr_2 == 0) begin                            
                        case (i) 
                            2: mem1[33] <= mem1[33] | (~(mem2[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem2[cmp_addr_2] ^ extended_cmp_data_2));
                            3: mem2[33] <= mem2[33] | (~(mem3[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem3[cmp_addr_2] ^ extended_cmp_data_2));
                            4: mem3[33] <= mem3[33] | (~(mem4[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem4[cmp_addr_2] ^ extended_cmp_data_2));
                            5: mem4[33] <= mem4[33] | (~(mem5[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem5[cmp_addr_2] ^ extended_cmp_data_2));

                            18: mem17[33] <= mem17[33] | (~(mem18[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem18[cmp_addr_2] ^ extended_cmp_data_2));
                            19: mem18[33] <= mem18[33] | (~(mem19[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem19[cmp_addr_2] ^ extended_cmp_data_2));
                            20: mem19[33] <= mem19[33] | (~(mem20[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem20[cmp_addr_2] ^ extended_cmp_data_2));
                            21: mem20[33] <= mem20[33] | (~(mem21[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem21[cmp_addr_2] ^ extended_cmp_data_2)); 
                            default: ;
                        endcase
                    end
                    if (SEARCH_2row == 1'b1 & cmp_addr_1 ==0 & cmp_addr_2 == 0) begin                            
                        case (i)
                            2: mem1[33] <= mem1[33] | (~(mem2[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem2[ppg_addr_2+32] ^ extended_ppg_data_2));
                            3: mem2[33] <= mem2[33] | (~(mem3[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem3[ppg_addr_2+32] ^ extended_ppg_data_2));
                            4: mem3[33] <= mem3[33] | (~(mem4[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem4[ppg_addr_2+32] ^ extended_ppg_data_2));
                            5: mem4[33] <= mem4[33] | (~(mem5[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem5[ppg_addr_2+32] ^ extended_ppg_data_2));
                            18: mem17[33] <= mem17[33] | (~(mem18[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem18[ppg_addr_2+32] ^ extended_ppg_data_2));
                            19: mem18[33] <= mem18[33] | (~(mem19[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem19[ppg_addr_2+32] ^ extended_ppg_data_2));
                            20: mem19[33] <= mem19[33] | (~(mem20[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem20[ppg_addr_2+32] ^ extended_ppg_data_2));
                            21: mem20[33] <= mem20[33] | (~(mem21[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem21[ppg_addr_2+32] ^ extended_ppg_data_2));
                            default: ;
                        endcase
                    end                    
            end
        end
    end
endgenerate

// 用于尾数右移的代码，MSBtotag已经提前存储在所有尾数subarray的第一个meta data，倘若mem[32]=0则保留本位的元素，倘若mem[32]=1则输入高位数据
// cmp_addr_1默认为0，因为只对向量1中的元素移位
generate
    for (i = 0; i < 32; i = i + 1) begin : R_search_and_update_block
        always @(posedge CLK) begin
            if (Ttag == 16'b0 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b1 && Ftag == 1'b0 &&we == 1'b0 && chip_enable[i] == 1'b1) begin 
                if (SEARCH_2row == 1'b1) begin                            
                    case (i) 
                        // 第一组尾数移位
                        5: mem6[cmp_addr_1] <= mem6[cmp_addr_1] & (~mem6[32]);
                        6: mem7[cmp_addr_1] <= (mem7[cmp_addr_1] & (~mem6[32])) + (mem6[cmp_addr_1] & mem6[32]);
                        7: mem8[cmp_addr_1] <= (mem8[cmp_addr_1] & (~mem7[32])) + (mem7[cmp_addr_1] & mem7[32]);
                        8: mem9[cmp_addr_1] <= (mem9[cmp_addr_1] & (~mem8[32])) + (mem8[cmp_addr_1] & mem8[32]);
                        9: mem10[cmp_addr_1] <= (mem10[cmp_addr_1] & (~mem9[32])) + (mem9[cmp_addr_1] & mem9[32]);
                        10: mem11[cmp_addr_1] <= (mem11[cmp_addr_1] & (~mem10[32])) + (mem10[cmp_addr_1] & mem10[32]);
                        11: mem12[cmp_addr_1] <= (mem12[cmp_addr_1] & (~mem11[32])) + (mem11[cmp_addr_1] & mem11[32]);
                        12: mem13[cmp_addr_1] <= (mem13[cmp_addr_1] & (~mem12[32])) + (mem12[cmp_addr_1] & mem12[32]);
                        13: mem14[cmp_addr_1] <= (mem14[cmp_addr_1] & (~mem13[32])) + (mem13[cmp_addr_1] & mem13[32]);
                        14: mem15[cmp_addr_1] <= (mem15[cmp_addr_1] & (~mem14[32])) + (mem14[cmp_addr_1] & mem14[32]);
                        // 第二组尾数移位                               
                        21: mem22[cmp_addr_1] <= mem22[cmp_addr_1] & (~mem22[32]);
                        22: mem23[cmp_addr_1] <= (mem23[cmp_addr_1] & (~mem22[32])) + (mem22[cmp_addr_1] & mem22[32]);
                        23: mem24[cmp_addr_1] <= (mem24[cmp_addr_1] & (~mem23[32])) + (mem23[cmp_addr_1] & mem23[32]);
                        24: mem25[cmp_addr_1] <= (mem25[cmp_addr_1] & (~mem24[32])) + (mem24[cmp_addr_1] & mem24[32]);
                        25: mem26[cmp_addr_1] <= (mem26[cmp_addr_1] & (~mem25[32])) + (mem25[cmp_addr_1] & mem25[32]);
                        26: mem27[cmp_addr_1] <= (mem27[cmp_addr_1] & (~mem26[32])) + (mem26[cmp_addr_1] & mem26[32]);
                        27: mem28[cmp_addr_1] <= (mem28[cmp_addr_1] & (~mem27[32])) + (mem27[cmp_addr_1] & mem27[32]);
                        28: mem29[cmp_addr_1] <= (mem29[cmp_addr_1] & (~mem28[32])) + (mem28[cmp_addr_1] & mem28[32]);
                        29: mem30[cmp_addr_1] <= (mem30[cmp_addr_1] & (~mem29[32])) + (mem29[cmp_addr_1] & mem29[32]);
                        30: mem31[cmp_addr_1] <= (mem31[cmp_addr_1] & (~mem30[32])) + (mem30[cmp_addr_1] & mem30[32]);
                        default: ;
                    endcase
                end
            end
        end
    end
endgenerate

// Esum0_shift：将指数最低位存入最高位的 meta data
always @(posedge CLK) begin
    if (Ttag == 16'b0_00001_0000000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin                            
            mem1[36] <= mem5[34];
            mem17[36] <= mem21[34];
    end
end
    

// Esum1_shift：将指数倒数第二位存入最高位的 meta data
always @(posedge CLK) begin
    if (Ttag == 16'b0_00010_0000000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin                            
            mem1[35] <= mem4[34];
            mem17[35] <= mem20[34];
    end
end

// Esum2_shift：将指数倒数第三位存入最高位的 meta data
always @(posedge CLK) begin
    if (Ttag == 16'b0_00100_0000000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin                            
            mem1[34] <= mem3[34];
            mem17[34] <= mem19[34];
    end
end

// Esum3_shift：将指数倒数第四位存入最高位的 meta data
always @(posedge CLK) begin
    if (Ttag == 16'b0_01000_0000000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin                            
            mem1[33] <= mem2[34];
            mem17[33] <= mem18[34];
    end
end

// Esum4_shift：将指数最高位存入最高位的 meta data
always @(posedge CLK) begin
    if (Ttag == 16'b0_10000_0000000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin                            
            mem1[32] <= mem1[34];
            mem17[32] <= mem17[34];
    end
end

// Find_Emax：输出指数最高位的 meta data，找到最大指数值
reg [5:0] temp_sum0, temp_sum1; 
always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        sum_0 <= 0; sum_1 <= 0;
    end else if (Ttag == 16'b0_10000_0000000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem1[ppg_addr_1 + 32][j];
            temp_sum1 = temp_sum1 + mem17[ppg_addr_1 + 32][j];
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

// Acc and MSBtotag：指数部分search的时候tag bit要存入每一个尾数的 meta data中，此过程要使用“或门”
// exp_in_1 和 exp_in_2 代表输入的要搜索的指数值
reg [31:0] MSBtotag_1;
wire [31:0] extended_exp_in_1_bit0; assign extended_exp_in_1_bit0 = {32{exp_in_1[0]}};
wire [31:0] extended_exp_in_1_bit1; assign extended_exp_in_1_bit1 = {32{exp_in_1[1]}};
wire [31:0] extended_exp_in_1_bit2; assign extended_exp_in_1_bit2 = {32{exp_in_1[2]}};
wire [31:0] extended_exp_in_1_bit3; assign extended_exp_in_1_bit3 = {32{exp_in_1[3]}};
wire [31:0] extended_exp_in_1_bit4; assign extended_exp_in_1_bit4 = {32{exp_in_1[4]}};
reg [31:0] MSBtotag_2;
wire [31:0] extended_exp_in_2_bit0; assign extended_exp_in_2_bit0 = {32{exp_in_2[0]}};
wire [31:0] extended_exp_in_2_bit1; assign extended_exp_in_2_bit1 = {32{exp_in_2[1]}};
wire [31:0] extended_exp_in_2_bit2; assign extended_exp_in_2_bit2 = {32{exp_in_2[2]}};
wire [31:0] extended_exp_in_2_bit3; assign extended_exp_in_2_bit3 = {32{exp_in_2[3]}};
wire [31:0] extended_exp_in_2_bit4; assign extended_exp_in_2_bit4 = {32{exp_in_2[4]}};

always @(posedge CLK or negedge rst_n) begin
    if (!rst_n) begin
        MSBtotag_1 <= 0; MSBtotag_2 <= 0; 
    end else if (Ttag == 16'b0_10000_0000000000 && FB == 1'b0 && acc == 1'b1 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin
        // 对 MSBtotag_1 处理并把它存储在前16个 array 中的尾数整列中，存储在第一个 meta data 的位置
        MSBtotag_1 <= MSBtotag_1 | (~(mem1[32] ^ extended_exp_in_1_bit4)) & (~(mem1[33] ^ extended_exp_in_1_bit3)) & (~(mem1[34] ^ extended_exp_in_1_bit2)) & (~(mem1[35] ^ extended_exp_in_1_bit1)) & (~(mem1[36] ^ extended_exp_in_1_bit0));
        mem6[32] <= MSBtotag_1; mem7[32] <= MSBtotag_1; mem8[32] <= MSBtotag_1; mem9[32] <= MSBtotag_1; mem10[32] <= MSBtotag_1;
        mem11[32] <= MSBtotag_1; mem12[32] <= MSBtotag_1; mem13[32] <= MSBtotag_1; mem14[32] <= MSBtotag_1; mem15[32] <= MSBtotag_1; 
        
        // 对 MSBtotag_2 处理并把它存储在后16个 array 中的尾数整列中，存储在第一个 meta data 的位置
        MSBtotag_2 <= MSBtotag_2 | (~(mem17[32] ^ extended_exp_in_2_bit4)) & (~(mem17[33] ^ extended_exp_in_2_bit3)) & (~(mem17[34] ^ extended_exp_in_2_bit2)) & (~(mem17[35] ^ extended_exp_in_2_bit1)) & (~(mem17[36] ^ extended_exp_in_2_bit0));
        mem22[32] <= MSBtotag_2; mem23[32] <= MSBtotag_2; mem24[32] <= MSBtotag_2; mem25[32] <= MSBtotag_2; mem26[32] <= MSBtotag_2;
        mem27[32] <= MSBtotag_2; mem28[32] <= MSBtotag_2; mem29[32] <= MSBtotag_2; mem30[32] <= MSBtotag_2; mem31[32] <= MSBtotag_2;
    end
end

// Dataprocess_0: cmp_addr_1代表操作数1（全部bit）的地址，cmp_addr_2代表操作数2（单bit）的地址，一次运算的结果存储在mem[32]，即第一个 meta data 的位置
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_1000000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin 
        if (SEARCH_2row == 1'b0) begin
            // 前16个 array 中的尾数处理               
            mem6[32] <= mem6[cmp_addr_1] & (mem6[cmp_addr_2]);
            mem7[32] <= mem7[cmp_addr_1] & (mem6[cmp_addr_2]);
            mem8[32] <= mem8[cmp_addr_1] & (mem6[cmp_addr_2]);
            mem9[32] <= mem9[cmp_addr_1] & (mem6[cmp_addr_2]);
            mem10[32] <= mem10[cmp_addr_1] & (mem6[cmp_addr_2]);
            mem11[32] <= mem11[cmp_addr_1] & (mem6[cmp_addr_2]);
            mem12[32] <= mem12[cmp_addr_1] & (mem6[cmp_addr_2]);
            mem13[32] <= mem13[cmp_addr_1] & (mem6[cmp_addr_2]);
            mem14[32] <= mem14[cmp_addr_1] & (mem6[cmp_addr_2]);
            mem15[32] <= mem15[cmp_addr_1] & (mem6[cmp_addr_2]);
            // 后16个 array 中的尾数处理
            mem22[32] <= mem22[cmp_addr_1] & (mem22[cmp_addr_2]);
            mem23[32] <= mem23[cmp_addr_1] & (mem22[cmp_addr_2]);
            mem24[32] <= mem24[cmp_addr_1] & (mem22[cmp_addr_2]);
            mem25[32] <= mem25[cmp_addr_1] & (mem22[cmp_addr_2]);
            mem26[32] <= mem26[cmp_addr_1] & (mem22[cmp_addr_2]);
            mem27[32] <= mem27[cmp_addr_1] & (mem22[cmp_addr_2]);
            mem28[32] <= mem28[cmp_addr_1] & (mem22[cmp_addr_2]);
            mem29[32] <= mem29[cmp_addr_1] & (mem22[cmp_addr_2]);
            mem30[32] <= mem30[cmp_addr_1] & (mem22[cmp_addr_2]);
            mem31[32] <= mem31[cmp_addr_1] & (mem22[cmp_addr_2]);
        end
    end
end


// Dataprocess_1: cmp_addr_1代表操作数1（全部bit）的地址，cmp_addr_2代表操作数2（单bit）的地址，一次运算的结果存储在mem[32]，即第一个 meta data 的位置
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0100000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin 
        if (SEARCH_2row == 1'b0) begin
            // 前16个 array 中的尾数处理               
            mem6[32] <= mem6[cmp_addr_1] & (mem7[cmp_addr_2]);
            mem7[32] <= mem7[cmp_addr_1] & (mem7[cmp_addr_2]);
            mem8[32] <= mem8[cmp_addr_1] & (mem7[cmp_addr_2]);
            mem9[32] <= mem9[cmp_addr_1] & (mem7[cmp_addr_2]);
            mem10[32] <= mem10[cmp_addr_1] & (mem7[cmp_addr_2]);
            mem11[32] <= mem11[cmp_addr_1] & (mem7[cmp_addr_2]);
            mem12[32] <= mem12[cmp_addr_1] & (mem7[cmp_addr_2]);
            mem13[32] <= mem13[cmp_addr_1] & (mem7[cmp_addr_2]);
            mem14[32] <= mem14[cmp_addr_1] & (mem7[cmp_addr_2]);
            mem15[32] <= mem15[cmp_addr_1] & (mem7[cmp_addr_2]);
            // 后16个 array 中的尾数处理
            mem22[32] <= mem22[cmp_addr_1] & (mem23[cmp_addr_2]);
            mem23[32] <= mem23[cmp_addr_1] & (mem23[cmp_addr_2]);
            mem24[32] <= mem24[cmp_addr_1] & (mem23[cmp_addr_2]);
            mem25[32] <= mem25[cmp_addr_1] & (mem23[cmp_addr_2]);
            mem26[32] <= mem26[cmp_addr_1] & (mem23[cmp_addr_2]);
            mem27[32] <= mem27[cmp_addr_1] & (mem23[cmp_addr_2]);
            mem28[32] <= mem28[cmp_addr_1] & (mem23[cmp_addr_2]);
            mem29[32] <= mem29[cmp_addr_1] & (mem23[cmp_addr_2]);
            mem30[32] <= mem30[cmp_addr_1] & (mem23[cmp_addr_2]);
            mem31[32] <= mem31[cmp_addr_1] & (mem23[cmp_addr_2]);
        end
    end
end

// Dataprocess_2: cmp_addr_1代表操作数1（全部bit）的地址，cmp_addr_2代表操作数2（单bit）的地址，一次运算的结果存储在mem[32]，即第一个 meta data 的位置
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0010000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin 
        if (SEARCH_2row == 1'b0) begin
            // 前16个 array 中的尾数处理               
            mem6[32] <= mem6[cmp_addr_1] & (mem8[cmp_addr_2]);
            mem7[32] <= mem7[cmp_addr_1] & (mem8[cmp_addr_2]);
            mem8[32] <= mem8[cmp_addr_1] & (mem8[cmp_addr_2]);
            mem9[32] <= mem9[cmp_addr_1] & (mem8[cmp_addr_2]);
            mem10[32] <= mem10[cmp_addr_1] & (mem8[cmp_addr_2]);
            mem11[32] <= mem11[cmp_addr_1] & (mem8[cmp_addr_2]);
            mem12[32] <= mem12[cmp_addr_1] & (mem8[cmp_addr_2]);
            mem13[32] <= mem13[cmp_addr_1] & (mem8[cmp_addr_2]);
            mem14[32] <= mem14[cmp_addr_1] & (mem8[cmp_addr_2]);
            mem15[32] <= mem15[cmp_addr_1] & (mem8[cmp_addr_2]);
            // 后16个 array 中的尾数处理
            mem22[32] <= mem22[cmp_addr_1] & (mem24[cmp_addr_2]);
            mem23[32] <= mem23[cmp_addr_1] & (mem24[cmp_addr_2]);
            mem24[32] <= mem24[cmp_addr_1] & (mem24[cmp_addr_2]);
            mem25[32] <= mem25[cmp_addr_1] & (mem24[cmp_addr_2]);
            mem26[32] <= mem26[cmp_addr_1] & (mem24[cmp_addr_2]);
            mem27[32] <= mem27[cmp_addr_1] & (mem24[cmp_addr_2]);
            mem28[32] <= mem28[cmp_addr_1] & (mem24[cmp_addr_2]);
            mem29[32] <= mem29[cmp_addr_1] & (mem24[cmp_addr_2]);
            mem30[32] <= mem30[cmp_addr_1] & (mem24[cmp_addr_2]);
            mem31[32] <= mem31[cmp_addr_1] & (mem24[cmp_addr_2]);
        end
    end
end

// Dataprocess_3: cmp_addr_1代表操作数1（全部bit）的地址，cmp_addr_2代表操作数2（单bit）的地址，一次运算的结果存储在mem[32]，即第一个 meta data 的位置
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0001000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin 
        if (SEARCH_2row == 1'b0) begin
            // 前16个 array 中的尾数处理               
            mem6[32] <= mem6[cmp_addr_1] & (mem9[cmp_addr_2]);
            mem7[32] <= mem7[cmp_addr_1] & (mem9[cmp_addr_2]);
            mem8[32] <= mem8[cmp_addr_1] & (mem9[cmp_addr_2]);
            mem9[32] <= mem9[cmp_addr_1] & (mem9[cmp_addr_2]);
            mem10[32] <= mem10[cmp_addr_1] & (mem9[cmp_addr_2]);
            mem11[32] <= mem11[cmp_addr_1] & (mem9[cmp_addr_2]);
            mem12[32] <= mem12[cmp_addr_1] & (mem9[cmp_addr_2]);
            mem13[32] <= mem13[cmp_addr_1] & (mem9[cmp_addr_2]);
            mem14[32] <= mem14[cmp_addr_1] & (mem9[cmp_addr_2]);
            mem15[32] <= mem15[cmp_addr_1] & (mem9[cmp_addr_2]);
            // 后16个 array 中的尾数处理
            mem22[32] <= mem22[cmp_addr_1] & (mem25[cmp_addr_2]);
            mem23[32] <= mem23[cmp_addr_1] & (mem25[cmp_addr_2]);
            mem24[32] <= mem24[cmp_addr_1] & (mem25[cmp_addr_2]);
            mem25[32] <= mem25[cmp_addr_1] & (mem25[cmp_addr_2]);
            mem26[32] <= mem26[cmp_addr_1] & (mem25[cmp_addr_2]);
            mem27[32] <= mem27[cmp_addr_1] & (mem25[cmp_addr_2]);
            mem28[32] <= mem28[cmp_addr_1] & (mem25[cmp_addr_2]);
            mem29[32] <= mem29[cmp_addr_1] & (mem25[cmp_addr_2]);
            mem30[32] <= mem30[cmp_addr_1] & (mem25[cmp_addr_2]);
            mem31[32] <= mem31[cmp_addr_1] & (mem25[cmp_addr_2]);
        end
    end
end

// Dataprocess_4: cmp_addr_1代表操作数1（全部bit）的地址，cmp_addr_2代表操作数2（单bit）的地址，一次运算的结果存储在mem[32]，即第一个 meta data 的位置
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000100000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin 
        if (SEARCH_2row == 1'b0) begin
            // 前16个 array 中的尾数处理               
            mem6[32] <= mem6[cmp_addr_1] & (mem10[cmp_addr_2]);
            mem7[32] <= mem7[cmp_addr_1] & (mem10[cmp_addr_2]);
            mem8[32] <= mem8[cmp_addr_1] & (mem10[cmp_addr_2]);
            mem9[32] <= mem9[cmp_addr_1] & (mem10[cmp_addr_2]);
            mem10[32] <= mem10[cmp_addr_1] & (mem10[cmp_addr_2]);
            mem11[32] <= mem11[cmp_addr_1] & (mem10[cmp_addr_2]);
            mem12[32] <= mem12[cmp_addr_1] & (mem10[cmp_addr_2]);
            mem13[32] <= mem13[cmp_addr_1] & (mem10[cmp_addr_2]);
            mem14[32] <= mem14[cmp_addr_1] & (mem10[cmp_addr_2]);
            mem15[32] <= mem15[cmp_addr_1] & (mem10[cmp_addr_2]);
            // 后16个 array 中的尾数处理
            mem22[32] <= mem22[cmp_addr_1] & (mem26[cmp_addr_2]);
            mem23[32] <= mem23[cmp_addr_1] & (mem26[cmp_addr_2]);
            mem24[32] <= mem24[cmp_addr_1] & (mem26[cmp_addr_2]);
            mem25[32] <= mem25[cmp_addr_1] & (mem26[cmp_addr_2]);
            mem26[32] <= mem26[cmp_addr_1] & (mem26[cmp_addr_2]);
            mem27[32] <= mem27[cmp_addr_1] & (mem26[cmp_addr_2]);
            mem28[32] <= mem28[cmp_addr_1] & (mem26[cmp_addr_2]);
            mem29[32] <= mem29[cmp_addr_1] & (mem26[cmp_addr_2]);
            mem30[32] <= mem30[cmp_addr_1] & (mem26[cmp_addr_2]);
            mem31[32] <= mem31[cmp_addr_1] & (mem26[cmp_addr_2]);
        end
    end
end

// Dataprocess_5: cmp_addr_1代表操作数1（全部bit）的地址，cmp_addr_2代表操作数2（单bit）的地址，一次运算的结果存储在mem[32]，即第一个 meta data 的位置
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000010000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin 
        if (SEARCH_2row == 1'b0) begin
            // 前16个 array 中的尾数处理               
            mem6[32] <= mem6[cmp_addr_1] & (mem11[cmp_addr_2]);
            mem7[32] <= mem7[cmp_addr_1] & (mem11[cmp_addr_2]);
            mem8[32] <= mem8[cmp_addr_1] & (mem11[cmp_addr_2]);
            mem9[32] <= mem9[cmp_addr_1] & (mem11[cmp_addr_2]);
            mem10[32] <= mem10[cmp_addr_1] & (mem11[cmp_addr_2]);
            mem11[32] <= mem11[cmp_addr_1] & (mem11[cmp_addr_2]);
            mem12[32] <= mem12[cmp_addr_1] & (mem11[cmp_addr_2]);
            mem13[32] <= mem13[cmp_addr_1] & (mem11[cmp_addr_2]);
            mem14[32] <= mem14[cmp_addr_1] & (mem11[cmp_addr_2]);
            mem15[32] <= mem15[cmp_addr_1] & (mem11[cmp_addr_2]);
            // 后16个 array 中的尾数处理
            mem22[32] <= mem22[cmp_addr_1] & (mem27[cmp_addr_2]);
            mem23[32] <= mem23[cmp_addr_1] & (mem27[cmp_addr_2]);
            mem24[32] <= mem24[cmp_addr_1] & (mem27[cmp_addr_2]);
            mem25[32] <= mem25[cmp_addr_1] & (mem27[cmp_addr_2]);
            mem26[32] <= mem26[cmp_addr_1] & (mem27[cmp_addr_2]);
            mem27[32] <= mem27[cmp_addr_1] & (mem27[cmp_addr_2]);
            mem28[32] <= mem28[cmp_addr_1] & (mem27[cmp_addr_2]);
            mem29[32] <= mem29[cmp_addr_1] & (mem27[cmp_addr_2]);
            mem30[32] <= mem30[cmp_addr_1] & (mem27[cmp_addr_2]);
            mem31[32] <= mem31[cmp_addr_1] & (mem27[cmp_addr_2]);
        end
    end
end

// Dataprocess_6: cmp_addr_1代表操作数1（全部bit）的地址，cmp_addr_2代表操作数2（单bit）的地址，一次运算的结果存储在mem[32]，即第一个 meta data 的位置
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000001000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin 
        if (SEARCH_2row == 1'b0) begin
            // 前16个 array 中的尾数处理               
            mem6[32] <= mem6[cmp_addr_1] & (mem12[cmp_addr_2]);
            mem7[32] <= mem7[cmp_addr_1] & (mem12[cmp_addr_2]);
            mem8[32] <= mem8[cmp_addr_1] & (mem12[cmp_addr_2]);
            mem9[32] <= mem9[cmp_addr_1] & (mem12[cmp_addr_2]);
            mem10[32] <= mem10[cmp_addr_1] & (mem12[cmp_addr_2]);
            mem11[32] <= mem11[cmp_addr_1] & (mem12[cmp_addr_2]);
            mem12[32] <= mem12[cmp_addr_1] & (mem12[cmp_addr_2]);
            mem13[32] <= mem13[cmp_addr_1] & (mem12[cmp_addr_2]);
            mem14[32] <= mem14[cmp_addr_1] & (mem12[cmp_addr_2]);
            mem15[32] <= mem15[cmp_addr_1] & (mem12[cmp_addr_2]);
            // 后16个 array 中的尾数处理
            mem22[32] <= mem22[cmp_addr_1] & (mem28[cmp_addr_2]);
            mem23[32] <= mem23[cmp_addr_1] & (mem28[cmp_addr_2]);
            mem24[32] <= mem24[cmp_addr_1] & (mem28[cmp_addr_2]);
            mem25[32] <= mem25[cmp_addr_1] & (mem28[cmp_addr_2]);
            mem26[32] <= mem26[cmp_addr_1] & (mem28[cmp_addr_2]);
            mem27[32] <= mem27[cmp_addr_1] & (mem28[cmp_addr_2]);
            mem28[32] <= mem28[cmp_addr_1] & (mem28[cmp_addr_2]);
            mem29[32] <= mem29[cmp_addr_1] & (mem28[cmp_addr_2]);
            mem30[32] <= mem30[cmp_addr_1] & (mem28[cmp_addr_2]);
            mem31[32] <= mem31[cmp_addr_1] & (mem28[cmp_addr_2]);
        end
    end
end

// Dataprocess_7: cmp_addr_1代表操作数1（全部bit）的地址，cmp_addr_2代表操作数2（单bit）的地址，一次运算的结果存储在mem[32]，即第一个 meta data 的位置
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000000100 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin 
        if (SEARCH_2row == 1'b0) begin
            // 前16个 array 中的尾数处理               
            mem6[32] <= mem6[cmp_addr_1] & (mem13[cmp_addr_2]);
            mem7[32] <= mem7[cmp_addr_1] & (mem13[cmp_addr_2]);
            mem8[32] <= mem8[cmp_addr_1] & (mem13[cmp_addr_2]);
            mem9[32] <= mem9[cmp_addr_1] & (mem13[cmp_addr_2]);
            mem10[32] <= mem10[cmp_addr_1] & (mem13[cmp_addr_2]);
            mem11[32] <= mem11[cmp_addr_1] & (mem13[cmp_addr_2]);
            mem12[32] <= mem12[cmp_addr_1] & (mem13[cmp_addr_2]);
            mem13[32] <= mem13[cmp_addr_1] & (mem13[cmp_addr_2]);
            mem14[32] <= mem14[cmp_addr_1] & (mem13[cmp_addr_2]);
            mem15[32] <= mem15[cmp_addr_1] & (mem13[cmp_addr_2]);
            // 后16个 array 中的尾数处理
            mem22[32] <= mem22[cmp_addr_1] & (mem29[cmp_addr_2]);
            mem23[32] <= mem23[cmp_addr_1] & (mem29[cmp_addr_2]);
            mem24[32] <= mem24[cmp_addr_1] & (mem29[cmp_addr_2]);
            mem25[32] <= mem25[cmp_addr_1] & (mem29[cmp_addr_2]);
            mem26[32] <= mem26[cmp_addr_1] & (mem29[cmp_addr_2]);
            mem27[32] <= mem27[cmp_addr_1] & (mem29[cmp_addr_2]);
            mem28[32] <= mem28[cmp_addr_1] & (mem29[cmp_addr_2]);
            mem29[32] <= mem29[cmp_addr_1] & (mem29[cmp_addr_2]);
            mem30[32] <= mem30[cmp_addr_1] & (mem29[cmp_addr_2]);
            mem31[32] <= mem31[cmp_addr_1] & (mem29[cmp_addr_2]);
        end
    end
end

// Dataprocess_8: cmp_addr_1代表操作数1（全部bit）的地址，cmp_addr_2代表操作数2（单bit）的地址，一次运算的结果存储在mem[32]，即第一个 meta data 的位置
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000000010 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin 
        if (SEARCH_2row == 1'b0) begin
            // 前16个 array 中的尾数处理               
            mem6[32] <= mem6[cmp_addr_1] & (mem14[cmp_addr_2]);
            mem7[32] <= mem7[cmp_addr_1] & (mem14[cmp_addr_2]);
            mem8[32] <= mem8[cmp_addr_1] & (mem14[cmp_addr_2]);
            mem9[32] <= mem9[cmp_addr_1] & (mem14[cmp_addr_2]);
            mem10[32] <= mem10[cmp_addr_1] & (mem14[cmp_addr_2]);
            mem11[32] <= mem11[cmp_addr_1] & (mem14[cmp_addr_2]);
            mem12[32] <= mem12[cmp_addr_1] & (mem14[cmp_addr_2]);
            mem13[32] <= mem13[cmp_addr_1] & (mem14[cmp_addr_2]);
            mem14[32] <= mem14[cmp_addr_1] & (mem14[cmp_addr_2]);
            mem15[32] <= mem15[cmp_addr_1] & (mem14[cmp_addr_2]);
            // 后16个 array 中的尾数处理
            mem22[32] <= mem22[cmp_addr_1] & (mem30[cmp_addr_2]);
            mem23[32] <= mem23[cmp_addr_1] & (mem30[cmp_addr_2]);
            mem24[32] <= mem24[cmp_addr_1] & (mem30[cmp_addr_2]);
            mem25[32] <= mem25[cmp_addr_1] & (mem30[cmp_addr_2]);
            mem26[32] <= mem26[cmp_addr_1] & (mem30[cmp_addr_2]);
            mem27[32] <= mem27[cmp_addr_1] & (mem30[cmp_addr_2]);
            mem28[32] <= mem28[cmp_addr_1] & (mem30[cmp_addr_2]);
            mem29[32] <= mem29[cmp_addr_1] & (mem30[cmp_addr_2]);
            mem30[32] <= mem30[cmp_addr_1] & (mem30[cmp_addr_2]);
            mem31[32] <= mem31[cmp_addr_1] & (mem30[cmp_addr_2]);
        end
    end
end

// Dataprocess_9: cmp_addr_1代表操作数1（全部bit）的地址，cmp_addr_2代表操作数2（单bit）的地址，一次运算的结果存储在mem[32]，即第一个 meta data 的位置
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000000001 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin 
        if (SEARCH_2row == 1'b0) begin
            // 前16个 array 中的尾数处理               
            mem6[32] <= mem6[cmp_addr_1] & (mem15[cmp_addr_2]);
            mem7[32] <= mem7[cmp_addr_1] & (mem15[cmp_addr_2]);
            mem8[32] <= mem8[cmp_addr_1] & (mem15[cmp_addr_2]);
            mem9[32] <= mem9[cmp_addr_1] & (mem15[cmp_addr_2]);
            mem10[32] <= mem10[cmp_addr_1] & (mem15[cmp_addr_2]);
            mem11[32] <= mem11[cmp_addr_1] & (mem15[cmp_addr_2]);
            mem12[32] <= mem12[cmp_addr_1] & (mem15[cmp_addr_2]);
            mem13[32] <= mem13[cmp_addr_1] & (mem15[cmp_addr_2]);
            mem14[32] <= mem14[cmp_addr_1] & (mem15[cmp_addr_2]);
            mem15[32] <= mem15[cmp_addr_1] & (mem15[cmp_addr_2]);
            // 后16个 array 中的尾数处理
            mem22[32] <= mem22[cmp_addr_1] & (mem31[cmp_addr_2]);
            mem23[32] <= mem23[cmp_addr_1] & (mem31[cmp_addr_2]);
            mem24[32] <= mem24[cmp_addr_1] & (mem31[cmp_addr_2]);
            mem25[32] <= mem25[cmp_addr_1] & (mem31[cmp_addr_2]);
            mem26[32] <= mem26[cmp_addr_1] & (mem31[cmp_addr_2]);
            mem27[32] <= mem27[cmp_addr_1] & (mem31[cmp_addr_2]);
            mem28[32] <= mem28[cmp_addr_1] & (mem31[cmp_addr_2]);
            mem29[32] <= mem29[cmp_addr_1] & (mem31[cmp_addr_2]);
            mem30[32] <= mem30[cmp_addr_1] & (mem31[cmp_addr_2]);
            mem31[32] <= mem31[cmp_addr_1] & (mem31[cmp_addr_2]);
        end
    end
end

// Output_0：在输出阶段将尾数第1位（最高位）送至加法器
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_1000000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin 
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem6[32][j];  // 对 mem6 第一个 meta data 行的32个元素求和
            temp_sum1 = temp_sum1 + mem22[32][j]; // 对 mem22 第一个 meta data 行的32个元素求和
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

// Output_1：在输出阶段将尾数第2位送至加法器
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0100000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin 
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem7[32][j];  // 对 mem7 第一个 meta data 行的32个元素求和
            temp_sum1 = temp_sum1 + mem23[32][j]; // 对 mem23 第一个 meta data 行的32个元素求和
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

// Output_2：在输出阶段将尾数第3位送至加法器
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0010000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin 
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem8[32][j];  // 对 mem8 第一个 meta data 行的32个元素求和
            temp_sum1 = temp_sum1 + mem24[32][j]; // 对 mem24 第一个 meta data 行的32个元素求和
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

// Output_3：在输出阶段将尾数第4位送至加法器
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0001000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin 
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem9[32][j];  // 对 mem9 第一个 meta data 行的32个元素求和
            temp_sum1 = temp_sum1 + mem25[32][j]; // 对 mem25 第一个 meta data 行的32个元素求和
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

// Output_4：在输出阶段将尾数第5位送至加法器
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000100000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin 
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem10[32][j]; // 对 mem10 第一个 meta data 行的32个元素求和
            temp_sum1 = temp_sum1 + mem26[32][j]; // 对 mem26 第一个 meta data 行的32个元素求和
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

// Output_5：在输出阶段将尾数第6位送至加法器
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000010000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin 
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem11[32][j]; // 对 mem11 第一个 meta data 行的32个元素求和
            temp_sum1 = temp_sum1 + mem27[32][j]; // 对 mem27 第一个 meta data 行的32个元素求和
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

// Output_6：在输出阶段将尾数第7位送至加法器
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000001000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin 
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem12[32][j]; // 对 mem12 第一个 meta data 行的32个元素求和
            temp_sum1 = temp_sum1 + mem28[32][j]; // 对 mem28 第一个 meta data 行的32个元素求和
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

// Output_7：在输出阶段将尾数第8位送至加法器
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000000100 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin 
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem13[32][j]; // 对 mem13 第一个 meta data 行的32个元素求和
            temp_sum1 = temp_sum1 + mem29[32][j]; // 对 mem29 第一个 meta data 行的32个元素求和
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

// Output_8：在输出阶段将尾数第9位送至加法器
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000000010 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin 
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem14[32][j]; // 对 mem14 第一个 meta data 行的32个元素求和
            temp_sum1 = temp_sum1 + mem30[32][j]; // 对 mem30 第一个 meta data 行的32个元素求和
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

// Output_9：在输出阶段将尾数第10（最低位）位送至加法器
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000000001 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin 
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem15[32][j]; // 对 mem15 第一个 meta data 行的32个元素求和
            temp_sum1 = temp_sum1 + mem31[32][j]; // 对 mem31 第一个 meta data 行的32个元素求和
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

endmodule
