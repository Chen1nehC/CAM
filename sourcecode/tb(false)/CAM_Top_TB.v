`timescale 1ns / 1ps

module CAM_Top_TB;

    reg         rst;
    reg         CLK;
    reg  [15:0] data_in;
    reg         update_signal;
    reg  [9:0]  cmp_addr;
    reg  [3:0]  ppg_addr;
    reg  [1:0]  cmp_data;
    reg  [1:0]  ppg_data;
    reg  [7:0]  exp_in;
    reg  [2:0]  state_ctrl;
    reg  [4:0]  sa_ctrl;
    reg         acc_en;
    wire [15:0] tag_out;

    // 实例化 DUT
    CAM_Top uut (
        .rst(rst),
        .CLK(CLK),
        .data_in(data_in),
        .update_signal(update_signal),
        .cmp_addr(cmp_addr),
        .ppg_addr(ppg_addr),
        .cmp_data(cmp_data),
        .ppg_data(ppg_data),
        .exp_in(exp_in),
        .state_ctrl(state_ctrl),
        .sa_ctrl(sa_ctrl),
        .acc_en(acc_en),
        .tag_out(tag_out)
    );

    // 生成时钟
    always #5 CLK = ~CLK;  // 10ns 周期

    integer i;

    initial begin
        // 波形文件
        $fsdbDumpfile("CAM_Top.fsdb");
        $fsdbDumpvars(0, CAM_Top_TB);

        // 初始化
        CLK = 0;
        rst = 0;
        data_in = 16'b0;
        update_signal = 0;
        cmp_addr = 10'b0;
        ppg_addr = 4'b0;
        cmp_data = 2'b0;
        ppg_data = 2'b0;
        exp_in = 8'b0;
        state_ctrl = 3'b000; // idle
        sa_ctrl = 5'b0;
        acc_en = 0;

        // 复位
        #20;
        @(posedge CLK);
        rst = 1;  // 解除复位

        // 设置输入
        @(posedge CLK);
        data_in = 16'b1110_0010_0110_1111;
        cmp_addr = 10'b00001_00000;  // 高位设定
        state_ctrl = 3'b001;  // 进入存储状态 


        // 测试结束
        #100000;

        // **打印符号位 `CAM_Subarray` 的存储内容**
        print_mem_sign();

        // **打印特殊指数位 `CAM_Subarray` 的存储内容**
        print_mem_exp();

        // **打印尾数位 `CAM_Subarray` 的存储内容**
        print_mem_man();

        // **结束仿真**
        #50 $finish;
    end

    // **观察尾数 mem 的 3x32 结构**
    task print_mem_man;
        integer i, j;
        begin
            $display("\n------ Memory Dump M (3x32 for all CAM_Subarray Instances) ------");

            // **实例 2 到 15 分别打印**
            $display(">> CAM_Subarray_Instances[2]");
            for (i = 0; i < 3; i = i + 1) begin
                $write("[%2d] ", i);
                for (j = 31; j >= 0; j = j - 1) 
                    $write("%b ", uut.CAM_Subarray_Instances[2].u_cam_subarray.mem[i * 32 + j]);  
                $display();
            end

            $display(">> CAM_Subarray_Instances[3]");
            for (i = 0; i < 3; i = i + 1) begin
                $write("[%2d] ", i);
                for (j = 31; j >= 0; j = j - 1) 
                    $write("%b ", uut.CAM_Subarray_Instances[3].u_cam_subarray.mem[i * 32 + j]);  
                $display();
            end
            
            // **重复到 15**
            $display(">> CAM_Subarray_Instances[4]");
            for (i = 0; i < 3; i = i + 1) begin
                $write("[%2d] ", i);
                for (j = 31; j >= 0; j = j - 1) 
                    $write("%b ", uut.CAM_Subarray_Instances[4].u_cam_subarray.mem[i * 32 + j]);  
                $display();
            end

            $display(">> CAM_Subarray_Instances[5]");
            for (i = 0; i < 3; i = i + 1) begin
                $write("[%2d] ", i);
                for (j = 31; j >= 0; j = j - 1) 
                    $write("%b ", uut.CAM_Subarray_Instances[5].u_cam_subarray.mem[i * 32 + j]);  
                $display();
            end

            $display(">> CAM_Subarray_Instances[6]");
            for (i = 0; i < 3; i = i + 1) begin
                $write("[%2d] ", i);
                for (j = 31; j >= 0; j = j - 1) 
                    $write("%b ", uut.CAM_Subarray_Instances[6].u_cam_subarray.mem[i * 32 + j]);  
                $display();
            end

            $display(">> CAM_Subarray_Instances[7]");
            for (i = 0; i < 3; i = i + 1) begin
                $write("[%2d] ", i);
                for (j = 31; j >= 0; j = j - 1) 
                    $write("%b ", uut.CAM_Subarray_Instances[7].u_cam_subarray.mem[i * 32 + j]);  
                $display();
            end

            $display(">> CAM_Subarray_Instances[8]");
            for (i = 0; i < 3; i = i + 1) begin
                $write("[%2d] ", i);
                for (j = 31; j >= 0; j = j - 1) 
                    $write("%b ", uut.CAM_Subarray_Instances[8].u_cam_subarray.mem[i * 32 + j]);  
                $display();
            end

            $display(">> CAM_Subarray_Instances[9]");
            for (i = 0; i < 3; i = i + 1) begin
                $write("[%2d] ", i);
                for (j = 31; j >= 0; j = j - 1) 
                    $write("%b ", uut.CAM_Subarray_Instances[9].u_cam_subarray.mem[i * 32 + j]);  
                $display();
            end

            $display(">> CAM_Subarray_Instances[10]");
            for (i = 0; i < 3; i = i + 1) begin
                $write("[%2d] ", i);
                for (j = 31; j >= 0; j = j - 1) 
                    $write("%b ", uut.CAM_Subarray_Instances[10].u_cam_subarray.mem[i * 32 + j]);  
                $display();
            end

            $display(">> CAM_Subarray_Instances[11]");
            for (i = 0; i < 3; i = i + 1) begin
                $write("[%2d] ", i);
                for (j = 31; j >= 0; j = j - 1) 
                    $write("%b ", uut.CAM_Subarray_Instances[11].u_cam_subarray.mem[i * 32 + j]);  
                $display();
            end
            
            $display(">> CAM_Subarray_Instances[12]");
            for (i = 0; i < 3; i = i + 1) begin
                $write("[%2d] ", i);
                for (j = 31; j >= 0; j = j - 1) 
                    $write("%b ", uut.CAM_Subarray_Instances[12].u_cam_subarray.mem[i * 32 + j]);  
                $display();
            end

            $display(">> CAM_Subarray_Instances[13]");
            for (i = 0; i < 3; i = i + 1) begin
                $write("[%2d] ", i);
                for (j = 31; j >= 0; j = j - 1) 
                    $write("%b ", uut.CAM_Subarray_Instances[13].u_cam_subarray.mem[i * 32 + j]);  
                $display();
            end

            $display(">> CAM_Subarray_Instances[14]");
            for (i = 0; i < 3; i = i + 1) begin
                $write("[%2d] ", i);
                for (j = 31; j >= 0; j = j - 1) 
                    $write("%b ", uut.CAM_Subarray_Instances[14].u_cam_subarray.mem[i * 32 + j]);  
                $display();
            end

            $display(">> CAM_Subarray_Instances[15]");
            for (i = 0; i < 3; i = i + 1) begin
                $write("[%2d] ", i);
                for (j = 31; j >= 0; j = j - 1) 
                    $write("%b ", uut.CAM_Subarray_Instances[15].u_cam_subarray.mem[i * 32 + j]);  
                $display();
            end

            $display("---------------------------------------------------------------\n");
        end
    endtask

    // **观察符号位 mem 的 3x32 结构**
    task print_mem_sign;
        integer i, j;
        begin
            $display("\n------ Memory Dump S (3x32) ------");
            for (i = 0; i < 3; i = i + 1) begin
                $write("[%2d] ", i);
                for (j = 31; j >= 0; j = j - 1) 
                    $write("%b ", uut.u_cam_sign.mem[i * 32 + j]);  
                $display();
            end
            $display("-------------------------------\n");
        end
    endtask

    // **观察特殊指数位 mem 的 3x32 结构**
    task print_mem_exp;
        integer i, j;
        begin
            $display("\n------ Memory Dump E (3x32) ------");
            for (i = 0; i < 3; i = i + 1) begin
                $write("[%2d] ", i);
                for (j = 31; j >= 0; j = j - 1) 
                    $write("%b ", uut.u_cam_exp.mem[i * 32 + j]);  
                $display();
            end
            $display("-------------------------------\n");
        end
    endtask

    // **初始化 `CAM_Subarray_Exp`、`CAM_Subarray` 存储单元**
    task initialize_mem;
        integer i, j, k;
        begin
            $display("\n------ Initializing Memory to 0 ------");
            
            // **初始化 `CAM_Subarray_Exp`**
            for (i = 0; i < 36; i = i + 1)
                for (j = 0; j < 32; j = j + 1)
                    uut.u_cam_exp.mem[i * 32 + j] = 0;

            // **初始化 `CAM_Subarray` (符号位存储)**
            for (i = 0; i < 36; i = i + 1)
                for (j = 0; j < 32; j = j + 1)
                    uut.u_cam_sign.mem[i * 32 + j] = 0;

            // **初始化 `CAM_Subarray_Instances[0] - [13]`**
            for (i = 2; i < 16; i = i + 1) begin
                for (j = 0; j < 36; j = j + 1) begin
                    for (k = 0; k < 32; k = k + 1) begin
                        case (i)
                            2: uut.CAM_Subarray_Instances[2].u_cam_subarray.mem[j * 32 + k] = 0;
                            3: uut.CAM_Subarray_Instances[3].u_cam_subarray.mem[j * 32 + k] = 0;
                            4: uut.CAM_Subarray_Instances[4].u_cam_subarray.mem[j * 32 + k] = 0;
                            5: uut.CAM_Subarray_Instances[5].u_cam_subarray.mem[j * 32 + k] = 0;
                            6: uut.CAM_Subarray_Instances[6].u_cam_subarray.mem[j * 32 + k] = 0;
                            7: uut.CAM_Subarray_Instances[7].u_cam_subarray.mem[j * 32 + k] = 0;
                            8: uut.CAM_Subarray_Instances[8].u_cam_subarray.mem[j * 32 + k] = 0;
                            9: uut.CAM_Subarray_Instances[9].u_cam_subarray.mem[j * 32 + k] = 0;
                            10: uut.CAM_Subarray_Instances[10].u_cam_subarray.mem[j * 32 + k] = 0;
                            11: uut.CAM_Subarray_Instances[11].u_cam_subarray.mem[j * 32 + k] = 0;
                            12: uut.CAM_Subarray_Instances[12].u_cam_subarray.mem[j * 32 + k] = 0;
                            13: uut.CAM_Subarray_Instances[13].u_cam_subarray.mem[j * 32 + k] = 0;
                            14: uut.CAM_Subarray_Instances[14].u_cam_subarray.mem[j * 32 + k] = 0;
                            15: uut.CAM_Subarray_Instances[15].u_cam_subarray.mem[j * 32 + k] = 0;
                        endcase
                    end
                end
            end
            
            $display("------ Memory Initialization Complete ------\n");
        end
    endtask


endmodule
