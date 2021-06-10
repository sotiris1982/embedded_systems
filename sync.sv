module sync(
input logic data_av_ai,
output logic data_av_sync,
clk_rstn_if interf 
);

//internal signals
logic out_ff1;
logic out_ff2;
 always_ff @ (posedge interf.clk_i, negedge interf.rstn_i) begin
	if (!interf.rstn_i) begin
		out_ff1 <= 0;
		out_ff2 <= 0;
        data_av_sync <=0;
	end
	else begin
		out_ff1 <= data_av_ai;
		out_ff2 <= out_ff1;
	end
	 assign data_av_sync = out_ff2;
 end
 
endmodule : sync
