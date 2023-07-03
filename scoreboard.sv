//Gets the packet from monitor, generates the expected result and compares with the actual result received from the Monitor

class scoreboard;
   
  //create mailbox handle
  mailbox mbx_ms;

  //used to count the number of transactions
  int tot_trans;

  //array to use as local memory

  logic [31:0] mem_array [0:255]; 

  //constructor
  function new(mailbox mbx_ms);
    //getting the mailbox handles from  environment 
    this.mbx_ms = mbx_ms;
   
  endfunction

  //main method

  task main;
    transaction trans;
    int test_pass;
    int test_fail;
    integer i;
    forever begin 
      //#50;
      mbx_ms.get(trans);

      if(trans.HSEL==1 && trans.HREADY==1)begin
        if(trans.HPROT==1)begin
          if(trans.HTRANS==0 )begin          //idle  
            if(trans.HRESP==0)begin      //ok
              $display("OK TO IDLE TRANSFER");
            end
            else begin
              $display("ERROR TO IDLE TRANSFER");
            end
          end
          else if(trans.HTRANS ==1) begin    //busy
            if(trans.HRESP==0)begin
              $display("OK TO BUSY TRANSFER");
            end
            else begin
              $display("ERROR TO BUSY TRANSFER");
            end
          end
          else begin                 //SEQ  //NON-SEQ
            if(trans.HWRITE==0) begin     //READ
              case(trans.HSIZE)
                3'h0:begin         //byte
                 // for(i=0;i<4;i++)begin 
                    if(trans.HADDR[1:0]==0)begin
                     // if(mem_array[trans.HADDR[9:2]][(i*8)+7:i*8]==trans.HRDATA[(i*8)+7:i*8])begin
                     if(mem_array[trans.HADDR[9:2]][7:0]==trans.HRDATA[7:0])begin 
                      $display("READ TEST BYTE PASSED");
                        test_pass++;
                      end
                      else begin
                        $display("READ TEST BYTE FAILED");
                        test_fail++;
                      end
                    end
                    if(trans.HADDR[1:0]==1)begin
                     // if(mem_array[trans.HADDR[9:2]][(i*8)+7:i*8]==trans.HRDATA[(i*8)+7:i*8])begin
                     if(mem_array[trans.HADDR[9:2]][15:8]==trans.HRDATA[15:8])begin 
                      $display("READ TEST BYTE PASSED");
                        test_pass++;
                      end
                      else begin
                        $display("READ TEST BYTE FAILED");
                        test_fail++;
                      end
                    end
                    if(trans.HADDR[1:0]==2)begin
                     // if(mem_array[trans.HADDR[9:2]][(i*8)+7:i*8]==trans.HRDATA[(i*8)+7:i*8])begin
                     if(mem_array[trans.HADDR[9:2]][23:16]==trans.HRDATA[23:16])begin 
                      $display("READ TEST BYTE PASSED");
                        test_pass++;
                      end
                      else begin
                        $display("READ TEST BYTE FAILED");
                        test_fail++;
                      end
                    end
                    if(trans.HADDR[1:0]==3)begin
                     // if(mem_array[trans.HADDR[9:2]][(i*8)+7:i*8]==trans.HRDATA[(i*8)+7:i*8])begin
                     if(mem_array[trans.HADDR[9:2]][31:24]==trans.HRDATA[31:24])begin 
                      $display("READ TEST BYTE PASSED");
                        test_pass++;
                      end
                      else begin
                        $display("READ TEST BYTE FAILED");
                        test_fail++;
                      end
                    end
                 // end
                end
                
                3'h1:begin               //halfword
                //  for(i=0;i<2;i++)begin 
                    if(trans.HADDR[1]==0)begin
                    //  if(mem_array[trans.HADDR[9:2]][(i*16)+15:i*16]==trans.HRDATA[(i*16)+15:i*16])begin
                      if(mem_array[trans.HADDR[9:2]][15:0]==trans.HRDATA[15:0])begin
                        $display("READ TEST HW PASSED");
                        test_pass++;
                      end
                      else begin
                        $display("DATA of mem_array:: %h , HRDATA:: %h , HADDR:: %h",mem_array[trans.HADDR[9:2]][15:0], trans.HRDATA[15:0] , trans.HADDR );
                        $display("READ TEST HW FAILED");
                        test_fail++;
                      end
                    end
                    if(trans.HADDR[1]==1)begin
                    //  if(mem_array[trans.HADDR[9:2]][(i*16)+15:i*16]==trans.HRDATA[(i*16)+15:i*16])begin
                      if(mem_array[trans.HADDR[9:2]][31:16]==trans.HRDATA[31:16])begin
                        $display("READ TEST HW PASSED");
                        test_pass++;
                      end
                      else begin
                        $display("DATA of mem_array:: %h , HRDATA:: %h , HADDR:: %h",mem_array[trans.HADDR[9:2]][15:0], trans.HRDATA[15:0] , trans.HADDR );
                        $display("READ TEST HW FAILED");
                        test_fail++;
                      end
                    end
                  //end
                end

                3'h2: begin                         //word read
                  if(mem_array[trans.HADDR[9:2]]==trans.HRDATA) begin
                    $display("READ TEST W PASSED");
                    test_pass++;
                  end
                  else begin
                    $display("READ TEST W FAILED");
                    test_fail++;
                  end
                end
                              
              endcase
            end
            if(trans.HWRITE==1'b1) begin     //WRITE
              $display("I AM IN WRITING STAGE");
              case(trans.HSIZE)
                3'h0:begin         //byte write
                 // for(i=0;i<4;i++)begin 
                    if(trans.HADDR[1:0]==0)begin
                      mem_array[trans.HADDR[9:2]][7:0]=trans.HWDATA[7:0]; 
                    end
                     if(trans.HADDR[1:0]==1)begin
                      mem_array[trans.HADDR[9:2]][15:8]=trans.HWDATA[15:8]; 
                    end
                     if(trans.HADDR[1:0]==2)begin
                      mem_array[trans.HADDR[9:2]][23:16]=trans.HWDATA[23:16]; 
                    end
                     if(trans.HADDR[1:0]==3)begin
                      mem_array[trans.HADDR[9:2]][31:24]=trans.HWDATA[31:24]; 
                    end
                  //end
                end
                
                3'h1:begin               //halfword write
                  //for(i=0;i<2;i++)begin 
                    if(trans.HADDR[1]==0)begin
                      mem_array[trans.HADDR[31:2]][15:0]=trans.HWDATA[15:0];
                      $display("HURRAyyyyy i am working");
                    end
                    if(trans.HADDR[1]==1)begin
                      mem_array[trans.HADDR[31:2]][31:16]=trans.HWDATA[31:16];
                    end
                  //end
                end
                3'h2: begin                         //word write
                  mem_array[trans.HADDR[9:2]]=trans.HWDATA ;
                end
                                
              endcase
            end
          end
        end 
        else begin  
          $display("trans.HPROT FAILED");
        end
      end
      else begin
        $display("trans.HSEL OR trans.HREADY FAILED nothing can be done");
      end



      tot_trans++;



      $display("--------------------------------------");
      $display("TOTAL TRANSACTIONS :: %d",tot_trans);
      $display("TESTS PASSED READ:: %d",test_pass);
      $display("TESTS FAILED READ:: %d",test_fail);
      $display("--------------------------------------");





    

      end

  endtask
endclass

























/*

if(trans.trans.HSEL&&trans.trans.HPROT) begin                                        //FOR  READ 
  $display("SLAVE CONNECTED  ,,,, PROT. DATA ACCESS ONLY");


    if(trans.trans.HWRITE==0 && trans.HREADY==1 && trans.trans.HRDATA==mem_array[trans.trans.HADDR[9:2]])begin
      $display("READ PASSED");
      test_pass_read++;
    end
      else begin
      $display("HRADDR ,%h",trans.trans.HADDR[9:2]);
      $display("mem_array ,%h",mem_array[trans.trans.HADDR[9:2]]);
      $display("trans.trans.HRDATA ,%h",trans.trans.HRDATA);
      $display("READ FAILED");
      test_fail_read++;
      end
  

      end
      else begin
        $display("SLAVE IS NOT CONNECTED , NOTING CAN BE TESTED");
        

      end
      
  
    */




/*


task main;
  transaction trans;
  forever begin
    #50;
    mon2scb.get(trans);
    if(trans.rd_en) begin
      if(mem[trans.addr] != trans.rdata) 
        $error("[SCB-FAIL] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.addr,mem[trans.addr],trans.rdata);
      else 
        $display("[SCB-PASS] Addr = %0h,\n \t   Data :: Expected = %0h Actual = %0h",trans.addr,mem[trans.addr],trans.rdata);
    end
    else if(trans.wr_en)
      mem[trans.addr] = trans.wdata;

    no_transactions++;
  end

  */