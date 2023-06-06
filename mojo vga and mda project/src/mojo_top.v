module mojo_top(
    // 50MHz clock input
    input clk,
    // Input from reset button (active low)
    input rst_n,
    // cclk input from AVR, high when AVR is ready
    input cclk,
    // Outputs to the 8 onboard LEDs
    output[7:0]led,
    // AVR SPI connections
    output spi_miso,
    input spi_ss,
    input spi_mosi,
    input spi_sck,
    // AVR ADC channel select
    output [3:0] spi_channel,
    // Serial connections
    input avr_tx, // AVR Tx => FPGA Rx
    output avr_rx, // AVR Rx => FPGA Tx
    input avr_rx_busy, // AVR Rx buffer full
    // Outputs to Red
    output[2:0]pin_R,
    // Outputs to Green
    output[2:0]pin_G,
    // Outputs to Blue
    output[2:0]pin_B,
	 //Syncs
    output pin_vsync,
    output pin_hsync
    );

wire rst = ~rst_n; // make reset active high

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

wire [9:0] x;
wire [9:0] y;

vga vga(
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
  
assign pin_R[0] = video;
assign pin_R[1] = video;
assign pin_R[2] = video;
assign pin_G[0] = video;
assign pin_G[1] = video;
assign pin_G[2] = video;
assign pin_B[0] = video;
assign pin_B[1] = video;
assign pin_hsync = hsync;
assign pin_vsync = vsync;

assign led[6:0] = 7'b0;
assign led[7] = rst;

reg video;
  
  
  
always @(*) begin
	if (valid) begin
		video = ((x < 2 || x > 638) || (y < 2 || y > 478)) ? 1 : 0; //1px box around viewable area
		//video = (x % 16) ? 1 : 0; //vertical lines every 16 px
		//video = 1; //fill with signal
	end else begin
		video = 0;
	end
end
  

endmodule