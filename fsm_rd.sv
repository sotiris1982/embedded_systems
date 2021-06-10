
module fsm_rd(
    output logic [2:0] addr,
    output logic [31:0] avg_o,
    input  logic [15:0] rd_data,
    input  logic control_i,
    //input  logic clk_i,
    //input  logic rstn_i
	 clk_rstn_if interf  
    );



typedef enum logic[5:0] {IDLE, REQUEST, WAITING,WAITING1, RECEIVE, CALCULATE} state_t;
state_t fsm_state; 
logic [2:0] addr_req; // internal signal connected to addr output to ask for adderess 
//logic [15:0] rd_data_rec; // internal signal connected to rd_data apo ti bram
logic [31:0] sum; // signal to do summation after the state recieve. 
logic [3:0] count; // counter for the 7 places
logic [7:0]   [31:0] sum_temp ;
int i;

always_ff @(posedge interf.clk_i, negedge interf.rstn_i) begin
  if (!interf.rstn_i) begin
    fsm_state  <= IDLE;
	addr <= 3'b0;
	sum_temp <=0;
	addr_req <= 3'b0;
	count <= 3'b0;
	avg_o <= 0;
    sum     <= 32'b0;
	
  end
    
  else begin
    case(fsm_state)
      IDLE: begin
        addr <= 3'b0;
		addr_req <= 3'b0;
		count <= 3'b0;
		sum_temp <=0;
		avg_o <= 0;
		sum     <= 32'b0;
        if (control_i) begin
          fsm_state <= REQUEST;
        end
         else begin
          fsm_state<=IDLE;
         end  
		end 
       REQUEST: begin     //1 cycle
         addr <= addr_req;  // internal signal that sends request to BRAM through addr
         fsm_state <= WAITING;
       end
                        
       WAITING: begin  //1 cycle propagation delay for simulation. 
         fsm_state <= WAITING1;
       end 
       WAITING1: begin  //1 cycle propagation delay for simulation. 
                fsm_state <= RECEIVE;
              end
       
       
       RECEIVE: begin  //1 kuklos
       sum_temp[addr_req]<= rd_data;
                //rd_data_rec <= rd_data;
               
                count <= count + 1;
                addr_req <= addr_req +1;
                if (count == 8) begin                   
                      fsm_state <= IDLE;
                      count<= 0;
                      addr_req <=0;
                end
                else begin
                fsm_state <= CALCULATE;
                end
              end
	   
	   CALCULATE: begin //1 kuklos
         if (count==7) begin         // summation and division one cycle before recieve goes to idle
           for (i=0; i<8; i=i+1) begin
             sum = sum +sum_temp[i];
            end
         end
         else begin
         fsm_state <= REQUEST;
         end
       end
    endcase
  end
 	assign avg_o = sum >> 3 ;
end
        
endmodule : fsm_rd
