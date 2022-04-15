export PATH := /home/shay/a/ece270/bin:$(PATH)
export LD_LIBRARY_PATH := /home/shay/a/ece270/lib:$(LD_LIBRARY_PATH)

YOSYS=yosys
NEXTPNR=nextpnr-ice40
SHELL=bash

PROJ    = verdle
PINMAP  = pinmap.pcf
TCLPREF = addwave.gtkw
CELLS	= support/cells_map_timing.v support/cells_sim_timing.v
SRC     = verdle.sv
ICE     = ice40hx8k.sv
UART    = support/uart.v support/uart_tx.v support/uart_rx.v
FILES   = $(ICE) $(SRC) $(UART)
BUILD   = ./build
TRACE   = $(BUILD)/$(PROJ).vcd

DEVICE  = 8k
TIMEDEV = hx8k
FOOTPRINT = ct256

SUBMODULES=fr_counter wordcmp printer ssdisplay

all: verify

verify: verdle.sv
	mkdir -p $(BUILD)
	@echo
	@echo Synthesizing modules...
	@for name in $(SUBMODULES) ; do \
		yosys -p "read_verilog -sv verdle.sv; synth_ice40 -top $$name; write_verilog $(BUILD)/$$name.v";\
	done
	@echo
	@echo Testing modules...
	@for name in $(SUBMODULES) ; do \
		rm -f vvp;\
		echo "=============================================================" ; \
		echo "==> Running $$name tests..." ; \
		iverilog -g2012 tests/tb_$$name.v $(BUILD)/$$name.v $(CELLS) -o vvp | grep -v "constant selects";\
		(ls vvp > /dev/null && ./vvp) || (echo Tests for $$name failed, see feedback. && rm -f vvp && exit 1);\
	done
	@rm -f vvp

$(BUILD)/$(PROJ).json : $(FILES) $(PINMAP) verdle.json Makefile
	# lint with Verilator
	verilator --lint-only support/blank.verdle.sv $(SRC) --top-module top -Wno-CASEINCOMPLETE
	# if build folder doesn't exist, create it
	mkdir -p $(BUILD)
	# synthesize using Yosys
	$(YOSYS) -p "read_json verdle.json; read_verilog -sv -noblackbox $(FILES); synth_ice40 -top ice40hx8k -json $(BUILD)/$(PROJ).json"

$(BUILD)/$(PROJ).asc : $(BUILD)/$(PROJ).json
	# Place and route using nextpnr
	$(NEXTPNR) --hx8k --package ct256 --pcf $(PINMAP) --asc $(BUILD)/$(PROJ).asc --json $(BUILD)/$(PROJ).json 2> >(sed -e 's/^.* 0 errors$$//' -e '/^Info:/d' -e '/^[ ]*$$/d' 1>&2)

$(BUILD)/$(PROJ).bin : $(BUILD)/$(PROJ).asc
	# Convert to bitstream using IcePack
	icepack $(BUILD)/$(PROJ).asc $(BUILD)/$(PROJ).bin

flash: $(BUILD)/$(PROJ).bin
	iceprog $(BUILD)/$(PROJ).bin

cram: $(BUILD)/$(PROJ).bin
	iceprog -S $(BUILD)/$(PROJ).bin

clean:
	rm -rf vvp $(BUILD)
