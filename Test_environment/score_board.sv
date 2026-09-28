// Scoreboard Class

class scoreboard;
  transaction t;                            // Declare a transaction object
  mailbox #(transaction) mon2sco;           // Declare a mailbox to receive transactions from the monitor
  event nxt_sco;                            // Declare an event for synchronization
  
  bit[31:0] pwdata[12] = '{default:0};      // Declare an array to store written data
  bit[31:0] prdata;                         // Declare a variable to store read data
  int index;                                // Declare an index variable
  
  // Constructor
  function new(mailbox #(transaction) mon2sco);
    this.mon2sco = mon2sco;                 // Assign the provided mailbox to the class member
  endfunction
  
  // Task to handle main scoreboard operations
  task main();
    forever begin
      mon2sco.get(t);                       // Get a transaction from the monitor mailbox
      $display("[SCO]:DATA RCVD pwdata:%0d,prdata:%0d,pwrite:%0d",t.pwdata,t.prdata,t.pwrite);  // Display a message with the received transaction details
      if((t.pwrite==1'b1) && (t.pslverr==1'b0)) begin   // Check if the write enable signal is asserted and slave error signal is deasserted
        pwdata[t.paddr] = t.pwdata;          // Store the written data in the corresponding array index
        $display("[SCO]:DATA STORED WDATA:%0d,ADDR:%0d",t.pwdata,t.paddr);  // Display a message with the stored data details
      end
      else if((t.pwrite==1'b0) && (t.pslverr==1'b0)) begin  // Check if the write enable signal is deasserted and slave error signal is deasserted
        prdata = pwdata[t.paddr];            // Retrieve the stored data from the corresponding array index
        if(prdata==t.prdata)
          $display("[SCO]:DATA MATCHED");   // Display a message indicating data match
        else
          $display("[SCO]:DATA MISMATCHED!");  // Display a message indicating data mismatch
      end
      else if(t.pslverr==1'b1)
        $display("[SCO]:SLAVE ERROR DETECTED!");  // Display a message indicating a slave error
      ->nxt_sco;                            // Trigger the next scoreboard event
    end
  endtask
  
endclass
