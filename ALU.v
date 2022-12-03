module ALU#(parameter N=16) (input[N-1:0] in_src, input[N-1:0] in_dst, input[2:0] controlSignal, 
            output[N-1:0] out, output carryFlay, output zeroFlag, output negFlag);
    // always@(controlSignal) begin
    //     $display(controlSignal);
    // end
    // always@(out) begin
    //     $display("src = %d",out);
    //     $display("cs = %d",in_src);
    // end
    assign {carryFlay, out} = (controlSignal == 0) ? (in_src + in_dst) :
                              (controlSignal == 1) ? ~in_src :
                              (controlSignal == 2) ? {0, in_dst} : 
                              (controlSignal == 3) ? {0, in_src}
                              : {carryFlay, out};
    
    assign zeroFlag = (controlSignal != 3) ? !(|out) ? 1 : 0 :
                         zeroFlag;
    assign negFlag = (controlSignal != 3) ? out[N-1] : negFlag;
endmodule
