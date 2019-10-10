module meuCpu(input logic Clk, input logic Reset);
/******ENTRADAS E SAIDAS******/
logic [63:0]SaidaMuxA;
logic [63:0]SaidaMuxB;
logic [63:0]WriteDataReg;
logic [63:0]DeslocValue;
logic [63:0]SaidaMuxPc;
logic [63:0]WriteDataMem;
logic [63:0]MDR;
logic [63:0]SaidaMeuDado;
logic [63:0]EPC;
logic [63:0]EPCProvisorio;
logic [63:0]entradaA;
logic [63:0]entradaB;
logic [63:0]immediate;
logic [63:0]leitura;
wire [4:0]Instr19_15;
wire [4:0]Instr24_20;
wire [4:0]WriteRegister;
wire [6:0]Instr6_0;	
wire [31:0]memOutInst;
logic [63:0]A;
logic [63:0]B;
logic [63:0]AluOut;
logic [63:0]saidaMem64;
logic[32-1:0]data;
logic[32-1:0]dataOut;
wire[64-1:0]Alu;
wire[64-1:0]PC;
/******SELETORES******/
logic [3:0]SeletorMuxA;
logic [3:0]SeletorMuxB;
logic [3:0]SeletorMuxW;
logic [3:0]SeletorMuxPC;
logic [3:0]SeletorMuxMem64;
logic [3:0]seletorMeuDado;
logic [1:0]selShift;
logic [3:0]indicaImmediate;
/********CONTROLE**************/
logic RegWrite;
logic regEscreve;
logic escreveA;
logic escreveB;
logic regEscreveMDR;
logic escreveALUOut;
logic escreveEPC;
logic escreveEPCProvisorio;
logic wrInstMem;
logic IRWrite;
logic LerEscreMem64;
logic [2:0]Estado;//soma subtracao...
logic igual;
logic maior;
logic menor;
logic Overflow;

UniControle uniCpu(
    .clk(Clk),
    .rst_n(Reset),
    .estadoUla(Estado),
    .escritaPC(regEscreve), 
    .RWmemoria(wrInstMem),
    .escreveInstr(IRWrite),
    .instrucao(memOutInst),
    .escreveA(escreveA),
    .escreveB(escreveB),
    .escreveALUOut(escreveALUOut),
    .opcode(Instr6_0),
    .escreveNoBancoDeReg(RegWrite),
    .SeletorMuxA(SeletorMuxA),
    .SeletorMuxB(SeletorMuxB),
    .SeletorMuxW(SeletorMuxW),
    .indicaImmediate(indicaImmediate),
    .iguais(igual),
    .seletorMuxPC(SeletorMuxPC),
    .LerEscreMem64(LerEscreMem64),
    .menor(menor),
    .maior(maior),
    .selShift(selShift),
    .seletorMuxMem64(SeletorMuxMem64),
    .regEscreveMDR(regEscreveMDR),
    .seletorMeuDado(seletorMeuDado),
    .escreveEPC(escreveEPC),
    .escreveEPCProvisorio(escreveEPCProvisorio),
    .Overflow(Overflow)
    );

meuDado myData(
    .entrada1(B),
    .entrada2(MDR), 
    .qualTipo(seletorMeuDado),
    .concatenado(SaidaMeuDado)
    );

Deslocamento meuShift(
    .Shift(selShift),
    .Entrada(A),
    .N(memOutInst[25:20]),
    .Saida(DeslocValue)
    );

SignExtend MeuExtensor(
    .instrucao(memOutInst),
    .immediate(immediate),
    .indicaImmediate(indicaImmediate)
    );  

register meuMDR(
    .clk(Clk),
    .reset(Reset),
    .regWrite(regEscreveMDR),
    .DadoIn(saidaMem64),
    .DadoOut(MDR)
    );

register meuPC(
    .clk(Clk),
    .reset(Reset),
    .regWrite(regEscreve),
    .DadoIn(SaidaMuxPc),
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
register MeuEPC(
    .clk(Clk),
    .reset(Reset),
    .regWrite(escreveEPC),
    .DadoIn(EPCProvisorio),
    .DadoOut(EPC)
);
register MeuEPCProvisorio(
    .clk(Clk),
    .reset(Reset),
    .regWrite(escreveEPCProvisorio),
    .DadoIn(PC),
    .DadoOut(EPCProvisorio)
);
register ALUOut(
    .clk(Clk),
    .reset(Reset),
    .regWrite(escreveALUOut),
    .DadoIn(Alu),
    .DadoOut(AluOut)
	);

Memoria64 minhaMem64(
    .raddress(SaidaMuxPc),
    .waddress(SaidaMuxPc),
    .Clk(Clk),         
    .Datain(WriteDataMem),
    .Dataout(saidaMem64),
    .Wr(LerEscreMem64)
    );
   
bancoReg BancoDeRegistrador(
    .write(RegWrite),
    .clock(Clk),
    .reset(Reset),
    .regreader1(Instr19_15),
    .regreader2(Instr24_20),
    .regwriteaddress(WriteRegister),
    .datain(WriteDataReg),
    .dataout1(entradaA),
    .dataout2(entradaB)			
);

Ula64 minhaUla(
    .A(SaidaMuxA),
    .B(SaidaMuxB),
    .Seletor(Estado),
    .S(Alu),
    .Overflow(Overflow),
    .Igual(igual),
    .Maior(maior),
    .Menor(menor)
    );

mux muxWrite(//escreve no banco reg
    .entradaZero(AluOut),
    .entradaUm(saidaMem64),
    .entradaDois(PC),
    .entradaTres(DeslocValue),
    .entradaQuatro(SaidaMeuDado),
    .entradaCinco(64'd0),
    .entradaSeis(64'd1),
    .seletor(SeletorMuxW),
    .saida(WriteDataReg)
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

mux muxPC( 
    .entradaZero(Alu),
    .entradaUm(AluOut),
    .entradaDois(64'd254),
    .entradaTres(64'd255),
    .entradaQuatro(MDR),
    .seletor(SeletorMuxPC),
    .saida(SaidaMuxPc)
    );

mux muxMem64( 
    .entradaZero(B),
    .entradaUm(SaidaMeuDado),
    .seletor(SeletorMuxMem64),
    .saida(WriteDataMem)
    );

Memoria32 meminst(
    .raddress(PC[31:0]),
    .waddress(PC[31:0]),
    .Clk(Clk),         
    .Datain(data),
    .Dataout(dataOut),
    .Wr(wrInstMem)
    );

Instr_Reg_RISC_V RegInst(
    .Clk(Clk), 
    .Reset(Reset),
    .Load_ir(IRWrite),
    .Entrada(dataOut),
    .Instr19_15(Instr19_15),
    .Instr24_20(Instr24_20),
    .Instr11_7(WriteRegister),
    .Instr6_0(Instr6_0),
    .Instr31_0(memOutInst)
    );
  
endmodule
