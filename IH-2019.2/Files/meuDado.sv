module meuDado(input logic [63:0]entrada1,//b
                input logic [63:0]entrada2,//memoria
                input logic [3:0]qualTipo,
                output logic [63:0] concatenado
	);

always_comb begin
	case(qualTipo)
        0://SW
        begin
            concatenado = {entrada2[63:32], entrada1[31:0]};
        end
        1://SH
        begin
            concatenado = {entrada2[63:16], entrada1[15:0]};
        end
        2://SB
        begin
            concatenado = {entrada2[63:8], entrada1[7:0]};
        end
endcase

end

endmodule