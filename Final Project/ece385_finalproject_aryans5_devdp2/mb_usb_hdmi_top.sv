`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Zuofu Cheng
// 
// Create Date: 12/11/2022 10:48:49 AM
// Design Name: 
// Module Name: mb_usb_hdmi_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Top level for mb_lwusb test project, copy mb wrapper here from Verilog and modify
// to SV
// Dependencies: microblaze block design
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//Create axi4 lite interface that decodes the 601 registers (which are used for communicating)
//VRAM shared between mb and video hardware (memory mapped)
//AXI is 32 bit wide, therefore w 2400 bytes, dividing by 4 (32 bits) we hav 600 reg
//Diff signaling will cause errors during bitstream if driven by anything other than DS
//missing IPs will be optimized out during synthesis leading to bitstream errors



module mb_usb_hdmi_top(
    input logic Clk,
    input logic reset_rtl_0,
    
    //sound vars
    output logic mosi,
    input logic miso,
    output logic cs,
    output logic sclk,
    output logic PWML,
    output logic PWMR,
    //USB SIGNALS
    input logic [0:0] gpio_usb_int_tri_i,
    output logic gpio_usb_rst_tri_o,
    input logic usb_spi_miso,
    output logic usb_spi_mosi,
    output logic usb_spi_sclk,
    output logic usb_spi_ss,
    
    //HEX displays
    output logic [7:0] hex_segA,
    output logic [3:0] hex_gridA,
    output logic [7:0] hex_segB,
    output logic [3:0] hex_gridB,
    
    //UART
    input logic uart_rtl_0_rxd,
    output logic uart_rtl_0_txd,
    
    //HDMI
    output logic hdmi_tmds_clk_n,
    output logic hdmi_tmds_clk_p,
    output logic [2:0]hdmi_tmds_data_n,
    output logic [2:0]hdmi_tmds_data_p
    );
    logic [31:0] keycode0_gpio, keycode1_gpio;
    logic clk_25MHz, clk_125MHz, clk_100MHz;
    logic locked;
    logic [9:0] drawX, drawY, ballxsig, ballysig, ballsizesig;
    logic hsync, vsync, vde;
    logic [3:0] red, green, blue;
    logic reset_ah;
    assign reset_ah = reset_rtl_0;
    //sound vars
    logic clk_50MHz;
    logic clk_48KHz;
    logic[15:0] fifo_output;
    logic align_signal;
    enum logic [8:0] {RESET, READBLOCK, READL_0, READL_1, READH_0, READH_1, WRITE, ERROR, DONE} state_r, state_x;
    logic ramwe;
    logic[24:0] ramaddress;
    logic[15:0] ramdataout;
    logic raminiterror;
    logic raminitdone;
    logic flag1;
    logic flag2;
    logic flag3;
    //Keycode HEX drivers
    HexDriver HexA (
        .clk(Clk),
        .reset(reset_ah),
        .in({keycode0_gpio[31:28], keycode0_gpio[27:24], keycode0_gpio[23:20], keycode0_gpio[19:16]}),
        .hex_seg(hex_segA),
        .hex_grid(hex_gridA)
    );
    
    HexDriver HexB (
        .clk(Clk),
        .reset(reset_ah),
        .in({keycode0_gpio[15:12], keycode0_gpio[11:8], keycode0_gpio[7:4], keycode0_gpio[3:0]}),
        .hex_seg(hex_segB),
        .hex_grid(hex_gridB)
    );
    
    
    mb_block mb_block_i(
        .HDMI_0_tmds_clk_n(hdmi_tmds_clk_n),
        .HDMI_0_tmds_clk_p(hdmi_tmds_clk_p),
        .HDMI_0_tmds_data_n(hdmi_tmds_data_n),
        .HDMI_0_tmds_data_p(hdmi_tmds_data_p),
        .clk_100MHz(Clk),
        .gpio_usb_int_tri_i(gpio_usb_int_tri_i),
        .gpio_usb_keycode_0_tri_o(keycode0_gpio),
        .gpio_usb_keycode_1_tri_o(keycode1_gpio),
        .gpio_usb_rst_tri_o(gpio_usb_rst_tri_o),
        .reset_rtl_0(~reset_ah), //Block designs expect active low reset, all other modules are active high
        .uart_rtl_0_rxd(uart_rtl_0_rxd),
        .uart_rtl_0_txd(uart_rtl_0_txd),
        .usb_spi_miso(usb_spi_miso),
        .usb_spi_mosi(usb_spi_mosi),
        .usb_spi_sclk(usb_spi_sclk),
        .usb_spi_ss(usb_spi_ss)
        
    );
        
    clkdiv clock(
        .clk_in(Clk),
        .clk_out(clk_50MHz)
    );
    
     clkdivKHz clock2(
        .clk_in(Clk),
        .clk_out(clk_48KHz)
    );
    
        Pulse_Module PWM(
        .clk(clk_50MHz),
        .audio(fifo_output),
        .PWMR(PWMR),
        .PWML(PWML)
    );
    
    posedge_detector posed(
        .clk(clk_50MHz),
        .flag(clk_48KHz),
        .reset(reset_ah),
        .sync(align_signal)
    );
    
    sdcard_init sdcard (
    .clk50(clk_50MHz),
    .reset(reset_ah),
    .ram_we(ramwe),
    .ram_address(ramaddress),
    .ram_data(ramdataout),
    .ram_op_begun(align_signal),
    .ram_init_error(raminiterror),
    .ram_init_done(raminitdone),
    .cs_bo(cs),
    .sclk_o(sclk),
    .mosi_o(mosi),
    .miso_i(miso),
    .state_r(state_r), 
    .state_x(state_x)
    );
    
    fifo_generator_0 fifo (
    .full(flag1),
    .din(ramdataout),
    .wr_en(ramwe),
    .empty(flag2),
    .dout(fifo_output),
    .rd_en(align_signal),
    .clk(clk_50MHz),
    .srst(reset_ah),
    .prog_full(flag3) 
    );
    
    ila_0 myila (
    .clk(Clk),
    .probe0(clk_100Mhz),
    .probe1(clk_48KHz),  
    .probe2(clk_50MHz),
    .probe3(align_signal), 
    .probe4(PWMR),
    .probe5(PWML),
    .probe6(fifo_output), 
    .probe7(ramaddress),
    .probe8(ramdataout),
    .probe9(ram_we),
    .probe10(state_r)
    );
    
endmodule
