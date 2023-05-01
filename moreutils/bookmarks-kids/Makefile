.PHONY: build clean

build: out.md
	pandoc  -T 'Bookmarks Kids' -s out.md > bookmarks-kids.html

out.md:
	cat bookmarks-kids.md | perl -n ./regex.pl | tee out.md


clean:
	rm -f out.*
	rm -f *.html

