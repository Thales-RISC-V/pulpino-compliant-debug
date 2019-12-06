PDFDIR := ./pdfs
SRC_FILES := $(wildcard *.tex)
PDF_FILES := $(SRC_FILES:.tex=.pdf)

all: $(PDF_FILES)
	rm $(PDFDIR)/*.aux
	rm $(PDFDIR)/*.log
	rm $(PDFDIR)/*.out
	
%.pdf: %.tex
	pdflatex -output-directory=$(PDFDIR) $<
	
clean:
	rm $(PDFDIR)/*
