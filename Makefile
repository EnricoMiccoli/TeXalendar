.PHONY: clean

weeks.tex: gencal.py
	python3 gencal.py

cal.pdf: calendar.cls cal.tex weeks.tex gencal.py
	xelatex cal.tex

halved.pdf: cal.pdf
	mutool poster -x 2 cal.pdf halved.pdf

padded.pdf: halved.pdf padder.tex
	pdflatex padder.tex
	mv padder.pdf padded.pdf

inclusions.tex: geninclude.py
	python3 geninclude.py

imposition.pdf: padded.pdf imposer.tex inclusions.tex
	pdflatex imposer.tex
	mv imposer.pdf imposition.pdf

clean:
	rm -f *.aux *.log *.pdf weeks.tex inclusions.tex
