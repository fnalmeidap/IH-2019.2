module mux(input logic [63:0]entradaZero,
	input logic [63:0]entradaUm,
	input logic [63:0]entradaDois,
	input logic [63:0]entradaTres,
	input logic [63:0]entradaQuatro,
	input logic [63:0]entradaCinco,
	input logic [63:0]entradaSeis,
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
		3:
		begin
		saida = entradaTres;
		end
		4:
		begin
		saida=entradaQuatro;
		end
		5:
		begin
		saida=entradaCinco;
		end
		6:
		begin
		saida=entradaSeis;
		end
endcase
end

endmodule