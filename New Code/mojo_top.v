module mojo_top(
    // 50MHz clock input
    input clk,
    // Input from reset button (active low)
    input rst_n,
    // Outputs to the 8 onboard LEDs
    output[7:0]led,
	 // video output pins
    output pin_v,
    output pin_hsync,
    output pin_vsync
    );

wire rst = ~rst_n; // make reset active high

wire [9:0] x;
wire [9:0] y;

mda mda(
  .clk(clk),
  .rst(rst),
  .x(x[9:0]),
  .y(y[9:0]),
  .valid(valid),
  .hsync(hsync),
  .vsync(vsync),
  .newframe(newframe),
  .newline(newline)
  );

assign pin_v = video;
assign pin_hsync = hsync;
assign pin_vsync = vsync;

assign led[6:0] = 7'b0;
assign led[7] = rst;

reg video;

always @(*) begin
	if (valid) begin
		video = ((x < 2 || x > 718) || (y < 2 || y > 348)) ? 1 : 0; //1px box around viewable area
		//video = (x % 16) ? 1 : 0; //vertical lines every 16 px
		//video = 1; //fill with signal
	end else begin
		video = 0;
	end
end
endmodule