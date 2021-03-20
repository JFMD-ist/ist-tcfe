# ------------------------------------------------------------
# type "make" command in the Linux terminal create report.pdf
#
# type "make clean" to delete all generated files
# ------------------------------------------------------------

all:
	sudo apt-get install -y octave-miscellaneous
	make -C doc
	cp doc/main.pdf .

clean:
	make -C doc clean

.PHONY: all clean


