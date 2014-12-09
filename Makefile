VLOG	= ncverilog
MEM   = MEM/RA2SH.v
SRC		= sync_r2w.v \
        sync_w2r.v \
        rptr_empty.v \
        wptr_full.v \
        fifo.v \
		  	fifo_t.v
SRC2		= sync_r2w.v \
        sync_w2r.v \
        rptr_empty.v \
        wptr_full.v \
        fifo.v \
		lab06_t.v
SRC_S	= fifo_syn.v \
		    fifo_t.v 
VLOGARG	= +access+r
CellLib = -v /theda21_2/CBDK_IC_Contest/cur/Verilog/tsmc13.v
TSCALE = +nctimescale+1ns/1ps

TMPFILE	= *.log \
		  ncverilog.key \
		  nWaveLog \
		  INCA_libs \
      *.dat \
      header.v

DBFILE	= *.fsdb *.vcd *.bak *.mr *.syn *.pvl *.sdf.X novas* *.svf *~
 
RM		= -rm -rf
all :: sim
sim :
		@if [ '$(PATTERN)' == '' ] ; then \
			echo -e '\033[31m Warning: Make sure you have load all files required.\033[0m'; \
		else \
			cp $(PATTERN)* ./ ; \
		fi
		@if [ '$(DEBUG)' == '' ] ; then \
			echo -e '\033[31m Debug Level 0. \033[0m'; \
			$(VLOG) header.v $(MEM) $(SRC) $(VLOGARG) +define+PATTERN=$(PATTERN); \
		else \
			$(VLOG) header.v $(MEM) $(SRC) $(VLOGARG) +define+PATTERN=$(PATTERN) +DEBUG=$(DEBUG); \
		fi 
sim2 : 
			$(VLOG) header.v $(MEM) $(SRC2) $(VLOGARG)
syn :
		@if [ '$(PATTERN)' == '' ] ; then \
			echo -e '\033[31m Warning: Make sure you have load all files required.\033[0m'; \
    	else \
       		cp $(PATTERN)* ./ ; \
		fi
		@dc_shell-t -f fifo.tcl
simg :
		@if [ '$(PATTERN)' == '' ] ; then \
			echo -e '\033[31m Warning: Make sure you have load all files required.\033[0m'; \
    	else \
       		cp $(PATTERN)* ./ ; \
		fi
		@$(VLOG) header.v $(MEM) $(SRC_S) $(CellLib) $(VLOGARG) $(TSCALE) +define+SYN
clean :
		@$(RM) $(TMPFILE)
veryclean :
		@$(RM) $(TMPFILE) $(DBFILE)

