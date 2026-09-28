// Implementaion of AMBA APB protocol using APB_RAM in System Verilog
module apb_ram(
  input pclk,presetn,  //Global Signals availble on system buses
  input psel,penable,pwrite,  //Control signals send by master bridge
  input [31:0] paddr,pwdata,  //Data signals sent by master bridge
  output reg[31:0] prdata,    //Output data signal by slave APB_RAM
  output reg pready,pslverr  //Output control signals by slave APB_RAM
);
  
  reg[31:0] mem[32];   //RAM array each 32-bit wide
  
  typedef enum{idle=0, setup=1, access=2, transfer=3} state_type;//States of FSM
  
  state_type state = idle, next_state = idle; 
  
  always @(posedge pclk) begin
    if(presetn==1'b0) begin  //System works on active-low reset
      state <= idle;
      prdata <= 32'h00000000;
      pready <= 1'b0;
      pslverr <= 1'b0;
      for(int i=0;i<32;i++) //Reset the memory(RAM)
        mem[i] <= 0;
    end
    else begin
      case (state)
        idle:    //Idle State
          begin
            prdata <= 32'h00000000;
            pready <= 1'b0;
            pslverr <= 1'b0;
            if((psel==1'b0) && (penable==1'b0))
              state <= setup;
          end
        setup:  //Setup State
          begin
            if((psel==1'b1) && (penable==1'b0)) begin
              if(paddr<32) begin  //Checking if address is correct
                state <= access;
                pready <= 1'b1;
              end
              else begin   //If not throwing an error from slave to master
                state <= access;
                pready <= 1'b0;
              end
            end
            else 
              state <= setup;
          end
        access:
          begin
            if(psel && pwrite && penable) begin  //For write operation
              if(paddr<32) begin
                mem[paddr] <= pwdata;
                state <= transfer;
                pslverr <= 1'b0;
              end
              else begin
                state <= transfer;
                pready <= 1'b1;
                pslverr <= 1'b1;
              end
            end
            else if(psel && !pwrite && penable) begin  //For Read operation
              if(paddr<32) begin
                prdata <= mem[paddr];
                state <= transfer;
                pslverr <= 1'b0;
              end
              else begin
                state <= transfer;
                pslverr <= 1'b1;
                pready <= 1'b1;
                prdata <= 32'hxxxxxxxx;
              end
            end
          end
        transfer:   //Transfer State - Extending transaction
          begin
            state <= setup;
            pready <= 1'b0;
            pslverr <= 1'b0;
          end
        default: state <= idle;
      endcase
    end
  end
  
endmodule
