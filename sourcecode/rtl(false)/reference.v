

//`define CYCLE 10
module UN_model_5(

/////////////////////////////////////////////////////
input CLK,
input CEB,          // chip enable
input WEB,          // write enable
input [11:0] A, 	// SRAM write address//
input [7:0]D_L,
input [7:0]D_R,


//input [3:0] CIM_addr_x,
input [1:0] A_NN,

//input [1:0] channel_mode,//00:16 01:32 10:64
//input precision,//0:full 1:
output reg signed[15:0] DOUT_NN_L_0,
output reg signed[15:0] DOUT_NN_L_1,
output reg signed[15:0] DOUT_NN_L_2,
output reg signed[15:0] DOUT_NN_L_3,
                        
output reg signed[15:0] DOUT_NN_R_0,
output reg signed[15:0] DOUT_NN_R_1,
output reg signed[15:0] DOUT_NN_R_2,
output reg signed[15:0] DOUT_NN_R_3,

input [3:0]NN_IN_0, 
input [3:0]NN_IN_1, 
input [3:0]NN_IN_2, 
input [3:0]NN_IN_3, 
input [3:0]NN_IN_4, 
input [3:0]NN_IN_5, 
input [3:0]NN_IN_6, 
input [3:0]NN_IN_7, 
input [3:0]NN_IN_8, 
input [3:0]NN_IN_9, 
input [3:0]NN_IN_10,
input [3:0]NN_IN_11,
input [3:0]NN_IN_12,
input [3:0]NN_IN_13,
input [3:0]NN_IN_14,
input [3:0]NN_IN_15,



input NNEN,		// 0: SRAM mode, 1: CIM mode 
output reg [7:0] Q_R,	// SRAM read data out 
output reg [7:0] Q_L,	// SRAM read data out 

/////////////////////////////////////////////////////power
`ifdef POWER_PINS
inout VDDM,
inout VSSM,
inout VDDP,
inout VDD_HD,
inout VDD_HWL,
inout VDD_INPUT01,
inout VDD_INPUT10,
inout REF_H,
inout REF_L,
inout VCM,
`endif
/////////////////////////////////////////////////////power
/////////////////////////////////////////////////////

input RST_N,
input TM_PRE,
input TM_HDPULSE,
input TM_INPULSE,
input TM_SAR_CAP,
input EXT_HD_R,
input EXT_HD_F,
input EXT_INPUT_F,
input EXT_CAP_F,
input EXT_SAR_F,
output [5:0]SAOUT_NN

/////////////////////////////////////////////////////


);

wire [3:0]CIM_addr_x;
assign CIM_addr_x[3] = A[6];
assign CIM_addr_x[2] = A[5];
assign CIM_addr_x[1] = A[4];
assign CIM_addr_x[0] = A[3];

wire [3:0] CIM_in_[15:0];
assign  CIM_in_[0 ]  =  NN_IN_0 ;
assign  CIM_in_[1 ]  =  NN_IN_1 ;
assign  CIM_in_[2 ]  =  NN_IN_2 ;
assign  CIM_in_[3 ]  =  NN_IN_3 ;
assign  CIM_in_[4 ]  =  NN_IN_4 ;
assign  CIM_in_[5 ]  =  NN_IN_5 ;
assign  CIM_in_[6 ]  =  NN_IN_6 ;
assign  CIM_in_[7 ]  =  NN_IN_7 ;
assign  CIM_in_[8 ]  =  NN_IN_8 ;
assign  CIM_in_[9 ]  =  NN_IN_9 ;
assign  CIM_in_[10]  =  NN_IN_10;
assign  CIM_in_[11]  =  NN_IN_11;
assign  CIM_in_[12]  =  NN_IN_12;
assign  CIM_in_[13]  =  NN_IN_13;
assign  CIM_in_[14]  =  NN_IN_14;
assign  CIM_in_[15]  =  NN_IN_15;







reg [0:63]mem_righ[0:511];
reg [0:63]mem_left[0:511];

reg [0:63]mem_16_left_1_7[0:15];
reg [0:63]mem_16_left_1_6[0:15];
reg [0:63]mem_16_left_1_5[0:15];
reg [0:63]mem_16_left_1_4[0:15];
reg [0:63]mem_16_left_1_3[0:15];
reg [0:63]mem_16_left_1_2[0:15];
reg [0:63]mem_16_left_1_1[0:15];
reg [0:63]mem_16_left_1_0[0:15];


reg [0:63]mem_16_left_2_7[0:15];
reg [0:63]mem_16_left_2_6[0:15];
reg [0:63]mem_16_left_2_5[0:15];
reg [0:63]mem_16_left_2_4[0:15];
reg [0:63]mem_16_left_2_3[0:15];
reg [0:63]mem_16_left_2_2[0:15];
reg [0:63]mem_16_left_2_1[0:15];
reg [0:63]mem_16_left_2_0[0:15];

reg [0:63]mem_16_left_3_7[0:15];
reg [0:63]mem_16_left_3_6[0:15];
reg [0:63]mem_16_left_3_5[0:15];
reg [0:63]mem_16_left_3_4[0:15];
reg [0:63]mem_16_left_3_3[0:15];
reg [0:63]mem_16_left_3_2[0:15];
reg [0:63]mem_16_left_3_1[0:15];
reg [0:63]mem_16_left_3_0[0:15];

reg [0:63]mem_16_left_4_7[0:15];
reg [0:63]mem_16_left_4_6[0:15];
reg [0:63]mem_16_left_4_5[0:15];
reg [0:63]mem_16_left_4_4[0:15];
reg [0:63]mem_16_left_4_3[0:15];
reg [0:63]mem_16_left_4_2[0:15];
reg [0:63]mem_16_left_4_1[0:15];
reg [0:63]mem_16_left_4_0[0:15];




reg [0:63]mem_16_right_1_7[0:15];
reg [0:63]mem_16_right_1_6[0:15];
reg [0:63]mem_16_right_1_5[0:15];
reg [0:63]mem_16_right_1_4[0:15];
reg [0:63]mem_16_right_1_3[0:15];
reg [0:63]mem_16_right_1_2[0:15];
reg [0:63]mem_16_right_1_1[0:15];
reg [0:63]mem_16_right_1_0[0:15];


reg [0:63]mem_16_right_2_7[0:15];
reg [0:63]mem_16_right_2_6[0:15];
reg [0:63]mem_16_right_2_5[0:15];
reg [0:63]mem_16_right_2_4[0:15];
reg [0:63]mem_16_right_2_3[0:15];
reg [0:63]mem_16_right_2_2[0:15];
reg [0:63]mem_16_right_2_1[0:15];
reg [0:63]mem_16_right_2_0[0:15];

reg [0:63]mem_16_right_3_7[0:15];
reg [0:63]mem_16_right_3_6[0:15];
reg [0:63]mem_16_right_3_5[0:15];
reg [0:63]mem_16_right_3_4[0:15];
reg [0:63]mem_16_right_3_3[0:15];
reg [0:63]mem_16_right_3_2[0:15];
reg [0:63]mem_16_right_3_1[0:15];
reg [0:63]mem_16_right_3_0[0:15];

reg [0:63]mem_16_right_4_7[0:15];
reg [0:63]mem_16_right_4_6[0:15];
reg [0:63]mem_16_right_4_5[0:15];
reg [0:63]mem_16_right_4_4[0:15];
reg [0:63]mem_16_right_4_3[0:15];
reg [0:63]mem_16_right_4_2[0:15];
reg [0:63]mem_16_right_4_1[0:15];
reg [0:63]mem_16_right_4_0[0:15];

//reg [0:63]mem_righ[0:512];
//reg [0:63]mem_left[0:512];
//mem_righ[row][col]
integer hhh_2,hhh_3;
always@(*) begin
    for(hhh_2 = 0; hhh_2 < 64; hhh_2 = hhh_2 + 1)begin
        for(hhh_3 = 0; hhh_3 < 16; hhh_3 = hhh_3 + 1)begin
            mem_16_left_1_7[hhh_3][hhh_2] = mem_left[hhh_3   ][hhh_2];
            mem_16_left_1_6[hhh_3][hhh_2] = mem_left[hhh_3+16][hhh_2];
            mem_16_left_1_5[hhh_3][hhh_2] = mem_left[hhh_3+32][hhh_2];
            mem_16_left_1_4[hhh_3][hhh_2] = mem_left[hhh_3+48][hhh_2];
            mem_16_left_1_3[hhh_3][hhh_2] = mem_left[hhh_3+64][hhh_2];
            mem_16_left_1_2[hhh_3][hhh_2] = mem_left[hhh_3+80][hhh_2];
            mem_16_left_1_1[hhh_3][hhh_2] = mem_left[hhh_3+96][hhh_2];
            mem_16_left_1_0[hhh_3][hhh_2] = mem_left[hhh_3+112][hhh_2];
        end
    end
end
integer hhh_4,hhh_5;
always@(*) begin
    for(hhh_4 = 0; hhh_4 < 64; hhh_4 = hhh_4 + 1)begin
        for(hhh_5 = 0; hhh_5 < 16; hhh_5 = hhh_5 + 1)begin
            mem_16_left_2_7[hhh_5][hhh_4] = mem_left[hhh_5+128][hhh_4];
            mem_16_left_2_6[hhh_5][hhh_4] = mem_left[hhh_5+128+16][hhh_4];
            mem_16_left_2_5[hhh_5][hhh_4] = mem_left[hhh_5+128+32][hhh_4];
            mem_16_left_2_4[hhh_5][hhh_4] = mem_left[hhh_5+128+48][hhh_4];
            mem_16_left_2_3[hhh_5][hhh_4] = mem_left[hhh_5+128+64][hhh_4];
            mem_16_left_2_2[hhh_5][hhh_4] = mem_left[hhh_5+128+80][hhh_4];
            mem_16_left_2_1[hhh_5][hhh_4] = mem_left[hhh_5+128+96][hhh_4];
            mem_16_left_2_0[hhh_5][hhh_4] = mem_left[hhh_5+128+112][hhh_4];
        end
    end
end
integer hhh_6,hhh_7;
always@(*) begin
    for(hhh_6 = 0; hhh_6 < 64; hhh_6 = hhh_6 + 1)begin
        for(hhh_7 = 0; hhh_7 < 16; hhh_7 = hhh_7 + 1)begin
            mem_16_left_3_7[hhh_7][hhh_6] = mem_left[hhh_7+256][hhh_6];
            mem_16_left_3_6[hhh_7][hhh_6] = mem_left[hhh_7+256+16][hhh_6];
            mem_16_left_3_5[hhh_7][hhh_6] = mem_left[hhh_7+256+32][hhh_6];
            mem_16_left_3_4[hhh_7][hhh_6] = mem_left[hhh_7+256+48][hhh_6];
            mem_16_left_3_3[hhh_7][hhh_6] = mem_left[hhh_7+256+64][hhh_6];
            mem_16_left_3_2[hhh_7][hhh_6] = mem_left[hhh_7+256+80][hhh_6];
            mem_16_left_3_1[hhh_7][hhh_6] = mem_left[hhh_7+256+96][hhh_6];
            mem_16_left_3_0[hhh_7][hhh_6] = mem_left[hhh_7+256+112][hhh_6];
        end
    end
end
integer hhh_8,hhh_9;
always@(*) begin
    for(hhh_8 = 0; hhh_8 < 64; hhh_8 = hhh_8 + 1)begin
        for(hhh_9 = 0; hhh_9 < 16; hhh_9 = hhh_9 + 1)begin
            mem_16_left_4_7[hhh_9][hhh_8] = mem_left[hhh_9+384][hhh_8];
            mem_16_left_4_6[hhh_9][hhh_8] = mem_left[hhh_9+384+16][hhh_8];
            mem_16_left_4_5[hhh_9][hhh_8] = mem_left[hhh_9+384+32][hhh_8];
            mem_16_left_4_4[hhh_9][hhh_8] = mem_left[hhh_9+384+48][hhh_8];
            mem_16_left_4_3[hhh_9][hhh_8] = mem_left[hhh_9+384+64][hhh_8];
            mem_16_left_4_2[hhh_9][hhh_8] = mem_left[hhh_9+384+80][hhh_8];
            mem_16_left_4_1[hhh_9][hhh_8] = mem_left[hhh_9+384+96][hhh_8];
            mem_16_left_4_0[hhh_9][hhh_8] = mem_left[hhh_9+384+112][hhh_8];
        end
    end
end






///////////////
integer eee_2,eee_3;
always@(*) begin
    for(eee_2 = 0; eee_2 < 64; eee_2 = eee_2 + 1)begin
        for(eee_3 = 0; eee_3 < 16; eee_3 = eee_3 + 1)begin
            mem_16_right_1_7[eee_3][eee_2] = mem_righ[eee_3   ][eee_2];
            mem_16_right_1_6[eee_3][eee_2] = mem_righ[eee_3+16][eee_2];
            mem_16_right_1_5[eee_3][eee_2] = mem_righ[eee_3+32][eee_2];
            mem_16_right_1_4[eee_3][eee_2] = mem_righ[eee_3+48][eee_2];
            mem_16_right_1_3[eee_3][eee_2] = mem_righ[eee_3+64][eee_2];
            mem_16_right_1_2[eee_3][eee_2] = mem_righ[eee_3+80][eee_2];
            mem_16_right_1_1[eee_3][eee_2] = mem_righ[eee_3+96][eee_2];
            mem_16_right_1_0[eee_3][eee_2] = mem_righ[eee_3+112][eee_2];
        end
    end
end
integer eee_4,eee_5;
always@(*) begin
    for(eee_4 = 0; eee_4 < 64; eee_4 = eee_4 + 1)begin
        for(eee_5 = 0; eee_5 < 16; eee_5 = eee_5 + 1)begin
            mem_16_right_2_7[eee_5][eee_4] = mem_righ[eee_5+128][eee_4];
            mem_16_right_2_6[eee_5][eee_4] = mem_righ[eee_5+128+16][eee_4];
            mem_16_right_2_5[eee_5][eee_4] = mem_righ[eee_5+128+32][eee_4];
            mem_16_right_2_4[eee_5][eee_4] = mem_righ[eee_5+128+48][eee_4];
            mem_16_right_2_3[eee_5][eee_4] = mem_righ[eee_5+128+64][eee_4];
            mem_16_right_2_2[eee_5][eee_4] = mem_righ[eee_5+128+80][eee_4];
            mem_16_right_2_1[eee_5][eee_4] = mem_righ[eee_5+128+96][eee_4];
            mem_16_right_2_0[eee_5][eee_4] = mem_righ[eee_5+128+112][eee_4];
        end
    end
end
integer eee_6,eee_7;
always@(*) begin
    for(eee_6 = 0; eee_6 < 64; eee_6 = eee_6 + 1)begin
        for(eee_7 = 0; eee_7 < 16; eee_7 = eee_7 + 1)begin
            mem_16_right_3_7[eee_7][eee_6] = mem_righ[eee_7+256][eee_6];
            mem_16_right_3_6[eee_7][eee_6] = mem_righ[eee_7+256+16][eee_6];
            mem_16_right_3_5[eee_7][eee_6] = mem_righ[eee_7+256+32][eee_6];
            mem_16_right_3_4[eee_7][eee_6] = mem_righ[eee_7+256+48][eee_6];
            mem_16_right_3_3[eee_7][eee_6] = mem_righ[eee_7+256+64][eee_6];
            mem_16_right_3_2[eee_7][eee_6] = mem_righ[eee_7+256+80][eee_6];
            mem_16_right_3_1[eee_7][eee_6] = mem_righ[eee_7+256+96][eee_6];
            mem_16_right_3_0[eee_7][eee_6] = mem_righ[eee_7+256+112][eee_6];
        end
    end
end
integer eee_8,eee_9;
always@(*) begin
    for(eee_8 = 0; eee_8 < 64; eee_8 = eee_8 + 1)begin
        for(eee_9 = 0; eee_9 < 16; eee_9 = eee_9 + 1)begin
            mem_16_right_4_7[eee_9][eee_8] = mem_righ[eee_9+384][eee_8];
            mem_16_right_4_6[eee_9][eee_8] = mem_righ[eee_9+384+16][eee_8];
            mem_16_right_4_5[eee_9][eee_8] = mem_righ[eee_9+384+32][eee_8];
            mem_16_right_4_4[eee_9][eee_8] = mem_righ[eee_9+384+48][eee_8];
            mem_16_right_4_3[eee_9][eee_8] = mem_righ[eee_9+384+64][eee_8];
            mem_16_right_4_2[eee_9][eee_8] = mem_righ[eee_9+384+80][eee_8];
            mem_16_right_4_1[eee_9][eee_8] = mem_righ[eee_9+384+96][eee_8];
            mem_16_right_4_0[eee_9][eee_8] = mem_righ[eee_9+384+112][eee_8];
        end
    end
end



//CIM inference
//mem[row][col]
//channel_mode   00 16 mode
//               A_NN 00 01 10 11 
     
//channel_mode   01 32 mode  
//               A_NN 00 10

//channel_mode   11 64 mode
//               A_NN 00
integer hhh_1;
integer x_1;


reg signed[15:0] tmp_left_1;
reg signed[15:0] tmp_left_2;
reg signed[15:0] tmp_left_3;
reg signed[15:0] tmp_left_4;

reg signed[15:0] tmp_righ_1;
reg signed[15:0] tmp_righ_2;
reg signed[15:0] tmp_righ_3;
reg signed[15:0] tmp_righ_4;

wire [3:0]CIM_addr_x_param;
assign CIM_addr_x_param = 15 - CIM_addr_x;

always@(posedge CLK) begin
    if(NNEN==1)begin
        DOUT_NN_L_0 = 0;
        DOUT_NN_L_1 = 0;
        DOUT_NN_L_2 = 0;
        DOUT_NN_L_3 = 0;
                         
        DOUT_NN_R_0 = 0;
        DOUT_NN_R_1 = 0;
        DOUT_NN_R_2 = 0;
        DOUT_NN_R_3 = 0;
        
        for(hhh_1 = 0; hhh_1 < 16; hhh_1 = hhh_1 + 1)begin
            
        
            tmp_left_1 
            =   ((CIM_in_[hhh_1][3:2] * mem_16_left_1_7[CIM_addr_x_param][A_NN + hhh_1*4]))*(-128)*(4)+  ((CIM_in_[hhh_1][1:0] * mem_16_left_1_7[CIM_addr_x_param][A_NN + hhh_1*4]))*(-128)   +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_1_6[CIM_addr_x_param][A_NN + hhh_1*4]))*(64)*(4)  +  ((CIM_in_[hhh_1][1:0] * mem_16_left_1_6[CIM_addr_x_param][A_NN + hhh_1*4]))*(64)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_1_5[CIM_addr_x_param][A_NN + hhh_1*4]))*(32)*(4)  +  ((CIM_in_[hhh_1][1:0] * mem_16_left_1_5[CIM_addr_x_param][A_NN + hhh_1*4]))*(32)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_1_4[CIM_addr_x_param][A_NN + hhh_1*4]))*(16)*(4)  +  ((CIM_in_[hhh_1][1:0] * mem_16_left_1_4[CIM_addr_x_param][A_NN + hhh_1*4]))*(16)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_1_3[CIM_addr_x_param][A_NN + hhh_1*4]))*(8)*(4)   +  ((CIM_in_[hhh_1][1:0] * mem_16_left_1_3[CIM_addr_x_param][A_NN + hhh_1*4]))*(8)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_1_2[CIM_addr_x_param][A_NN + hhh_1*4]))*(4)*(4)   +  ((CIM_in_[hhh_1][1:0] * mem_16_left_1_2[CIM_addr_x_param][A_NN + hhh_1*4]))*(4)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_1_1[CIM_addr_x_param][A_NN + hhh_1*4]))*(2)*(4)   +  ((CIM_in_[hhh_1][1:0] * mem_16_left_1_1[CIM_addr_x_param][A_NN + hhh_1*4]))*(2)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_1_0[CIM_addr_x_param][A_NN + hhh_1*4]))*(1)*(4)   +  ((CIM_in_[hhh_1][1:0] * mem_16_left_1_0[CIM_addr_x_param][A_NN + hhh_1*4]))*(1)    ; 
            tmp_left_2                                                                                                                                                                          
            =   ((CIM_in_[hhh_1][3:2] * mem_16_left_2_7[CIM_addr_x_param][A_NN + hhh_1*4]))*(-128)*(4)+  ((CIM_in_[hhh_1][1:0] * mem_16_left_2_7[CIM_addr_x_param][A_NN + hhh_1*4]))*(-128)   +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_2_6[CIM_addr_x_param][A_NN + hhh_1*4]))*(64)*(4)  +  ((CIM_in_[hhh_1][1:0] * mem_16_left_2_6[CIM_addr_x_param][A_NN + hhh_1*4]))*(64)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_2_5[CIM_addr_x_param][A_NN + hhh_1*4]))*(32)*(4)  +  ((CIM_in_[hhh_1][1:0] * mem_16_left_2_5[CIM_addr_x_param][A_NN + hhh_1*4]))*(32)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_2_4[CIM_addr_x_param][A_NN + hhh_1*4]))*(16)*(4)  +  ((CIM_in_[hhh_1][1:0] * mem_16_left_2_4[CIM_addr_x_param][A_NN + hhh_1*4]))*(16)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_2_3[CIM_addr_x_param][A_NN + hhh_1*4]))*(8)*(4)   +  ((CIM_in_[hhh_1][1:0] * mem_16_left_2_3[CIM_addr_x_param][A_NN + hhh_1*4]))*(8)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_2_2[CIM_addr_x_param][A_NN + hhh_1*4]))*(4)*(4)   +  ((CIM_in_[hhh_1][1:0] * mem_16_left_2_2[CIM_addr_x_param][A_NN + hhh_1*4]))*(4)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_2_1[CIM_addr_x_param][A_NN + hhh_1*4]))*(2)*(4)   +  ((CIM_in_[hhh_1][1:0] * mem_16_left_2_1[CIM_addr_x_param][A_NN + hhh_1*4]))*(2)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_2_0[CIM_addr_x_param][A_NN + hhh_1*4]))*(1)*(4)   +  ((CIM_in_[hhh_1][1:0] * mem_16_left_2_0[CIM_addr_x_param][A_NN + hhh_1*4]))*(1)    ;  
            tmp_left_3                                                                                                                                                                     
            =   ((CIM_in_[hhh_1][3:2] * mem_16_left_3_7[CIM_addr_x_param][A_NN + hhh_1*4]))*(-128)*(4)+  ((CIM_in_[hhh_1][1:0] * mem_16_left_3_7[CIM_addr_x_param][A_NN + hhh_1*4]))*(-128)   +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_3_6[CIM_addr_x_param][A_NN + hhh_1*4]))*(64)*(4)  +  ((CIM_in_[hhh_1][1:0] * mem_16_left_3_6[CIM_addr_x_param][A_NN + hhh_1*4]))*(64)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_3_5[CIM_addr_x_param][A_NN + hhh_1*4]))*(32)*(4)  +  ((CIM_in_[hhh_1][1:0] * mem_16_left_3_5[CIM_addr_x_param][A_NN + hhh_1*4]))*(32)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_3_4[CIM_addr_x_param][A_NN + hhh_1*4]))*(16)*(4)  +  ((CIM_in_[hhh_1][1:0] * mem_16_left_3_4[CIM_addr_x_param][A_NN + hhh_1*4]))*(16)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_3_3[CIM_addr_x_param][A_NN + hhh_1*4]))*(8)*(4)   +  ((CIM_in_[hhh_1][1:0] * mem_16_left_3_3[CIM_addr_x_param][A_NN + hhh_1*4]))*(8)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_3_2[CIM_addr_x_param][A_NN + hhh_1*4]))*(4)*(4)   +  ((CIM_in_[hhh_1][1:0] * mem_16_left_3_2[CIM_addr_x_param][A_NN + hhh_1*4]))*(4)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_3_1[CIM_addr_x_param][A_NN + hhh_1*4]))*(2)*(4)   +  ((CIM_in_[hhh_1][1:0] * mem_16_left_3_1[CIM_addr_x_param][A_NN + hhh_1*4]))*(2)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_3_0[CIM_addr_x_param][A_NN + hhh_1*4]))*(1)*(4)   +  ((CIM_in_[hhh_1][1:0] * mem_16_left_3_0[CIM_addr_x_param][A_NN + hhh_1*4]))*(1)    ; 
            tmp_left_4                                                                                                                                                                      
            =   ((CIM_in_[hhh_1][3:2] * mem_16_left_4_7[CIM_addr_x_param][A_NN + hhh_1*4]))*(-128)*(4)+  ((CIM_in_[hhh_1][1:0] * mem_16_left_4_7[CIM_addr_x_param][A_NN + hhh_1*4]))*(-128)   +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_4_6[CIM_addr_x_param][A_NN + hhh_1*4]))*(64)*(4)  +  ((CIM_in_[hhh_1][1:0] * mem_16_left_4_6[CIM_addr_x_param][A_NN + hhh_1*4]))*(64)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_4_5[CIM_addr_x_param][A_NN + hhh_1*4]))*(32)*(4)  +  ((CIM_in_[hhh_1][1:0] * mem_16_left_4_5[CIM_addr_x_param][A_NN + hhh_1*4]))*(32)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_4_4[CIM_addr_x_param][A_NN + hhh_1*4]))*(16)*(4)  +  ((CIM_in_[hhh_1][1:0] * mem_16_left_4_4[CIM_addr_x_param][A_NN + hhh_1*4]))*(16)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_4_3[CIM_addr_x_param][A_NN + hhh_1*4]))*(8)*(4)   +  ((CIM_in_[hhh_1][1:0] * mem_16_left_4_3[CIM_addr_x_param][A_NN + hhh_1*4]))*(8)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_4_2[CIM_addr_x_param][A_NN + hhh_1*4]))*(4)*(4)   +  ((CIM_in_[hhh_1][1:0] * mem_16_left_4_2[CIM_addr_x_param][A_NN + hhh_1*4]))*(4)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_4_1[CIM_addr_x_param][A_NN + hhh_1*4]))*(2)*(4)   +  ((CIM_in_[hhh_1][1:0] * mem_16_left_4_1[CIM_addr_x_param][A_NN + hhh_1*4]))*(2)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_left_4_0[CIM_addr_x_param][A_NN + hhh_1*4]))*(1)*(4)   +  ((CIM_in_[hhh_1][1:0] * mem_16_left_4_0[CIM_addr_x_param][A_NN + hhh_1*4]))*(1)    ; 
                                                                                                                                                                                                 
            tmp_righ_1                                                                           
            =   ((CIM_in_[hhh_1][3:2] * mem_16_right_1_7[CIM_addr_x_param][A_NN +hhh_1*4]))*(-128)*(4)   +  ((CIM_in_[hhh_1][1:0] * mem_16_right_1_7[CIM_addr_x_param][A_NN +hhh_1*4]))*(-128)   +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_1_6[CIM_addr_x_param][A_NN +hhh_1*4]))*(64)*(4)     +  ((CIM_in_[hhh_1][1:0] * mem_16_right_1_6[CIM_addr_x_param][A_NN +hhh_1*4]))*(64)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_1_5[CIM_addr_x_param][A_NN +hhh_1*4]))*(32)*(4)     +  ((CIM_in_[hhh_1][1:0] * mem_16_right_1_5[CIM_addr_x_param][A_NN +hhh_1*4]))*(32)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_1_4[CIM_addr_x_param][A_NN +hhh_1*4]))*(16)*(4)     +  ((CIM_in_[hhh_1][1:0] * mem_16_right_1_4[CIM_addr_x_param][A_NN +hhh_1*4]))*(16)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_1_3[CIM_addr_x_param][A_NN +hhh_1*4]))*(8)*(4)      +  ((CIM_in_[hhh_1][1:0] * mem_16_right_1_3[CIM_addr_x_param][A_NN +hhh_1*4]))*(8)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_1_2[CIM_addr_x_param][A_NN +hhh_1*4]))*(4)*(4)      +  ((CIM_in_[hhh_1][1:0] * mem_16_right_1_2[CIM_addr_x_param][A_NN +hhh_1*4]))*(4)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_1_1[CIM_addr_x_param][A_NN +hhh_1*4]))*(2)*(4)      +  ((CIM_in_[hhh_1][1:0] * mem_16_right_1_1[CIM_addr_x_param][A_NN +hhh_1*4]))*(2)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_1_0[CIM_addr_x_param][A_NN +hhh_1*4]))*(1)*(4)      +  ((CIM_in_[hhh_1][1:0] * mem_16_right_1_0[CIM_addr_x_param][A_NN +hhh_1*4]))*(1)    ;              
            tmp_righ_2                                                                                                                                                                             
            =   ((CIM_in_[hhh_1][3:2] * mem_16_right_2_7[CIM_addr_x_param][A_NN +hhh_1*4]))*(-128)*(4)   +  ((CIM_in_[hhh_1][1:0] * mem_16_right_2_7[CIM_addr_x_param][A_NN +hhh_1*4]))*(-128)   +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_2_6[CIM_addr_x_param][A_NN +hhh_1*4]))*(64)*(4)     +  ((CIM_in_[hhh_1][1:0] * mem_16_right_2_6[CIM_addr_x_param][A_NN +hhh_1*4]))*(64)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_2_5[CIM_addr_x_param][A_NN +hhh_1*4]))*(32)*(4)     +  ((CIM_in_[hhh_1][1:0] * mem_16_right_2_5[CIM_addr_x_param][A_NN +hhh_1*4]))*(32)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_2_4[CIM_addr_x_param][A_NN +hhh_1*4]))*(16)*(4)     +  ((CIM_in_[hhh_1][1:0] * mem_16_right_2_4[CIM_addr_x_param][A_NN +hhh_1*4]))*(16)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_2_3[CIM_addr_x_param][A_NN +hhh_1*4]))*(8)*(4)      +  ((CIM_in_[hhh_1][1:0] * mem_16_right_2_3[CIM_addr_x_param][A_NN +hhh_1*4]))*(8)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_2_2[CIM_addr_x_param][A_NN +hhh_1*4]))*(4)*(4)      +  ((CIM_in_[hhh_1][1:0] * mem_16_right_2_2[CIM_addr_x_param][A_NN +hhh_1*4]))*(4)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_2_1[CIM_addr_x_param][A_NN +hhh_1*4]))*(2)*(4)      +  ((CIM_in_[hhh_1][1:0] * mem_16_right_2_1[CIM_addr_x_param][A_NN +hhh_1*4]))*(2)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_2_0[CIM_addr_x_param][A_NN +hhh_1*4]))*(1)*(4)      +  ((CIM_in_[hhh_1][1:0] * mem_16_right_2_0[CIM_addr_x_param][A_NN +hhh_1*4]))*(1)    ;              
            tmp_righ_3                                                                                                                                                                             
            =   ((CIM_in_[hhh_1][3:2] * mem_16_right_3_7[CIM_addr_x_param][A_NN +hhh_1*4]))*(-128)*(4)   +  ((CIM_in_[hhh_1][1:0] * mem_16_right_3_7[CIM_addr_x_param][A_NN +hhh_1*4]))*(-128)   +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_3_6[CIM_addr_x_param][A_NN +hhh_1*4]))*(64)*(4)     +  ((CIM_in_[hhh_1][1:0] * mem_16_right_3_6[CIM_addr_x_param][A_NN +hhh_1*4]))*(64)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_3_5[CIM_addr_x_param][A_NN +hhh_1*4]))*(32)*(4)     +  ((CIM_in_[hhh_1][1:0] * mem_16_right_3_5[CIM_addr_x_param][A_NN +hhh_1*4]))*(32)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_3_4[CIM_addr_x_param][A_NN +hhh_1*4]))*(16)*(4)     +  ((CIM_in_[hhh_1][1:0] * mem_16_right_3_4[CIM_addr_x_param][A_NN +hhh_1*4]))*(16)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_3_3[CIM_addr_x_param][A_NN +hhh_1*4]))*(8)*(4)      +  ((CIM_in_[hhh_1][1:0] * mem_16_right_3_3[CIM_addr_x_param][A_NN +hhh_1*4]))*(8)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_3_2[CIM_addr_x_param][A_NN +hhh_1*4]))*(4)*(4)      +  ((CIM_in_[hhh_1][1:0] * mem_16_right_3_2[CIM_addr_x_param][A_NN +hhh_1*4]))*(4)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_3_1[CIM_addr_x_param][A_NN +hhh_1*4]))*(2)*(4)      +  ((CIM_in_[hhh_1][1:0] * mem_16_right_3_1[CIM_addr_x_param][A_NN +hhh_1*4]))*(2)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_3_0[CIM_addr_x_param][A_NN +hhh_1*4]))*(1)*(4)      +  ((CIM_in_[hhh_1][1:0] * mem_16_right_3_0[CIM_addr_x_param][A_NN +hhh_1*4]))*(1)    ;    
            tmp_righ_4                                                                                                                                                                             
            =   ((CIM_in_[hhh_1][3:2] * mem_16_right_4_7[CIM_addr_x_param][A_NN +hhh_1*4]))*(-128)*(4)   +  ((CIM_in_[hhh_1][1:0] * mem_16_right_4_7[CIM_addr_x_param][A_NN +hhh_1*4]))*(-128)   +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_4_6[CIM_addr_x_param][A_NN +hhh_1*4]))*(64)*(4)     +  ((CIM_in_[hhh_1][1:0] * mem_16_right_4_6[CIM_addr_x_param][A_NN +hhh_1*4]))*(64)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_4_5[CIM_addr_x_param][A_NN +hhh_1*4]))*(32)*(4)     +  ((CIM_in_[hhh_1][1:0] * mem_16_right_4_5[CIM_addr_x_param][A_NN +hhh_1*4]))*(32)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_4_4[CIM_addr_x_param][A_NN +hhh_1*4]))*(16)*(4)     +  ((CIM_in_[hhh_1][1:0] * mem_16_right_4_4[CIM_addr_x_param][A_NN +hhh_1*4]))*(16)     +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_4_3[CIM_addr_x_param][A_NN +hhh_1*4]))*(8)*(4)      +  ((CIM_in_[hhh_1][1:0] * mem_16_right_4_3[CIM_addr_x_param][A_NN +hhh_1*4]))*(8)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_4_2[CIM_addr_x_param][A_NN +hhh_1*4]))*(4)*(4)      +  ((CIM_in_[hhh_1][1:0] * mem_16_right_4_2[CIM_addr_x_param][A_NN +hhh_1*4]))*(4)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_4_1[CIM_addr_x_param][A_NN +hhh_1*4]))*(2)*(4)      +  ((CIM_in_[hhh_1][1:0] * mem_16_right_4_1[CIM_addr_x_param][A_NN +hhh_1*4]))*(2)      +
                ((CIM_in_[hhh_1][3:2] * mem_16_right_4_0[CIM_addr_x_param][A_NN +hhh_1*4]))*(1)*(4)      +  ((CIM_in_[hhh_1][1:0] * mem_16_right_4_0[CIM_addr_x_param][A_NN +hhh_1*4]))*(1)    ;  
            
            DOUT_NN_L_3 = DOUT_NN_L_3 + tmp_left_1;
            DOUT_NN_L_2 = DOUT_NN_L_2 + tmp_left_2;    
            DOUT_NN_L_1 = DOUT_NN_L_1 + tmp_left_3; 
            DOUT_NN_L_0 = DOUT_NN_L_0 + tmp_left_4;
            
            DOUT_NN_R_3 = DOUT_NN_R_3 + tmp_righ_1;
            DOUT_NN_R_2 = DOUT_NN_R_2 + tmp_righ_2;
            DOUT_NN_R_1 = DOUT_NN_R_1 + tmp_righ_3;
            DOUT_NN_R_0 = DOUT_NN_R_0 + tmp_righ_4;
            
        end
    end
    else begin
            DOUT_NN_L_0 = 0;
            DOUT_NN_L_1 = 0;
            DOUT_NN_L_2 = 0;
            DOUT_NN_L_3 = 0;
            DOUT_NN_R_0 = 0;
            DOUT_NN_R_1 = 0;
            DOUT_NN_R_2 = 0;
            DOUT_NN_R_3 = 0;      
    end
end



///////////normal
//reg [0:63]mem_righ[0:512];
//mem_righ[row][col]
//reg [0:63]mem_left[0:512];
integer i1;
wire [8:0]add_param;
assign add_param = 511 - A[11:3];

always@(posedge CLK) begin 
	if(~CEB && ~WEB && ~NNEN) begin
		// col set select 
		case(A[2:0])
		3'd0:
			for (i1 = 0; i1 < 8; i1 = i1 + 1) 
				mem_righ[add_param][i1*8] = D_R[i1]; 
		3'd1: 
			for (i1 = 0; i1 < 8; i1 = i1 + 1) 
				mem_righ[add_param][i1*8+1] = D_R[i1]; 
		3'd2: 
			for (i1 = 0; i1 < 8; i1 = i1 + 1) 
				mem_righ[add_param][i1*8+2] = D_R[i1]; 
		3'd3: 
			for (i1 = 0; i1 < 8; i1 = i1 + 1) 
				mem_righ[add_param][i1*8+3] = D_R[i1]; 
		3'd4: 
			for (i1 = 0; i1 < 8; i1 = i1 + 1) 
				mem_righ[add_param][i1*8+4] = D_R[i1]; 
		3'd5: 
			for (i1 = 0; i1 < 8; i1 = i1 + 1) 
				mem_righ[add_param][i1*8+5] = D_R[i1]; 
		3'd6: 
			for (i1 = 0; i1 < 8; i1 = i1 + 1) 
				mem_righ[add_param][i1*8+6] = D_R[i1]; 
		3'd7: 
			for (i1 = 0; i1 < 8; i1 = i1 + 1) 
				mem_righ[add_param][i1*8+7] = D_R[i1];
         
		endcase
	end 
end 

integer i2;
always@(posedge CLK) begin 
	if(~CEB && ~WEB && ~NNEN) begin
		// col set select 
		case(A[2:0])
		3'd0:
			for (i2 = 0; i2 < 8; i2 = i2 + 1) 
				mem_left[add_param][i2*8] = D_L[i2]; 
		3'd1: 
			for (i2 = 0; i2 < 8; i2 = i2 + 1) 
				mem_left[add_param][i2*8+1] = D_L[i2]; 
		3'd2: 
			for (i2 = 0; i2 < 8; i2 = i2 + 1) 
				mem_left[add_param][i2*8+2] = D_L[i2]; 
		3'd3: 
			for (i2 = 0; i2 < 8; i2 = i2 + 1) 
				mem_left[add_param][i2*8+3] = D_L[i2]; 
		3'd4: 
			for (i2 = 0; i2 < 8; i2 = i2 + 1) 
				mem_left[add_param][i2*8+4] = D_L[i2]; 
		3'd5: 
			for (i2 = 0; i2 < 8; i2 = i2 + 1) 
				mem_left[add_param][i2*8+5] = D_L[i2]; 
		3'd6: 
			for (i2 = 0; i2 < 8; i2 = i2 + 1) 
				mem_left[add_param][i2*8+6] = D_L[i2]; 
		3'd7: 
			for (i2 = 0; i2 < 8; i2 = i2 + 1) 
				mem_left[add_param][i2*8+7] = D_L[i2];
         
		endcase
	end 
end 


// SRAM Read at CEB:0, WEB: 1, NNEN: 0
integer i3;
always@(posedge CLK) begin 
	if(~CEB && WEB && ~NNEN) begin 
		case(A[2:0])
		3'd0:
			for (i3 = 0; i3 < 8; i3 = i3 + 1) 
				Q_L[i3] = mem_left[add_param][i3*8]; 
		3'd1: 
			for (i3 = 0; i3 < 8; i3 = i3 + 1) 
				Q_L[i3] = mem_left[add_param][i3*8+1]; 
		3'd2: 
			for (i3 = 0; i3 < 8; i3 = i3 + 1) 
				Q_L[i3] = mem_left[add_param][i3*8+2]; 
		3'd3: 
			for (i3 = 0; i3 < 8; i3 = i3 + 1) 
				Q_L[i3] = mem_left[add_param][i3*8+3]; 
		3'd4: 
			for (i3 = 0; i3 < 8; i3 = i3 + 1) 
				Q_L[i3] = mem_left[add_param][i3*8+4]; 
		3'd5: 
			for (i3 = 0; i3 < 8; i3 = i3 + 1) 
				Q_L[i3] = mem_left[add_param][i3*8+5]; 
		3'd6: 
			for (i3 = 0; i3 < 8; i3 = i3 + 1) 
				Q_L[i3] = mem_left[add_param][i3*8+6]; 
		3'd7: 
			for (i3 = 0; i3 < 8; i3 = i3 + 1) 
				Q_L[i3] = mem_left[add_param][i3*8+7]; 
        endcase
	end 
	else 
		Q_L <= 0;
end 

integer i4;
always@(posedge CLK) begin 
	if(~CEB && WEB && ~NNEN) begin 
		case(A[2:0])
		3'd0:
			for (i4 = 0; i4 < 8; i4 = i4 + 1) 
				Q_R[i4] = mem_righ[add_param][i4*8]; 
		3'd1: 
			for (i4 = 0; i4 < 8; i4 = i4 + 1) 
				Q_R[i4] = mem_righ[add_param][i4*8+1]; 
		3'd2: 
			for (i4 = 0; i4 < 8; i4 = i4 + 1) 
				Q_R[i4] = mem_righ[add_param][i4*8+2]; 
		3'd3: 
			for (i4 = 0; i4 < 8; i4 = i4 + 1) 
				Q_R[i4] = mem_righ[add_param][i4*8+3]; 
		3'd4: 
			for (i4 = 0; i4 < 8; i4 = i4 + 1) 
				Q_R[i4] = mem_righ[add_param][i4*8+4]; 
		3'd5: 
			for (i4 = 0; i4 < 8; i4 = i4 + 1) 
				Q_R[i4] = mem_righ[add_param][i4*8+5]; 
		3'd6: 
			for (i4 = 0; i4 < 8; i4 = i4 + 1) 
				Q_R[i4] = mem_righ[add_param][i4*8+6]; 
		3'd7: 
			for (i4 = 0; i4 < 8; i4 = i4 + 1) 
				Q_R[i4] = mem_righ[add_param][i4*8+7]; 
        endcase
	end 
	else 
		Q_R <= 0;
end 



endmodule
	
