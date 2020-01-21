################################################################################
##
## Filename:	Makefile
##
## Project:	AutoFPGA basic peripheral demonstration project
##
## Purpose:	A master project makefile.  It tries to build all targets
##		within the project, mostly by directing subdirectory makes.
##
##
## Creator:	Dan Gisselquist, Ph.D.
##		Gisselquist Technology, LLC
##
################################################################################
##
## Copyright (C) 2015-2020, Gisselquist Technology, LLC
##
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
## You should have received a copy of the GNU Lesser General Public License along
## with this program.  (It's in the $(ROOT)/doc directory.  Run make with no
## target there if the PDF file isn't present.)  If not, see
## <http://www.gnu.org/licenses/> for a copy.
##
## License:	LGPL, v3, as defined and found on www.gnu.org,
##		http://www.gnu.org/licenses/lgpl.html
##
##
################################################################################
##
##
.PHONY: all
all:	autodata check-install datestamp rtl sim sw subs
#
# Could also depend upon load, if desired, but not necessary
AUTODATA := `find auto-data -name "*.txt"`
CONSTRAINTS := `find . -name "*.xdc"`
YYMMDD:=`date +%Y%m%d`
SUBMAKE:= $(MAKE) --no-print-directory -C
AUTO := $(wildcard auto-data/*.txt) auto-data/Makefile
RTL  := $(wildcard rtl/*.v) rtl/Makefile
SW   := $(wildcard sw/*.h) $(wildcard sw/*.cpp) $(wildcard sw/*.c) sw/Makefile
YYMMDD:=`date +%Y%m%d`

#
#
# Check that we have all the programs available to us that we need
#
#
.PHONY: check-install
check-install: check-perl check-verilator check-gpp

.PHONY: check-perl
	$(call checkif-installed,perl,)

.PHONY: check-autofpga
check-autofpga:
	$(call checkif-installed,autofpga,-V)

.PHONY: check-verilator
check-verilator:
	$(call checkif-installed,verilator,-V)

.PHONY: check-gpp
check-gpp:
	$(call checkif-installed,g++,-v)

#
#
#
# Now that we know that all of our required components exist, we can build
# things
#
#
#
# Create a datestamp file, so that we can check for the build-date when the
# project was put together.
#
.PHONY: datestamp
datestamp: check-perl
	@bash -c 'if [ ! -e $(YYMMDD)-build.v ]; then rm -f 20??????-build.v; perl mkdatev.pl > $(YYMMDD)-build.v; rm -f rtl/builddate.v; fi'
	@bash -c 'if [ ! -e rtl/builddate.v ]; then cd rtl; cp ../$(YYMMDD)-build.v builddate.v; fi'

#
#
# Build our main (and toplevel) Verilog files via autofpga
#
.PHONY: autodata
autodata: check-autofpga
	$(MAKE) --no-print-directory --directory=auto-data
	$(call copyif-changed,auto-generated/toplevel.v,rtl/toplevel.v)
	$(call copyif-changed,auto-generated/main.v,rtl/main.v)
	$(call copyif-changed,auto-generated/regdefs.h,sw/regdefs.h)
	$(call copyif-changed,auto-generated/regdefs.cpp,sw/regdefs.cpp)
	$(call copyif-changed,auto-generated/rtl.make.inc,rtl/make.inc)
	$(call copyif-changed,auto-generated/testb.h,sim/testb.h)
	$(call copyif-changed,auto-generated/main_tb.cpp,sim/main_tb.cpp)

HEXBUS := dbgbus
XBAR   := wb2axip
.PHONY: subs
subs:
	@bash -c "if [ ! -e $(HEXBUS)/README.md ]; then git submodule init ; git submodule update; fi"
	@bash -c "if [ ! -e $(XBAR)/README.md ]; then git submodule init; git submodule update; fi"

.PHONY: archive
archive:
	tar --transform s,^,$(YYMMDD)-demo/, -chjf $(YYMMDD)-demo.tjz $(AUTO) $(RTL) $(SW)
#
#
# Verify that the rtl has no bugs in it, while also creating a Verilator
# simulation class library that we can then use for simulation
#
.PHONY: verilated
verilated: datestamp check-verilator subs
	+@$(SUBMAKE) rtl

.PHONY: rtl
rtl: verilated

#
#
# Build a simulation of this entire design
#
.PHONY: sim
sim: rtl check-gpp subs
	+@$(SUBMAKE) sim

#
#
# A master target to build all of the support software
#
.PHONY: sw
sw: check-gpp subs
	+@$(SUBMAKE) sw

.PHONY: test
test: sim sw
	@echo
	@echo "Running a design test"
	+bash -c "./test.sh || true"

#
#
# Copy a file from the auto-data directory that had been created by
# autofpga, into the directory structure where it might be used.
#
define	copyif-changed
	@bash -c 'cmp $(1) $(2); if [[ $$? != 0 ]]; then echo "Copying $(1) to $(2)"; cp $(1) $(2); fi'
endef

#
#
# Check if the given program is installed
#
define	checkif-installed
	@bash -c '$(1) $(2) < /dev/null >& /dev/null; if [[ $$? != 0 ]]; then echo "Program not found: $(1)"; exit -1; fi'
endef


.PHONY: clean
clean:
	+$(SUBMAKE) auto-data clean
	+$(SUBMAKE) sim       clean
	+$(SUBMAKE) rtl       clean
	+$(SUBMAKE) sw        clean
