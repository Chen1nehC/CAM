`timescale 1ns / 1ps

module CAM_Top_Eng (
    input  wire        rst_n,
    input  wire        CLK,
    input  wire [31:0] data_in_0,
    input  wire [31:0] data_in_1,
    input  wire [4:0]  cmp_addr_1,
    input  wire [4:0]  cmp_addr_2,
    input  wire [1:0]  ppg_addr_1,
    input  wire [1:0]  ppg_addr_2,
    input  wire [2:0]  ppg_addr_msb,
    input  wire        cmp_data_1,
    input  wire        cmp_data_2,
    input  wire        ppg_data_1,
    input  wire        ppg_data_2,
    input  wire [7:0]  exp_in_1,
    input  wire [7:0]  exp_in_2,
    input  wire [4:0]  state_ctrl, 
  /*  placement and routing
    input  wire        vref,
    input  wire        sampled,
    input  wire        preb,
    input  wire        diff,
    input  wire        SA_en,
 */
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
        5'd0: begin we = 1'b1; end // Write
        5'd1: begin FB = 1'b1; end // FB enable     
        5'd2: begin Lshift = 1'b1; end // Lshift enable       
        5'd3: begin Rshift = 1'b1; end // Rshift enable      
        5'd4: begin Ttag = 16'b00001_0000000000; Ftag = 1'b1; end // Move Esum0
        5'd5: begin Ttag = 16'b00010_0000000000; Ftag = 1'b1; end // Move Esum1
        5'd6: begin Ttag = 16'b00100_0000000000; Ftag = 1'b1; end // Move Esum2
        5'd7: begin Ttag = 16'b01000_0000000000; Ftag = 1'b1; end // Move Esum3
        5'd8: begin Ttag = 16'b10000_0000000000; Ftag = 1'b1; end // Move Esum4
        5'd9: Ttag = 16'b10000_0000000000; // Find Emax
        5'd10: begin Ttag = 16'b00000_1000000000; Ftag = 1'b1; end // Data prepare 0
        5'd11: begin Ttag = 16'b00000_0100000000; Ftag = 1'b1; end // Data prepare 1
        5'd12: begin Ttag = 16'b00000_0010000000; Ftag = 1'b1; end // Data prepare 2
        5'd13: begin Ttag = 16'b00000_0001000000; Ftag = 1'b1; end // Data prepare 3
        5'd14: begin Ttag = 16'b00000_0000100000; Ftag = 1'b1; end // Data prepare 4
        5'd15: begin Ttag = 16'b00000_0000010000; Ftag = 1'b1; end // Data prepare 5
        5'd16: begin Ttag = 16'b00000_0000001000; Ftag = 1'b1; end // Data prepare 6
        5'd17: begin Ttag = 16'b00000_0000000100; Ftag = 1'b1; end // Data prepare 7
        5'd18: begin Ttag = 16'b00000_0000000010; Ftag = 1'b1; end // Data prepare 8
        5'd19: begin Ttag = 16'b00000_0000000001; Ftag = 1'b1; end // Data prepare 9
        5'd20: Ttag = 16'b00000_1000000000; // Accumulate 0
        5'd21: Ttag = 16'b00000_0100000000; // Accumulate 1
        5'd22: Ttag = 16'b00000_0010000000; // Accumulate 2
        5'd23: Ttag = 16'b00000_0001000000; // Accumulate 3
        5'd24: Ttag = 16'b00000_0000100000; // Accumulate 4
        5'd25: Ttag = 16'b00000_0000010000; // Accumulate 5
        5'd26: Ttag = 16'b00000_0000001000; // Accumulate 6
        5'd27: Ttag = 16'b00000_0000000100; // Accumulate 7
        5'd28: Ttag = 16'b00000_0000000010; // Accumulate 8
        5'd29: Ttag = 16'b00000_0000000001; // Accumulate 9
        5'd30: begin Ttag = 16'b10000_0000000000; acc  = 1'b1; Ftag = 1'b1; end // acc + MSB to tag
        default: ; // Do nothing
    endcase
end

reg [31:0] mem0 [0:35];
reg [31:0] mem1 [0:39]; // Max exponent bits
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
reg [31:0] mem17 [0:39]; // Max exponent bits
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
// Data_0 direct input module
// 2 SIGN + 14 normal subarray
// cmp_addr_1 represents the address of the input vector, default 0 and 1
generate
    for (i = 0; i < 32; i = i + 1) begin : mem_write_block_0
        always @(posedge CLK) begin
            if (Ttag == 16'b0 && FB == 1'b0 && acc == 1'b0 && Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 && we == 1'b1 && chip_enable[i] == 1'b1) begin
                case (i)
                    0: mem0[cmp_addr_1] <= data_in_0; // sign
                    16: mem16[cmp_addr_1] <= data_in_0; // sign

                    2: mem2[cmp_addr_1] <= data_in_0; // other exponent bits
                    3: mem3[cmp_addr_1] <= data_in_0;
                    4: mem4[cmp_addr_1] <= data_in_0;
                    5: mem5[cmp_addr_1] <= data_in_0;
                    6: mem6[cmp_addr_1] <= data_in_0; // mantissa bits
                    7: mem7[cmp_addr_1] <= data_in_0;
                    8: mem8[cmp_addr_1] <= data_in_0;
                    9: mem9[cmp_addr_1] <= data_in_0;
                    10: mem10[cmp_addr_1] <= data_in_0;
                    11: mem11[cmp_addr_1] <= data_in_0;
                    12: mem12[cmp_addr_1] <= data_in_0;
                    13: mem13[cmp_addr_1] <= data_in_0;
                    14: mem14[cmp_addr_1] <= data_in_0;
                    15: mem15[cmp_addr_1] <= data_in_0;
                    default: ;
                endcase
            end
        end
    end
endgenerate

// Data_1 direct input module
// 2 MSB + 14 normal subarray
// cmp_addr_2 represents the address of the input vector, default 0 and 1
generate
    for (i = 0; i < 32; i = i + 1) begin : mem_write_block_1
        always @(posedge CLK) begin
            if (Ttag == 16'b0 && FB == 1'b0 && acc == 1'b0 && Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 && we == 1'b1 && chip_enable[i] == 1'b1) begin
                case (i)                                       
                    1: mem1[cmp_addr_2] <= data_in_1; // Max exponent bits
                    17: mem17[cmp_addr_2] <= data_in_1; // Max exponent bits
                    
                    18: mem18[cmp_addr_2] <= data_in_1; // other exponent bits
                    19: mem19[cmp_addr_2] <= data_in_1;
                    20: mem20[cmp_addr_2] <= data_in_1;
                    21: mem21[cmp_addr_2] <= data_in_1;   
                    22: mem22[cmp_addr_2] <= data_in_1; // mantissa bits
                    23: mem23[cmp_addr_2] <= data_in_1;
                    24: mem24[cmp_addr_2] <= data_in_1;
                    25: mem25[cmp_addr_2] <= data_in_1;
                    26: mem26[cmp_addr_2] <= data_in_1;
                    27: mem27[cmp_addr_2] <= data_in_1;
                    28: mem28[cmp_addr_2] <= data_in_1;
                    29: mem29[cmp_addr_2] <= data_in_1;
                    30: mem30[cmp_addr_2] <= data_in_1;
                    31: mem31[cmp_addr_2] <= data_in_1;
                    default: ;
                endcase
            end
        end
    end
endgenerate


wire [31:0] extended_cmp_data_1;
assign extended_cmp_data_1 = {32{cmp_data_1}}; // Extend cmp_data_1 to 32 bits
wire [31:0] extended_cmp_data_2;
assign extended_cmp_data_2 = {32{cmp_data_2}}; // Extend cmp_data_2 to 32 bits
wire [31:0] extended_ppg_data_1;
assign extended_ppg_data_1 = {32{ppg_data_1}}; // Extend ppg_data_1 to 32 bits
wire [31:0] extended_ppg_data_2;
assign extended_ppg_data_2 = {32{ppg_data_2}}; // Extend ppg_data_2 to 32 bits

// There are three cases for the FB section:
// 1. FB code for exponent carry, SEARCH_2row == 1'b1, mem[32] represents the stored S of the exponent bit
// 2. FB code for exponent carry, SEARCH_2row == 1'b1, mem[34] represents the final result of the exponent bit
// 3. FB code after mantissa right shift, SEARCH_2row == 1'b0, mem[32] represents MSBtotag, performing an "AND operation" can make all elements corresponding to MSBtotag = 0 become 0
generate
    for (i = 0; i < 32; i = i + 1) begin : FB_search_and_update_block
        always @(posedge CLK) begin
            if (Ttag == 16'b0 && FB == 1'b1 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0 && chip_enable[i] == 1'b1) begin 
                    if (SEARCH_2row == 1'b1 & ppg_addr_1 ==0 & ppg_addr_2 == 0) begin                            
                        case (i)
                            // The exponential carry of the first 16 subarrays (using cmp control), calculating S
                            // ppg_addr_msb = 0
                            1: mem1[ppg_addr_msb + 32] <= mem1[ppg_addr_msb + 32] | (~(mem1[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem1[cmp_addr_2] ^ extended_cmp_data_2));
                            2: mem2[ppg_addr_msb + 32] <= mem2[ppg_addr_msb + 32] | (~(mem2[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem2[cmp_addr_2] ^ extended_cmp_data_2));
                            3: mem3[ppg_addr_msb + 32] <= mem3[ppg_addr_msb + 32] | (~(mem3[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem3[cmp_addr_2] ^ extended_cmp_data_2));
                            4: mem4[ppg_addr_msb + 32] <= mem4[ppg_addr_msb + 32] | (~(mem4[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem4[cmp_addr_2] ^ extended_cmp_data_2));
                            5: mem5[ppg_addr_msb + 32] <= mem5[ppg_addr_msb + 32] | (~(mem5[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem5[cmp_addr_2] ^ extended_cmp_data_2));
                            // The exponential carry of the last 16 subarrays (using cmp control), calculates S
                            // ppg_addr_msb = 0
                            17: mem17[ppg_addr_msb + 32] <= mem17[ppg_addr_msb + 32] | (~(mem17[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem17[cmp_addr_2] ^ extended_cmp_data_2));
                            18: mem18[ppg_addr_msb + 32] <= mem18[ppg_addr_msb + 32] | (~(mem18[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem18[cmp_addr_2] ^ extended_cmp_data_2));
                            19: mem19[ppg_addr_msb + 32] <= mem19[ppg_addr_msb + 32] | (~(mem19[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem19[cmp_addr_2] ^ extended_cmp_data_2));
                            20: mem20[ppg_addr_msb + 32] <= mem20[ppg_addr_msb + 32] | (~(mem20[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem20[cmp_addr_2] ^ extended_cmp_data_2));
                            21: mem21[ppg_addr_msb + 32] <= mem21[ppg_addr_msb + 32] | (~(mem21[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem21[cmp_addr_2] ^ extended_cmp_data_2));
                            default: ;
                        endcase
                    end
                    if (SEARCH_2row == 1'b1 & cmp_addr_1 ==0 & cmp_addr_2 == 0) begin                            
                        case (i)
                            // The exponential carry of the first 16 subarrays (using ppg control), computed using C and S
                            // ppg_addr_msb = 2
                            1: mem1[ppg_addr_msb + 32] <= mem1[ppg_addr_msb + 32] | (~(mem1[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem1[ppg_addr_2+32] ^ extended_ppg_data_2));
                            2: mem2[ppg_addr_msb + 32] <= mem2[ppg_addr_msb + 32] | (~(mem2[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem2[ppg_addr_2+32] ^ extended_ppg_data_2));
                            3: mem3[ppg_addr_msb + 32] <= mem3[ppg_addr_msb + 32] | (~(mem3[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem3[ppg_addr_2+32] ^ extended_ppg_data_2));
                            4: mem4[ppg_addr_msb + 32] <= mem4[ppg_addr_msb + 32] | (~(mem4[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem4[ppg_addr_2+32] ^ extended_ppg_data_2));
                            5: mem5[ppg_addr_msb + 32] <= mem5[ppg_addr_msb + 32] | (~(mem5[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem5[ppg_addr_2+32] ^ extended_ppg_data_2));
                            // The exponential carry of the last 16 subarrays (using ppg control) is computed using C and S
                            // ppg_addr_msb = 2
                            17: mem17[ppg_addr_msb + 32] <= mem17[ppg_addr_msb + 32] | (~(mem17[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem17[ppg_addr_2+32] ^ extended_ppg_data_2));
                            18: mem18[ppg_addr_msb + 32] <= mem18[ppg_addr_msb + 32] | (~(mem18[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem18[ppg_addr_2+32] ^ extended_ppg_data_2));
                            19: mem19[ppg_addr_msb + 32] <= mem19[ppg_addr_msb + 32] | (~(mem19[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem19[ppg_addr_2+32] ^ extended_ppg_data_2));
                            20: mem20[ppg_addr_msb + 32] <= mem20[ppg_addr_msb + 32] | (~(mem20[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem20[ppg_addr_2+32] ^ extended_ppg_data_2));
                            21: mem21[ppg_addr_msb + 32] <= mem21[ppg_addr_msb + 32] | (~(mem21[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem21[ppg_addr_2+32] ^ extended_ppg_data_2));
                            default: ;
                        endcase
                    end
                    if (SEARCH_2row == 1'b0) begin
                        case (i) 
                            // After the mantissa of the first 16 subarrays is shifted, elements whose exponent is too small are cleared
                            // ppg_addr_msb = 0
                            6: mem6[cmp_addr_1] <= mem6[cmp_addr_1] & mem6[ppg_addr_msb + 32];
                            7: mem7[cmp_addr_1] <= mem7[cmp_addr_1] & mem7[ppg_addr_msb + 32];
                            8: mem8[cmp_addr_1] <= mem8[cmp_addr_1] & mem8[ppg_addr_msb + 32];
                            9: mem9[cmp_addr_1] <= mem9[cmp_addr_1] & mem9[ppg_addr_msb + 32];
                            10: mem10[cmp_addr_1] <= mem10[cmp_addr_1] & mem10[ppg_addr_msb + 32];
                            11: mem11[cmp_addr_1] <= mem11[cmp_addr_1] & mem11[ppg_addr_msb + 32];
                            12: mem12[cmp_addr_1] <= mem12[cmp_addr_1] & mem12[ppg_addr_msb + 32];
                            13: mem13[cmp_addr_1] <= mem13[cmp_addr_1] & mem13[ppg_addr_msb + 32];
                            14: mem14[cmp_addr_1] <= mem14[cmp_addr_1] & mem14[ppg_addr_msb + 32];
                            15: mem15[cmp_addr_1] <= mem15[cmp_addr_1] & mem15[ppg_addr_msb + 32];
                            // The mantissa of the last 16 subarrays is shifted to remove elements with too small an exponent  
                            // ppg_addr_msb = 0              
                            22: mem22[cmp_addr_1] <= mem22[cmp_addr_1] & mem22[ppg_addr_msb + 32];
                            23: mem23[cmp_addr_1] <= mem23[cmp_addr_1] & mem23[ppg_addr_msb + 32];
                            24: mem24[cmp_addr_1] <= mem24[cmp_addr_1] & mem24[ppg_addr_msb + 32];
                            25: mem25[cmp_addr_1] <= mem25[cmp_addr_1] & mem25[ppg_addr_msb + 32];
                            26: mem26[cmp_addr_1] <= mem26[cmp_addr_1] & mem26[ppg_addr_msb + 32];
                            27: mem27[cmp_addr_1] <= mem27[cmp_addr_1] & mem27[ppg_addr_msb + 32];
                            28: mem28[cmp_addr_1] <= mem28[cmp_addr_1] & mem28[ppg_addr_msb + 32];
                            29: mem29[cmp_addr_1] <= mem29[cmp_addr_1] & mem29[ppg_addr_msb + 32];
                            30: mem30[cmp_addr_1] <= mem30[cmp_addr_1] & mem30[ppg_addr_msb + 32];
                            31: mem31[cmp_addr_1] <= mem31[cmp_addr_1] & mem31[ppg_addr_msb + 32];
                            default: ;
                        endcase
                    end 
            end
        end
    end
endgenerate

// Left shift code for exponential carry, mem[33] stands for C where exponential bits are stored
// cmp_addr_1 and cmp_addr_2 are 0 and 1 by default
generate
    for (i = 0; i < 32; i = i + 1) begin : L_search_and_update_block
        always @(posedge CLK) begin 
            if (Ttag == 16'b0 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b1 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0 && chip_enable[i] == 1'b1) begin 
                    if (SEARCH_2row == 1'b1 & ppg_addr_1 ==0 & ppg_addr_2 == 0) begin                            
                        case (i) 
                            // ppg_addr_msb = 1  
                            2: mem1[ppg_addr_msb + 32] <= mem1[ppg_addr_msb + 32] | (~(mem2[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem2[cmp_addr_2] ^ extended_cmp_data_2));
                            3: mem2[ppg_addr_msb + 32] <= mem2[ppg_addr_msb + 32] | (~(mem3[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem3[cmp_addr_2] ^ extended_cmp_data_2));
                            4: mem3[ppg_addr_msb + 32] <= mem3[ppg_addr_msb + 32] | (~(mem4[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem4[cmp_addr_2] ^ extended_cmp_data_2));
                            5: mem4[ppg_addr_msb + 32] <= mem4[ppg_addr_msb + 32] | (~(mem5[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem5[cmp_addr_2] ^ extended_cmp_data_2));
                            // ppg_addr_msb = 1 
                            18: mem17[ppg_addr_msb + 32] <= mem17[ppg_addr_msb + 32] | (~(mem18[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem18[cmp_addr_2] ^ extended_cmp_data_2));
                            19: mem18[ppg_addr_msb + 32] <= mem18[ppg_addr_msb + 32] | (~(mem19[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem19[cmp_addr_2] ^ extended_cmp_data_2));
                            20: mem19[ppg_addr_msb + 32] <= mem19[ppg_addr_msb + 32] | (~(mem20[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem20[cmp_addr_2] ^ extended_cmp_data_2));
                            21: mem20[ppg_addr_msb + 32] <= mem20[ppg_addr_msb + 32] | (~(mem21[cmp_addr_1] ^ extended_cmp_data_1)) & (~(mem21[cmp_addr_2] ^ extended_cmp_data_2));
                            default: ;
                        endcase
                    end
                    if (SEARCH_2row == 1'b1 & cmp_addr_1 ==0 & cmp_addr_2 == 0) begin                            
                        case (i)
                            // ppg_addr_msb = 1 
                            2: mem1[ppg_addr_msb + 32] <= mem1[ppg_addr_msb + 32] | (~(mem2[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem2[ppg_addr_2+32] ^ extended_ppg_data_2));
                            3: mem2[ppg_addr_msb + 32] <= mem2[ppg_addr_msb + 32] | (~(mem3[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem3[ppg_addr_2+32] ^ extended_ppg_data_2));
                            4: mem3[ppg_addr_msb + 32] <= mem3[ppg_addr_msb + 32] | (~(mem4[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem4[ppg_addr_2+32] ^ extended_ppg_data_2));
                            5: mem4[ppg_addr_msb + 32] <= mem4[ppg_addr_msb + 32] | (~(mem5[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem5[ppg_addr_2+32] ^ extended_ppg_data_2));
                            // ppg_addr_msb = 1 
                            18: mem17[ppg_addr_msb + 32] <= mem17[ppg_addr_msb + 32] | (~(mem18[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem18[ppg_addr_2+32] ^ extended_ppg_data_2));
                            19: mem18[ppg_addr_msb + 32] <= mem18[ppg_addr_msb + 32] | (~(mem19[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem19[ppg_addr_2+32] ^ extended_ppg_data_2));
                            20: mem19[ppg_addr_msb + 32] <= mem19[ppg_addr_msb + 32] | (~(mem20[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem20[ppg_addr_2+32] ^ extended_ppg_data_2));
                            21: mem20[ppg_addr_msb + 32] <= mem20[ppg_addr_msb + 32] | (~(mem21[ppg_addr_1+32] ^ extended_ppg_data_1)) & (~(mem21[ppg_addr_2+32] ^ extended_ppg_data_2));
                            default: ;
                        endcase
                    end                    
            end
        end
    end
endgenerate

// Code for mantissa right shift, MSBtotag has been stored in advance in the first meta data of all mantissa subarrays, keeping the standard element if mem[32]=0, and entering the high data if mem[32]=1
// cmp_addr_1 defaults to 0 because only elements in vector 1 are shifted
generate
    for (i = 0; i < 32; i = i + 1) begin : R_search_and_update_block
        always @(posedge CLK) begin
            if (Ttag == 16'b0 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b1 && Ftag == 1'b0 &&we == 1'b0 && chip_enable[i] == 1'b1) begin 
                if (SEARCH_2row == 1'b1) begin                            
                    case (i) 
                        // The first set of mantissa shifts
                        // ppg_addr_msb = 0 
                        5: mem6[cmp_addr_1] <= mem6[cmp_addr_1] & (~mem6[ppg_addr_msb + 32]);
                        6: mem7[cmp_addr_1] <= (mem7[cmp_addr_1] & (~mem6[ppg_addr_msb + 32])) + (mem6[cmp_addr_1] & mem6[ppg_addr_msb + 32]);
                        7: mem8[cmp_addr_1] <= (mem8[cmp_addr_1] & (~mem7[ppg_addr_msb + 32])) + (mem7[cmp_addr_1] & mem7[ppg_addr_msb + 32]);
                        8: mem9[cmp_addr_1] <= (mem9[cmp_addr_1] & (~mem8[ppg_addr_msb + 32])) + (mem8[cmp_addr_1] & mem8[ppg_addr_msb + 32]);
                        9: mem10[cmp_addr_1] <= (mem10[cmp_addr_1] & (~mem9[ppg_addr_msb + 32])) + (mem9[cmp_addr_1] & mem9[ppg_addr_msb + 32]);
                        10: mem11[cmp_addr_1] <= (mem11[cmp_addr_1] & (~mem10[ppg_addr_msb + 32])) + (mem10[cmp_addr_1] & mem10[ppg_addr_msb + 32]);
                        11: mem12[cmp_addr_1] <= (mem12[cmp_addr_1] & (~mem11[ppg_addr_msb + 32])) + (mem11[cmp_addr_1] & mem11[ppg_addr_msb + 32]);
                        12: mem13[cmp_addr_1] <= (mem13[cmp_addr_1] & (~mem12[ppg_addr_msb + 32])) + (mem12[cmp_addr_1] & mem12[ppg_addr_msb + 32]);
                        13: mem14[cmp_addr_1] <= (mem14[cmp_addr_1] & (~mem13[ppg_addr_msb + 32])) + (mem13[cmp_addr_1] & mem13[ppg_addr_msb + 32]);
                        14: mem15[cmp_addr_1] <= (mem15[cmp_addr_1] & (~mem14[ppg_addr_msb + 32])) + (mem14[cmp_addr_1] & mem14[ppg_addr_msb + 32]);
                        // The second set of mantissa shifts    
                        // ppg_addr_msb = 0                        
                        21: mem22[cmp_addr_1] <= mem22[cmp_addr_1] & (~mem22[ppg_addr_msb + 32]);
                        22: mem23[cmp_addr_1] <= (mem23[cmp_addr_1] & (~mem22[ppg_addr_msb + 32])) + (mem22[cmp_addr_1] & mem22[ppg_addr_msb + 32]);
                        23: mem24[cmp_addr_1] <= (mem24[cmp_addr_1] & (~mem23[ppg_addr_msb + 32])) + (mem23[cmp_addr_1] & mem23[ppg_addr_msb + 32]);
                        24: mem25[cmp_addr_1] <= (mem25[cmp_addr_1] & (~mem24[ppg_addr_msb + 32])) + (mem24[cmp_addr_1] & mem24[ppg_addr_msb + 32]);
                        25: mem26[cmp_addr_1] <= (mem26[cmp_addr_1] & (~mem25[ppg_addr_msb + 32])) + (mem25[cmp_addr_1] & mem25[ppg_addr_msb + 32]);
                        26: mem27[cmp_addr_1] <= (mem27[cmp_addr_1] & (~mem26[ppg_addr_msb + 32])) + (mem26[cmp_addr_1] & mem26[ppg_addr_msb + 32]);
                        27: mem28[cmp_addr_1] <= (mem28[cmp_addr_1] & (~mem27[ppg_addr_msb + 32])) + (mem27[cmp_addr_1] & mem27[ppg_addr_msb + 32]);
                        28: mem29[cmp_addr_1] <= (mem29[cmp_addr_1] & (~mem28[ppg_addr_msb + 32])) + (mem28[cmp_addr_1] & mem28[ppg_addr_msb + 32]);
                        29: mem30[cmp_addr_1] <= (mem30[cmp_addr_1] & (~mem29[ppg_addr_msb + 32])) + (mem29[cmp_addr_1] & mem29[ppg_addr_msb + 32]);
                        30: mem31[cmp_addr_1] <= (mem31[cmp_addr_1] & (~mem30[ppg_addr_msb + 32])) + (mem30[cmp_addr_1] & mem30[ppg_addr_msb + 32]);
                        default: ;
                    endcase
                end
            end
        end
    end
endgenerate

// Esum0_shift: Stores the lowest exponent into the highest digit meta data
// ppg_addr_msb = 2
always @(posedge CLK) begin
    if (Ttag == 16'b0_00001_0000000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin                            
            mem1[36] <= mem5[ppg_addr_msb + 32];
            mem17[36] <= mem21[ppg_addr_msb + 32];
    end
end
    

// Esum1_shift: Stores the second-to-last digit of the index into the highest-digit meta data
// ppg_addr_msb = 2
always @(posedge CLK) begin
    if (Ttag == 16'b0_00010_0000000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin                            
            mem1[35] <= mem4[ppg_addr_msb + 32];
            mem17[35] <= mem20[ppg_addr_msb + 32];
    end
end

// Esum2_shift: Stores the third-to-last digit of the index into the highest-digit meta data
// ppg_addr_msb = 2
always @(posedge CLK) begin
    if (Ttag == 16'b0_00100_0000000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin                            
            mem1[34] <= mem3[ppg_addr_msb + 32];
            mem17[34] <= mem19[ppg_addr_msb + 32];
    end
end

// Esum3_shift: Stores the fourth digit from the bottom of the index into the highest digit meta data
// ppg_addr_msb = 2
always @(posedge CLK) begin
    if (Ttag == 16'b0_01000_0000000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin                            
            mem1[33] <= mem2[ppg_addr_msb + 32];
            mem17[33] <= mem18[ppg_addr_msb + 32];
    end
end

// Esum4_shift: Stores the highest digit of the index into the highest digit meta data
// ppg_addr_msb = 2
always @(posedge CLK) begin
    if (Ttag == 16'b0_10000_0000000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin                            
            mem1[32] <= mem1[ppg_addr_msb + 32];
            mem17[32] <= mem17[ppg_addr_msb + 32];
    end
end

// Find_Emax: Outputs the meta data with the highest exponent digit to find the maximum exponent value
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

// Acc and MSBtotag: The tag bit should be stored in the meta data of each mantissa when the index part is searched. This process should use "or gate".
// exp_in_1 and exp_in_2 indicate the entered index values to be searched
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
        // Process MSBtotag_1 and store it in the mantissa column of the first 16 array, in the location of the first meta data
        // ppg_addr_msb = 0
        MSBtotag_1 <= MSBtotag_1 | (~(mem1[32] ^ extended_exp_in_1_bit4)) & (~(mem1[33] ^ extended_exp_in_1_bit3)) & (~(mem1[34] ^ extended_exp_in_1_bit2)) & (~(mem1[35] ^ extended_exp_in_1_bit1)) & (~(mem1[36] ^ extended_exp_in_1_bit0));
        mem6[ppg_addr_msb + 32] <= MSBtotag_1; mem7[ppg_addr_msb + 32] <= MSBtotag_1; mem8[ppg_addr_msb + 32] <= MSBtotag_1; mem9[ppg_addr_msb + 32] <= MSBtotag_1; mem10[ppg_addr_msb + 32] <= MSBtotag_1;
        mem11[ppg_addr_msb + 32] <= MSBtotag_1; mem12[ppg_addr_msb + 32] <= MSBtotag_1; mem13[ppg_addr_msb + 32] <= MSBtotag_1; mem14[ppg_addr_msb + 32] <= MSBtotag_1; mem15[ppg_addr_msb + 32] <= MSBtotag_1; 
        
        // Process MSBtotag_2 and store it in the mantissa whole column of the last 16 array, in the location of the first meta data
        // ppg_addr_msb = 0        
        MSBtotag_2 <= MSBtotag_2 | (~(mem17[32] ^ extended_exp_in_2_bit4)) & (~(mem17[33] ^ extended_exp_in_2_bit3)) & (~(mem17[34] ^ extended_exp_in_2_bit2)) & (~(mem17[35] ^ extended_exp_in_2_bit1)) & (~(mem17[36] ^ extended_exp_in_2_bit0));
        mem22[ppg_addr_msb + 32] <= MSBtotag_2; mem23[ppg_addr_msb + 32] <= MSBtotag_2; mem24[ppg_addr_msb + 32] <= MSBtotag_2; mem25[ppg_addr_msb + 32] <= MSBtotag_2; mem26[ppg_addr_msb + 32] <= MSBtotag_2;
        mem27[ppg_addr_msb + 32] <= MSBtotag_2; mem28[ppg_addr_msb + 32] <= MSBtotag_2; mem29[ppg_addr_msb + 32] <= MSBtotag_2; mem30[ppg_addr_msb + 32] <= MSBtotag_2; mem31[ppg_addr_msb + 32] <= MSBtotag_2;
    end
end

// Dataprocess_0: cmp_addr_1 represents the address of operand 1 (all bits), cmp_addr_2 represents the address of operand 2 (single bit), and the result of one operation is stored in mem[32], the location of the first meta data
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_1000000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin 
        if (SEARCH_2row == 1'b0) begin
            // Mantissa processing in the first 16 arrays           
            // ppg_addr_msb = 0    
            mem6[ppg_addr_msb + 32] <= mem6[cmp_addr_1] & (mem6[cmp_addr_2]);
            mem7[ppg_addr_msb + 32] <= mem7[cmp_addr_1] & (mem6[cmp_addr_2]);
            mem8[ppg_addr_msb + 32] <= mem8[cmp_addr_1] & (mem6[cmp_addr_2]);
            mem9[ppg_addr_msb + 32] <= mem9[cmp_addr_1] & (mem6[cmp_addr_2]);
            mem10[ppg_addr_msb + 32] <= mem10[cmp_addr_1] & (mem6[cmp_addr_2]);
            mem11[ppg_addr_msb + 32] <= mem11[cmp_addr_1] & (mem6[cmp_addr_2]);
            mem12[ppg_addr_msb + 32] <= mem12[cmp_addr_1] & (mem6[cmp_addr_2]);
            mem13[ppg_addr_msb + 32] <= mem13[cmp_addr_1] & (mem6[cmp_addr_2]);
            mem14[ppg_addr_msb + 32] <= mem14[cmp_addr_1] & (mem6[cmp_addr_2]);
            mem15[ppg_addr_msb + 32] <= mem15[cmp_addr_1] & (mem6[cmp_addr_2]);
            // Mantissa in the last 16 arrays are processed
            mem22[ppg_addr_msb + 32] <= mem22[cmp_addr_1] & (mem22[cmp_addr_2]);
            mem23[ppg_addr_msb + 32] <= mem23[cmp_addr_1] & (mem22[cmp_addr_2]);
            mem24[ppg_addr_msb + 32] <= mem24[cmp_addr_1] & (mem22[cmp_addr_2]);
            mem25[ppg_addr_msb + 32] <= mem25[cmp_addr_1] & (mem22[cmp_addr_2]);
            mem26[ppg_addr_msb + 32] <= mem26[cmp_addr_1] & (mem22[cmp_addr_2]);
            mem27[ppg_addr_msb + 32] <= mem27[cmp_addr_1] & (mem22[cmp_addr_2]);
            mem28[ppg_addr_msb + 32] <= mem28[cmp_addr_1] & (mem22[cmp_addr_2]);
            mem29[ppg_addr_msb + 32] <= mem29[cmp_addr_1] & (mem22[cmp_addr_2]);
            mem30[ppg_addr_msb + 32] <= mem30[cmp_addr_1] & (mem22[cmp_addr_2]);
            mem31[ppg_addr_msb + 32] <= mem31[cmp_addr_1] & (mem22[cmp_addr_2]);
        end
    end
end


// Dataprocess_1: cmp_addr_1 represents the address of operand 1 (all bits) and cmp_addr_2 represents the address of operand 2 (single bits).The result of one operation is stored in mem[32], which is the location of the first meta data
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0100000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin 
        if (SEARCH_2row == 1'b0) begin
            // mantissa processing in the first 16 arrays               
            mem6[ppg_addr_msb + 32] <= mem6[cmp_addr_1] & (mem7[cmp_addr_2]);
            mem7[ppg_addr_msb + 32] <= mem7[cmp_addr_1] & (mem7[cmp_addr_2]);
            mem8[ppg_addr_msb + 32] <= mem8[cmp_addr_1] & (mem7[cmp_addr_2]);
            mem9[ppg_addr_msb + 32] <= mem9[cmp_addr_1] & (mem7[cmp_addr_2]);
            mem10[ppg_addr_msb + 32] <= mem10[cmp_addr_1] & (mem7[cmp_addr_2]);
            mem11[ppg_addr_msb + 32] <= mem11[cmp_addr_1] & (mem7[cmp_addr_2]);
            mem12[ppg_addr_msb + 32] <= mem12[cmp_addr_1] & (mem7[cmp_addr_2]);
            mem13[ppg_addr_msb + 32] <= mem13[cmp_addr_1] & (mem7[cmp_addr_2]);
            mem14[ppg_addr_msb + 32] <= mem14[cmp_addr_1] & (mem7[cmp_addr_2]);
            mem15[ppg_addr_msb + 32] <= mem15[cmp_addr_1] & (mem7[cmp_addr_2]);
            // mantissa processing in the last 16 arrays
            mem22[ppg_addr_msb + 32] <= mem22[cmp_addr_1] & (mem23[cmp_addr_2]);
            mem23[ppg_addr_msb + 32] <= mem23[cmp_addr_1] & (mem23[cmp_addr_2]);
            mem24[ppg_addr_msb + 32] <= mem24[cmp_addr_1] & (mem23[cmp_addr_2]);
            mem25[ppg_addr_msb + 32] <= mem25[cmp_addr_1] & (mem23[cmp_addr_2]);
            mem26[ppg_addr_msb + 32] <= mem26[cmp_addr_1] & (mem23[cmp_addr_2]);
            mem27[ppg_addr_msb + 32] <= mem27[cmp_addr_1] & (mem23[cmp_addr_2]);
            mem28[ppg_addr_msb + 32] <= mem28[cmp_addr_1] & (mem23[cmp_addr_2]);
            mem29[ppg_addr_msb + 32] <= mem29[cmp_addr_1] & (mem23[cmp_addr_2]);
            mem30[ppg_addr_msb + 32] <= mem30[cmp_addr_1] & (mem23[cmp_addr_2]);
            mem31[ppg_addr_msb + 32] <= mem31[cmp_addr_1] & (mem23[cmp_addr_2]);
        end
    end
end

// Dataprocess_2: cmp_addr_1 is the address of operand 1 (all bits), cmp_addr_2 is the address of operand 2 (single bit), and the result of an operation is stored in mem[32], which is the location of the first meta data
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0010000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin 
        if (SEARCH_2row == 1'b0) begin
            // mantissa processing in the first 16 arrays               
            mem6[ppg_addr_msb + 32] <= mem6[cmp_addr_1] & (mem8[cmp_addr_2]);
            mem7[ppg_addr_msb + 32] <= mem7[cmp_addr_1] & (mem8[cmp_addr_2]);
            mem8[ppg_addr_msb + 32] <= mem8[cmp_addr_1] & (mem8[cmp_addr_2]);
            mem9[ppg_addr_msb + 32] <= mem9[cmp_addr_1] & (mem8[cmp_addr_2]);
            mem10[ppg_addr_msb + 32] <= mem10[cmp_addr_1] & (mem8[cmp_addr_2]);
            mem11[ppg_addr_msb + 32] <= mem11[cmp_addr_1] & (mem8[cmp_addr_2]);
            mem12[ppg_addr_msb + 32] <= mem12[cmp_addr_1] & (mem8[cmp_addr_2]);
            mem13[ppg_addr_msb + 32] <= mem13[cmp_addr_1] & (mem8[cmp_addr_2]);
            mem14[ppg_addr_msb + 32] <= mem14[cmp_addr_1] & (mem8[cmp_addr_2]);
            mem15[ppg_addr_msb + 32] <= mem15[cmp_addr_1] & (mem8[cmp_addr_2]);
            // mantissa processing in the last 16 arrays
            mem22[ppg_addr_msb + 32] <= mem22[cmp_addr_1] & (mem24[cmp_addr_2]);
            mem23[ppg_addr_msb + 32] <= mem23[cmp_addr_1] & (mem24[cmp_addr_2]);
            mem24[ppg_addr_msb + 32] <= mem24[cmp_addr_1] & (mem24[cmp_addr_2]);
            mem25[ppg_addr_msb + 32] <= mem25[cmp_addr_1] & (mem24[cmp_addr_2]);
            mem26[ppg_addr_msb + 32] <= mem26[cmp_addr_1] & (mem24[cmp_addr_2]);
            mem27[ppg_addr_msb + 32] <= mem27[cmp_addr_1] & (mem24[cmp_addr_2]);
            mem28[ppg_addr_msb + 32] <= mem28[cmp_addr_1] & (mem24[cmp_addr_2]);
            mem29[ppg_addr_msb + 32] <= mem29[cmp_addr_1] & (mem24[cmp_addr_2]);
            mem30[ppg_addr_msb + 32] <= mem30[cmp_addr_1] & (mem24[cmp_addr_2]);
            mem31[ppg_addr_msb + 32] <= mem31[cmp_addr_1] & (mem24[cmp_addr_2]);
        end
    end
end

// Dataprocess_3: cmp_addr_1 is the address of operand 1 (all bits), cmp_addr_2 is the address of operand 2 (single bit), and the result of one operation is stored in mem[32], which is the location of the first meta data
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0001000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin 
        if (SEARCH_2row == 1'b0) begin
            // mantissa processing in the first 16 arrays       
            mem6[ppg_addr_msb + 32] <= mem6[cmp_addr_1] & (mem9[cmp_addr_2]);
            mem7[ppg_addr_msb + 32] <= mem7[cmp_addr_1] & (mem9[cmp_addr_2]);
            mem8[ppg_addr_msb + 32] <= mem8[cmp_addr_1] & (mem9[cmp_addr_2]);
            mem9[ppg_addr_msb + 32] <= mem9[cmp_addr_1] & (mem9[cmp_addr_2]);
            mem10[ppg_addr_msb + 32] <= mem10[cmp_addr_1] & (mem9[cmp_addr_2]);
            mem11[ppg_addr_msb + 32] <= mem11[cmp_addr_1] & (mem9[cmp_addr_2]);
            mem12[ppg_addr_msb + 32] <= mem12[cmp_addr_1] & (mem9[cmp_addr_2]);
            mem13[ppg_addr_msb + 32] <= mem13[cmp_addr_1] & (mem9[cmp_addr_2]);
            mem14[ppg_addr_msb + 32] <= mem14[cmp_addr_1] & (mem9[cmp_addr_2]);
            mem15[ppg_addr_msb + 32] <= mem15[cmp_addr_1] & (mem9[cmp_addr_2]);
            // mantissa processing in the last 16 arrays
            mem22[ppg_addr_msb + 32] <= mem22[cmp_addr_1] & (mem25[cmp_addr_2]);
            mem23[ppg_addr_msb + 32] <= mem23[cmp_addr_1] & (mem25[cmp_addr_2]);
            mem24[ppg_addr_msb + 32] <= mem24[cmp_addr_1] & (mem25[cmp_addr_2]);
            mem25[ppg_addr_msb + 32] <= mem25[cmp_addr_1] & (mem25[cmp_addr_2]);
            mem26[ppg_addr_msb + 32] <= mem26[cmp_addr_1] & (mem25[cmp_addr_2]);
            mem27[ppg_addr_msb + 32] <= mem27[cmp_addr_1] & (mem25[cmp_addr_2]);
            mem28[ppg_addr_msb + 32] <= mem28[cmp_addr_1] & (mem25[cmp_addr_2]);
            mem29[ppg_addr_msb + 32] <= mem29[cmp_addr_1] & (mem25[cmp_addr_2]);
            mem30[ppg_addr_msb + 32] <= mem30[cmp_addr_1] & (mem25[cmp_addr_2]);
            mem31[ppg_addr_msb + 32] <= mem31[cmp_addr_1] & (mem25[cmp_addr_2]);
        end
    end
end

// Dataprocess_4: cmp_addr_1 is the address of operand 1 (all bits), cmp_addr_2 is the address of operand 2 (single bit), and the result of one operation is stored in mem[32], which is the location of the first meta data
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000100000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin 
        if (SEARCH_2row == 1'b0) begin
            // mantissa processing in the first 16 arrays
            mem6[ppg_addr_msb + 32] <= mem6[cmp_addr_1] & (mem10[cmp_addr_2]);
            mem7[ppg_addr_msb + 32] <= mem7[cmp_addr_1] & (mem10[cmp_addr_2]);
            mem8[ppg_addr_msb + 32] <= mem8[cmp_addr_1] & (mem10[cmp_addr_2]);
            mem9[ppg_addr_msb + 32] <= mem9[cmp_addr_1] & (mem10[cmp_addr_2]);
            mem10[ppg_addr_msb + 32] <= mem10[cmp_addr_1] & (mem10[cmp_addr_2]);
            mem11[ppg_addr_msb + 32] <= mem11[cmp_addr_1] & (mem10[cmp_addr_2]);
            mem12[ppg_addr_msb + 32] <= mem12[cmp_addr_1] & (mem10[cmp_addr_2]);
            mem13[ppg_addr_msb + 32] <= mem13[cmp_addr_1] & (mem10[cmp_addr_2]);
            mem14[ppg_addr_msb + 32] <= mem14[cmp_addr_1] & (mem10[cmp_addr_2]);
            mem15[ppg_addr_msb + 32] <= mem15[cmp_addr_1] & (mem10[cmp_addr_2]);
            // mantissa processing in the last 16 arrays
            mem22[ppg_addr_msb + 32] <= mem22[cmp_addr_1] & (mem26[cmp_addr_2]);
            mem23[ppg_addr_msb + 32] <= mem23[cmp_addr_1] & (mem26[cmp_addr_2]);
            mem24[ppg_addr_msb + 32] <= mem24[cmp_addr_1] & (mem26[cmp_addr_2]);
            mem25[ppg_addr_msb + 32] <= mem25[cmp_addr_1] & (mem26[cmp_addr_2]);
            mem26[ppg_addr_msb + 32] <= mem26[cmp_addr_1] & (mem26[cmp_addr_2]);
            mem27[ppg_addr_msb + 32] <= mem27[cmp_addr_1] & (mem26[cmp_addr_2]);
            mem28[ppg_addr_msb + 32] <= mem28[cmp_addr_1] & (mem26[cmp_addr_2]);
            mem29[ppg_addr_msb + 32] <= mem29[cmp_addr_1] & (mem26[cmp_addr_2]);
            mem30[ppg_addr_msb + 32] <= mem30[cmp_addr_1] & (mem26[cmp_addr_2]);
            mem31[ppg_addr_msb + 32] <= mem31[cmp_addr_1] & (mem26[cmp_addr_2]);
        end
    end
end

// Dataprocess_5: cmp_addr_1 is the address of operand 1 (all bits), cmp_addr_2 is the address of operand 2 (single bit), and the result of one operation is stored in mem[32], which is the location of the first meta data
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000010000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin 
        if (SEARCH_2row == 1'b0) begin
            // mantissa processing in the first 16 arrays 
            mem6[ppg_addr_msb + 32] <= mem6[cmp_addr_1] & (mem11[cmp_addr_2]);
            mem7[ppg_addr_msb + 32] <= mem7[cmp_addr_1] & (mem11[cmp_addr_2]);
            mem8[ppg_addr_msb + 32] <= mem8[cmp_addr_1] & (mem11[cmp_addr_2]);
            mem9[ppg_addr_msb + 32] <= mem9[cmp_addr_1] & (mem11[cmp_addr_2]);
            mem10[ppg_addr_msb + 32] <= mem10[cmp_addr_1] & (mem11[cmp_addr_2]);
            mem11[ppg_addr_msb + 32] <= mem11[cmp_addr_1] & (mem11[cmp_addr_2]);
            mem12[ppg_addr_msb + 32] <= mem12[cmp_addr_1] & (mem11[cmp_addr_2]);
            mem13[ppg_addr_msb + 32] <= mem13[cmp_addr_1] & (mem11[cmp_addr_2]);
            mem14[ppg_addr_msb + 32] <= mem14[cmp_addr_1] & (mem11[cmp_addr_2]);
            mem15[ppg_addr_msb + 32] <= mem15[cmp_addr_1] & (mem11[cmp_addr_2]);
            // mantissa processing in the last 16 arrays
            mem22[ppg_addr_msb + 32] <= mem22[cmp_addr_1] & (mem27[cmp_addr_2]);
            mem23[ppg_addr_msb + 32] <= mem23[cmp_addr_1] & (mem27[cmp_addr_2]);
            mem24[ppg_addr_msb + 32] <= mem24[cmp_addr_1] & (mem27[cmp_addr_2]);
            mem25[ppg_addr_msb + 32] <= mem25[cmp_addr_1] & (mem27[cmp_addr_2]);
            mem26[ppg_addr_msb + 32] <= mem26[cmp_addr_1] & (mem27[cmp_addr_2]);
            mem27[ppg_addr_msb + 32] <= mem27[cmp_addr_1] & (mem27[cmp_addr_2]);
            mem28[ppg_addr_msb + 32] <= mem28[cmp_addr_1] & (mem27[cmp_addr_2]);
            mem29[ppg_addr_msb + 32] <= mem29[cmp_addr_1] & (mem27[cmp_addr_2]);
            mem30[ppg_addr_msb + 32] <= mem30[cmp_addr_1] & (mem27[cmp_addr_2]);
            mem31[ppg_addr_msb + 32] <= mem31[cmp_addr_1] & (mem27[cmp_addr_2]);
        end
    end
end

// Dataprocess_6: cmp_addr_1 is the address of operand 1 (all bits), cmp_addr_2 is the address of operand 2 (single bit), and the result of one operation is stored in mem[32], which is the location of the first meta data
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000001000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin 
        if (SEARCH_2row == 1'b0) begin
            // mantissa processing in the first 16 arrays
            mem6[ppg_addr_msb + 32] <= mem6[cmp_addr_1] & (mem12[cmp_addr_2]);
            mem7[ppg_addr_msb + 32] <= mem7[cmp_addr_1] & (mem12[cmp_addr_2]);
            mem8[ppg_addr_msb + 32] <= mem8[cmp_addr_1] & (mem12[cmp_addr_2]);
            mem9[ppg_addr_msb + 32] <= mem9[cmp_addr_1] & (mem12[cmp_addr_2]);
            mem10[ppg_addr_msb + 32] <= mem10[cmp_addr_1] & (mem12[cmp_addr_2]);
            mem11[ppg_addr_msb + 32] <= mem11[cmp_addr_1] & (mem12[cmp_addr_2]);
            mem12[ppg_addr_msb + 32] <= mem12[cmp_addr_1] & (mem12[cmp_addr_2]);
            mem13[ppg_addr_msb + 32] <= mem13[cmp_addr_1] & (mem12[cmp_addr_2]);
            mem14[ppg_addr_msb + 32] <= mem14[cmp_addr_1] & (mem12[cmp_addr_2]);
            mem15[ppg_addr_msb + 32] <= mem15[cmp_addr_1] & (mem12[cmp_addr_2]);
            // mantissa processing in the last 16 arrays
            mem22[ppg_addr_msb + 32] <= mem22[cmp_addr_1] & (mem28[cmp_addr_2]);
            mem23[ppg_addr_msb + 32] <= mem23[cmp_addr_1] & (mem28[cmp_addr_2]);
            mem24[ppg_addr_msb + 32] <= mem24[cmp_addr_1] & (mem28[cmp_addr_2]);
            mem25[ppg_addr_msb + 32] <= mem25[cmp_addr_1] & (mem28[cmp_addr_2]);
            mem26[ppg_addr_msb + 32] <= mem26[cmp_addr_1] & (mem28[cmp_addr_2]);
            mem27[ppg_addr_msb + 32] <= mem27[cmp_addr_1] & (mem28[cmp_addr_2]);
            mem28[ppg_addr_msb + 32] <= mem28[cmp_addr_1] & (mem28[cmp_addr_2]);
            mem29[ppg_addr_msb + 32] <= mem29[cmp_addr_1] & (mem28[cmp_addr_2]);
            mem30[ppg_addr_msb + 32] <= mem30[cmp_addr_1] & (mem28[cmp_addr_2]);
            mem31[ppg_addr_msb + 32] <= mem31[cmp_addr_1] & (mem28[cmp_addr_2]);
        end
    end
end

// Dataprocess_7: cmp_addr_1 is the address of operand 1 (all bits), cmp_addr_2 is the address of operand 2 (single bit), and the result of one operation is stored in mem[32], which is the location of the first meta data
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000000100 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin 
        if (SEARCH_2row == 1'b0) begin
            // mantissa processing in the first 16 arrays  
            mem6[ppg_addr_msb + 32] <= mem6[cmp_addr_1] & (mem13[cmp_addr_2]);
            mem7[ppg_addr_msb + 32] <= mem7[cmp_addr_1] & (mem13[cmp_addr_2]);
            mem8[ppg_addr_msb + 32] <= mem8[cmp_addr_1] & (mem13[cmp_addr_2]);
            mem9[ppg_addr_msb + 32] <= mem9[cmp_addr_1] & (mem13[cmp_addr_2]);
            mem10[ppg_addr_msb + 32] <= mem10[cmp_addr_1] & (mem13[cmp_addr_2]);
            mem11[ppg_addr_msb + 32] <= mem11[cmp_addr_1] & (mem13[cmp_addr_2]);
            mem12[ppg_addr_msb + 32] <= mem12[cmp_addr_1] & (mem13[cmp_addr_2]);
            mem13[ppg_addr_msb + 32] <= mem13[cmp_addr_1] & (mem13[cmp_addr_2]);
            mem14[ppg_addr_msb + 32] <= mem14[cmp_addr_1] & (mem13[cmp_addr_2]);
            mem15[ppg_addr_msb + 32] <= mem15[cmp_addr_1] & (mem13[cmp_addr_2]);
            // mantissa processing in the last 16 arrays
            mem22[ppg_addr_msb + 32] <= mem22[cmp_addr_1] & (mem29[cmp_addr_2]);
            mem23[ppg_addr_msb + 32] <= mem23[cmp_addr_1] & (mem29[cmp_addr_2]);
            mem24[ppg_addr_msb + 32] <= mem24[cmp_addr_1] & (mem29[cmp_addr_2]);
            mem25[ppg_addr_msb + 32] <= mem25[cmp_addr_1] & (mem29[cmp_addr_2]);
            mem26[ppg_addr_msb + 32] <= mem26[cmp_addr_1] & (mem29[cmp_addr_2]);
            mem27[ppg_addr_msb + 32] <= mem27[cmp_addr_1] & (mem29[cmp_addr_2]);
            mem28[ppg_addr_msb + 32] <= mem28[cmp_addr_1] & (mem29[cmp_addr_2]);
            mem29[ppg_addr_msb + 32] <= mem29[cmp_addr_1] & (mem29[cmp_addr_2]);
            mem30[ppg_addr_msb + 32] <= mem30[cmp_addr_1] & (mem29[cmp_addr_2]);
            mem31[ppg_addr_msb + 32] <= mem31[cmp_addr_1] & (mem29[cmp_addr_2]);
        end
    end
end

// Dataprocess_8: cmp_addr_1 is the address of operand 1 (all bits), cmp_addr_2 is the address of operand 2 (single bit), and the result of one operation is stored in mem[32], which is the location of the first meta data
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000000010 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin 
        if (SEARCH_2row == 1'b0) begin
            // mantissa processing in the first 16 arrays
            mem6[ppg_addr_msb + 32] <= mem6[cmp_addr_1] & (mem14[cmp_addr_2]);
            mem7[ppg_addr_msb + 32] <= mem7[cmp_addr_1] & (mem14[cmp_addr_2]);
            mem8[ppg_addr_msb + 32] <= mem8[cmp_addr_1] & (mem14[cmp_addr_2]);
            mem9[ppg_addr_msb + 32] <= mem9[cmp_addr_1] & (mem14[cmp_addr_2]);
            mem10[ppg_addr_msb + 32] <= mem10[cmp_addr_1] & (mem14[cmp_addr_2]);
            mem11[ppg_addr_msb + 32] <= mem11[cmp_addr_1] & (mem14[cmp_addr_2]);
            mem12[ppg_addr_msb + 32] <= mem12[cmp_addr_1] & (mem14[cmp_addr_2]);
            mem13[ppg_addr_msb + 32] <= mem13[cmp_addr_1] & (mem14[cmp_addr_2]);
            mem14[ppg_addr_msb + 32] <= mem14[cmp_addr_1] & (mem14[cmp_addr_2]);
            mem15[ppg_addr_msb + 32] <= mem15[cmp_addr_1] & (mem14[cmp_addr_2]);
            // mantissa processing in the last 16 arrays
            mem22[ppg_addr_msb + 32] <= mem22[cmp_addr_1] & (mem30[cmp_addr_2]);
            mem23[ppg_addr_msb + 32] <= mem23[cmp_addr_1] & (mem30[cmp_addr_2]);
            mem24[ppg_addr_msb + 32] <= mem24[cmp_addr_1] & (mem30[cmp_addr_2]);
            mem25[ppg_addr_msb + 32] <= mem25[cmp_addr_1] & (mem30[cmp_addr_2]);
            mem26[ppg_addr_msb + 32] <= mem26[cmp_addr_1] & (mem30[cmp_addr_2]);
            mem27[ppg_addr_msb + 32] <= mem27[cmp_addr_1] & (mem30[cmp_addr_2]);
            mem28[ppg_addr_msb + 32] <= mem28[cmp_addr_1] & (mem30[cmp_addr_2]);
            mem29[ppg_addr_msb + 32] <= mem29[cmp_addr_1] & (mem30[cmp_addr_2]);
            mem30[ppg_addr_msb + 32] <= mem30[cmp_addr_1] & (mem30[cmp_addr_2]);
            mem31[ppg_addr_msb + 32] <= mem31[cmp_addr_1] & (mem30[cmp_addr_2]);
        end
    end
end

// Dataprocess_9: cmp_addr_1 is the address of operand 1 (all bits), cmp_addr_2 is the address of operand 2 (single bit), and the result of one operation is stored in mem[32], which is the location of the first meta data
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000000001 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b1 &&we == 1'b0) begin 
        if (SEARCH_2row == 1'b0) begin
            // mantissa processing in the first 16 arrays     
            mem6[ppg_addr_msb + 32] <= mem6[cmp_addr_1] & (mem15[cmp_addr_2]);
            mem7[ppg_addr_msb + 32] <= mem7[cmp_addr_1] & (mem15[cmp_addr_2]);
            mem8[ppg_addr_msb + 32] <= mem8[cmp_addr_1] & (mem15[cmp_addr_2]);
            mem9[ppg_addr_msb + 32] <= mem9[cmp_addr_1] & (mem15[cmp_addr_2]);
            mem10[ppg_addr_msb + 32] <= mem10[cmp_addr_1] & (mem15[cmp_addr_2]);
            mem11[ppg_addr_msb + 32] <= mem11[cmp_addr_1] & (mem15[cmp_addr_2]);
            mem12[ppg_addr_msb + 32] <= mem12[cmp_addr_1] & (mem15[cmp_addr_2]);
            mem13[ppg_addr_msb + 32] <= mem13[cmp_addr_1] & (mem15[cmp_addr_2]);
            mem14[ppg_addr_msb + 32] <= mem14[cmp_addr_1] & (mem15[cmp_addr_2]);
            mem15[ppg_addr_msb + 32] <= mem15[cmp_addr_1] & (mem15[cmp_addr_2]);
            // mantissa processing in the last 16 arrays
            mem22[ppg_addr_msb + 32] <= mem22[cmp_addr_1] & (mem31[cmp_addr_2]);
            mem23[ppg_addr_msb + 32] <= mem23[cmp_addr_1] & (mem31[cmp_addr_2]);
            mem24[ppg_addr_msb + 32] <= mem24[cmp_addr_1] & (mem31[cmp_addr_2]);
            mem25[ppg_addr_msb + 32] <= mem25[cmp_addr_1] & (mem31[cmp_addr_2]);
            mem26[ppg_addr_msb + 32] <= mem26[cmp_addr_1] & (mem31[cmp_addr_2]);
            mem27[ppg_addr_msb + 32] <= mem27[cmp_addr_1] & (mem31[cmp_addr_2]);
            mem28[ppg_addr_msb + 32] <= mem28[cmp_addr_1] & (mem31[cmp_addr_2]);
            mem29[ppg_addr_msb + 32] <= mem29[cmp_addr_1] & (mem31[cmp_addr_2]);
            mem30[ppg_addr_msb + 32] <= mem30[cmp_addr_1] & (mem31[cmp_addr_2]);
            mem31[ppg_addr_msb + 32] <= mem31[cmp_addr_1] & (mem31[cmp_addr_2]);
        end
    end
end

// Output_0: Sends the first (most significant) bit of the mantissa to the adder during the output phase
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_1000000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin 
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem6[ppg_addr_msb + 32][j];  // Sum over the 32 elements of the first meta data row of mem6
            temp_sum1 = temp_sum1 + mem22[ppg_addr_msb + 32][j]; // Sum over the 32 elements of the first meta data row of mem22
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

// Output_1: sends the second bit of the mantissa to the adder during the output phase
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0100000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin 
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem7[ppg_addr_msb + 32][j];  // Sum over the 32 elements of the first meta data row of mem7
            temp_sum1 = temp_sum1 + mem23[ppg_addr_msb + 32][j]; // Sum over the 32 elements of the first meta data row of mem23
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

// Output_2
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0010000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin 
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem8[ppg_addr_msb + 32][j];  
            temp_sum1 = temp_sum1 + mem24[ppg_addr_msb + 32][j]; 
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

// Output_3
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0001000000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin 
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem9[ppg_addr_msb + 32][j];  
            temp_sum1 = temp_sum1 + mem25[ppg_addr_msb + 32][j]; 
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

// Output_4
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000100000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin 
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem10[ppg_addr_msb + 32][j]; 
            temp_sum1 = temp_sum1 + mem26[ppg_addr_msb + 32][j]; 
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

// Output_5
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000010000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin 
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem11[ppg_addr_msb + 32][j]; 
            temp_sum1 = temp_sum1 + mem27[ppg_addr_msb + 32][j]; 
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

// Output_6
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000001000 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin 
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem12[ppg_addr_msb + 32][j]; 
            temp_sum1 = temp_sum1 + mem28[ppg_addr_msb + 32][j]; 
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

// Output_7
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000000100 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin 
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem13[ppg_addr_msb + 32][j]; 
            temp_sum1 = temp_sum1 + mem29[ppg_addr_msb + 32][j]; 
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

// Output_8
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000000010 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin 
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem14[ppg_addr_msb + 32][j]; 
            temp_sum1 = temp_sum1 + mem30[ppg_addr_msb + 32][j]; 
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

// Output_9
always @(posedge CLK) begin
    if (Ttag == 16'b0_00000_0000000001 && FB == 1'b0 && acc == 1'b0 &&Lshift == 1'b0 && Rshift == 1'b0 && Ftag == 1'b0 &&we == 1'b0) begin 
        temp_sum0 = 0; temp_sum1 = 0;
        for (j = 0; j < 32; j = j + 1) begin
            temp_sum0 = temp_sum0 + mem15[ppg_addr_msb + 32][j];
            temp_sum1 = temp_sum1 + mem31[ppg_addr_msb + 32][j]; 
        end
        sum_0 <= temp_sum0;
        sum_1 <= temp_sum1;
    end
end

endmodule