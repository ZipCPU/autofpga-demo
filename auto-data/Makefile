################################################################################
##
## Filename:	auto-data/Makefile
## {{{
## Project:	AutoFPGA basic peripheral demonstration project
##
## Purpose:	To direct the build of the autofpga automatically generated
##		files.  The various configuration files are the *.txt files
##	found in this directory.
##
##
## Creator:	Dan Gisselquist, Ph.D.
##		Gisselquist Technology, LLC
##
################################################################################
## }}}
## Copyright (C) 2017-2021, Gisselquist Technology, LLC
## {{{
## This file is part of the AutoFPGA peripheral demonstration project.
##
## The AutoFPGA peripheral demonstration project is free software (firmware):
## you can redistribute it and/or modify it under the terms of the GNU Lesser
## General Public License as published by the Free Software Foundation, either
## version 3 of the License, or (at your option) any later version.
##
## The AutoFPGA peripheral demonstration project is distributed in the hope
## that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
## warranty of MERCHANTIBILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with this program.  (It's in the $(ROOT)/doc directory.  Run make with
## no target there if the PDF file isn't present.)  If not, see
## <http://www.gnu.org/licenses/> for a copy.
## }}}
## License:	LGPL, v3, as defined and found on www.gnu.org,
## {{{
##		http://www.gnu.org/licenses/lgpl.html
##
################################################################################
##
## }}}
.PHONY: all
all:	data
#
# Could also depend upon load, if desired, but not necessary
#
# This is the list of components that will form our project.  Each file consists
# of parts and pieces of our project that autofpga will copy/paste into our
# main project files.
#
DATA := global.txt bkram.txt buserr.txt clock.txt hexbus.txt		\
	fixdata.txt pwrcount.txt rawreg.txt simhalt.txt	version.txt spio.txt

AUTOFPGA?= $(shell which autofpga)

.PHONY: data
data: $(DATA)
	$(AUTOFPGA) -d autofpga.dbg -o ../auto-generated $(DATA)

define	notify-on-change
	@bash -c 'cmp $(1) $(2)/$(1); if [[ $$? != 0 ]]; then echo "Files $(1) and $(2)/$(1) differ"; fi'
endef

.PHONY: clean
clean:
	# rm -f toplevel.v main.v regdefs.h regdefs.cpp board.h board.ld
	# rm -f rtl.make.inc main_tb.cpp
	rm -f autofpga.dbg
