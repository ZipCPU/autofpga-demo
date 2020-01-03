////////////////////////////////////////////////////////////////////////////////
//
// Filename:	testtb.cpp
//
// Project:	dbgbus, a collection of 8b channel to WB bus debugging protocols
//
// Purpose:	
//
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2017-2019, Gisselquist Technology, LLC
//
// This file is part of the debugging interface demonstration.
//
// The debugging interface demonstration is free software (firmware): you can
// redistribute it and/or modify it under the terms of the GNU Lesser General
// Public License as published by the Free Software Foundation, either version
// 3 of the License, or (at your option) any later version.
//
// This debugging interface demonstration is distributed in the hope that it
// will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
// of MERCHANTIBILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
// General Public License for more details.
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
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <strings.h>
#include <ctype.h>
#include <string.h>
#include <signal.h>
#include <assert.h>

#include "port.h"
#include "regdefs.h"
#include "design.h"
#include "hexbus.h"

FPGA	*m_fpga;
void	closeup(int v) {
	m_fpga->kill();
	exit(0);
}

void	usage(void) {
	printf("USAGE: testtb\n"
"\n"
"\tThis test bench testing script requires that you first run main_tb\n"
"\tfrom another window.  Alternatively, you can connect the attached\n"
"\tdesign to an FPGA and use netuart to connect to it.  testtb then\n"
"\tattempts a series of scripted tests to see if the simulation works\n"
"\tas desired.\n");
}

int main(int argc, char **argv) {
	bool		fail = false;
	FPGA::BUSW	buserr;

	FPGAOPEN(m_fpga);

	signal(SIGSTOP, closeup);
	signal(SIGHUP, closeup);

	if (argc != 1) {
		usage();
		// printf("USAGE: testtb # (takes no arguments)\n");
		exit(-1);
	}

	buserr = m_fpga->readio(R_BUSERR);
	try {
		FPGA::BUSW	v, fixdata, pwrcount, version, spio, ledmask,
				rawdata;

		version = m_fpga->readio(R_VERSION);
		if (version != DATESTAMP) {
			printf("VERSION   : 0x%08x FAIL, != 0x%08x\n", version, DATESTAMP);
			fail = true;
		} else
			printf("VERSION   : 0x%08x\n", version);

		pwrcount = m_fpga->readio(R_PWRCOUNT);
		printf("PWRCOUNT  : 0x%08x (Initial)\n", pwrcount);

		//
		// Fixed data register
		fixdata = m_fpga->readio(R_FIXEDATA);
		printf("FIXEDATA  : 0x%08x\n", fixdata);
		m_fpga->writeio(R_FIXEDATA, -1);
		if (fixdata != (v = m_fpga->readio(R_FIXEDATA))) {
			printf("FIXEDATA  : 0x%08x FAIL, != %08x\n", v, fixdata);
			fail = true;
		}
		m_fpga->writeio(R_FIXEDATA, 0x12345678);
		if (fixdata != (v = m_fpga->readio(R_FIXEDATA))) {
			printf("FIXEDATA  : 0x%08x FAIL, != %08x\n", v, fixdata);
			fail = true;
		}
		m_fpga->writeio(R_FIXEDATA, 0x87654321);
		if (fixdata != (v = m_fpga->readio(R_FIXEDATA))) {
			printf("FIXEDATA  : 0x%08x FAIL, != %08x\n", v, fixdata);
			fail = true;
		}
		m_fpga->writeio(R_FIXEDATA, 0);
		if (fixdata != (v = m_fpga->readio(R_FIXEDATA))) {
			printf("FIXEDATA  : 0x%08x FAIL, != %08x\n", v, fixdata);
			fail = true;
		}

		//
		// Raw data register
		rawdata = m_fpga->readio(R_RAWREG);
		printf("RAWREG    : 0x%08x\n", rawdata);
		m_fpga->writeio(R_RAWREG, -1);
		if (0xffffffff != (v = m_fpga->readio(R_RAWREG))) {
			printf("RAWREG    : 0x%08x FAILS, != 0xffffffff\n", v);
			fail = true;
		}
		m_fpga->writeio(R_RAWREG, 0x12345678);
		if (0x12345678 != (v = m_fpga->readio(R_RAWREG))) {
			printf("RAWREG    : 0x%08x FAILS, != 0x12345678\n", v);
			fail = true;
		}
		m_fpga->writeio(R_RAWREG, 0x87654321);
		if (0x87654321 != (v = m_fpga->readio(R_RAWREG))) {
			printf("RAWREG    : 0x%08x FAILS, != 0x87654321\n", v);
			fail = true;
		}
		m_fpga->writeio(R_RAWREG, 0);
		if (0 != (v = m_fpga->readio(R_RAWREG))) {
			printf("RAWREG    : 0x%08x FAILS, != 0\n", v);
			fail = true;
		}

		//
		// LED register
		spio = m_fpga->readio(R_SPIO);
		printf("SPIO      : 0x%08x\n", spio);
		// Turn all LEDs on
		m_fpga->writeio(R_SPIO, 0x0ffff);
		ledmask = m_fpga->readio(R_SPIO) & 0x0ff;
		if (ledmask == 0 && (spio & 0x0ff) != 0) {
			printf("SPIO      : 0x%08x FAIL (all on?)\n", ledmask);
			fail = true;
		} else {
			// Turn all LEDs off
			m_fpga->writeio(R_SPIO, 0x0ff00);
			if (0 != (v = (m_fpga->readio(R_SPIO) & 0x0ff))) {
				printf("SPIO      : 0x%08x FAIL (LEDs still on?)\n", v);
				fail = true;
			} else for(unsigned msk=1; msk & ledmask ; msk <<= 1) {
				// Turn one LEDs on
				m_fpga->writeio(R_SPIO, msk | (msk<<8));
				v = m_fpga->readio(R_SPIO) & 0x0ff;
				if (v != msk) {
					printf("SPIO      : 0x%08x FAIL (Pin #%02x is off)\n", v, msk);
					fail = true;
				}


				// Turn that LED back off
				m_fpga->writeio(R_SPIO, ((~msk)&0x0ff) | (msk<<8));
				v = m_fpga->readio(R_SPIO) & 0x0ff;
				if (v != 0) {
					printf("SPIO      : 0x%08x FAIL (Pin #%02x is on!)\n", v, msk);
					fail = true;
				}
			}
		}

#define	NTEST	128
		unsigned	data[NTEST]; // addr[NTEST]

		printf("Checking memory ...\n");
		//
		// Let's check out or RAM memory
		for(unsigned k=0; k<NTEST; k++)
			data[k] = rand();

		m_fpga->writei(R_BKRAM, NTEST, data);
		for(unsigned k=0; k<NTEST; k++) {
			v = m_fpga->readio(R_BKRAM+k*4);
			printf("RAM[%3d]\r", k); fflush(stdout);
			if (v != data[k]) {
				printf("RAM[%3d]  : 0x%08x FAIL (!= 0x%08x)\n", k, v, data[k]);
				fail = true;
			}
		}

		v = m_fpga->readio(R_PWRCOUNT);
		if (v == pwrcount) {
			printf("PWRCOUNT : 0x%08x, FAIL -- remained constant\n", v);
			fail = true;
		}


		v = m_fpga->readio(R_BUSERR);
		if (buserr != v) {
			printf("BUSERR   : 0x%08x, FAIL -- changed from 0x%08x\n", v, buserr);
			fail = true;
		}


		//
		// SIMHALT register --- can we read it?
		v = m_fpga->readio(R_SIMHALT);
		printf("SIMHALT  : 0x%08x\n", v);
		
	} catch(BUSERR b) {
		printf("%08x : BUS-ERROR\n", b.addr);
		fail = true;
	}

	if (!fail)
		printf("SUCCESS!\n");
	else
		printf("FAIL\n");

	try {
		m_fpga->writeio(R_SIMHALT, 1);
	} catch(...) {
	}
}

