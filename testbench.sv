//Top most file which connets DUT, interface and the test

//-------------------------[NOTE]---------------------------------
//Particular testcase can be run by uncommenting, and commenting the rest
//`include "test1.sv"
//`include "test2.sv"
//`include "test3.sv"
//----------------------------------------------------------------

`include "interface.sv"

//`include "test_all_read_diff_address.sv"
//`include "test_write_read_same.sv"
`include "test_write_read_diff.sv"
//`include "test_write_all.sv"
//`include "test_write_all_byte.sv"
//`include "test_write_all_halfw.sv"
//`include "test_write_all_word.sv"

//`include "test_read_only.sv"
//`include "test_read_only_non_seq.sv"
//`include "test_read_only_seq.sv"
//`include "test_read_write_only_idle.sv"
//`include "test_read_write_only_busy.sv"

//`include "test_hsel.sv"
//`include "test_hready.sv"
//`include "test_hprot.sv"



module testbench_top;
  
  //declare clock and reset signal
  bit HCLK;
  bit HRESETn;
  
  //clock generation
  initial begin
    HCLK = 1;
    forever #5 HCLK = ~HCLK;
  end

  //reset generation
  initial begin
    HRESETn = 0;
    #5;
    HRESETn = 1;
   // #50;
    //HRESETn = 0;
    //#100;
    //HRESETn = 1;
    
    
  end

  //interface instance, inorder to connect DUT and testcase
  mem_intf vif(HCLK, HRESETn);
  //testcase instance, interface handle is passed to test as an argument
  test t1(vif);
  //DUT instance, interface signals are connected to the DUT ports
  ahb3lite_sram1rw DUT(
    .HRESETn(vif.HRESETn),
    .HCLK(vif.HCLK),
    .HSEL(vif.HSEL),
    .HADDR(vif.HADDR),
    .HWDATA(vif.HWDATA),
    .HRDATA(vif.HRDATA),
    .HWRITE(vif.HWRITE),
    .HSIZE(vif.HSIZE),
    .HBURST(vif.HBURST),
    .HPROT(vif.HPROT),
    .HTRANS(vif.HTRANS),
    .HREADYOUT(vif.HREADYOUT),
    .HREADY(vif.HREADY),
    .HRESP(vif.HRESP)
  );

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule



