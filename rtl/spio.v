////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	spio.v
// {{{
// Project:	AutoFPGA basic peripheral demonstration project
//
// Purpose:	
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
`default_nettype none
// }}}
module	spio(i_clk, i_wb_cyc, i_wb_stb, i_wb_we, i_wb_data, i_wb_sel,
		o_wb_stall, o_wb_ack, o_wb_data,
		i_sw, i_btn, o_led, o_int);
	parameter	NLEDS=8, NBTN=8, NSW=8;
	input	wire			i_clk;
	input	wire			i_wb_cyc, i_wb_stb, i_wb_we;
	input	wire	[31:0]		i_wb_data;
	input	wire	[3:0]		i_wb_sel;
	output	reg			o_wb_ack;
	output	wire			o_wb_stall;
	output	wire	[31:0]		o_wb_data;
	input	wire	[(NSW-1):0]	i_sw;
	input	wire	[(NBTN-1):0]	i_btn;
	output	reg	[(NLEDS-1):0]	o_led;
	output	reg			o_int;

	reg	[(8-1):0]	r_led;
	wire	[(8-1):0]	w_btn;
	reg	[(8-1):0]	r_sw;
	reg			sw_int;
	reg	[(NBTN-1):0]	last_btn;

	initial	r_led = 0;
	always @(posedge i_clk)
	if ((i_wb_stb)&&(i_wb_we)&&(i_wb_sel[0]))
	begin
		if (!i_wb_sel[1])
			r_led[NLEDS-1:0] <= i_wb_data[(NLEDS-1):0];
		else
			r_led[NLEDS-1:0] <= (r_led[NLEDS-1:0]&(~i_wb_data[(8+NLEDS-1):8]))
				|(i_wb_data[(NLEDS-1):0]&i_wb_data[(8+NLEDS-1):8]);
	end

	debouncer #(NBTN) thedebouncer(i_clk, i_btn, w_btn[(NBTN-1):0]);
	generate if (NBTN < 8)
		assign	w_btn[7:NBTN] = 0;
	endgenerate

	// 2FF synchronizer for our switches
	generate if (NSW > 0)
	begin
		reg	[2*NSW-1:0]	sw_pipe;

		initial	r_sw    = 0;
		initial	sw_pipe = 0;
		always @(posedge i_clk)
		begin
			r_sw <= 0;
			{ r_sw[NSW-1:0], sw_pipe } <= { sw_pipe, i_sw };

			sw_int <= (r_sw[NSW-1:0] != sw_pipe[2*NSW-1:NSW]);
		end

	end else begin

		always @(*)
			r_sw = 0;

	end endgenerate

	assign	o_wb_data = { 8'b0, r_sw, w_btn, r_led };

	always @(posedge i_clk)
		last_btn <= w_btn[(NBTN-1):0];

	initial	o_int = 0;
	always @(posedge i_clk)
		o_int <= sw_int || (|((w_btn[(NBTN-1):0])&(~last_btn)));

	always @(*)
		o_led = r_led;

	assign	o_wb_stall = 1'b0;

	initial	o_wb_ack = 1'b0;
	always @(posedge i_clk)
		o_wb_ack <= (i_wb_stb);

	// Make Verilator happy
	// verilator lint_on  UNUSED
	wire	unused;
	assign	unused = &{ 1'b0, i_wb_cyc, i_wb_data, i_wb_sel[3:2] };
	// verilator lint_off UNUSED
endmodule
