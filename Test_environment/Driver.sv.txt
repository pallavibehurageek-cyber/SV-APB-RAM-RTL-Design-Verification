// Driver Class

class driver;
  transaction t;                            // Declare a transaction object
  mailbox #(transaction) gen2drv;           // Declare a mailbox to receive transactions from the generator
  event nxt_drv;                           // Declare an event for synchronization
  
  virtual ram_if rif;                       // Declare a virtual interface to communicate with the RAM
  
  // Constructor
  function new(mailbox #(transaction) gen2drv);
    this.gen2drv = gen2drv;                 // Assign the provided mailbox to the class member
  endfunction
  
  // Task to reset the driver
  task reset();
    rif.presetn <= 1'b0;                    // Assert the reset signal of the virtual interface
    rif.psel <= 1'b0;                       // Set the peripheral select signal to 0
    rif.penable <= 1'b0;                    // Set the peripheral enable signal to 0
    rif.paddr <= 0;                         // Set the peripheral address to 0
    rif.pwdata <= 0;                        // Set the peripheral write data to 0
    rif.pwrite <= 1'b0;                     // Set the write enable signal to 0
    repeat(5) @(posedge rif.pclk);          // Wait for 5 positive clock edges
    rif.presetn <= 1'b1;                    // Deassert the reset signal
    repeat(5) @(posedge rif.pclk);          // Wait for 5 positive clock edges
    $display("[DRV]:RESET DONE");           // Display a message indicating the reset is done
  endtask
  
  // Task to handle main operations
  task main();
    forever begin
      gen2drv.get(t);                       // Get a transaction from the generator mailbox
      if(t.oper==0) begin                   // Write Operation
        @(posedge rif.pclk);
        rif.psel <= 1'b1;                   // Assert the peripheral select signal
        rif.penable <= 1'b0;                // Set the peripheral enable signal to 0
        rif.pwrite <= 1'b1;                 // Set the write enable signal to 1
        rif.paddr <= t.paddr;               // Assign the peripheral address from the transaction
        rif.pwdata <= t.pwdata;             // Assign the peripheral write data from the transaction
        @(posedge rif.pclk);
        rif.penable <= 1'b1;                // Set the peripheral enable signal to 1
        repeat(2) @(posedge rif.pclk);
        rif.psel <= 1'b0;                   // Deassert the peripheral select signal
        rif.penable <= 1'b0;                // Set the peripheral enable signal to 0
        rif.pwrite <= 1'b0;                 // Set the write enable signal to 0
        $display("[DRV]:DATA WRITE OP DATA:%0d,ADDRESS:%0d",t.pwdata,t.paddr); // Display a message with the write operation details
      end
      else if(t.oper==1) begin              // Read Operation
        @(posedge rif.pclk);
        rif.psel <= 1'b1;                   // Assert the peripheral select signal
        rif.penable <= 1'b0;                // Set the peripheral enable signal to 0
        rif.pwrite <= 1'b0;                 // Set the write enable signal to 0
        rif.pwdata <= t.pwdata;             // Assign the peripheral write data from the transaction
        rif.paddr <= t.paddr;               // Assign the peripheral address from the transaction
        @(posedge rif.pclk);
        rif.penable <= 1'b1;                // Set the peripheral enable signal to 1
        repeat(2) @(posedge rif.pclk);
        rif.penable <= 1'b0;                // Set the peripheral enable signal to 0
        rif.psel <= 1'b0;                   // Deassert the peripheral select signal
        rif.pwrite <= 1'b0;                 // Set the write enable signal to 0
        $display("[DRV]:DATA READ OP ADDR:%0d",t.paddr);  // Display a message with the read operation details
      end
      else if(t.oper==2) begin              // Random Operation
        @(posedge rif.pclk);
        rif.psel <= 1'b1;                   // Assert the peripheral select signal
        rif.penable <= 1'b0;                // Set the peripheral enable signal to 0
        rif.pwrite <= t.pwrite;             // Assign the write enable signal from the transaction
        rif.pwdata <= t.pwdata;             // Assign the peripheral write data from the transaction
        rif.paddr <= t.paddr;               // Assign the peripheral address from the transaction
        @(posedge rif.pclk);
        rif.penable <= 1'b1;                // Set the peripheral enable signal to 1
        repeat(2) @(posedge rif.pclk);
        rif.penable <= 1'b0;                // Set the peripheral enable signal to 0
        rif.psel <= 1'b0;                   // Deassert the peripheral select signal
        rif.pwrite <= 1'b0;                 // Set the write enable signal to 0
        $display("[DRV]:RANDOM OPERATION"); // Display a message indicating a random operation
      end
      else if(t.oper==3) begin              // SLV Error
        @(posedge rif.pclk);
        rif.psel <= 1'b1;                   // Assert the peripheral select signal
        rif.penable <= 1'b0;                // Set the peripheral enable signal to 0
        rif.pwrite <= t.pwrite;             // Assign the write enable signal from the transaction
        rif.paddr <= $urandom_range(32,100); // Generate a random peripheral address between 32 and 100
        rif.pwdata <= t.pwdata;             // Assign the peripheral write data from the transaction
        @(posedge rif.pclk);
        rif.penable <= 1'b1;                // Set the peripheral enable signal to 1
        repeat(2) @(posedge rif.pclk);
        rif.penable <= 1'b0;                // Set the peripheral enable signal to 0
        rif.pwrite <= 1'b0;                 // Set the write enable signal to 0
        rif.psel <= 1'b0;                   // Deassert the peripheral select signal
        $display("[DRV]:SLV ERROR");         // Display a message indicating an SLV error
      end
      ->nxt_drv;                            // Trigger the next driver event
    end
  endtask
  
endclass
