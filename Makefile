VLOG	= ncverilog
SRC		= header.h \
          sync_w2r.v \
          alu.v \
          shifter.v \
          fu.v \
		  fu_t.v
SRC_S	= fifo_syn.v \
          fifo_t.v 
VLOGARG	= +access+r
CellLib = -v /theda21_2/CBDK_IC_Contest/cur/Verilog/tsmc13.v
TSCALE = +nctimescale+1ns/1ps
TMPFILE	= *.log \
		  ncverilog.key \
		  nWaveLog \
		  INCA_libs
DBFILE	= *.fsdb *.vcd *.bak *.mr *.syn *.pvl *.sdf.X novas* *.svf *~
 
RM		= -rm -rf
all :: sim
sim :
		git pull
		@if [ '$(PATTERN)' == '' ] ; then \
			echo -e '\033[31m Warning: Make sure you have load all files required.\033[0m'; \
		else \
			cp $(PATTERN) ./pattern.dat ; \
		fi
		@if [ '$(DEBUG)' == '' ] ; then \
			echo -e '\033[31m Debug Level 0. \033[0m'; \
			$(VLOG) $(SRC) $(VLOGARG); \
		else \
			$(VLOG) $(SRC) $(VLOGARG) +DEBUG=$(DEBUG); \
		fi 
syn :
		@dc_shell-t -f fifo.tcl
simg :
		@if [ '$(PATTERN)' == '' ] ; then \
			echo -e '\033[31m Warning: Make sure you have load all files required.\033[0m'; \
    	else \
       		cp $(PATTERN) ./pattern.dat ; \
		fi
		@$(VLOG) $(SRC_S) $(CellLib) $(VLOGARG) $(TSCALE) +define+SYN
clean :
		@$(RM) $(TMPFILE)
veryclean :
		@$(RM) $(TMPFILE) $(DBFILE)

