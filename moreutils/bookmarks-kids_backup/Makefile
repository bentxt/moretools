.PHONY: build clean

clean
	rm -f out.*
	rm -f *.html

out.md:
	cat bookmarks-kids.md | perl -n ./regex.pl | tee out.md

build: out.md
	pandoc -s out.md > bookmarks-kids.html
