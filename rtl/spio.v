////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	spio.v
//
// Project:	AutoFPGA basic peripheral demonstration project
//
// Purpose:	
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2017-2019, Gisselquist Technology, LLC
//
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
//
// License:	LGPL, v3, as defined and found on www.gnu.org,
//		http://www.gnu.org/licenses/lgpl.html
//
//
////////////////////////////////////////////////////////////////////////////////
//
//
`default_nettype none
//
module	spio(i_clk, i_wb_cyc, i_wb_stb, i_wb_we, i_wb_data, i_wb_sel,
		o_wb_ack, o_wb_stall, o_wb_data,
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

	initial	o_led = 0;
	always @(posedge i_clk)
	begin
		if ((i_wb_stb)&&(i_wb_we)&&(i_wb_sel[0]))
		begin
			if (!i_wb_sel[1])
				o_led <= i_wb_data[(NLEDS-1):0];
			else
				o_led <= (o_led&(~i_wb_data[(8+NLEDS-1):8]))
					|(i_wb_data[(NLEDS-1):0]&i_wb_data[(8+NLEDS-1):8]);
		end
	end

	wire	[(8-1):1]	w_btn;
	wire	[(8-1):0]	o_btn;
	debouncer #(NBTN) thedebouncer(i_clk, i_btn, o_btn[(NBTN-1):0]);
	assign	w_btn[(NBTN-1):1] = i_btn[(NBTN-1):1];
	generate if (NBTN < 8)
		assign	w_btn[7:NBTN] = 0;
		assign	o_btn[7:NBTN] = 0;
	endgenerate

	wire	[(8-1):0]		w_sw;
	assign	w_sw[(NSW-1):0] = i_sw;
	generate if (NLEDS < 8)
		assign	w_sw[7:NSW] = 0;
	endgenerate

	assign	o_wb_data = { w_btn[7:1], 1'b0, w_sw, o_btn, o_led };

	reg	[(NSW-1):0]	last_sw;
	reg	[(NBTN-1):0]	last_btn;
	always @(posedge i_clk)
		last_sw <= i_sw;
	always @(posedge i_clk)
		last_btn <= o_btn[(NBTN-1):0];
	always @(posedge i_clk)
		o_int <= (last_sw != i_sw)
			|| (|((o_btn[(NBTN-1):0])&(~last_btn)));

	assign	o_wb_stall = 1'b0;
	always @(posedge i_clk)
		o_wb_ack <= (i_wb_stb);

	// Make Verilator happy
	// verilator lint_on  UNUSED
	wire	[34:0]	unused;
	assign	unused = { i_wb_cyc, i_wb_data, i_wb_sel[3:2] };
	// verilator lint_off UNUSED
endmodule
