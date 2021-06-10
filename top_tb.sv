module top_tb;

timeunit 1ns;
timeprecision 100ps;

logic [31:0] avg_o;
logic [15:0] data_i;
logic data_av_ai;
logic clk_i=0;
logic rstn_i=0;

clk_rstn_if interface_top();  
assign interface_top.clk_i=clk_i;    
assign interface_top.rstn_i=rstn_i;   

top top_inst(
.avg_o 			(avg_o),
.data_i			(data_i),
.data_av_ai		(data_av_ai),
.interf			(interface_top)
);

`define PERIOD 10

always
    #(`PERIOD/2) clk_i= ~clk_i;  
    
 initial begin 
 
  rstn_i=0; #30;
  rstn_i=1; data_av_ai=16'd1; data_i=16'd1500; #10;
  rstn_i=1; data_av_ai=16'd0; data_i=16'd1500; #70;
                                           
    rstn_i=1; data_av_ai=16'd1; data_i=16'd100; #10;
    rstn_i=1; data_av_ai=16'd0; data_i=16'd100; #70;
    
    rstn_i=1; data_av_ai=16'd1; data_i=16'd10; #10;
        rstn_i=1; data_av_ai=16'd0; data_i=16'd10; #70; 
    
    
    rstn_i=1; data_av_ai=16'd1; data_i=16'd40000; #10;
    rstn_i=1; data_av_ai=16'd0; data_i=16'd40000; #70;
    
    rstn_i=1; data_av_ai=16'd1; data_i=16'd300; #10;
    rstn_i=1; data_av_ai=16'd0; data_i=16'd300; #70;
     
    rstn_i=1; data_av_ai=16'd1; data_i=16'd1100; #10;
    rstn_i=1; data_av_ai=16'd0; data_i=16'd1100; #70;
                                              
    rstn_i=1; data_av_ai=16'd1; data_i=16'd3500; #10;
    rstn_i=1; data_av_ai=16'd0; data_i=16'd3500; #70                         
                                         
    rstn_i=1; data_av_ai=16'd1; data_i=16'd2000; #10;
    rstn_i=1; data_av_ai=16'd0; data_i=16'd2000; #400;
                                                                                                                                                                                                                                                           
                                         
$finish;
 end    
	
 
endmodule  
    
   

