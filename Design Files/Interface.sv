//Adding Interface between DUT and TB
interface ram_if;
  logic pclk,presetn;          //Global Signals
  logic psel,penable,pwrite;   //Input Control Signals
  logic [31:0] pwdata,paddr;   //Input Data Signals
  logic [31:0] prdata;         //Output Data Signal
  logic pready,pslverr;        //Output Control Signals
endinterface
