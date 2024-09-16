# ECE-385-Coursework
Labs and corresponding reports designed for ECE 385: Digital Systems Laboratory @ UIUC FA'23

For more information on each lab, its report gives a detailed explanation on the project goals. Some project folders only include modified files from the provided files given to us by instructors.

Final Project Description:
Pac-Man | SystemVerilog, C, Xilinx Vivado, Vitis HLS, RealDigital Urbana Board 
October 2023 - December 2023
• Emulated Namco’s popularized arcade game using Vivado design software and the Urbana FPGA hardware.
• Utilized PNG to COE file conversion to import and instantiate sprites as modules, defining SystemVerilog code to modify
behavior.
• Incorporated background music by editing the raw data of an SD card and instantiating necessary .sv modules such as
clock dividers, PWM, positive edge detectors, and FIFO buffer to support Vivado integration.
• Defined ghost logic by exploring open-source implementations of parallelizing A* approach in SystemVerilog, resulting in
a 76% more efficient path than a hard-coded approach.
• Additional modules instantiated for support of HDMI external display using a VGA-HDMI IP, SPI communication to
handle keyboard input with MAX3421E USB host controller, FPGA Hex Driver display, MicroBlaze soft-core processor,
and ILA cores for debugging purposes.
