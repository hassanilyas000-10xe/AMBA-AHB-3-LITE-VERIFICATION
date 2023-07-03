//A container class that contains Mailbox, Generator, Driver, Monitor and Scoreboard
//Connects all the components of the verification environment
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
class environment;
  
  //handles of all components
  generator  gen;
  driver     drv;
  monitor    mon;
  scoreboard scb;
  //mailbox handles
  mailbox mbx_gd;
  mailbox mbx_ms;
  //declare an event
  event gen_ended;
  //virtual interface handle
  virtual mem_intf vif;
  //constructor
  function new(virtual mem_intf vif);
    //get the interface from test
    this.vif = vif;
    
    //creating the mailbox (Same handle will be shared across generator and driver)
    mbx_gd = new();
    mbx_ms  = new();
    
    //creating generator and driver
    gen  = new(mbx_gd,gen_ended);
    drv = new(vif,mbx_gd);
    mon  = new(vif,mbx_ms);
    scb  = new(mbx_ms);
  endfunction

  task pre_test();
    drv.reset();
  endtask
  
  task test();
    fork 
    gen.main();
    drv.main();
    mon.main();
    scb.main();      
    join_any
  endtask
  
  task post_test();
    wait(gen_ended.triggered);
    $display("Generator FINISHED");
    wait(gen.count == drv.tot_trans);
    $display("driv.tot_trans %d",drv.tot_trans);
    wait(gen.count == scb.tot_trans);
    $display("scb.tot_trans %d",drv.tot_trans);
    
  endtask  
  
  //run task
  task run;
    pre_test();
    test();
    post_test();
    $finish;
  endtask
endclass







