FILENAME=thesis
SOURCENAME=source
OUTPUTNAME=output

default: preview

compile:
	lhs2TeX -o $(FILENAME).tex $(SOURCENAME).lagda --agda
	pydflatex $(FILENAME).tex
	bibtex $(FILENAME)
	pydflatex $(FILENAME).tex
	pydflatex $(FILENAME).tex
	mv $(FILENAME).pdf $(OUTPUTNAME).pdf

open:
	open $(OUTPUTNAME).pdf

clean:
	rm $(FILENAME).*
	rm symbols/*-converted-to.pdf

preview: compile open clean
