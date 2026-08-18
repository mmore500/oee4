SHELL=/bin/bash

# get the basename of the containing directory
# this will be used to name the output document
BUILD_DIR := oee4

all: ${BUILD_DIR}-draft.pdf

draft: ${BUILD_DIR}-draft.pdf

release: ${BUILD_DIR}.pdf

${BUILD_DIR}.pdf: main.tex
	latexmk -pdf -interaction=nonstopmode -file-line-error -g \
    -jobname=${BUILD_DIR} \
    -usepretex='\def\nofake{}\def\nodraft{}' \
    main.tex

${BUILD_DIR}-draft.pdf: main.tex
	latexmk -pdf -interaction=nonstopmode -file-line-error -g \
    -jobname=${BUILD_DIR}-draft \
    -usepretex='\def\nofake{}' \
    main.tex

fresh: clean all

fresher: cleaner all

clean:
	rm -f ${BUILD_DIR}.pdf
	rm -f ${BUILD_DIR}-draft.pdf

sview:
	xdg-open ${BUILD_DIR}-draft.pdf 2>/dev/null

cleaner: clean
	latexmk -CA
	# remove auxillary files, excepting .tex and .bib files
	find . -type f -name ${BUILD_DIR}"*" ! -name '*.tex' ! -name '*.bib' -delete
	rm -rf *.bbl *.blg *.aux

.PHONY: all draft release clean sview cleaner fresh fresher
