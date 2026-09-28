// Environment Class

class environment;
  transaction tr;                            // Declare a transaction object
  generator gen;                             // Declare a generator object
  driver drv;                                // Declare a driver object
  monitor mon;                              // Declare a monitor object
  scoreboard sco;                           // Declare a scoreboard object
  
  mailbox #(transaction) gen2drv;            // Declare a mailbox for communication between generator and driver
  mailbox #(transaction) mon2sco;            // Declare a mailbox for communication between monitor and scoreboard
  
  event nxt_sco, nxt_drv;                    // Declare events for synchronization
  
  virtual ram_if rif;                        // Declare a virtual interface to communicate with the RAM
  
  // Constructor
  function new(virtual ram_if rif);
    
    gen2drv = new();                         // Create a new generator-to-driver mailbox
    mon2sco = new();                         // Create a new monitor-to-scoreboard mailbox
    gen = new(gen2drv);                      // Create a new generator instance and pass the generator-to-driver mailbox
    drv = new(gen2drv);                      // Create a new driver instance and pass the generator-to-driver mailbox
    mon = new(mon2sco);                      // Create a new monitor instance and pass the monitor-to-scoreboard mailbox
    sco = new(mon2sco);                      // Create a new scoreboard instance and pass the monitor-to-scoreboard mailbox
    
    this.rif = rif;                          // Assign the provided virtual interface to the class member
    drv.rif = rif;                           // Assign the virtual interface to the driver instance
    mon.rif = rif;                           // Assign the virtual interface to the monitor instance
    
    gen.nxt_drv = nxt_drv;                   // Assign the next driver event to the generator instance
    drv.nxt_drv = nxt_drv;                   // Assign the next driver event to the driver instance
    gen.nxt_sco = nxt_sco;                   // Assign the next scoreboard event to the generator instance
    sco.nxt_sco = nxt_sco;                   // Assign the next scoreboard event to the scoreboard instance
    
  endfunction
  
  // Task to perform pre-test operations
  task pre_test();
    drv.reset();                             // Call the driver's reset task
  endtask
  
  // Task to perform the main test operations
  task test();
    fork
      gen.main();                            // Call the generator's main task
      drv.main();                            // Call the driver's main task
      mon.main();                            // Call the monitor's main task
      sco.main();                            // Call the scoreboard's main task
    join_any
  endtask
  
  // Task to perform post-test operations
  task post_test();
    wait(gen.done.triggered);                // Wait for the generator to finish generating transactions
    $finish();                               // Terminate the simulation
  endtask
  
  // Main task of the environment
  task main();
    pre_test();                              // Perform pre-test operations
    test();                                  // Perform the main test operations
    post_test();                             // Perform post-test operations
  endtask
  
endclass
