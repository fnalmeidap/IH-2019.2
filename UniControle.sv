
module UniControle (
	input logic clk,    // Clock
	input logic rst_n,
	output logic estadoUla,
	output logic escritaPC,
	output logic RWmemoria,
	output logic escreveInstr
);

enum bit[1:0]{reset,leMem,addPC,espera}estado,proxEstado;

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
			proxEstado = leMem;
			RWmemoria = 0;
			escreveInstr =0;
			escritaPC=0;
			estadoUla=0;
 			end
			
			leMem:
			begin
			proxEstado = addPC;
			escreveInstr =1;
			RWmemoria = 0;
			escritaPC=0;
			estadoUla=0;
			end
			
			addPC:
			begin
			estadoUla = 1;//soma na ula
			escritaPC = 1;
			escreveInstr =0;
			RWmemoria = 0;
			proxEstado = espera;
			end

			espera:
			begin
			RWmemoria = 0;
			escreveInstr =0;
			escritaPC=0;
			estadoUla=0;
			proxEstado = leMem;
			end

		endcase
	end
endmodule