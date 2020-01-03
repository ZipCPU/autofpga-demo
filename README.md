# An AutoFPGA peripheral demonstration project

This is a demonstration project.  It is designed to show users how simple
peripherals can be incorporated into a design via
[AutoFPGA](https://github.com/ZipCPU/autofpga).  My plan is to
blog about this design at [zipcpu.com](http://zipcpu.com), and describe how
various components can be added (or removed) from a design using this design
as an example.

To use, first install [AutoFPGA](https://github.com/ZipCPU/autofpga), and
place the autofpga executable in your path.  Then, from the main directory,
run:

```bash
% make autodata
% make test
```

You should see a "SUCCESS" result.

## Interactive testing

Now that you have a working design, you can try examples yourself.  To
start the simulation, run `main_tb` from the `sim` directory and let it
run.

Now change into the `sw` directory and try running some (or all) of the below
commands:

```bash
% wbregs VERSION	# Read the build-date from the design
% wbregs PWRCOUNT 	# Read sim clocks since startup
% wbregs FIXEDATA	# Read a fixed data register from within the design
% wbregs RAWREG		# Read a register
% wbregs RAWREG	 0x22334567	# Write to the same register
% wbregs RAWREG	 	# Read our register back again, to check our change
% wbregs PWRCOUNT 	# Read (updated) sim clocks since startup
% wbregs SIMHALT 1 	# End the simulation
```

When you give the final command, `wbregs SIMHALT 1`, you tell Verilator
to end the simulation.

There's also a `RAM` area you can write to, as well as a `BUSERR` register which
should capture the address of the last bus error.

## FPGA testing

You can now turn around and deploy this design onto an FPGA.  To do this,
build the design found in the `rtl` directory.  You will need the sources
from the `dbgbus/hexbus/rtl` directory as well.

The design is set to work on a baud rate of 1MBaud, as defined by in
[auto-data/hexbus.txt](auto-data/hexbus.txt).  If you run into problems,
then feel free to adjust this baud rate to something that will work with the
terminal program on your system.  I've found that 9600 Baud seems to be a
universally supported number.  After making this change, re-run `make autodata`
from the main directory, rebuild your design, and then deploy it to your
FPGA board.

Now start up `netuart`.  NetUART will connect to the serial port of your
design and attempt to forward that serial port over the TCP/IP port identified
in [port.h](sw/port.h).  `netuart` connects to the serial port named
`/dev/ttyUSB2` by default.  You may give it a single argument identifying
a different serial port if you like.  Do beware, however, that because
`main_tb` and `netuart` connect to the same TCP/IP port number, they cannot
both run at the same time.

Once `netuart` is up and running, you may then repeat the `wbregs` tests from
the interactive test above.  They should all work as before, save that writing
to the `SIMHALT` register will no longer halt the simulation--since you won't
be running a simulation anymore.
