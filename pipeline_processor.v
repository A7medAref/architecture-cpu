module pipelinedProcessor(
	input clk,
    input reset,
	input [2:0] write_addr,
    output [15:0] wb_output,
    // fetch module only
    input write_enable_fm,
    input rst_fm,
    input[15:0] write_data_fm,
    input[31:0] write_addr_fm,
    // can be removed
    output [15:0] instruction,
    input interrupt
    );


    wire [15:0] memory_data_output;
    wire [15:0] result_buf;
    wire [15:0] result_buf2;    
    
    wire mem_read_buf, mem_write_buf, mem_read_buf2, mem_write_buf2, mem_read_buf3, mem_write_buf3;
    
    wire [15:0] read_data1_buf;
    wire [15:0] read_data1_buf2;
    wire [15:0] read_data2_buf;
    wire [15:0] read_data2_buf2;
    wire [3:0] alu_operation_buf;
    wire destination_alu_select_buf;
    wire wb_buf, wb_buf2, wb_buf3;

    /////////////////// should be inputs for the next stage
    wire push_signal;
    wire pop_signal;
    wire in_port_signal;
    wire out_port_signal;
    ////////////////////
    wire[1:0] jump_type_signal;
    wire jump_occured, direct_jump;

    wire[2:0] reg1_buf1, reg2_buf1 , reg2_buf2, reg2_buf3;
    wire saveInterruptData;

    fetchInstructionModule fim_45185(write_enable_fm,
                                    instruction, 
                                    write_data_fm, 
                                    clk, 
                                    rst_fm, 
                                    write_addr_fm, 
                                    jump_occured, 
                                    read_data1_buf2,
                                    direct_jump,
                                    read_data1_buf,
                                    interrupt,
                                    saveInterruptData);

    decodingStage ds_1331(
        clk,
        reset,
        write_addr,
        wb_output,
        instruction,
        
        // Needs another buffering
        mem_read_buf,
        mem_write_buf,
        mem_read_buf2,
        mem_write_buf2,
        mem_read_buf3,
        mem_write_buf3,
        read_data1_buf,
        read_data1_buf2,
        read_data2_buf,
        read_data2_buf2,
        /////////////////////

        alu_operation_buf,
        destination_alu_select_buf,
        wb_buf,
        wb_buf2,
        wb_buf3,
        //////////////////////// new signals phase 2
        push_signal,
        pop_signal,
        in_port_signal,
        out_port_signal,
        jump_type_signal,
        jump_occured,
        direct_jump,
        reg1_buf1,
        reg2_buf1,
        reg2_buf2,
        reg2_buf3
        );



    ALU_stage alu_1839( clk,
                        read_data1_buf,
                        read_data2_buf,
                        alu_operation_buf,
                        destination_alu_select_buf,
                        result_buf,
                        result_buf2,
                        jump_type_signal,
                        jump_occured,
                        instruction,
                        wb_buf2,
                        wb_buf3,
                        mem_write_buf2,
                        mem_write_buf3,
                        reg1_buf1,
                        reg2_buf1,
                        reg2_buf2,
                        reg2_buf3,
                        memory_data_output,
                        mem_read_buf,
                        mem_read_buf3
                        );

    dataMemory dm_1438(mem_read_buf2, 
                        mem_write_buf2, 
                        memory_data_output,
                        read_data2_buf2,
                        clk,
                        1'b0/*rst*/, 
                        result_buf/*address come from alu*/,
                        result_buf,
                        push_signal,
                        pop_signal);

    wb_stage wb_85915(clk, mem_read_buf3, memory_data_output, result_buf2, wb_output);
endmodule
