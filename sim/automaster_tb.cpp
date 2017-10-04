////////////////////////////////////////////////////////////////////////////////
//
// Filename:	automaster_tb.cpp
//
// Project:	AutoFPGA basic peripheral demonstration project
//
// Purpose:	This file calls and accesses the main.v function via the
//		MAIN_TB class found in main_tb.cpp.  When put together with
//	the other components here, this file will simulate (all of) the
//	host's interaction with the FPGA circuit board.
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2015-2017, Gisselquist Technology, LLC
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
#include <signal.h>
#include <time.h>
#include <ctype.h>
#include <string.h>
#include <stdint.h>

#include "verilated.h"
#include "design.h"

#include "testb.h"
// #include "twoc.h"

#include "port.h"

#include "main_tb.cpp"

void	usage(void) {
	fprintf(stderr, "USAGE: main_tb <options>\n");
	fprintf(stderr,
"\t-d\tSets the debugging flag\n"
"\t-t <filename>\n"
"\t\tTurns on tracing, sends the trace to <filename>--assumed to\n"
"\t\tbe a vcd file\n"
);
}

int	main(int argc, char **argv) {
	const	char *trace_file = NULL; // "trace.vcd";
	bool	debug_flag = false, willexit = false;
	Verilated::commandArgs(argc, argv);
	MAINTB	*tb = new MAINTB;

	for(int argn=1; argn < argc; argn++) {
		if (argv[argn][0] == '-') for(int j=1;
					(j<512)&&(argv[argn][j]);j++) {
			switch(tolower(argv[argn][j])) {
			case 'd': debug_flag = true;
				if (trace_file == NULL)
					trace_file = "trace.vcd";
				break;
			// case 'p': fpga_port = atoi(argv[++argn]); j=1000; break;
			// case 's': serial_port=atoi(argv[++argn]); j=1000; break;
			case 't': trace_file = argv[++argn]; j=1000; break;
			case 'h': usage(); exit(0); break;
			default:
				fprintf(stderr, "ERR: Unexpected flag, -%c\n\n",
					argv[argn][j]);
				usage();
				break;
			}
		} else {
			fprintf(stderr, "ERR: Cannot read %s\n", argv[argn]);
			perror("O/S Err:");
			exit(EXIT_FAILURE);
		}
	}

	willexit = true;

	if (debug_flag) {
		printf("Opening Bus-master with\n");
		printf("\tDebug Access port = %d\n", FPGAPORT); // fpga_port);
		// printf("\tSerial Console    = %d\n", FPGAPORT+1);
			// (serial_port == 0) ? " (Standard output)" : "");
		printf("\tVCD File         = %s\n", trace_file);
	} if (trace_file)
		tb->opentrace(trace_file);

	tb->reset();

	if (willexit) {
		while(!tb->done())
			tb->tick();
	} else
		while(true)
			tb->tick();

	tb->close();
	delete tb;

	return	EXIT_SUCCESS;
}

