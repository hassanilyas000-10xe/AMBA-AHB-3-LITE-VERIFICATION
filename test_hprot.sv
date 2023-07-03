//A program block that creates the environment and initiate the stimulus
`include "environment.sv"
program test(mem_intf vif);
  
  class my_trans extends transaction;
    
    constraint con_hprot{ };
    function void pre_randomize();      
        HPROT.rand_mode(0);
        HPROT=0;
      HWRITE.rand_mode(0);
      HWRITE=1;
    endfunction
    
  endclass
    

  //declare environment handle
  environment env;
  my_trans my_tr;
  initial begin
    //create environment
    env=new(vif);
    my_tr = new();

    //initiate the stimulus by calling run of env
    env.gen.count = 10;

    env.gen.trans = my_tr;

    env.run();


  end
  
  initial begin    
    $display (" LOADING FILE IN TEST ");
    $readmemh( "memfile.txt", env.scb.mem_array , 0, 255);  
  end
  
endprogram






