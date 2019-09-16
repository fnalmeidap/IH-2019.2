module mux(input logic [64:0]entradaUm,
	input logic [64:0]entradaDois,
	input logic seletor,
	output logic [64:0]saida
	);
always_comb begin
		case(seletor)
		0:
		begin
		saida = entradaUm;
		end
		1:
		begin
		saida = entradaDois;
		end
endcase
end

endmodule