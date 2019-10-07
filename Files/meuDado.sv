module meuDado(input logic [63:0]entrada1,//b
                input logic [63:0]entrada2,//memoria
                input logic [3:0]qualTipo,
                output logic [63:0]concatenado
	);
logic zerado[31:0];
logic zerado1[47:0];
logic zerado2[55:0];
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
        3://LW
        begin
            if(entrada2[31])
            begin
            //assign zerado = '{default:1};
            concatenado = {32'b11111111111111111111111111111111, entrada2[31:0]};
            end
            else
            begin
            assign zerado= '{default:0};
            concatenado = {32'b0, entrada2[31:0]};
            end
        end
        4://LH
        begin
            if(entrada2[15])
            begin
            assign zerado1 = '{default:1};
            concatenado = {48'b111111111111111111111111111111111111111111111111, entrada2[15:0]};
            end
            else
            begin
            assign zerado1= '{default:0};
            concatenado = {48'b0, entrada2[15:0]};
            end
	end
        5://lb
        begin
            if(entrada2[7])
            begin
            assign zerado2 = '{default:1};
            concatenado = {56'b11111111111111111111111111111111111111111111111111111111, entrada2[7:0]};
            end
            else
            begin
            assign zerado2= '{default:0};
            concatenado = {56'b0, entrada2[7:0]};
            end
	end	
        6://lbu
        begin
        
            concatenado = {56'b0, entrada2[7:0]};
	end	

            7://lhu
        begin

            concatenado = {48'b0, entrada2[15:0]};

	end	

            8://lwu
        begin

            concatenado = {31'b0, entrada2[7:0]};
	end	
endcase

end

endmodule