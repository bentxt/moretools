chomp;
if(/^\s*-\s*([a-zA-Z0-9\.\-\:\/]+)\s*(?:\((.+)\))\s*$/){
    print "- [$2](https://$1)\n";
}elsif(/^\s*-\s*([a-zA-Z0-9\-\.\:\/]+)\s*$/){
    print "- [$1](https://$1)\n";
}elsif(/^\s*-\s*.+$/){
    die "Err: invalid link line " . $_;
}elsif(/^\s*\#+/){
    print "$_\n"
}elsif(/^\s*$/){
    print "$_\n"
}else{
    die "Err: invalid string " . $_;
}



