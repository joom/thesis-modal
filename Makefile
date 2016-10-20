FILENAME=thesis

default: preview

compile:
	lhs2TeX -o $(FILENAME).tex $(FILENAME).lagda --agda
	pdflatex $(FILENAME).tex
	bibtex $(FILENAME)
	pdflatex $(FILENAME).tex
	pdflatex $(FILENAME).tex

open:
	open $(FILENAME).pdf

preview: compile open
