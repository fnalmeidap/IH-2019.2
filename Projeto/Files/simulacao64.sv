`timescale 1ps/1ps

module simulacao64;
    localparam CLKPERIOD = 10000;
    localparam CLKDELAY = CLKPERIOD / 2; 

    logic clk;
    logic nrst;
    
    parameter ramSize = 4096;
    reg [64-1:0]rdaddress;
    reg [64-1:0]wdaddress;
    reg [64-1:0]data;
    reg fimdaescrita;
    reg Wr;
    wire [64-1:0]q;
    
    Memoria64 meminst 
    (.raddress(rdaddress),
     .waddress(wdaddress),
     .Clk(clk),         
     .Datain(data),
     .Dataout(q),
     .Wr(Wr)
    );  
    
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
                wdaddress <= wdaddress + 8;
                data <= data + 8;
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
                    rdaddress <= rdaddress + 8;
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
