//Gets the packet from generator and drive the transaction packet items into interface (interface is connected to DUT, so the items driven into interface signal will get driven in to DUT) 

`define DRIV_IF vif.DRIVER.driver_cb
class driver;
  
  //used to count the number of transactions
  int tot_trans;
  //virtual interface handle
  virtual mem_intf vif;
  //create mailbox handle
  mailbox mbx_gd;

  //constructor
  function new(virtual mem_intf vif,mailbox mbx_gd);
    this.vif = vif;
    this.mbx_gd = mbx_gd;
  endfunction

  //reset methods, Reset the Interface signals to default/initial values
  task reset;
    wait(!vif.HRESETn);                                            //reset working as active low so reset=!0 evaluated in this
    $display("--------- [DRIVER] Reset Started ---------");
    `DRIV_IF.HSEL <= 0;
    `DRIV_IF.HADDR <= 0;
    `DRIV_IF.HWDATA  <= 0;
   // `DRIV_IF.HRDATA <= 0;    //
    `DRIV_IF.HWRITE <= 0;
    `DRIV_IF.HSIZE <= 0;
    `DRIV_IF.HBURST  <= 0;
    `DRIV_IF.HPROT <= 0;  
    `DRIV_IF.HTRANS <= 0;
    //`DRIV_IF.HREADYOUT <= 0;//
    `DRIV_IF.HREADY  <= 1;      //ready for new transfer
    //`DRIV_IF.HRESP <= 0;  //
    wait(vif.HRESETn);                                       //ended at reset = 1
    $display("--------- [DRIVER] Reset Ended ---------");
  endtask
  //drive methods
  task drive;
    transaction trans;
   
    mbx_gd.get(trans);
   // $display("--------- [DRIVER-TRANSFER: %0d] ---------",tot_trans);

    `DRIV_IF.HADDR <= trans.HADDR;
    `DRIV_IF.HSEL <= trans.HSEL;
    `DRIV_IF.HWRITE <= trans.HWRITE;
    `DRIV_IF.HSIZE <= trans.HSIZE;
    `DRIV_IF.HBURST <= trans.HBURST;
    `DRIV_IF.HPROT <= trans.HPROT;
    `DRIV_IF.HTRANS <= trans.HTRANS;
    `DRIV_IF.HREADY <= trans.HREADY;

    @(posedge vif.DRIVER.HCLK);
     

    if(trans.HWRITE)begin     //WRITE
   `DRIV_IF.HWDATA <= trans.HWDATA;
    $display("DRIVER:: \tHADDR = %0h \tHWDATA = %0h",trans.HADDR,trans.HWDATA);
   // @(posedge vif.DRIVER.HCLK);
    end 
   
    //$display("-----------------------------------------");
    tot_trans++;
  endtask
  //main methods

  task main;
    forever begin
      fork
        begin
          wait(vif.HRESETn);
        end
        begin
          forever
            drive();
        end
      join
      disable fork;
    end
  endtask
        
endclass


