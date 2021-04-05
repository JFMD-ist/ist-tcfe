# ---------------------------------------------------------
# type "make" command in Unix to create report.pdf 
# ---------------------------------------------------------

#list of LibreOffice Draw files
FILE=report
LODFIGS = $(patsubst %.odg,%.pdf,$(wildcard *.odg))

all: $(FILE).pdf
	evince $< &

Data.txt: ../other/t2_datagen.py
	python2 $<
	
ngspice: ngspice_1 ngspice_2 ngspice_3 ngspice_4

$(FILE).pdf: $(wildcard *.tex) $(LODFIGS) octave.log ngspice
	pdflatex  $(FILE).tex
	pdflatex  $(FILE).tex
	pdflatex  $(FILE).tex

octave.log: Data.txt
	octave ../mat/t2.m
	octave ../mat/circuit_create.m

../mat/octave.log: Data.txt
	make -C ../mat
	
ngspice_1: ngspice_1.log
	$(eval NGSTABS=$(shell grep _TAB $< | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB | grep -v $i_END | grep -v '#' | sed 's/\=/\&/g' | sed 's/$$/\\\\ \\hline/g' > $i_1_tab.tex;)
	$(foreach i, $(NGSFIGPS), ps2pdf $i;)

ngspice_1.log: ../sim/t2_1.net
	ngspice -b $< -o $@
	
ngspice_2: ngspice_2.log
	$(eval NGSTABS=$(shell grep _TAB $< | sed 's/_TAB//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(foreach i, $(NGSTABS), sed -n '/^$i_TAB/,/^$i_END/{p;/^$i_END/q}' $< | grep -v $i_TAB | grep -v $i_END | grep -v '#' | sed 's/\=/\&/g' | sed 's/$$/\\\\ \\hline/g' > $i_2_tab.tex;)
	$(foreach i, $(NGSFIGPS), ps2pdf $i;)

ngspice_2.log: ../sim/t2_2.net
	ngspice -b $< -o $@


ngspice_3: ngspice_3.log
	$(eval NGSFIGS=$(shell grep _FIG $< | sed 's/_FIG//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(eval NGSFIGPS=$(addsuffix .ps, $(NGSFIGS)))
	$(foreach i, $(NGSFIGPS), ps2pdf $i;)
	
ngspice_3.log: ../sim/t2_3.net
	ngspice -b $< -o $@
	
ngspice_4: ngspice_4.log
	$(eval NGSFIGS=$(shell grep _FIG $< | sed 's/_FIG//g' | sed ':a;N;$!ba;s/\n/ /g'))
	$(eval NGSFIGPS=$(addsuffix .ps, $(NGSFIGS)))
	$(foreach i, $(NGSFIGPS), ps2pdf $i;)
	
ngspice_4.log: ../sim/t2_4.net
	ngspice -b $< -o $@	

#convert libreoffice draw figures to pdf
%.pdf: %.odg
	soffice --headless --convert-to pdf $<

clean:
	@rm -rf *.aux *.bbl *.blg *.glg *.glo *.gls *.ilg *.ist *.lof
	@rm -rf *.log *.lot *.nlo *.nls *.out *.toc *~ *.*% ./*.pdf ./*.ps
	@rm -rf *_tab.tex octave-workspace *.eps
	@rm -rf *Ix.tex *voltages1.tex *voltages2.tex *v3_mag.tex *v3_ph.tex *Data.txt
	@rm -rf *vx.txt *t2_1.cir *t2_2.cir *t2_3.cir *t2_4.cir *currents1.tex *Vx.tex *Req.tex

.PHONY: all clean Data.txt ngspice octave
