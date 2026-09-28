// Generator Class

class generator;
  transaction t;                         // Declare a transaction object
  mailbox #(transaction) gen2drv;        // Declare a mailbox to communicate with the driver
  int count=0;                           // Counter variable
  event done;                            // Event indicating completion
  event nxt_drv, nxt_sco;                // Events for synchronization

  // Constructor
  function new(mailbox #(transaction) gen2drv);
    this.gen2drv = gen2drv;              // Initialize the mailbox
    t = new();                           // Create a new transaction object
  endfunction

  // Main task
  task main();
    repeat(count) begin                  // Repeat the following block 'count' number of times
      assert(t.randomize()) else $error("Randomization Failed!");  // Randomize the transaction, and if it fails, display an error message
      gen2drv.put(t.copy);               // Copy the transaction and put it into the mailbox for the driver
      t.display("GEN");                  // Display the transaction details with a label "GEN"
      @(nxt_drv);                        // Wait for the next driver event
      @(nxt_sco);                        // Wait for the next score event
      $display("-----------------------------------------------");  // Display a separator line
    end
    ->done;                              // Trigger the 'done' event to indicate completion
  endtask

endclass
