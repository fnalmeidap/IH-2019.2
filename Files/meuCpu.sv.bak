
module meuCpu(input logic Clk, input logic Reset);
logic regEscreve;
wire[64-1:0] Entrada;
wire[64-1:0] Saida;
logic EstadoDaUla;//soma subtracao...
logic[32-1:0]data;
logic[32-1:0]dataOut;
logic LeituraEscritaMemoria;
logic escreveRegInstr;

	wire [4:0]Instr19_15;
    wire [4:0]Instr24_20;
	wire [4:0]Instr11_7;
	wire [6:0]Instr6_0;	
	wire [31:0]Instr31_0;

register PC(
	    .clk(Clk),
            .reset(Reset),
            .regWrite(regEscreve),
            .DadoIn(Entrada),
            .DadoOut(Saida)
	  );

Ula64 minhaUla(.A(Saida),.B(64'd4),.Seletor(3'd1),.S(Entrada));


UniControle uniCpu(.clk(Clk),
                   .rst_n(Reset),
                   .estadoUla(EstadoDaUla),
                   .escritaPC(regEscreve), 
                   .RWmemoria(LeituraEscritaMemoria),
                   .escreveInstr(escreveRegInstr)
                   );

 Memoria32 meminst 
    (.raddress(Saida[31:0]),
     .waddress(Saida[31:0]),
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
    .Instr31_0(Instr31_0)
    );
  

endmodule
