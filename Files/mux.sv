module mux(input logic [63:0]entradaZero,
	input logic [63:0]entradaUm,
	input logic [63:0]entradaDois,
	input logic [3:0]seletor,
	output logic [63:0]saida
	);
always_comb begin
		case(seletor)
		0:
		begin
		saida = entradaZero;
		end
		1:
		begin
		saida = entradaUm;
		end
		2:
		begin
		saida = entradaDois;
		end
endcase
end

endmodule