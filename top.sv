module top(
	output logic [31:0] avg_o,
	input logic [15:0] data_i,
	input logic data_av_ai,
	clk_rstn_if interf
	);
	
//internal signals
logic data_av_sync; // eswteriko sima toy sync module

// eswterika simata median
logic [15:0] median_o;
logic control_o_m;

// internal signals fsm_wr 
logic [15:0] wr_data;
logic control_o_wr;
logic [2:0] addr_wr;
logic control_rd;
logic control_i;
logic median_i;

// internal signals fsm_rd
logic [2:0] addr_rd;
//logic [31:0] avg;
logic [15:0] rd_data;
logic control_i_rd;




//instantiations

sync sync_inst(
.data_av_ai    (data_av_ai),
.data_av_sync  (data_av_sync),
.interf        (interf)
);

median median_inst(
.median_o       (median_o),
.control_o      (control_o_m),
.data_av_sync   (data_av_sync),
.data_i         (data_i),
.interf         (interf)
);



fsm_wr fsm_wr_inst(
.wr_data        (wr_data),
.control_o      (control_o_wr),
.addr	        (addr_wr),
.control_rd     (control_rd),
.median_i       (median_o),
.control_i      (control_o_m),
.interf         (interf)
);



blk_mem_gen_0 blk_mem_inst(
.addra           (addr_wr), // apo tin fsm_wr
.clka            (interf.clk_i),
.dina            (wr_data),
.wea             (control_o_wr),
.doutb           (rd_data),
.addrb           (addr_rd),// erxete apo tin fsm_rd
.clkb            (interf.clk_i)
);


fsm_rd fsm_rd_inst(
.avg_o       (avg_o),
.addr	     (addr_rd),
.rd_data     (rd_data),
.control_i   (control_rd),
.interf     (interf)
);


endmodule : top