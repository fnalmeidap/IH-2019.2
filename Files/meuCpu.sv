
module meuCpu(input logic Clk, input logic Reset);
logic regEscreve;
wire[64-1:0] SaidaDaUla;
wire[64-1:0] PC;
logic [2:0]EstadoDaUla;//soma subtracao...
logic[32-1:0]data;
logic[32-1:0]dataOut;
logic LeituraEscritaMemoria;
logic escreveRegInstr;
logic [63:0]A;
logic [63:0]B;
logic [63:0]WriteRegister;
logic [63:0]entrada64;
logic escreveA;
logic escreveB;
logic [63:0]leitura;
	
    wire [4:0]Instr19_15;
    wire [4:0]Instr24_20;
	wire [4:0]Instr11_7;
	wire [6:0]Instr6_0;	
	wire [31:0]memOutInst;
	logic [63:0]SaidaMuxA;
    logic [63:0]SaidaMuxB;
	logic [3:0]SeletorMuxA;
    logic [3:0]SeletorMuxB;
	logic escreveNoBancoDeReg;
    logic escreveALUOut;
    logic [63:0]entradaA;
    logic [63:0]entradaB;
    logic [63:0]immediate;
    logic [3:0]indicaImmediate;
    logic [11:0]testeImmediate;
    logic igual;
    assign testeImmediate = memOutInst[31:20];
//saida = {instrucao[31:5], instrucao[10:6]}
UniControle uniCpu(.clk(Clk),
                   .rst_n(Reset),
                   .estadoUla(EstadoDaUla),
                   .escritaPC(regEscreve), 
                   .RWmemoria(LeituraEscritaMemoria),
                   .escreveInstr(escreveRegInstr),
                   .instrucao(memOutInst),
                   .escreveA(escreveA),
                   .escreveB(escreveB),
                   .leitura(leitura),
                   .opcode(Instr6_0),
                   .escreveNoBancoDeReg(escreveNoBancoDeReg),
		           .SeletorMuxA(SeletorMuxA),
                   .SeletorMuxB(SeletorMuxB),
                   .indicaImmediate(indicaImmediate),
                   .iguais(igual)
                   );

SignExtend MeuExtensor(
                       .instrucao(memOutInst),
                       .immediate(immediate),
                       .indicaImmediate(indicaImmediate)
                       );  

register meuPC(
	        .clk(Clk),
            .reset(Reset),
            .regWrite(regEscreve),
            .DadoIn(SaidaDaUla),
            .DadoOut(PC)
	  );

register meuA(
	        .clk(Clk),
            .reset(Reset),
            .regWrite(escreveA),
            .DadoIn(entradaA),
            .DadoOut(A)
	  );
register meuB(
	        .clk(Clk),
            .reset(Reset),
            .regWrite(escreveB),
            .DadoIn(entradaB),
            .DadoOut(B)
	  );
/*register ALUOut(
	        .clk(Clk),
            .reset(Reset),
            .regWrite(escreveALUOut),
            .DadoIn(SaidaDaUla),
            .DadoOut(B)
	  );*/
/*
module Memoria64 
    (.raddress(),
     .waddress(entradaA),
     .Clk(Clk),         
     .Datain(entradaB),
     .Dataout(),
     .Wr()
    );
   */
 
  bancoReg BancoDeRegistrador(
			                .write(escreveNoBancoDeReg),
                            .clock(Clk),
                            .reset(Reset),
                            .regreader1(Instr19_15),
                            .regreader2(Instr24_20),
                            .regwriteaddress(Instr11_7),
                            .datain(SaidaDaUla),
                            .dataout1(entradaA),
                            .dataout2(entradaB)
				
);


Ula64 minhaUla(
    .A(SaidaMuxA),
    .B(SaidaMuxB),
    .Seletor(EstadoDaUla),
    .S(SaidaDaUla),
    .Igual(igual)
    );

mux muxA(
    .entradaZero(PC),
    .entradaUm(A),
    .entradaDois(64'd0),
    .seletor(SeletorMuxA),
    .saida(SaidaMuxA)
);

mux muxB(
         .entradaZero(64'd4),
         .entradaUm(B),
         .entradaDois(immediate),
         .seletor(SeletorMuxB),
         .saida(SaidaMuxB) 
);

 Memoria32 meminst 
    (.raddress(PC[31:0]),
     .waddress(PC[31:0]),
     .Clk(Clk),         
     .Datain(data),
     .Dataout(dataOut),
     .Wr(LeituraEscritaMemoria)
    );

Instr_Reg_RISC_V RegInst(
    .Clk(Clk), 
    .Reset(Reset),
    .Load_ir(escreveRegInstr),
    .Entrada(dataOut),
    .Instr19_15(Instr19_15),
    .Instr24_20(Instr24_20),
    .Instr11_7(Instr11_7),
    .Instr6_0(Instr6_0),
    .Instr31_0(memOutInst)
    );
  

endmodule
