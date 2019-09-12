`timescale 1ps/1ps

module simulacaobancoderegistrador;
    localparam CLKPERIOD = 10000;
    localparam CLKDELAY = CLKPERIOD / 2; 

    logic clk;
    logic rst;
    
    parameter ramSize = 32;
    reg [5-1:0]rdaddress1;
    reg [5-1:0]rdaddress2;
    reg [5-1:0]wdaddress;
    reg [64-1:0]datain;
    reg fimdaescrita;
    reg Wr;
    wire [64-1:0]dataout1;
    wire [64-1:0]dataout2;
    
    bancoReg reginst(
            .clock(clk),
            .write(Wr),             
            .reset(rst),
            .regreader1(rdaddress1),
            .regreader2(rdaddress2),
            .regwriteaddress(wdaddress),
            .datain(datain),
            .dataout1(dataout1),
            .dataout2(dataout2)
        );
    
    /*Memoria32 meminst 
    (.raddress(rdaddress),
     .waddress(wdaddress),
     .Clk(clk),         
     .Datain(data),
     .Dataout(q),
     .Wr(Wr)
    ); */ 
    
    //gerador de clock
    initial clk = 1'b1;	
    always #(CLKDELAY) clk = ~clk;

    //gerador de reset
    initial
    begin
        rst = 1'b0;
        #(CLKPERIOD)
        rst = 1'b1;
        #(CLKPERIOD)
        #(CLKPERIOD)
        rst = 1'b0;       
    end
    
    //realiza a escrita
    always_ff @(posedge clk or posedge rst)
    begin
        if(rst) begin
            wdaddress <= 0;
            Wr <= 1'b0;
            fimdaescrita <= 1'b0;
            datain <= 0;
        end
        else begin
            if( (5'(wdaddress) + 5'(1)) < 32) begin                
                wdaddress <= wdaddress + 1;
                datain <= datain + 1;
                Wr <= 1'b1;                
            end
            else begin
                fimdaescrita <= 1'b1;
                Wr <= 1'b0;  
            end
        end
    end     
    
    //realiza a leitura
    always_ff @(posedge clk or posedge rst)
    begin
        if(rst) begin
            rdaddress1 <= 0;
            rdaddress2 <= 31;
        end
        else begin
            if(fimdaescrita) begin
                if((5'(rdaddress1) + 5'(1)) < 32) begin
                    rdaddress1 <= rdaddress1 + 1;
                    rdaddress2 <= rdaddress2 - 1;
                end
                else begin
                    rdaddress1 <= 0;
                    rdaddress2 <= 31;
                    $stop;
                end
            end
            else begin
                rdaddress1 <= 0;
                rdaddress2 <= 31;
            end
        end
    end
                
endmodule
