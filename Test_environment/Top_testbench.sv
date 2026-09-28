// Test-Bench Top Module

module tb_top();
  environment env;                             // Declare an instance of the environment class
  
  ram_if rif();                                // Declare an instance of the RAM interface
  apb_ram dut(rif.pclk, rif.presetn, rif.psel, rif.penable, rif.pwrite, rif.paddr, rif.pwdata, rif.prdata, rif.pready, rif.pslverr);  // Instantiate the DUT (RAM module) with the RAM interface
  
  initial begin
    rif.pclk <= 0;                             // Initialize the clock signal of the RAM interface to 0
  end
  
  always #10 rif.pclk <= ~rif.pclk;             // Toggle the clock signal of the RAM interface every 10 time units
  
  initial begin
    env = new(rif);                            // Create an instance of the environment and pass the RAM interface
    env.gen.count = 20;                         // Set the transaction count in the generator to 20
    env.main();                                 // Call the main task of the environment to start the simulation
  end
  
  initial begin
    $dumpfile("APB_RAM.vcd");                   // Specify the VCD dump file
    $dumpvars(0, tb_top);                        // Dump all variables for waveform tracing
  end
  
endmodule
