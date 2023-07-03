//Samples the interface signals, captures into transaction packet and sends the packet to scoreboard.

`define MON_IF vif.MONITOR.monitor_cb
class monitor;
  
  //virtual interface handle
  virtual mem_intf vif;
  //create mailbox handle
  mailbox mbx_ms;
  //constructor
  function new(virtual mem_intf vif,mailbox mbx_ms);
    this.vif = vif;
    this.mbx_ms = mbx_ms;
  endfunction
  //main method
  task main;
    @(posedge vif.MONITOR.HCLK);
    forever begin
      transaction trans;
      trans = new();
      
      trans.HADDR <= `MON_IF.HADDR;
      trans.HSEL <= `MON_IF.HSEL;
      trans.HWRITE <= `MON_IF.HWRITE;
      trans.HSIZE <= `MON_IF.HSIZE;
      trans.HBURST <= `MON_IF.HBURST;
      trans.HPROT <= `MON_IF.HPROT;
      trans.HTRANS <= `MON_IF.HTRANS;
      trans.HREADY <= `MON_IF.HREADY;

      trans.HREADYOUT <= `MON_IF.HREADYOUT;  //output
      trans.HRESP <= `MON_IF.HRESP;          //output


     // $display("MONITOR:: trans.HWRITE = %0h MON_IF.HWRITE = %0h",trans.HWRITE,`MON_IF.HWRITE);
      if(`MON_IF.HWRITE) begin
      @(posedge vif.MONITOR.HCLK);
      trans.HWDATA = `MON_IF.HWDATA;
      $display("MONITOR:: \tHADDR = %0h \tHWDATA = %0h",trans.HADDR,trans.HWDATA);
      end else begin
        @(posedge vif.MONITOR.HCLK);
      trans.HRDATA = `MON_IF.HRDATA;     //output
      end
      
      mbx_ms.put(trans);
    end
  endtask




endclass



