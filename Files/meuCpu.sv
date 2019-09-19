module meuCpu(input logic Clk, input logic Reset);

logic regEscreve;
wire[64-1:0] SaidaDaUla;
wire[64-1:0] PC;
logic [2:0]EstadoDaUla;//soma subtracao...
logic[32-1:0]data;
logic[32-1:0]dataOut;
logic LeituraEscritaMemoria;
logic escreveRegInstr;
logic LerEscreMem64;
logic [63:0]A;
logic [63:0]B;
logic [63:0]SaidaRegAluOut;
logic [63:0]WriteRegister;
logic [63:0]saidaMem64;
logic escreveA;
logic escreveB;
logic escreveALUOut;
logic [63:0]leitura;
wire [4:0]Instr19_15;
wire [4:0]Instr24_20;
wire [4:0]Instr11_7;
wire [6:0]Instr6_0;	
wire [31:0]memOutInst;
/******SAIDAS******/
logic [63:0]SaidaMuxA;
logic [63:0]SaidaMuxB;
logic [63:0]SaidaMuxW;
logic [63:0]SaidaMuxPc;
/******SELETORES******/
logic [3:0]SeletorMuxA;
logic [3:0]SeletorMuxB;
logic [3:0]SeletorMuxW;
logic [3:0]SeletorMuxPC;
logic escreveNoBancoDeReg;
logic [63:0]entradaA;
logic [63:0]entradaB;
logic [63:0]immediate;
logic [3:0]indicaImmediate;
logic [11:0]testeImmediate;
logic igual;
assign testeImmediate = memOutInst[31:20];

UniControle uniCpu(
    .clk(Clk),
    .rst_n(Reset),
    .estadoUla(EstadoDaUla),
    .escritaPC(regEscreve), 
    .RWmemoria(LeituraEscritaMemoria),
    .escreveInstr(escreveRegInstr),
    .instrucao(memOutInst),
    .escreveA(escreveA),
    .escreveB(escreveB),
    .escreveALUOut(escreveALUOut),
    .leitura(leitura),
    .opcode(Instr6_0),
    .escreveNoBancoDeReg(escreveNoBancoDeReg),
    .SeletorMuxA(SeletorMuxA),
    .SeletorMuxB(SeletorMuxB),
    .SeletorMuxW(SeletorMuxW),
    .indicaImmediate(indicaImmediate),
    .iguais(igual),
    .seletorMuxPC(SeletorMuxPC),
    .LerEscreMem64(LerEscreMem64)
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

register ALUOut(
    .clk(Clk),
    .reset(Reset),
    .regWrite(escreveALUOut),
    .DadoIn(SaidaDaUla),
    .DadoOut(SaidaRegAluOut)
	);

Memoria64 minhaMem64(
    .raddress(SaidaMuxPc),
    .waddress(SaidaMuxPc),
    .Clk(Clk),         
    .Datain(B),
    .Dataout(saidaMem64),
    .Wr(LerEscreMem64)
    );
   
bancoReg BancoDeRegistrador(
    .write(escreveNoBancoDeReg),
    .clock(Clk),
    .reset(Reset),
    .regreader1(Instr19_15),
    .regreader2(Instr24_20),
    .regwriteaddress(Instr11_7),
    .datain(SaidaMuxW),
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

mux muxWrite(
    .entradaZero(SaidaRegAluOut),
    .entradaUm(saidaMem64),
    //.entradaDois(64'd0),
    .seletor(SeletorMuxW),
    .saida(SaidaMuxW)
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
    .entradaZero(SaidaDaUla),
    .entradaUm(SaidaRegAluOut),
    .seletor(SeletorMuxPC),
    .saida(SaidaMuxPc)
    );

Memoria32 meminst(
    .raddress(PC[31:0]),
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
