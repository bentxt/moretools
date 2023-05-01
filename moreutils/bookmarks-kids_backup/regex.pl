chomp;
if(/^\s*-\s*([a-zA-Z0-9\-\.\:\/]+)\s*(\(.*\))$/){
    print "- [$1]$2\n";
}elsif(/^\s*-\s*([a-zA-Z0-9\-\.\:\/]+)\s*$/){
    print "- [$1]($1)\n";
}elsif(/^\s*-\s*.+$/){
    die "Err: invalid link line " . $_;
}elsif(/^\s*\#+/){
    print "$_\n"
}elsif(/^\s*$/){
    print "$_\n"
}else{
    die "Err: invalid string " . $_;
}



