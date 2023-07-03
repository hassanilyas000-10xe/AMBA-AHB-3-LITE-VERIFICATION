//Interface groups the design signals, specifies the direction (Modport) and Synchronize the signals(Clocking Block)

`define HADDR_SIZE 32
`define HDATA_SIZE 32

interface mem_intf(input logic HCLK,input logic HRESETn);

    // Add design signals here
  logic                       HSEL;
  logic      [`HADDR_SIZE-1:0] HADDR;
  logic      [`HDATA_SIZE-1:0] HWDATA;
  logic  [`HDATA_SIZE-1:0] HRDATA;
  logic                       HWRITE;
  logic      [           2:0] HSIZE;
  logic      [           2:0] HBURST;
  logic      [           3:0] HPROT;
  logic      [           1:0] HTRANS;
  logic                   HREADYOUT;
  logic                       HREADY;
  logic                      HRESP;
    //Master Clocking block - used for Drivers
  clocking driver_cb @(posedge HCLK);                //Output will be input in driver 
    default input #1 output #1;
    output HSEL;
    output HADDR;
    output HWDATA;
    input  HRDATA;
    output HWRITE;
    output HSIZE;
    output HBURST;
    output HPROT;
    output HTRANS;
    input  HREADYOUT;
    output HREADY;
    input  HRESP;
  endclocking
    //Monitor Clocking block - For sampling by monitor components
  clocking monitor_cb @(posedge HCLK);                //ALL will be input in monitor 
    default input #1 output #1;
    input HSEL;
    input HADDR;
    input HWDATA;
    input  HRDATA;
    input HWRITE;
    input HSIZE;
    input HBURST;
    input HPROT;
    input HTRANS;
    input  HREADYOUT;
    input HREADY;
    input  HRESP;
  endclocking
    //Add modports here
  //driver modport
  modport DRIVER  (clocking driver_cb,input HCLK,HRESETn);
  
  //monitor modport 
  modport MONITOR (clocking monitor_cb,input HCLK,HRESETn);

endinterface


