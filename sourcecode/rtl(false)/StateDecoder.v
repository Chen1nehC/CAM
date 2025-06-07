module StateDecoder (
    input  wire [3:0] state_ctrl,
    output reg        idle,
    output reg        store_data,
    output reg        exp_add_CS,
    output reg        exp_add_bitwise,
    output reg        store_emax,
    output reg        emax_output_add,
    output reg        find_exp_bit,
    output reg        shift_mantissa,
    output reg        partial_mul,
    output reg        partial_sum_output,
    output reg        done
);

    always @(*) begin
        // 默认全部拉低
        idle               = 1'b0;
        store_data         = 1'b0;
        exp_add_CS         = 1'b0;
        exp_add_bitwise    = 1'b0;
        store_emax         = 1'b0;
        emax_output_add    = 1'b0;
        find_exp_bit       = 1'b0;
        shift_mantissa     = 1'b0;
        partial_mul        = 1'b0;
        partial_sum_output = 1'b0;
        done               = 1'b0;

        // 根据 state_ctrl 译码
        case (state_ctrl)
            4'b0000: idle               = 1'b1; // IDLE
            4'b0001: store_data         = 1'b1; // 存储数据
            4'b0010: exp_add_CS         = 1'b1; // 指数加法（C和S）
            4'b0011: exp_add_bitwise    = 1'b1; // 指数加法（逐位）
            4'b0100: store_emax         = 1'b1; // 存储指数结果到Emax Sub
            4'b0101: emax_output_add    = 1'b1; // EMAX逐位输出到加法器
            4'b0110: find_exp_bit       = 1'b1; // 寻找特定指数位
            4'b0111: shift_mantissa     = 1'b1; // 尾数部分一位右移
            4'b1000: partial_mul        = 1'b1; // 1bit的部分积
            4'b1001: partial_sum_output = 1'b1; // 部分积输出到加法器
            4'b1111: done               = 1'b1; // 结束
            default: ; // 保持默认低电平
        endcase
    end

endmodule
