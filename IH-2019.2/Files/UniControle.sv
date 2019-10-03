
module UniControle (
	input logic clk,    		// Clock
	input logic rst_n,			//reset
	output logic [2:0]estadoUla,//seleciona estado da ula (Soma, Sub...)
	output logic escritaPC,		//habilita a escrita no PC
	output logic RWmemoria,		//0 deixa ler da memoria de 32 bits
	output logic escreveInstr,	//habilita escrita no registrador de instrucoes
	output logic escreveA,		//habilita escrita no registrador que guarda o valor de A do banco de registradores
	output logic escreveB,		//habilita escrita no registrador que guarda o valor de B do banco de registradores
	output logic escreveALUOut,//ESCREVE NO REGISTRADOR DE SAIDA DA ULA
	output logic [63:0]leitura, //NAO USADO
	input logic [31:0]instrucao,//instrucao completa
	input logic [6:0]opcode,//o opcode de 7bits
	output logic escreveNoBancoDeReg,//habilita escrita no banco de registradores
	output logic [3:0]SeletorMuxA, //Escolhe o valor que vai entrar no A da ULA (PC OU Reginstrador A da operacao  dada pelo opcode)
	output logic [3:0]SeletorMuxB,//Escolhe o valor que vai entrar no B da ULA (PC OU Reginstrador B da operacao  dada pelo opcode)
	output logic [3:0]SeletorMuxW,//SELECIONA OQ VAI ENTRAR NO PC
	output logic [3:0]indicaImmediate,//para as funcoes que precisamd e immediate, calcula aqui
	input logic iguais,//indica se as entradas na ula sao iguais
	output logic [3:0]seletorMuxPC,
	output logic LerEscreMem64,
	input logic menor, 
	input logic maior,
	output logic escrevemeushift,
	output logic [1:0]selShift,
	output logic [3:0]seletorMuxMem64,
	output logic regEscreveMDR, 
	output logic [3:0]seletorMeuDado
	
	

);




enum bit[15:0]{reset, atualizaPC, leMem, addPC, esperaMeuDado,escritaMemoria2, espera, pegaEConcatena, escrita, nops, store, slli, srli, srai, testaOpcode, breaks, tipoR, bge, blt, add, sub, addi, beq, bne, lui, ld, sd, jal, escritaMemoria, escritaPulos}estado,proxEstado;

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
				escreveALUOut=0;
				seletorMuxPC=0;
				LerEscreMem64=0;
				escrevemeushift = 0;
				seletorMuxMem64=0;
				
				regEscreveMDR=0;
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
				escreveALUOut=1;
				seletorMuxPC=0;
				escrevemeushift = 0;
				LerEscreMem64=0;
				seletorMuxMem64=0;
				
				regEscreveMDR=0;
			end
			
			testaOpcode:
			begin
				RWmemoria = 0;
				escreveInstr =0;
				escritaPC=0;
				escreveNoBancoDeReg=0;
				//indicaImmediate=0;
				proxEstado=addPC;
				//*******************************************
				escreveA = 1;
				escreveB=1;
				if(opcode==7'b0110011)//opcode de Funcao do tipo R
				begin 
					if(instrucao[31:25]==7'b0000000)//funcao de ADD
					begin
						proxEstado=add;					//escreve no registrador B (registrador cujo recebe valor do banco de registradores)
					end
					else
					if(instrucao[31:25]==7'b0100000)//funcao SUB
						proxEstado=sub;
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
						indicaImmediate=2;
						proxEstado = beq;
						estadoUla=1;
						SeletorMuxA=0;
						SeletorMuxB=2;
						escreveALUOut=1;
					end
				end
				
				if(opcode==7'b1100111)
				begin
					if(instrucao[14:12]==3'b001)begin//bne
						indicaImmediate=2;
						proxEstado=bne;
						estadoUla=1;
						SeletorMuxA=0;
						SeletorMuxB=2;
						escreveALUOut=1;
					end
					if(instrucao[14:12]==3'b101)begin//bge
						indicaImmediate=2;
						proxEstado=bge;
						estadoUla=1;
						SeletorMuxA=0;
						SeletorMuxB=2;
						escreveALUOut=1;
					end
					if(instrucao[14:12]==3'b100)begin//blt
						indicaImmediate=2;
						proxEstado=blt;
						estadoUla=1;
						SeletorMuxA=0;
						SeletorMuxB=2;
						escreveALUOut=1;
					end
				end
				//*******************************************
				if(opcode==7'b0110111)//lui
				begin
					proxEstado = lui;
				end

				if(opcode==7'b0000011)//ld
				begin
					if(instrucao[14:12]==3'b011)
					begin
						LerEscreMem64=0;
						indicaImmediate=1;
						proxEstado = ld;
						seletorMuxMem64=0;
					end
				end
				
				if(opcode==7'b0100011)//sd
				begin
					if(instrucao[14:12]==3'b111)//sd
					begin
						LerEscreMem64=0;
						proxEstado=sd;
						indicaImmediate=4;
						seletorMuxMem64=0;
					end
				//*******************************************
					if(instrucao[14:12]==3'b010)//SW
					begin
						LerEscreMem64=0;
						proxEstado=store;
						seletorMeuDado=0;
						indicaImmediate=4;
					end
					if(instrucao[14:12]==3'b001)//SH
					begin
						LerEscreMem64=0;
						proxEstado=store;
						seletorMeuDado=1;
						indicaImmediate=4;
					end
					if(instrucao[14:12]==3'b000)//SB
					begin
						LerEscreMem64=0;
						proxEstado=store;
						seletorMeuDado=2;
						indicaImmediate=4;
					end
				end
				//*******************************************
				if(opcode==7'b1101111)//jal
				begin
					proxEstado=jal;
					indicaImmediate=5;
					estadoUla=1;
					SeletorMuxA=0;
					SeletorMuxB=2;
					escreveALUOut=1;
				end

				if(opcode==7'b1110011)//break
				begin
					proxEstado=breaks;
				end
			if(opcode==7'b0010011)//shifts
				begin
					if(instrucao[14:12]==3'b101)begin
						if(instrucao[31:26]==6'b000000) begin//srli
							selShift = 2'b01;
							proxEstado = srli;
						end
						if(instrucao[31:26]==6'b010000) begin//srai
							selShift = 2'b10;
							proxEstado = srai;
						end
					end
					if(instrucao[14:12]==3'b001)begin//slli
						selShift = 2'b00;
						proxEstado = slli;
					end
				end
			
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
				escreveALUOut=1;
				escreveNoBancoDeReg=0;
				indicaImmediate=0;
				SeletorMuxW=0;
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
				escreveALUOut=1;
				escreveNoBancoDeReg=0;
				indicaImmediate=0;
				SeletorMuxW=0;
			end	

			addi:
			begin
				RWmemoria = 0;
				escreveInstr =0;
				escritaPC=0;
				estadoUla= 1;			//Estado de soma da ULA(2)
				SeletorMuxA=1;
				SeletorMuxB=2;
				escreveALUOut=1;
				escreveNoBancoDeReg=0;
				indicaImmediate=1;//CALCULA IMMEDIATE DA FUNCAO ADDI NO SIGNeXTEND
				proxEstado=escrita;
				SeletorMuxW=0;
			end

			beq:
			begin
				RWmemoria = 0;
				escreveInstr =0;
				escritaPC=0;
				estadoUla= 6;			//Estado de soma da ULA(2)
				SeletorMuxA=1;
				SeletorMuxB=1;
				escreveNoBancoDeReg=0;
				indicaImmediate=2;
				escreveALUOut=0;
				SeletorMuxW=0;
				if(iguais)
				begin
					escritaPC=1;
					proxEstado=escritaPulos;
					seletorMuxPC=1;
				end
				else
				begin
					proxEstado=addPC;
					escritaPC=0;
					seletorMuxPC=0;
				end
			end

			bne:
			begin
				RWmemoria = 0;
				escreveInstr =0;
				
				estadoUla= 6;			//Estado de soma da ULA(2)
				SeletorMuxA=1;
				SeletorMuxB=1;
				escreveNoBancoDeReg=0;
				indicaImmediate=2;
				escreveALUOut=0;
				SeletorMuxW=0;
				if(iguais)
				begin
					proxEstado=addPC;
					escritaPC=0;
					seletorMuxPC=0;
				end
				else
				begin
					proxEstado = escritaPulos;
					escritaPC=1;
					seletorMuxPC=1;
				end
			end

			lui:
			begin
				RWmemoria = 0;
				escreveInstr = 0;
				escritaPC=0;
				estadoUla= 1;			
				SeletorMuxA=2;
				SeletorMuxB=2;
				escreveNoBancoDeReg=0;
				indicaImmediate=3;//CALCULA IMMEDIATE DA FUNCAO BEQ E BNE NO SIGNeXTEND
				proxEstado=escrita;
				SeletorMuxW=0;
			end

			escrita:
			begin
				escreveNoBancoDeReg=1; //habilita escrita no banco de registradores
				proxEstado=addPC;
				escreveALUOut=0;
			end

			ld:
			begin
				RWmemoria = 0;//32bits
				escreveInstr =0;
				escritaPC=0;
				LerEscreMem64=0;
				estadoUla=1;
				SeletorMuxA=1;
				SeletorMuxB=2;
				escreveALUOut=1;
				proxEstado=escrita;
				SeletorMuxW=1;
				seletorMuxPC=0;
			end

			store://store para word, half, byte
			begin
				RWmemoria = 0;//32bits
				escreveInstr =0;
				escritaPC=0;
				LerEscreMem64=1;
				estadoUla=1;
				SeletorMuxA=1;
				SeletorMuxB=2;
				escreveALUOut=1;
				proxEstado=pegaEConcatena;
				SeletorMuxW=1;
				seletorMuxPC=0;
			end

			sd:
			begin
				RWmemoria = 0;//32bits
				escreveInstr = 0;
				escritaPC = 0;
				LerEscreMem64 = 1;
				estadoUla = 1;
				SeletorMuxA = 1;
				SeletorMuxB = 2;
				escreveALUOut = 0;
				proxEstado = escritaMemoria;
				SeletorMuxW = 1;
				seletorMuxPC = 0;
			end

			pegaEConcatena:
			begin
				LerEscreMem64=1;
				regEscreveMDR=1;
				proxEstado = esperaMeuDado;
			end

			esperaMeuDado:
			begin
				LerEscreMem64=1;
				seletorMuxMem64 = 1;
				proxEstado = escritaMemoria2;
			end

			jal:
			begin
				RWmemoria = 0;
				escreveInstr = 0;
				escritaPC=1;		
				escreveNoBancoDeReg=1;
				escreveALUOut=0;
				SeletorMuxW=2;
				proxEstado = escritaPulos;
			end

			bge:
			begin
				RWmemoria = 0;
				escreveInstr =0;
				escritaPC=0;
				estadoUla= 6;			//Estado de soma da ULA(2)
				SeletorMuxA=1;
				SeletorMuxB=1;
				escreveNoBancoDeReg=0;
				indicaImmediate=2;
				escreveALUOut=0;
				SeletorMuxW=0;
				if(menor)
				begin
					proxEstado=addPC;
					escritaPC=0;
					seletorMuxPC=0;
				end
				else
				begin
					escritaPC=1;
					proxEstado=escritaPulos;
					seletorMuxPC=1;
				end
			end

			blt:
			begin
				RWmemoria = 0;
				escreveInstr =0;
				escritaPC=0;
				estadoUla= 6;			//Estado de soma da ULA(2)
				SeletorMuxA=1;
				SeletorMuxB=1;
				escreveNoBancoDeReg=0;
				indicaImmediate=2;
				escreveALUOut=0;
				SeletorMuxW=0;
				if(menor)
				begin
					escritaPC=1;
					proxEstado=escritaPulos;
					seletorMuxPC=1;
				end
				else
				begin
					proxEstado=addPC;
					escritaPC=0;
					seletorMuxPC=0;
				end
			end

			breaks:
			begin
				proxEstado = breaks;
			end
			
			slli: 
			begin
				proxEstado = escrita;
				escrevemeushift = 1;
				SeletorMuxW=3;
			end

			srli: 
			begin
				proxEstado = escrita;
				escrevemeushift = 1;
				SeletorMuxW=3;
			end

			srai: 
			begin
				proxEstado = escrita;
				escrevemeushift = 1;
				SeletorMuxW=3;
			end

			escritaPulos:
			begin
				proxEstado=addPC;
			end

			escritaMemoria:
			begin
				LerEscreMem64=0;
				proxEstado=addPC;
			end

			escritaMemoria2:
			begin
				LerEscreMem64=0;
				proxEstado=escritaPulos;
			end
			
			default:
			begin
				proxEstado=addPC;
				escreveALUOut=0;
			end 
		endcase
	end
endmodule