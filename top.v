// DO NOT CHANGE THE NAME OR THE SIGNALS OF THIS MODULE

module top (
  input        clk    ,
  input  [3:0] sw     ,
  input  [3:0] btn    ,
  output [7:0] led    ,
  output [7:0] seven  ,
  output [3:0] segment
);

/* Your module instantiations go to here. */

reg [3:0] btn_db;
reg divided_clk;
reg [7:0] disp0;
reg [7:0] disp1;
reg [7:0] disp2;
reg [7:0] disp3;

clk_divider clk_div (
  .clk_in(clk),
  .divided_clk(divided_clk)
);

debouncer db00 (
  .clk(divided_clk),
  .noisy_in(~btn[0]),
  .clean_out(btn_db[0]),
  .rst(btn_db[2])
);
debouncer db01 (
  .clk(divided_clk),
  .noisy_in(~btn[1]),
  .clean_out(btn_db[1]),
  .rst(btn_db[2])
);
debouncer db02 (
  .clk(divided_clk),
  .noisy_in(~btn[2]),
  .clean_out(btn_db[2]),
  .rst(1'b0)
);
debouncer db03 (
  .clk(divided_clk),
  .noisy_in(~btn[3]),
  .clean_out(btn_db[3]),
  .rst(btn_db[2])
);


battleship game(
  .clk(divided_clk),
  .rst(btn_db[2]),
  .start(btn_db[1]),
  .pAb(btn_db[3]),
  .pBb(btn_db[0]),
  .X(sw[3:2]),
  .Y(sw[1:0]),
  .disp0(disp0),
  .disp1(disp1),
  .disp2(disp2),
  .disp3(disp3),
  .led(led)
);

ssd ssd00 (
  .clk(clk),
  .disp0(disp0),
  .disp1(disp1),
  .disp2(disp2),
  .disp3(disp3),
  .seven(seven),
  .segment(segment)
);

endmodule