module ALU#(parameter N=16) (input[N-1:0] in_src, input[N-1:0] in_dst, input[2:0] controlSignal, 
            output[N-1:0] out, output carryFlay, output zeroFlag, output negFlag);
    assign {carryFlay, out} = (controlSignal == 0) ? (in_src + in_dst) :
                              (controlSignal == 1) ? ~in_src :
                              (controlSignal == 2) ? {0, in_src} : 
                              (controlSignal == 3) ? {0, in_src}
                              : {carryFlay, out};
    
    assign zeroFlag = (controlSignal != 3) ? !(|out) ? 1 : 0 :
                            zeroFlag;
    assign negFlag = (controlSignal != 3) ? out[N-1] : negFlag;
endmodule
