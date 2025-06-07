#-----------------------------------------------------------
# Discription: For simulating the design modules using vcs.
# To run: `cd ../workspace/`
#	  `make -f ../scripts/vcs_sim.mk TB=<your_tb_module_name>`
#	   default tb is top_tb
# To clean: `make clean`
# Author: Keyi Jiang
# E-mail: jky21@mails.tsinghua.edu.cn
#-----------------------------------------------------------

#-----------------------------------------------------------
#Variables
#-----------------------------------------------------------
WORKSPACE = ../workspace
RTL_DIR = ../sourcecode/rtl
TB_DIR = ../sourcecode/tb
RTL_FILE = ../sourcecode/rtl_list.txt
TB_FILE = ../sourcecode/tb_list.txt
FSDB_FILE = $(WORKSPACE)/my_waveform.fsdb
TB ?= top_final_tb
HELP_FILE := ../scripts/help.txt
PYTHON = python3
UPDATE_RTL = ../scripts/update_sourcecode_list.py

#-----------------------------------------------------------
#Targets
#-----------------------------------------------------------
all:clean pre com sim verdi

run:clean pre com sim

help:pre print_help

print_help:
	@cat $(HELP_FILE)
	@echo "Current tb files (You just need TB=module_name, not file name!)"
	@cat $(TB_FILE)

pre:
	$(PYTHON) $(UPDATE_RTL)

com:
	@echo "WORKSPACE=${WORKSPACE}"
	@echo "FSDB_FILE=${FSDB_FILE}"
	@echo "MODULE_FILE=${MODULE_FILE}"
	mkdir -p $(WORKSPACE)/csrc
	vcs -o $(WORKSPACE)/simv \
	    -full64 \
	    -sverilog \
	    -debug_acc+all \
	    -f $(RTL_FILE) -f $(TB_FILE)\
	    -l $(WORKSPACE)/vcs_compile.log \
	    -Mdir=$(WORKSPACE)/csrc \
	    -fsdb +define+FSDB \
		+incdir+../sourcecode/rtl/\
	    -top $(TB)
		
sim:
	$(WORKSPACE)/simv -l $(WORKSPACE)/vcs_sim.log

verdi:
	verdi -f $(RTL_FILE) -f $(TB_FILE) -ssf $(WORKSPACE)/*.fsdb -nologo &

clean:
	rm -rf $(WORKSPACE)/*.vpd $(WORKSPACE)/csrc $(WORKSPACE)/*.log $(WORKSPACE)/*.key \
	$(WORKSPACE)/*.vpd $(WORKSPACE)/*simv* $(WORKSPACE)/DVE* $(WORKSPACE)/*.conf \
	$(WORKSPACE)/*.rc $(WORKSPACE)/verdi* $(WORKSPACE)/*.fsdb
	rm -rf $(WORKSPACE)/*
.PHONY:all run com sim verdi clean pre help print_help
	







