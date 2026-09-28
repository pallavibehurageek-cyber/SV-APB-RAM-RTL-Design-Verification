//Transaction Class
class transaction;

  // Define an enumeration for operation types
  typedef enum { write = 0, read = 1, random = 2, error = 3 } oper_type;

  // Declare random variables
  randc oper_type oper;            // Transaction operation type (write, read, random, error)
  rand bit psel, penable, pwrite;  // Transaction control signals
  rand bit [31:0] paddr, pwdata;   // Transaction address and data
  bit [31:0] prdata;               // Transaction read data
  bit pready, pslverr;             // Transaction status signals

  // Define a constraint for paddr
  constraint paddr_data {
    paddr > 1;
    paddr < 5;
  }

  // Define a constraint for pwdata
  constraint wdata {
    pwdata > 1;
    pwdata < 10;
  }

  // Define a function to display transaction details
  function void display(input string cls);
    $display("[%0s]:oper:%0s,psel:%0b,penable:%0b,pwrite:%0b,paddr:%0d,pwdata:%0d,prdata:%0d,pready:%0b,pslverr:%0b", cls, oper.name(), psel, penable, pwrite, paddr, pwdata, prdata, pready, pslverr);
  endfunction

  // Define a function to create a copy of the transaction
  function transaction copy();
    // Create a new transaction object
    copy = new();
    // Copy the values of variables from the current transaction to the copy
    copy.oper = this.oper;
    copy.psel = this.psel;
    copy.penable = this.penable;
    copy.pwrite = this.pwrite;
    copy.paddr = this.paddr;
    copy.pwdata = this.pwdata;
    copy.prdata = this.prdata;
    copy.pready = this.pready;
    copy.pslverr = this.pslverr;
  endfunction

endclass
