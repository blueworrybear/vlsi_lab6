VLOG	= ncverilog
SRC		= header.v \
          alu.v \
          shifter.v \
          fu.v \
		  fu_t.v
SRC2	= alu.v \
          shifter.v \
          barrel_shifter.v \
          datapath.v \
          fu2.v \
		  fu2_t.v  
SRC_S	= header.v \
		  fu_syn.v \
          fu_t.v
SRC2_S	= fu2_syn.v \
          fu2_t.v 
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
		@if [ '$(P)' == '' ] ; then \
			echo -e '\033[31m Warning: Make sure you have load pattern.dat.\033[0m'; \
		else \
			cp $(P) ./pattern.dat ; \
		fi
		@if [ '$(G)' == '' ] ; then \
			echo -e '\033[31m Warning: Make sure you have load gold.dat.\033[0m'; \
		else \
			cp $(G) ./gold.dat ; \
		fi
		@if [ '$(DEBUG)' == '' ] ; then \
			echo -e '\033[31m Debug Level 0. \033[0m'; \
			$(VLOG) $(SRC) $(VLOGARG); \
		else \
			$(VLOG) $(SRC) $(VLOGARG) +DEBUG=$(DEBUG); \
		fi 
sim2 :
		@if [ '$(P)' == '' ] ; then \
			echo -e '\033[31m Warning: Make sure you have load pattern.dat.\033[0m'; \
		else \
			cp $(P) ./pattern.dat ; \
		fi
		@if [ '$(G)' == '' ] ; then \
			echo -e '\033[31m Warning: Make sure you have load gold.dat.\033[0m'; \
		else \
			cp $(G) ./gold.dat ; \
		fi
		@if [ '$(DEBUG)' == '' ] ; then \
			echo -e '\033[31m Debug Level 0. \033[0m'; \
			$(VLOG) $(SRC2) $(VLOGARG); \
		else \
			$(VLOG) $(SRC2) $(VLOGARG) +DEBUG=$(DEBUG); \
		fi 
syn :
		@dc_shell-t -f fu.tcl
syn2 :
		@dc_shell-t -f fu2.tcl
simg :
		@if [ '$(P)' == '' ] ; then \
			echo -e '\033[31m Warning: Make sure you have load pattern.dat.\033[0m'; \
		else \
			cp $(P) ./pattern.dat ; \
		fi
		@if [ '$(G)' == '' ] ; then \
			echo -e '\033[31m Warning: Make sure you have load gold.dat.\033[0m'; \
		else \
			cp $(G) ./gold.dat ; \
		fi
		@$(VLOG) $(SRC_S) $(CellLib) $(VLOGARG) $(TSCALE) +define+SYN
simg2 :
		@if [ '$(P)' == '' ] ; then \
			echo -e '\033[31m Warning: Make sure you have load pattern.dat.\033[0m'; \
		else \
			cp $(P) ./pattern.dat ; \
		fi
		@if [ '$(G)' == '' ] ; then \
			echo -e '\033[31m Warning: Make sure you have load gold.dat.\033[0m'; \
		else \
			cp $(G) ./gold.dat ; \
		fi
		@$(VLOG) $(SRC2_S) $(CellLib) $(VLOGARG) $(TSCALE) +define+SYN
clean :
		@$(RM) $(TMPFILE)
veryclean :
		@$(RM) $(TMPFILE) $(DBFILE)

