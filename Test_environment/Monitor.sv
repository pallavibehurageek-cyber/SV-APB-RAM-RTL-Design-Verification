// Monitor Class

class monitor;
  transaction t;                            // Declare a transaction object
  mailbox #(transaction) mon2sco;           // Declare a mailbox to send transactions to the scoreboard
  
  virtual ram_if rif;                       // Declare a virtual interface to communicate with the RAM
  
  // Constructor
  function new(mailbox #(transaction) mon2sco);
    this.mon2sco = mon2sco;                 // Assign the provided mailbox to the class member
  endfunction
  
  // Task to handle main monitoring operations
  task main();
    t = new();                             // Create a new transaction object
    forever begin
      @(posedge rif.pclk);
      if((rif.psel) && (!rif.penable)) begin   // Check if the peripheral select signal is asserted and peripheral enable signal is deasserted
        @(posedge rif.pclk);
        if(rif.psel && rif.pwrite && rif.penable) begin   // Check if peripheral select, write enable, and peripheral enable signals are asserted
          @(posedge rif.pclk);
          t.wdata <= rif.pwdata;          // Assign the peripheral write data to the transaction
          t.paddr <= rif.paddr;           // Assign the peripheral address to the transaction
          t.pwrite <= rif.pwrite;         // Assign the write enable signal to the transaction
          t.pslverr <= rif.pslverr;       // Assign the slave error signal to the transaction
          $display("[MON]:DATA WRITTEN WDATA:%0d,WADDR:%0d",rif.pwdata,rif.paddr);  // Display a message with the written data details
          @(posedge rif.pclk);
        end
        else if(rif.psel && !rif.pwrite && rif.penable) begin  // Check if peripheral select, write enable, and peripheral enable signals are asserted and deasserted, respectively
          @(posedge rif.pclk);
          t.prdata <= rif.prdata;         // Assign the peripheral read data to the transaction
          t.paddr <= rif.paddr;           // Assign the peripheral address to the transaction
          t.pwrite <= rif.pwrite;         // Assign the write enable signal to the transaction
          t.pslverr <= rif.pslverr;       // Assign the slave error signal to the transaction
          $display("[MON]:DATA READ RDATA:%0d,RADDR:%0d",rif.prdata,rif.paddr);    // Display a message with the read data details
          @(posedge rif.pclk);
        end
        mon2sco.put(t);                   // Send the transaction to the scoreboard mailbox
      end
    end
  endtask
  
endclass
