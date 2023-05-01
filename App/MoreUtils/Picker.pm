package Modulinos::Picker;

use strict;
use warnings;
use Data::Dumper 'Dumper';

use Modulinos::Alphabeter;

use File::Temp qw(tempfile);

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

sub check_tokenstring {
   my ($tokenstring) = @_;

   my ($starttoken, $endtoken, @selection);
   if($tokenstring){
      die "Err: invalid chars in token $tokenstring" if ($tokenstring =~ /[^a-z\s\-\.\,]/);

      if ($tokenstring =~ /\-/){
         die "Err: invalid chars in token $tokenstring no range and selects please" 
            if ($tokenstring =~ /\,/);
         my @range  = map { trim($_) } split(/\-/,$tokenstring);
         ($starttoken, $endtoken) = (@range == 2) 
            ? @range 
            : die "Err: invalid range";
      }elsif ($tokenstring =~ /\,/){
         die "Err: invalid chars in token $tokenstring no range and selects please" 
            if ($tokenstring =~ /\-|\./);
         (@selection) = map { trim($_) } split(/\,/,$tokenstring);
      }else{
         $starttoken = $tokenstring;
      }
   }
   return  ($starttoken, $endtoken, \@selection);
}


sub writeall {
   die 'todo writeall'
}

sub readsingle{
   my ($keys, $matchtoken) = @_;

   return first { $_ eq $matchtoken } @$keys;
}

sub readrange_start_end {
   my ($keys, $starttoken, $endtoken) = @_;

   my ($start, $end, @keylist);

   foreach my $key (@$keys){
         if($start){
            push @keylist, $key;
            if($key eq $endtoken){ $end = 1; last; }
         }else{
            if($key eq $starttoken){
               push @keylist, $key;
               $start = 1 
            }elsif($key eq $endtoken){
               die "Err: no start token"
            }
         }
   }
   if($start){
      die "Err: no end detected" unless ($end);
   }else{
      if ($end){
         die "Err: no start detected but an $end"
      }else{
         die "Err: no start detected but an $end"
      }
   }
   return \@keylist;
}

sub readrange_start {
   my ($keys, $starttoken) = @_;

   my ($start, @keylist);

   foreach my $key (@$keys){
      if($start){
         push @keylist, $keys;
      }else{
         if($key eq $starttoken){
            push @keylist, $key;
            $start = 1 
         }
      }
   }

   return ($start)
      ? \@keylist
      : die "Err: no start detected" ;
}

sub readrange_end {
   my ($keys, $endtoken) = @_;

   my ($end, @keylist);

   foreach my $key (@$keys){
      push @keylist, $key;
      if($key eq $endtoken){ 
         $end = 1 ; last; 
      }else{
         push @keylist , $key;
      }
   }
   return ($end)
      ? \@keylist
      : die "Err: no end detected" ;
}


sub get_selection {
   my ($lines, $selection) = @_;

   my %table;
   foreach my $line (@$lines){
      if($line =~ /^([a-z]+)\:\s+(.*)/){
         $table{$1} = $2;
      }else{
         die "Err: parsing errror in line $line"
      }
   }
   my @out; 
   foreach my $key (@$selection){
      if(exists $table{$key}){
         push @out, $table{$key}
      }else{
         die "Err: cannot find key $key";
      }
   }
   return \@out;
}


sub get_range {
   my ($keys, $starttoken, $endtoken) = @_;

   die "Err: no starttoken " unless $starttoken;

   my @out;
   if($endtoken){
      if($starttoken eq '.'){
         if($endtoken eq '.'){
            (@out) = readrange_all($keys);
         }else{
            (@out) = readrange_end($keys, $endtoken);
         }
      }else{
         if($endtoken eq '.'){
            (@out) = readrange_start($keys, $starttoken);
         }else{
            (@out) = readrange_start_end($keys, $starttoken, $endtoken);
         }
      }
   }else{
      (@out) = readsingle($keys, $starttoken);
   }

}

sub picker {
   my ($keys, $table, $tokentriple) = @_;

   my ($starttoken, $endtoken, $selection);  
   if($tokentriple){
      ($starttoken, $endtoken, $selection) = (@$tokentriple)
   }else{
      die 'fffff' . Dumper $keys;
   }
}


sub main {

   my ($tokenstring);

   if(@ARGV){
      my ($filename, $tokenstring) = @ARGV;
      die "usage filename token " unless $filename;

      open (my $fh, '<', $filename) || die "Err: not a valid file for $filename";
      my ($keys, $table) = Modulinos::Alphabeter::alphabeter($fh);
      die xxxxx => Dumper $keys;
      #my @lines = <$fh>;
      #while (my $line = <$fh>){
      #if($line =~ /^([a-z]+)\:\s+(.*)$/){
      #}else{
      #die "Err: parsing errror in line $line"
      #}
      #die llll => Dumper \@lines;
      #close $fh;
      #($keys, $table) = Modulinos::Alphabeter::alphabeter($fh);
   }else{
      my ($keys, $table) = Modulinos::Alphabeter::alphabeter(\*STDIN);
      #while(<STDIN>){
      #chomp;
      #push @lines, $_
      #}
      #close STDIN;
   }
}

main() if not caller();
__END__


   return ($tokenstring) 
      ? picker ($keys, $table, [ check_tokenstring($tokenstring ) ])
      : picker ($keys, $table);


   #foreach(@$keys){
   #   print STDERR $_ . ": $table->{$_}\n";
   #}
   #print $outfh $string . ": $_\n";

   #$index{$string} = $_;
}

main() if not caller();

1;

#my ($outfh, $outfile )= tempfile();
#my ($string) = join("\n", @out);
#print STDERR $string;
#print $outfh $string;
#print STDERR "\n";
#print $outfile;

