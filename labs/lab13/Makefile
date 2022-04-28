export PATH := /home/shay/a/ece270/bin:$(PATH)
export LD_LIBRARY_PATH := /home/shay/a/ece270/lib:$(LD_LIBRARY_PATH)

YOSYS=yosys
NEXTPNR=nextpnr-ice40
SHELL=bash

PROJ	= lab13
PINMAP 	= pinmap.pcf
TCLPREF = addwave.gtkw
TB	= tb.sv
SRC	= top.sv
ICE   	= ice40hx8k.sv
JSON    = lunarlander.json
BBOX    = support/ignore.sv
UART	= support/uart.v support/uart_tx.v support/uart_rx.v
FILES   = $(ICE) $(SRC) $(UART)
TRACE	= $(PROJ).vcd
BUILD   = ./build

DEVICE  = 8k
TIMEDEV = hx8k
FOOTPRINT = ct256

all: cram

.PHONY: $(TRACE) clean

$(BUILD)/$(PROJ).json : $(ICE) $(SRC) $(PINMAP) Makefile
	verilator -Wno-PINMISSING --lint-only $(BBOX) $(SRC) --top-module top -Wno-CASEINCOMPLETE
	# if build folder doesn't exist, create it
	mkdir -p $(BUILD)
	# synthesize using Yosys
	$(YOSYS) -p "read_json $(JSON); read_verilog -sv -noblackbox $(FILES); synth_ice40 -top ice40hx8k -json $(BUILD)/$(PROJ).json"

$(BUILD)/$(PROJ).asc : $(BUILD)/$(PROJ).json
	# Place and route using nextpnr
	$(NEXTPNR) --hx8k --package ct256 --pcf $(PINMAP) --asc $(BUILD)/$(PROJ).asc --json $(BUILD)/$(PROJ).json 2> >(sed -e 's/^.* 0 errors$$//' -e '/^Info:/d' -e '/^[ ]*$$/d' 1>&2)

$(BUILD)/$(PROJ).bin : $(BUILD)/$(PROJ).asc
	# Convert to bitstream using IcePack
	icepack $(BUILD)/$(PROJ).asc $(BUILD)/$(PROJ).bin

$(TRACE): $(TB) $(SRC)
	verilator -Wno-PINMISSING --lint-only $(SRC) --top-module top
	iverilog -g2012 $(TB) $(SRC) -o sim.vvp 2> >(grep -v 'constant selects')
	vvp -N sim.vvp 1> >(sed -e 's/^.* 0 errors$$//' -e '/^Info:/d' -e '/^[ ]*$$/d' 1>&2)
	rm -f sim.vvp

verify: $(TRACE)
	# Running GTKWave
	gconftool-2 --type string --set /com.geda.gtkwave/0/reload 0
	pgrep -u ${USER} gtkwave || (gtkwave $(TCLPREF) >/dev/null 2>&1 &)

flash: $(BUILD)/$(PROJ).bin
	iceprog $(BUILD)/$(PROJ).bin

cram: $(BUILD)/$(PROJ).bin
	iceprog -S $(BUILD)/$(PROJ).bin

time: $(BUILD)/$(PROJ).asc
	icetime -p $(PINMAP) -P $(FOOTPRINT) -d $(TIMEDEV) $<

clean:
	-pkill -u $(USER) -9 vvp; true
	rm -rf build/ verilog.log $(PROJ).vcd sim.vvp
