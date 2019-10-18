module register(
            input clk,
            input reset,
            input regWrite,
            input logic [64-1:0] DadoIn,//DADO IN EH O PROXIMO ENDEREÇO
            output logic [64-1:0] DadoOut // DADOOUT EH O ENDERECO ATUAL
        );
//sinal soma 001
always_ff @(posedge clk or posedge reset)
begin	
	if(reset)
		DadoOut <= 64'd0;
	else
	begin
		if (regWrite) begin //SE FOR PRA PASSAR PRO PROXIMO ESTADO, O REG WRITE  DEVE ESTAR 1
		    DadoOut <= DadoIn;
		end
	end		
end
endmodule 
