
cat bookmarks-kids.md | perl -n ./regex.pl | tee out.md

pandoc -s out.md > bookmarks-kids.html
