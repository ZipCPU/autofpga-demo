`timescale	1ps / 1ps
////////////////////////////////////////////////////////////////////////////////
//
// Filename:	../auto-generated/main.v
// {{{
// Project:	AutoFPGA basic peripheral demonstration project
//
// DO NOT EDIT THIS FILE!
// Computer Generated: This file is computer generated by AUTOFPGA. DO NOT EDIT.
// DO NOT EDIT THIS FILE!
//
// CmdLine:	/home/dan/work/rnd/opencores/autofpga/trunk/sw/autofpga /home/dan/work/rnd/opencores/autofpga/trunk/sw/autofpga -d autofpga.dbg -o ../auto-generated global.txt bkram.txt buserr.txt clock.txt hexbus.txt fixdata.txt pwrcount.txt rawreg.txt simhalt.txt version.txt spio.txt
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
// }}}
// Copyright (C) 2017-2021, Gisselquist Technology, LLC
// {{{
// This file is part of the AutoFPGA peripheral demonstration project.
//
// The AutoFPGA peripheral demonstration project is free software (firmware):
// you can redistribute it and/or modify it under the terms of the GNU Lesser
// General Public License as published by the Free Software Foundation, either
// version 3 of the License, or (at your option) any later version.
//
// The AutoFPGA peripheral demonstration project is distributed in the hope
// that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
// warranty of MERCHANTIBILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  (It's in the $(ROOT)/doc directory.  Run make
// with no target there if the PDF file isn't present.)  If not, see
// <http://www.gnu.org/licenses/> for a copy.
// }}}
// License:	LGPL, v3, as defined and found on www.gnu.org,
// {{{
//		http://www.gnu.org/licenses/lgpl.html
//
////////////////////////////////////////////////////////////////////////////////
//
// }}}
`default_nettype	none
////////////////////////////////////////////////////////////////////////////////
//
// Macro defines
// {{{
//
//
// Here is a list of defines which may be used, post auto-design
// (not post-build), to turn particular peripherals (and bus masters)
// on and off.  In particular, to turn off support for a particular
// design component, just comment out its respective `define below.
//
// These lines are taken from the respective @ACCESS tags for each of our
// components.  If a component doesn't have an @ACCESS tag, it will not
// be listed here.
//
// First, the independent access fields for any bus masters
// And then for the independent peripherals
`define	SPIO_ACCESS
`define	BKRAM_ACCESS
//
// End of dependency list
//
//
// }}}
////////////////////////////////////////////////////////////////////////////////
//
// Any include files
// {{{
// These are drawn from anything with a MAIN.INCLUDE definition.
// }}}
//
// Finally, we define our main module itself.  We start with the list of
// I/O ports, or wires, passed into (or out of) the main function.
//
// These fields are copied verbatim from the respective I/O port lists,
// from the fields given by @MAIN.PORTLIST
//
module	main(i_clk, i_reset,
	// {{{
		// SPIO interface
		i_sw, i_btnc, i_btnd, i_btnl, i_btnr, i_btnu, o_led,
		o_simhalt,
 		// UART/host to wishbone interface
 		i_host_uart_rx, o_host_uart_tx	// }}}
);
////////////////////////////////////////////////////////////////////////////////
//
// Any parameter definitions
// {{{
// These are drawn from anything with a MAIN.PARAM definition.
// As they aren't connected to the toplevel at all, it would
// be best to use localparam over parameter, but here we don't
// check
	// SPIO interface
	localparam	NBTN=5,
			NLEDS=8,
			NSW=8;
// }}}
////////////////////////////////////////////////////////////////////////////////
//
// Port declarations
// {{{
// The next step is to declare all of the various ports that were just
// listed above.  
//
// The following declarations are taken from the values of the various
// @MAIN.IODECL keys.
//
	input	wire		i_clk;
	// verilator lint_off UNUSED
	input	wire		i_reset;
	// verilator lint_on UNUSED
	input	wire	[(NSW-1):0]	i_sw;
	input	wire		i_btnc, i_btnd, i_btnl, i_btnr, i_btnu;
	output	wire	[(NLEDS-1):0]	o_led;
	output	reg	o_simhalt;
	input	wire		i_host_uart_rx;
	output	wire		o_host_uart_tx;
// }}}
	// Make Verilator happy
	// {{{
	// Defining bus wires for lots of components often ends up with unused
	// wires lying around.  We'll turn off Ver1lator's lint warning
	// here that checks for unused wires.
	// }}}
	// verilator lint_off UNUSED
	////////////////////////////////////////////////////////////////////////
	//
	// Declaring interrupt lines
	// {{{
	// These declarations come from the various components values
	// given under the @INT.<interrupt name>.WIRE key.
	//
	wire	spio_int;	// spio.INT.SPIO.WIRE
	// }}}
	////////////////////////////////////////////////////////////////////////
	//
	// Component declarations
	// {{{
	// These declarations come from the @MAIN.DEFNS keys found in the
	// various components comprising the design.
	//
	wire	[(NBTN-1):0]	w_btn;
	reg	[31:0]	r_pwrcount_data;
	//
	//
	// UART interface
	//
	//
	localparam [23:0] BUSUART = 24'h64;	// 1000000 baud
	//
	wire	w_ck_uart, w_uart_tx;
	wire		rx_host_stb;
	wire	[7:0]	rx_host_data;
	wire		tx_host_stb;
	wire	[7:0]	tx_host_data;
	wire		tx_host_busy;
	reg	[19-1:0]	r_buserr_addr;
	reg	[31:0]	r_rawreg_data;
`include "builddate.v"

// }}}
	////////////////////////////////////////////////////////////////////////
	//
	// Declaring interrupt vector wires
	// {{{
	// These declarations come from the various components having
	// PIC and PIC.MAX keys.
	//
	// }}}
	////////////////////////////////////////////////////////////////////////
	//
	// Declare bus signals
	// {{{
	////////////////////////////////////////////////////////////////////////

	// Bus wb
	// {{{
	// Wishbone definitions for bus wb, component hb
	// Verilator lint_off UNUSED
	wire		wb_hb_cyc, wb_hb_stb, wb_hb_we;
	wire	[18:0]	wb_hb_addr;
	wire	[31:0]	wb_hb_data;
	wire	[3:0]	wb_hb_sel;
	wire		wb_hb_stall, wb_hb_ack, wb_hb_err;
	wire	[31:0]	wb_hb_idata;
	// Verilator lint_on UNUSED
	// Wishbone definitions for bus wb(SIO), component buserr
	// Verilator lint_off UNUSED
	wire		wb_buserr_cyc, wb_buserr_stb, wb_buserr_we;
	wire	[18:0]	wb_buserr_addr;
	wire	[31:0]	wb_buserr_data;
	wire	[3:0]	wb_buserr_sel;
	wire		wb_buserr_stall, wb_buserr_ack, wb_buserr_err;
	wire	[31:0]	wb_buserr_idata;
	// Verilator lint_on UNUSED
	// Wishbone definitions for bus wb(SIO), component fixdata
	// Verilator lint_off UNUSED
	wire		wb_fixdata_cyc, wb_fixdata_stb, wb_fixdata_we;
	wire	[18:0]	wb_fixdata_addr;
	wire	[31:0]	wb_fixdata_data;
	wire	[3:0]	wb_fixdata_sel;
	wire		wb_fixdata_stall, wb_fixdata_ack, wb_fixdata_err;
	wire	[31:0]	wb_fixdata_idata;
	// Verilator lint_on UNUSED
	// Wishbone definitions for bus wb(SIO), component pwrcount
	// Verilator lint_off UNUSED
	wire		wb_pwrcount_cyc, wb_pwrcount_stb, wb_pwrcount_we;
	wire	[18:0]	wb_pwrcount_addr;
	wire	[31:0]	wb_pwrcount_data;
	wire	[3:0]	wb_pwrcount_sel;
	wire		wb_pwrcount_stall, wb_pwrcount_ack, wb_pwrcount_err;
	wire	[31:0]	wb_pwrcount_idata;
	// Verilator lint_on UNUSED
	// Wishbone definitions for bus wb(SIO), component rawreg
	// Verilator lint_off UNUSED
	wire		wb_rawreg_cyc, wb_rawreg_stb, wb_rawreg_we;
	wire	[18:0]	wb_rawreg_addr;
	wire	[31:0]	wb_rawreg_data;
	wire	[3:0]	wb_rawreg_sel;
	wire		wb_rawreg_stall, wb_rawreg_ack, wb_rawreg_err;
	wire	[31:0]	wb_rawreg_idata;
	// Verilator lint_on UNUSED
	// Wishbone definitions for bus wb(SIO), component simhalt
	// Verilator lint_off UNUSED
	wire		wb_simhalt_cyc, wb_simhalt_stb, wb_simhalt_we;
	wire	[18:0]	wb_simhalt_addr;
	wire	[31:0]	wb_simhalt_data;
	wire	[3:0]	wb_simhalt_sel;
	wire		wb_simhalt_stall, wb_simhalt_ack, wb_simhalt_err;
	wire	[31:0]	wb_simhalt_idata;
	// Verilator lint_on UNUSED
	// Wishbone definitions for bus wb(SIO), component spio
	// Verilator lint_off UNUSED
	wire		wb_spio_cyc, wb_spio_stb, wb_spio_we;
	wire	[18:0]	wb_spio_addr;
	wire	[31:0]	wb_spio_data;
	wire	[3:0]	wb_spio_sel;
	wire		wb_spio_stall, wb_spio_ack, wb_spio_err;
	wire	[31:0]	wb_spio_idata;
	// Verilator lint_on UNUSED
	// Wishbone definitions for bus wb(SIO), component version
	// Verilator lint_off UNUSED
	wire		wb_version_cyc, wb_version_stb, wb_version_we;
	wire	[18:0]	wb_version_addr;
	wire	[31:0]	wb_version_data;
	wire	[3:0]	wb_version_sel;
	wire		wb_version_stall, wb_version_ack, wb_version_err;
	wire	[31:0]	wb_version_idata;
	// Verilator lint_on UNUSED
	// Wishbone definitions for bus wb, component wb_sio
	// Verilator lint_off UNUSED
	wire		wb_sio_cyc, wb_sio_stb, wb_sio_we;
	wire	[18:0]	wb_sio_addr;
	wire	[31:0]	wb_sio_data;
	wire	[3:0]	wb_sio_sel;
	wire		wb_sio_stall, wb_sio_ack, wb_sio_err;
	wire	[31:0]	wb_sio_idata;
	// Verilator lint_on UNUSED
	// Wishbone definitions for bus wb, component bkram
	// Verilator lint_off UNUSED
	wire		wb_bkram_cyc, wb_bkram_stb, wb_bkram_we;
	wire	[18:0]	wb_bkram_addr;
	wire	[31:0]	wb_bkram_data;
	wire	[3:0]	wb_bkram_sel;
	wire		wb_bkram_stall, wb_bkram_ack, wb_bkram_err;
	wire	[31:0]	wb_bkram_idata;
	// Verilator lint_on UNUSED
	// }}}
	// }}}
	////////////////////////////////////////////////////////////////////////
	//
	// Peripheral address decoding, bus handling
	// {{{
	//
	// BUS-LOGIC for wb
	// {{{
	//
	// wb Bus logic to handle SINGLE slaves
	//
	reg		r_wb_sio_ack;
	reg	[31:0]	r_wb_sio_data;

	assign	wb_sio_stall = 1'b0;

	initial r_wb_sio_ack = 1'b0;
	always	@(posedge i_clk)
		r_wb_sio_ack <= (wb_sio_stb);
	assign	wb_sio_ack = r_wb_sio_ack;

	always	@(posedge i_clk)
	casez( wb_sio_addr[2:0] )
	3'h0: r_wb_sio_data <= wb_buserr_idata;
	3'h1: r_wb_sio_data <= wb_fixdata_idata;
	3'h2: r_wb_sio_data <= wb_pwrcount_idata;
	3'h3: r_wb_sio_data <= wb_rawreg_idata;
	3'h4: r_wb_sio_data <= wb_simhalt_idata;
	3'h5: r_wb_sio_data <= wb_spio_idata;
	3'h6: r_wb_sio_data <= wb_version_idata;
	default: r_wb_sio_data <= wb_version_idata;
	endcase
	assign	wb_sio_idata = r_wb_sio_data;


	//
	// Now to translate this logic to the various SIO slaves
	//
	// In this case, the SIO bus has the prefix wb_sio
	// and all of the slaves have various wires beginning
	// with their own respective bus prefixes.
	// Our goal here is to make certain that all of
	// the slave bus inputs match the SIO bus wires
	assign	wb_buserr_cyc = wb_sio_cyc;
	assign	wb_buserr_stb = wb_sio_stb && (wb_sio_addr[ 2: 0] ==  3'h0);  // 0x00000
	assign	wb_buserr_we  = wb_sio_we;
	assign	wb_buserr_data= wb_sio_data;
	assign	wb_buserr_sel = wb_sio_sel;
	assign	wb_fixdata_cyc = wb_sio_cyc;
	assign	wb_fixdata_stb = wb_sio_stb && (wb_sio_addr[ 2: 0] ==  3'h1);  // 0x00004
	assign	wb_fixdata_we  = wb_sio_we;
	assign	wb_fixdata_data= wb_sio_data;
	assign	wb_fixdata_sel = wb_sio_sel;
	assign	wb_pwrcount_cyc = wb_sio_cyc;
	assign	wb_pwrcount_stb = wb_sio_stb && (wb_sio_addr[ 2: 0] ==  3'h2);  // 0x00008
	assign	wb_pwrcount_we  = wb_sio_we;
	assign	wb_pwrcount_data= wb_sio_data;
	assign	wb_pwrcount_sel = wb_sio_sel;
	assign	wb_rawreg_cyc = wb_sio_cyc;
	assign	wb_rawreg_stb = wb_sio_stb && (wb_sio_addr[ 2: 0] ==  3'h3);  // 0x0000c
	assign	wb_rawreg_we  = wb_sio_we;
	assign	wb_rawreg_data= wb_sio_data;
	assign	wb_rawreg_sel = wb_sio_sel;
	assign	wb_simhalt_cyc = wb_sio_cyc;
	assign	wb_simhalt_stb = wb_sio_stb && (wb_sio_addr[ 2: 0] ==  3'h4);  // 0x00010
	assign	wb_simhalt_we  = wb_sio_we;
	assign	wb_simhalt_data= wb_sio_data;
	assign	wb_simhalt_sel = wb_sio_sel;
	assign	wb_spio_cyc = wb_sio_cyc;
	assign	wb_spio_stb = wb_sio_stb && (wb_sio_addr[ 2: 0] ==  3'h5);  // 0x00014
	assign	wb_spio_we  = wb_sio_we;
	assign	wb_spio_data= wb_sio_data;
	assign	wb_spio_sel = wb_sio_sel;
	assign	wb_version_cyc = wb_sio_cyc;
	assign	wb_version_stb = wb_sio_stb && (wb_sio_addr[ 2: 0] ==  3'h6);  // 0x00018
	assign	wb_version_we  = wb_sio_we;
	assign	wb_version_data= wb_sio_data;
	assign	wb_version_sel = wb_sio_sel;
	//
	// No class DOUBLE peripherals on the "wb" bus
	//

	assign	wb_sio_err= 1'b0;
	assign	wb_bkram_err= 1'b0;
	//
	// Connect the wb bus components together using the wbxbar()
	//
	//
	wbxbar #(
		.NM(1), .NS(2), .AW(19), .DW(32),
		.SLAVE_ADDR({
			// Address width    = 19
			// Address LSBs     = 2
			// Slave name width = 6
			{ 19'h40000 }, //  bkram: 0x100000
			{ 19'h20000 }  // wb_sio: 0x080000
		}),
		.SLAVE_MASK({
			// Address width    = 19
			// Address LSBs     = 2
			// Slave name width = 6
			{ 19'h40000 }, //  bkram
			{ 19'h60000 }  // wb_sio
		}),
		.OPT_DBLBUFFER(1'b1))
	wb_xbar(
		.i_clk(i_clk), .i_reset(i_reset),
		.i_mcyc({
			wb_hb_cyc
		}),
		.i_mstb({
			wb_hb_stb
		}),
		.i_mwe({
			wb_hb_we
		}),
		.i_maddr({
			wb_hb_addr
		}),
		.i_mdata({
			wb_hb_data
		}),
		.i_msel({
			wb_hb_sel
		}),
		.o_mstall({
			wb_hb_stall
		}),
		.o_mack({
			wb_hb_ack
		}),
		.o_mdata({
			wb_hb_idata
		}),
		.o_merr({
			wb_hb_err
		}),
		// Slave connections
		.o_scyc({
			wb_bkram_cyc,
			wb_sio_cyc
		}),
		.o_sstb({
			wb_bkram_stb,
			wb_sio_stb
		}),
		.o_swe({
			wb_bkram_we,
			wb_sio_we
		}),
		.o_saddr({
			wb_bkram_addr,
			wb_sio_addr
		}),
		.o_sdata({
			wb_bkram_data,
			wb_sio_data
		}),
		.o_ssel({
			wb_bkram_sel,
			wb_sio_sel
		}),
		.i_sstall({
			wb_bkram_stall,
			wb_sio_stall
		}),
		.i_sack({
			wb_bkram_ack,
			wb_sio_ack
		}),
		.i_sdata({
			wb_bkram_idata,
			wb_sio_idata
		}),
		.i_serr({
			wb_bkram_err,
			wb_sio_err
		})
		);

	// End of bus logic for wb
	// }}}
	// }}}
	////////////////////////////////////////////////////////////////////////
	//
	// Declare the interrupt busses
	// {{{
	// Interrupt busses are defined by anything with a @PIC tag.
	// The @PIC.BUS tag defines the name of the wire bus below,
	// while the @PIC.MAX tag determines the size of the bus width.
	//
	// For your peripheral to be assigned to this bus, it must have an
	// @INT.NAME.WIRE= tag to define the wire name of the interrupt line,
	// and an @INT.NAME.PIC= tag matching the @PIC.BUS tag of the bus
	// your interrupt will be assigned to.  If an @INT.NAME.ID tag also
	// exists, then your interrupt will be assigned to the position given
	// by the ID# in that tag.
	//
	// }}}
	////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////
	//
	// @MAIN.INSERT and @MAIN.ALT
	// {{{
	////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////
	//
	//
	// Now we turn to defining all of the parts and pieces of what
	// each of the various peripherals does, and what logic it needs.
	//
	// This information comes from the @MAIN.INSERT and @MAIN.ALT tags.
	// If an @ACCESS tag is available, an ifdef is created to handle
	// having the access and not.  If the @ACCESS tag is `defined above
	// then the @MAIN.INSERT code is executed.  If not, the @MAIN.ALT
	// code is exeucted, together with any other cleanup settings that
	// might need to take place--such as returning zeros to the bus,
	// or making sure all of the various interrupt wires are set to
	// zero if the component is not included.
	//
`ifdef	SPIO_ACCESS
	// {{{
	assign	w_btn = { i_btnc, i_btnd, i_btnl, i_btnr, i_btnu };

	//
	// A "special-purpose" I/O controller, able to read buttons and
	// switches, and set LEDs.
	//
	spio #(.NBTN(NBTN), .NLEDS(NLEDS), .NSW(NSW)) spioi(i_clk,
		wb_spio_cyc, wb_spio_stb, wb_spio_we,
			wb_spio_data, // 32 bits wide
			wb_spio_sel,  // 32/8 bits wide
		wb_spio_stall, wb_spio_ack, wb_spio_idata,
		i_sw, w_btn, o_led, spio_int);
	// }}}
`else	// SPIO_ACCESS
	// {{{
	assign	w_btn    = 0;
	assign	o_led    = 0;
	// Null interrupt definitions
	// {{{
	assign	spio_int = 1'b0;	// spio.INT.SPIO.WIRE
	// }}}
	// }}}
`endif	// SPIO_ACCESS

	//
	// A simulation only peripheral: SIMHALT.  Sets a one-bit flag,
	// o_simhalt, read by the simulator as an indication of when to
	// halt the simulation.  Makes it easy to halt the simulation from
	// within the simulator.
	//
	initial	o_simhalt=1'b0;
	always @(posedge i_clk)
	if (wb_simhalt_stb && wb_simhalt_we)
		o_simhalt <= wb_simhalt_data[0];

	assign	wb_simhalt_idata = 32'h0;
	assign	wb_simhalt_ack   = wb_simhalt_stb;
	assign	wb_simhalt_stall = 1'b0;
	//
	// The power-up counter--counting all of the clocks since startup.
	// Once the clock sets the high order bit, it remains set--so that
	// you can keep using the counter to tell time differences if you wish.
	//
	initial	r_pwrcount_data = 32'h0;
	always @(posedge i_clk)
	if (r_pwrcount_data[31])
		r_pwrcount_data[30:0] <= r_pwrcount_data[30:0] + 1'b1;
	else
		r_pwrcount_data[31:0] <= r_pwrcount_data[31:0] + 1'b1;
	assign	wb_pwrcount_idata = r_pwrcount_data;
	// The Host USB interface, to be used by the WB-UART bus
	rxuartlite	#(5'd24,BUSUART) rcv(i_clk, i_host_uart_rx,
				rx_host_stb, rx_host_data);
	txuartlite	#(5'd24,BUSUART) txv(i_clk, tx_host_stb, tx_host_data,
				o_host_uart_tx, tx_host_busy);

`ifndef	BUSPIC_ACCESS
	wire	w_bus_int;
	assign	w_bus_int = 1'b0;
`endif

	//
	// The debugging bus--translating UART inputs into bus commands
	// and returning responses over the UART
	//
	hbbus	#(.AW(19)) genbus(i_clk,
			rx_host_stb, rx_host_data,
			wb_hb_cyc, wb_hb_stb, wb_hb_we,
			wb_hb_addr[19-1:0],
			wb_hb_data, // 32 bits wide
			wb_hb_sel,  // 32/8 bits wide
		wb_hb_stall, wb_hb_ack, wb_hb_idata,wb_hb_err,
			w_bus_int,
			tx_host_stb, tx_host_data, tx_host_busy);

	//
	// Let's capture the address of the last bus error on the HB master
	// (i.e. debugging bus) interface
	//
	initial	r_buserr_addr = 0;
	always @(posedge i_clk)
	if (wb_hb_err)
		r_buserr_addr <= wb_hb_addr;
	assign	wb_buserr_idata = { {(32-2-19){1'b0}},
					r_buserr_addr, 2'b00 };
`ifdef	BKRAM_ACCESS
	// {{{
	//
	// Block RAM example connectivity
	//
	memdev #(.LGMEMSZ(20), .EXTRACLOCK(1))
		bkrami(i_clk,
			wb_bkram_cyc, wb_bkram_stb, wb_bkram_we,
			wb_bkram_addr[18-1:0],
			wb_bkram_data, // 32 bits wide
			wb_bkram_sel,  // 32/8 bits wide
		wb_bkram_stall, wb_bkram_ack, wb_bkram_idata);
	// }}}
`else	// BKRAM_ACCESS
	// {{{
	// Null bus slave
	// {{{

	//
	// In the case that there is no wb_bkram peripheral
	// responding on the wb bus
	assign	wb_bkram_ack   = 1'b0;
	assign	wb_bkram_err   = (wb_bkram_stb);
	assign	wb_bkram_stall = 0;
	assign	wb_bkram_idata = 0;

	// }}}
	// }}}
`endif	// BKRAM_ACCESS

	//
	// A basic peripheral serving up a fixed/constant 32-bits of data
	//
	assign	wb_fixdata_idata = 32'h20170926;
	//
	// Basic/raw register
	//
	initial	r_rawreg_data = 32'h0;
	always @(posedge i_clk)
	if (wb_rawreg_stb && wb_rawreg_we)
		r_rawreg_data <= wb_rawreg_data;

	assign	wb_rawreg_idata = r_rawreg_data;
	assign	wb_version_idata = `DATESTAMP;
	assign	wb_version_ack   = wb_version_stb;
	assign	wb_version_stall = 1'b0;
	// }}}
endmodule // main.v
