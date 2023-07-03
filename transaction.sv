//Fields required to generate the stimulus are declared in the transaction class


`define HADDR_SIZE 32
`define HDATA_SIZE 32

class transaction;

 //AHB Slave Interfaces (receive data from AHB Masters)
 //AHB Masters connect to these ports
 randc bit                        HSEL;
 rand bit      [`HADDR_SIZE-1:0] HADDR;
 randc bit      [`HDATA_SIZE-1:0] HWDATA;
 bit [`HDATA_SIZE-1:0] HRDATA;                 //output
 randc bit                       HWRITE;
 rand bit      [           2:0] HSIZE;
 randc bit      [           2:0] HBURST;
 randc bit      [           3:0] HPROT;
 randc bit      [           1:0] HTRANS;
 bit                   HREADYOUT;      //output
 randc bit                       HREADY;
 bit                      HRESP;      //output

  
  //Add Constraints
  constraint con_hprot{ 
    HPROT ==4'b0001;   //data access only
    //HTRANS dist { 0:=10, 1:=10, 2:=80 };     //10% ,10%,80%    //idle   //busy //nonseq
  }; 
  

constraint con_hburst{
  //  HBURST inside {3'b000, 3'b010, 3'b011};   // Single burst, 4-beat wrapping burst, and 4-beat increment burst
  HBURST == 3'b000 || HBURST == 3'b010 || HBURST == 3'b011;   // Single burst, 4-beat wrapping burst, and 4-beat increment burst
};

constraint con_hsize{
  HSIZE inside {[0:2]};  //inside 0,1,2        //Transfer sizes of byte, half word and word only
};

constraint con_haddr{
  solve HSIZE before HADDR;    //2^0=0 ADDR CAN BE 0,1,2,3 IN BYTE ADDRESABLE
  HADDR % (2**HSIZE) == 0;     //2^1=2 ADDR CAN BE 0,2,4,6 IN HALF WORD                // Address aligned w.r.t. Size
                //2^2=4 ADDR CAN BE 0,4,8,16 IN WORD becuase we want next word in word addressable which is 4 bytes away

};

constraint con_hready{
  HREADY==1;
};

constraint con_hsel{
  HSEL==1;
};

  
  
  //Add print transaction method(optional)

  task print_tr;
    $display("----------PRINTING TRANSACTION CLASS SIGNALS--------------");  
  $display("HPROT::%b DATA ACCESS ONLY ",HPROT);
  $display("HBURST::%b SINGLE, 4 WRAPPING, 4 INCREMENT BURST ONLY ",HBURST);
  $display("HTRANS::%b ANY TRANS ",HTRANS);
  $display("HSIZE::%b CAN BE 0:BYTE, 1:HALF_WORD,2:WORD ",HSIZE);
  $display("HADDR::%b  HADDR ALLIGNED WITH HSIZE",HADDR);

  $display("HSEL::%b  ",HSEL);
  $display("HWDATA::%h  ",HWDATA);
  $display("HWRITE::%b  ",HWRITE);
  $display("HREADY::%b  ",HREADY);
    $display("---------------------END PRINTING--------------------------");  


  endtask

//COPY METHOD
  function transaction copy();
    transaction trans;
    trans = new();
    trans.HSEL  = this.HSEL;
    trans.HADDR = this.HADDR;
    trans.HWDATA = this.HWDATA;
    trans.HWRITE = this.HWRITE;
    trans.HSIZE  = this.HSIZE;
    trans.HBURST = this.HBURST;
    trans.HPROT = this.HPROT;
    trans.HTRANS = this.HTRANS;
    trans.HREADY = this.HREADY;
    return trans;
  endfunction


endclass