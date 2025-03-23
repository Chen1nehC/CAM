`timescale 1ns / 1ps

module CAM_Data_Store (
    input  wire        rst,           // 复位信号，低有效
    input  wire        CLK,           // 时钟信号
    input  wire [9:5]  cmp_addr_high, // 5-bit 高地址 (控制多个向量地址)
    input  wire [15:0] data_in,       // 16-bit 数据输入
    input  wire [3:0]  num_vectors,   // 需要写入的向量数 (例如 2 个)
    input  wire        write_ack,     // **新增**：表示子模块写成功信号
    output reg  [15:0] chip_enable,   // 16-bit 片选信号
    output reg  [9:0]  cmp_addr_reg,  // 10-bit 地址 (低 5 位固定，高 5 位变化)
    output reg         done,          // 当前向量写入完成
    output reg         done_all       // 所有向量写入完成
);

    reg [4:0] subarray_index;  // 当前写入的 subarray 索引 (0~15)
    reg [3:0] vector_index;    // 当前输入的向量索引 (0~num_vectors-1)

    typedef enum reg [1:0] {IDLE, WRITE, WAIT_ACK, DONE_STATE} state_t;
    state_t current_state, next_state;

    // =============================
    // 状态机流程
    always @(negedge rst or posedge CLK) begin
        if (!rst) begin
            current_state   <= IDLE;
            chip_enable     <= 16'b0;
            cmp_addr_reg    <= {cmp_addr_high, 5'b00000};
            subarray_index  <= 5'b00000;
            vector_index    <= 4'b0000;
            done            <= 1'b0;
            done_all        <= 1'b0;
        end else begin
            current_state <= next_state;
            case (current_state)
                IDLE: begin
                    chip_enable     <= 16'b0;
                    done            <= 1'b0;
                    done_all        <= 1'b0;
                    subarray_index  <= 5'b00000;
                    vector_index    <= 4'b0000;
                    cmp_addr_reg    <= {cmp_addr_high, 5'b00000};
                    if (!done_all) begin
                        next_state <= WRITE;
                    end else begin
                        next_state <= IDLE;
                    end
                end

                WRITE: begin
                    chip_enable <= (1 << subarray_index);  // 开启当前 subarray
                    next_state <= WAIT_ACK;
                end

                WAIT_ACK: begin
                    if (write_ack) begin
                        if (subarray_index < 5'b1111) begin
                            subarray_index <= subarray_index + 1;
                            next_state <= WRITE;
                        end else begin
                            done <= 1'b1; // 当前向量完成
                            next_state <= DONE_STATE;
                        end
                    end else begin
                        next_state <= WAIT_ACK;
                    end
                end

                DONE_STATE: begin
                    done <= 1'b0; // 一拍后清零
                    if (vector_index < num_vectors - 1) begin
                        vector_index <= vector_index + 1;
                        cmp_addr_reg <= {cmp_addr_high, vector_index + 1};
                        subarray_index <= 5'b00000;
                        next_state <= WRITE;
                    end else begin
                        done_all <= 1'b1;
                        next_state <= IDLE; // 所有完成
                    end
                end


                default: next_state <= WAIT_ACK;
            endcase
        end
    end

endmodule
