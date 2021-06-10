module median(
    output logic [15:0] median_o,
	output logic control_o,
    input logic data_av_sync,
    input logic [15:0] data_i,
    //input logic clk_i,
    //input logic rstn_i
	clk_rstn_if interf 
);
logic [15:0] fifo [2:0]; 
//logic [15:0] fifo_0;
//logic [15:0] fifo_1;     
//logic [15:0] fifo_2;
logic [2:0] addr ;  
logic [15:0] temp;

    always_ff @ (posedge interf.clk_i, negedge interf.rstn_i) begin
        if (!interf.rstn_i)begin
		fifo[0] <= 0;
		fifo[1] <= 0;
		fifo[2] <= 0;
	   end
	   else if (data_av_sync) begin
	       fifo[2] <= fifo[1];		
	       fifo[1] <= fifo[0];
	       fifo[0] <= data_i;
        end
    end  

  
    always_ff @ (posedge interf.clk_i, negedge interf.rstn_i) begin
            //control_o signal
         if (!interf.rstn_i) begin
	       control_o <= 0;
	     end
	        else begin
		       if (data_av_sync) begin
			     control_o <= 1;
		    end
		    else begin
			 control_o <= 0;
		    end	
        end
     end

// next steps are the combinational circuit that checks first  
// which register is smaller and to be saved in a register called index_0
// then the 3 cases are checked. 


    always_comb begin    
	   if (fifo[0] < fifo[1]) begin 
		 addr =0;          //fifo[addr] = fifo[0];
		 temp = fifo[0];
	   end
	   else begin
		addr =1;             //fifo[addr] = fifo[1];
		 temp= fifo[1];
		end
	//den afinei na kanw duo diaforetika always_comb dine sfalma
	// multiple drivers for addr
	
	   if ( fifo[2] < temp  )begin   //if fifo[2]< temp  
		addr = 2;             //index = 2
		end
	 end  
/////////////////////////////////////////////	
	
	always_comb begin
	   if (addr == 0) begin 
		  if (fifo[1] < fifo[2]) begin 
		      median_o = fifo[1]; 
		  end	                          // case 1
		  else begin 
			median_o = fifo[2];
		  end
	   end

		
	   else if (addr == 1) begin 
			if (fifo[0] < fifo[2]) begin 
				median_o = fifo[0];
			end
		    else begin
			     median_o = fifo[2];
		    end    
	   end	
	
	   else if (addr == 2) begin 
		  if (fifo[0] < fifo[1]) begin
		      median_o = fifo[0];
		  end
		  else begin 
		       median_o = fifo[1];
		  end
	   end 
    end

endmodule : median
