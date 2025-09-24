module register_file (
    input CLK,
    input RST,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input WE3,
    input  [31:0] WD3,
    output [31:0] RD1,
    output [31:0] RD2
  );

  reg [31:0] rf [31:0];

  assign RD1 = (A1 != 0) ? rf[A1] : 32'b0;
  assign RD2 = (A2 != 0) ? rf[A2] : 32'b0;

  always @ (posedge CLK or negedge RST)
  begin
    if(!RST)
    begin
      rf [A3] = 0;
    end
    else
    begin
      if(WE3)
        rf [A3] <= WD3;
    end
  end
endmodule