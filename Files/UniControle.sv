
module UniControle (
	input logic clk,    // Clock
	input logic rst_n,
	output logic estadoUla,
	output logic escritaPC,
	output logic RWmemoria,
	output logic escreveInstr,
	output logic escreveA,
	output logic escreveB,
	output logic [63:0]leitura,
	input logic [31:0]instrucao,//instrucao completa
	input logic [6:0]opcode,//o opcode de 7bits
	output logic escreveNoBancoDeReg
);



enum bit[15:0]{reset,leMem,addPC,espera,testaOpcode,tipoR,add,sub}estado,proxEstado;

always_ff @ (posedge clk or posedge rst_n)
	begin
		if(rst_n)begin
			estado <=reset;
		end
		else begin
			estado <= proxEstado;
		end

	end

	always_comb begin
		case(estado)
			reset:
			begin
			proxEstado = addPC;//determina prox estado
			RWmemoria = 0;	   //0 eh o comando de leitura da memoria
			escreveInstr =0;   //0 nao escreve no registrador de instrucao
			escritaPC=0;	   //atualiza o valor de PC
			estadoUla=0;	   //determina o estado da ula
			escreveNoBancoDeReg=0;
 			end
			
			addPC:
			begin
			estadoUla = 1;		//1 eh o estado de soma da ula
			escritaPC = 1;		//atualiza o valor de PC
			escreveInstr =1;	//escreve no registrador de instrucao
			RWmemoria = 0;		//0 apenas le da memoria 32bits
			proxEstado = testaOpcode;
			end

			testaOpcode:
			begin
			RWmemoria = 0;
			escreveInstr =0;
			escritaPC=0;
			estadoUla=0;
			if(opcode==7'b0110011)//opcode de Funcao do tipo R
			begin 
				if(instrucao[31:25]==7'b0000000)//funcao de ADD
				proxEstado=add;
				else
				if(instrucao[31:25]==7'b0100000)//funcao ADD
				proxEstado=sub;
			end
			else
			proxEstado=addPC;
			end
			add:				//so escolhe qual operacao com o mesmo opcode agnt vai pegar
			begin
			//if(instrucao[31:25]==7'b0000000)
			proxEstado = addPC;	
			end
			sub:
			begin
			proxEstado=addPC;
			end	
		default:
		begin
		proxEstado=addPC;
		end 
		endcase
	end
endmodule