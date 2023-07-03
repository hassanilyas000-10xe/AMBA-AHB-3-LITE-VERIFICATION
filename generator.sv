//Generates randomized transaction packets and put them in the mailbox to send the packets to driver 

class generator;
  
  //declare transaction class
    transaction trans;
    
  //create mailbox handle
  mailbox mbx_gd;
  //declare an event
  event event_gd;
  //variable, to speicify number of items to generate.
  int count;

  //constructor
  function new(mailbox mbx_gd,event event_gd);
  this.mbx_gd = mbx_gd;
  this.event_gd = event_gd;
  trans=new();
 endfunction

  //main methods
  task main(); 
    repeat(count) begin
      if( !trans.randomize() ) $fatal("Gen:: trans randomization failed");
      mbx_gd.put(trans.copy());
      trans.print_tr();
      end
      -> event_gd; 

  endtask

endclass



