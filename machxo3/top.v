module top (red, green, blue, hsync, vsync, xtal);
    // External signals
	output reg red;
	output reg green;
	output reg blue;
	output reg hsync;
	output reg vsync;
	
	input wire xtal;

    // Internal signals
//    wire fpga_clock;
    wire pclk;
    wire pclk_lock;
    reg [31:0] col_counter;
    reg [31:0] row_counter;
	reg temp;

    // Internal modules
//    OSCH #(.NOM_FREQ("133.0")) rc_oscillator(
//        .STDBY(1'b0),
//        .OSC(fpga_clock));
		
	pll pixel_clock (.CLKI(xtal), .CLKOP(pclk), .LOCK(pclk_lock));

    initial begin
        col_counter = 32'b0;
        row_counter = 32'b0;
		red = 1'b0;
		green = 1'b0;
		blue = 1'b0;
		hsync = 1'b1;
		vsync = 1'b1;
		temp = xtal;
    end

	// Below values are in pixels
	`define VISIBLE_WIDTH 640
	`define HFPORCH 16 + `VISIBLE_WIDTH
	`define HSYNC 96 + `HFPORCH
	`define HBPORCH 48 + `HSYNC

	// Below values are in lines
	`define VISIBLE_HEIGHT 480
	`define VFPORCH 10 + `VISIBLE_HEIGHT
	`define VSYNC 2 + `VFPORCH
	`define VBPORCH 33 + `VSYNC

    always @(posedge pclk) begin
        if (pclk_lock == 1'b1) begin
            col_counter <= col_counter + 1'b1;
            
            if (col_counter == `VISIBLE_WIDTH) begin
                // End of visible line
            end else if (col_counter == `HFPORCH) begin
                // End of front porch
                hsync = 1'b0;
            end else if (col_counter == `HSYNC) begin
                // End of hsync pulse
                hsync = 1'b1;
            end else if (col_counter == `HBPORCH) begin
                // End of back porch
                row_counter <= row_counter + 1'b1;
                col_counter <= 0;
            end

            if (row_counter == `VISIBLE_HEIGHT) begin
                // End of visible frame
            end else if (row_counter == `VFPORCH) begin
                // End of front porch
                vsync = 1'b0;
            end else if (row_counter == `VSYNC) begin
                // End of vsync pulse
                vsync = 1'b1;
            end else if (row_counter == `VBPORCH) begin
                // End of back porch
                row_counter <= 0;
            end
			
			if ((col_counter <= `VISIBLE_WIDTH) && (row_counter <= `VISIBLE_HEIGHT)) begin
				red = 1'b1;
			end else begin
				red = 1'b0;
			end
        end
    end

endmodule
