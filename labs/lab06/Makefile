export PATH := /home/shay/a/ece270/bin:$(PATH)
export LD_LIBRARY_PATH := /home/shay/a/ece270/lib:$(LD_LIBRARY_PATH)

YOSYS=yosys
NEXTPNR=nextpnr-ice40
SHELL=bash

PROJ	= lab06
PINMAP 	= pinmap.pcf
TCLPREF = addwave.gtkw
TB	= tb.sv
SRC	= top.sv
ICE   	= ice40hx8k.sv
CHK 	= check.bin
DEM 	= demo.bin
UART	= uart/uart.v uart/uart_tx.v uart/uart_rx.v
FILES   = $(ICE) $(SRC) $(UART)
TRACE	= $(PROJ).vcd
BUILD   = ./build

DEVICE  = 8k
TIMEDEV = hx8k
FOOTPRINT = ct256

all: cram

$(BUILD)/$(PROJ).json : $(ICE) $(SRC) $(PINMAP) Makefile
	# lint with Verilator
	verilator --lint-only $(SRC)
	# if build folder doesn't exist, create it
	mkdir -p $(BUILD)
	# synthesize using Yosys
	$(YOSYS) -p "read_verilog -sv -noblackbox $(FILES); synth_ice40 -top ice40hx8k -json $(BUILD)/$(PROJ).json"

$(BUILD)/$(PROJ).asc : $(BUILD)/$(PROJ).json
	# Place and route using nextpnr
	$(NEXTPNR) --hx8k --package ct256 --pcf $(PINMAP) --asc $(BUILD)/$(PROJ).asc --json $(BUILD)/$(PROJ).json 2> >(sed -e 's/^.* 0 errors$$//' -e '/^Info:/d' -e '/^[ ]*$$/d' 1>&2)

$(BUILD)/$(PROJ).bin : $(BUILD)/$(PROJ).asc
	# Convert to bitstream using IcePack
	icepack $(BUILD)/$(PROJ).asc $(BUILD)/$(PROJ).bin

$(TRACE): $(TB) $(SRC)
	iverilog -g2012 $(TB) $(SRC) -o sim.vvp
	vvp -N sim.vvp 1> >(sed -e 's/^.* 0 errors$$//' -e '/^Info:/d' -e '/^[ ]*$$/d' 1>&2)
	rm -f sim.vvp

verify: $(TRACE)
	# Running GTKWave
	gconftool-2 --type string --set /com.geda.gtkwave/0/reload 0
	pgrep -u ${USER} gtkwave || (gtkwave $(TCLPREF) >/dev/null 2>&1 &)
	
check: $(CHK)
	iceprog -S $(CHK)
	
demo:  $(DEM)
	iceprog -S $(DEM)

flash: $(BUILD)/$(PROJ).bin
	iceprog $(BUILD)/$(PROJ).bin

cram: $(BUILD)/$(PROJ).bin
	iceprog -S $(BUILD)/$(PROJ).bin

time: $(BUILD)/$(PROJ).asc
	icetime -p $(PINMAP) -P $(FOOTPRINT) -d $(TIMEDEV) $<

clean:
	rm -rf build/ verilog.log $(PROJ).vcd
