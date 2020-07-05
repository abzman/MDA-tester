module mojo_top(
    // 50MHz clock input
    input clk,
    // Input from reset button (active low)
    input rst_n,
	 output reg [9:0] x,
    output reg [9:0] y,
    output valid,
    output video,
    output hsync,
    output vsync,
    output reg newframe, // 1 clock pulse when new frame starts
    output reg newline, // 1 clock pulse when new line starts
    output[7:0]led, // Outputs to the 8 onboard LEDs
    output pin_v,
    output pin_hsync,
    output pin_vsync
    );

wire rst = ~rst_n; // make reset active high

assign hsync = x &gt; (720 + 10) &amp;&amp; x &lt;= (720 + 10 + 135);
assign vsync = y = (350 + 0 + 16);
assign valid = (x &lt; 720) &amp;&amp; (y &lt; 350);


assign led[6:1] = 6'b0;
assign led[7] = rst;

reg video;
reg clk16;
reg [31:0]	ctr;
initial ctr = 0;

always @(posedge clk) begin
	if (valid) begin
		video = ((x  710) || (y  340)) ? 1 : 0;
		//video = 1;
	end else begin
		video = 0;
	end

  newframe &lt;= 0;
  newline &lt;= 0;
  if (rst) begin
    x &lt;= 10'b0;
    y &lt;= 10'b0;
    clk16 &lt;= 1'b0;
    newframe &lt;= 1;
    newline &lt;= 1;
  end else begin
    {clk16, ctr} &lt;= ctr + 32'd1396465667; // creates 16.257MHz signal
    if (clk16 == 1'b1) begin
      if (x &lt; 10'd881) begin
        x &lt;= x + 1'b1;
      end else begin
        x &lt;= 10'b0;
        newline &lt;= 1;
        if (y &lt; 10'd369) begin
          y &lt;= y + 1'b1;
        end else begin
          y &lt;= 10'b0;
          newframe &lt;= 1;
        end
      end
    end
  end
end

assign	led[0] = (ctr[31:30] == 2'b00);

assign pin_v = video;
assign pin_hsync = hsync;
assign pin_vsync = vsync;

endmodule