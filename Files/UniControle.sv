
module UniControle (
	input logic clk,    		// Clock
	input logic rst_n,			//reset
	output logic [2:0]estadoUla,//seleciona estado da ula (Soma, Sub...)
	output logic escritaPC,		//habilita a escrita no PC
	output logic RWmemoria,		//0 deixa ler da memoria de 32 bits
	output logic escreveInstr,	//habilita escrita no registrador de instrucoes
	output logic escreveA,		//habilita escrita no registrador que guarda o valor de A do banco de registradores
	output logic escreveB,		//habilita escrita no registrador que guarda o valor de B do banco de registradores
	output logic [63:0]leitura, 
	input logic [31:0]instrucao,//instrucao completa
	input logic [6:0]opcode,//o opcode de 7bits
	output logic escreveNoBancoDeReg,//habilita escrita no banco de registradores
	output logic [3:0]SeletorMuxA, //Escolhe o valor que vai entrar no A da ULA (PC OU Reginstrador A da operacao  dada pelo opcode)
	output logic [3:0]SeletorMuxB,//Escolhe o valor que vai entrar no B da ULA (PC OU Reginstrador B da operacao  dada pelo opcode)
	output logic [3:0]indicaImmediate,//para as funcoes que precisamd e immediate, calcula aqui
	input logic iguais//indica se as entradas na ula sao iguais
);




enum bit[15:0]{reset,leMem,addPC,espera,escrita,testaOpcode,tipoR,add,sub,addi,beq,bne,comparaBEQ,comparaBNE,lui}estado,proxEstado;

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
			SeletorMuxA=0;
			SeletorMuxB=0;
			escreveNoBancoDeReg=0;
			indicaImmediate=0;
			escreveA=0;
			escreveB=0;
 			end
			
			addPC:
			begin
			estadoUla = 1;		//1 eh o estado de soma da ula
			escritaPC = 1;		//atualiza o valor de PC
			escreveInstr =1;	//escreve no registrador de instrucao
			RWmemoria = 0;		//0 apenas le da memoria 32bits
			proxEstado = testaOpcode;
			SeletorMuxA=0;
			SeletorMuxB=0;
			escreveNoBancoDeReg=0;
			indicaImmediate=0;
			escreveA=0;
			escreveB=0;
			end

			
			testaOpcode:
			begin
			RWmemoria = 0;
			escreveInstr =0;
			escritaPC=0;
			estadoUla=0;
			SeletorMuxA=0;
			SeletorMuxB=0;
			escreveNoBancoDeReg=0;
			indicaImmediate=0;
			proxEstado=addPC;
			//*******************************************
			
			if(opcode==7'b0110011)//opcode de Funcao do tipo R
			begin 
				if(instrucao[31:25]==7'b0000000)//funcao de ADD
				begin
				proxEstado=add;
				escreveA=1;						//escreve no registrador A (registrador cujo recebe valor do banco de registradores) 
				escreveB=1;						//escreve no registrador B (registrador cujo recebe valor do banco de registradores)
				end
				else
				if(instrucao[31:25]==7'b0100000)//funcao SUB
				proxEstado=sub;
				escreveA=1;						//escreve no registrador A (registrador cujo recebe valor do banco de registradores) 
				escreveB=1;	
			end
			//*******************************************
			
			if(opcode==7'b0010011)//funcao addi
			begin
			proxEstado=addi;
			end
			//*******************************************
			
			if(opcode==7'b1100011)//funcao do tipo SB
			begin
				if(instrucao[14:12]==3'b000)//funcao beq
				begin
				proxEstado = comparaBEQ;
				escreveA=1;						//escreve no registrador A (registrador cujo recebe valor do banco de registradores) 
				escreveB=1;	
				end
				if(instrucao[14:12]==3'b001)//funcaoBNE
				begin
				proxEstado=comparaBNE;
				escreveA=1;						//escreve no registrador A (registrador cujo recebe valor do banco de registradores) 
				escreveB=1;	
				end
			end
			
			//*******************************************
			if(opcode==7'b0110111)//lui
			begin
			proxEstado = lui;
			end

			//*******************************************
			end
			
			add:				//so escolhe qual operacao com o mesmo opcode agnt vai pegar
			begin
			RWmemoria = 0;			
			escreveInstr =0;
			escritaPC=0;
			proxEstado = escrita;
			estadoUla= 1;			// estado de soma da ULA(1)
			SeletorMuxA=1;
			SeletorMuxB=1;
			escreveNoBancoDeReg=0;
			indicaImmediate=0;	
			end
			
			sub:
			begin
			RWmemoria = 0;
			escreveInstr =0;
			escritaPC=0;
			proxEstado=escrita;		//vai pro estado de escrever no banco de registradores
			estadoUla= 2;			//Estado de subtracao da ULA(2)
			SeletorMuxA=1;
			SeletorMuxB=1;
			escreveNoBancoDeReg=0;
			indicaImmediate=0;
			end	

			addi:
			begin
			RWmemoria = 0;
			escreveInstr =0;
			escritaPC=0;
			estadoUla= 1;			//Estado de soma da ULA(2)
			SeletorMuxA=1;
			SeletorMuxB=2;
			escreveNoBancoDeReg=0;
			indicaImmediate=1;//CALCULA IMMEDIATE DA FUNCAO ADDI NO SIGNeXTEND
			proxEstado=escrita;
			end

			comparaBEQ:
			begin
			RWmemoria = 0;
			escreveInstr =0;
			escritaPC=0;
			estadoUla= 6;			//Estado de soma da ULA(2)
			SeletorMuxA=1;
			SeletorMuxB=1;
			escreveNoBancoDeReg=0;
			indicaImmediate=1;
			if(iguais)
			proxEstado=beq;
			else
			proxEstado=addPC;
			end

			comparaBNE:
			begin
			RWmemoria = 0;
			escreveInstr =0;
			escritaPC=0;
			estadoUla= 6;			//Estado de soma da ULA(2)
			SeletorMuxA=1;
			SeletorMuxB=1;
			escreveNoBancoDeReg=0;
			indicaImmediate=1;
			if(iguais)
			proxEstado=addPC;
			else
			proxEstado = bne;
			end

			beq:
			begin
			RWmemoria = 0;
			escreveInstr =0;
			escritaPC=1;
			estadoUla= 1;			//Estado de soma da ULA(2)
			SeletorMuxA=0;
			SeletorMuxB=2;
			escreveNoBancoDeReg=0;
			indicaImmediate=2;//CALCULA IMMEDIATE DA FUNCAO BEQ E BNE NO SIGNeXTEND
			proxEstado=addPC;
			end

			bne:
			begin
			RWmemoria = 0;
			escreveInstr =0;
			escritaPC=1;
			estadoUla= 1;			//Estado de soma da ULA(2)
			SeletorMuxA=0;
			SeletorMuxB=2;
			escreveNoBancoDeReg=0;
			indicaImmediate=2;//CALCULA IMMEDIATE DA FUNCAO BEQ E BNE NO SIGNeXTEND
			proxEstado=addPC;
			end

			lui:
			begin
			RWmemoria = 0;
			escreveInstr =0;
			escritaPC=0;
			estadoUla= 1;			
			SeletorMuxA=2;
			SeletorMuxB=2;
			escreveNoBancoDeReg=0;
			indicaImmediate=3;//CALCULA IMMEDIATE DA FUNCAO BEQ E BNE NO SIGNeXTEND
			proxEstado=escrita;
			end

			escrita:
			begin
			escreveNoBancoDeReg=1; //habilita escrita no banco de registradores
			proxEstado=addPC;
			end
		
		default:
		begin
		proxEstado=addPC;
		end 
		endcase
	end
endmodule