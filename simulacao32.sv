`timescale 1ps/1ps

module simulacao32;
    localparam CLKPERIOD = 10000;
    localparam CLKDELAY = CLKPERIOD / 2; 

    logic clk;
    logic nrst;
    
    parameter ramSize = 4096;
    reg [32-1:0]rdaddress;
    reg [32-1:0]wdaddress;
    reg [32-1:0]data;
    reg fimdaescrita;
    reg Wr;
    wire [32-1:0]q;
    
    Memoria32 meminst 
    (.raddress(rdaddress),
     .waddress(wdaddress),
     .Clk(clk),         
     .Datain(data),
     .Dataout(q),
     .Wr(Wr)
    );  
    //altera_mf_ver
    //gerador de clock
    initial clk = 1'b1;	
    always #(CLKDELAY) clk = ~clk;

    //gerador de reset
    initial
    begin
        nrst = 1'b0;
        #(CLKPERIOD)
        nrst = 1'b1;
        #(CLKPERIOD)
        #(CLKPERIOD)
        nrst = 1'b0;       
    end
    
    //realiza a escrita
    always_ff @(posedge clk or posedge nrst)
    begin
        if(nrst) begin
            wdaddress <= 0;
            Wr <= 1'b0;
            fimdaescrita <= 1'b0;
            data <= 0;
        end
        else begin
            if(wdaddress < 64) begin                
                wdaddress <= wdaddress + 4;
                data <= data + 4;
                Wr <= 1'b1;                
            end
            else begin
                fimdaescrita <= 1'b1;
            end
        end
    end     
    
    //realiza a leitura
    always_ff @(posedge clk or posedge nrst)
    begin
        if(nrst) begin
            rdaddress <= 0;
        end
        else begin
            if(fimdaescrita) begin
                if(rdaddress < 64) begin
                    rdaddress <= rdaddress + 4;
                end
                else begin
                    rdaddress <= 0;
                    $stop;
                end
            end
            else begin
                rdaddress <= 0;
            end
        end
    end
                
endmodule
