//A program block that creates the environment and initiate the stimulus
`include "environment.sv"
program test(mem_intf vif);
  
  class my_trans extends transaction;
    
    constraint con_haddr { } ;
   
    
constraint con_hready{ };
    bit [1:0] cnt;
      int count;
      
    function void pre_randomize();      
        HREADY.rand_mode(0);
      HREADY=0;
      HWRITE.rand_mode(0);
      HADDR.rand_mode(0);
      HSIZE.rand_mode(0);
            HTRANS.rand_mode(0);
      HTRANS=2;           //NON-SEQ

      HSIZE=2;            //-word
             
      if(cnt %2== 0) begin
        HWRITE = 1;
        HADDR  = count;      
      end 
      else begin
        
        HWRITE = 0;
        HADDR  = count;
      end
      cnt++;
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






