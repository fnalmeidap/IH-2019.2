module SignExtend(input logic [31:0]instrucao, output logic [63:0]immediate, input [3:0]indicaImmediate);
logic [51:0] zerado;
logic [50:0] zerado2;
logic[31:0]zerado3;
logic[41:0]zerado4;
always_comb
begin
    case(indicaImmediate)
    1://ADDI
    begin
        if(instrucao[31])
        begin
        assign zerado= '{default:1};
        assign immediate = {zerado,instrucao[31:20]};
        end
        else 
        begin
        assign zerado= '{default:0};
        assign immediate = {zerado,instrucao[31:20]};//isso aq concatena com zero o immediate
        end
    end
    
    2://BEQ E BNE
     begin
        if(instrucao[31])
        begin
        assign zerado2= '{default:1};
        assign immediate = {zerado2,instrucao[31],instrucao[7],instrucao[30:25],instrucao[11:8],1'b0,1'b0};
        end
        else 
        begin
        assign zerado2= '{default:0};
        assign immediate = {zerado2,instrucao[31],instrucao[7],instrucao[30:25],instrucao[11:8],1'b0,1'b0};
        end
     end
    3://LUI
    begin
        if(instrucao[31])
        begin
        assign zerado3= '{default:1};
        assign immediate = {zerado3,instrucao[31:12],12'b0};
        end
        else 
        begin
        assign zerado3= '{default:0};
        assign immediate = {zerado3,instrucao[31:12],12'b0};
    	end
    
    end
    4://sd
    begin
        if(instrucao[31])
        begin
        assign zerado= '{default:1};
        assign immediate = {zerado,instrucao[31:25],instrucao[11:7]};
        end
        else 
        begin
        assign zerado= '{default:0};
        assign immediate = {zerado,instrucao[31:25],instrucao[11:7]};
    	end
     
    end
    5://jal
    begin
        if(instrucao[31])
        begin
        assign zerado4 = '{default:1};
        assign immediate = {zerado4, instrucao[31],instrucao[19:12],instrucao[20],instrucao[30:21],2'b0};

        end
        else 
        begin
        assign zerado4= '{default:0};
        assign immediate = {42'b0, instrucao[31],instrucao[19:12],instrucao[20],instrucao[30:21],2'b0};
    	end
     
    end
endcase
end
endmodule