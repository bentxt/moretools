# 
# Create a table with alphabetic keys
#     ax: Thist is my first line 
#     ay: in this world
#
#     from | pipeline or from a file arg
#
#
#
#
# ls | perl -s Modulinos/Alphabeter.pm [ -o=output.txt]
# or:
# perl -s Modulinos/Alphabeter.pm  [-o=output.txt]  [input]
#
#die aaa => Dumper \@ARGS;

my $output_arg=$o; # when called from cli with the -s switch

package Modulinos::Alphabeter;

use strict;
use warnings;
use Data::Dumper 'Dumper';


my @alpha = qw( a b c d e f g h i k l m n o k r s t u v w );

my $alphasize = $#alpha ;

my %index;

sub alphabeter{
   my ($handle) = @_;
   
   my $alphacounter = 0;
   my (@rows, @keys, %table);

   while(<$handle>){
      chomp;
      if ($alphacounter < $alphasize){
         $rows[0] = $alphacounter++;
      }else{

         my $rowsize = scalar @rows;

         $alphacounter = 1;

         my $row_pointer = 0;
         $rows[$row_pointer] = 0;

         for ($row_pointer = 1 ; $row_pointer <= $rowsize ; $row_pointer+=1){
            if(exists $rows[$row_pointer]){
               my $rowval = $rows[$row_pointer];

               if ($rowval < $alphasize){
                  $rows[$row_pointer] = $rowval + 1;
                  last;
               }else{
                  if ($row_pointer == $rowsize){
                     $rows[$row_pointer] = 0 ;
                     push @rows, 0 ;
                     last;
                  }
               }
            }else{
               push @rows, 0 ;
               last;
            }
         }
      }
   my ($key) = join('' , map { $alpha[$_] } reverse @rows);
   push @keys, $key;
   $table{$key} = $_;
   }
   return (\@keys, \%table);
}

sub main {


   my ($keys, $table) ; 
   
   if(@ARGV){
      my ($filename) = @ARGV;

      open (my $fh, '<', $filename) 
         || die "Err: not a valid file for $filename";

      ($keys, $table) = alphabeter($fh);
      close $fh;
   }else{                                            # is part of a | pipeline
      ($keys, $table) = alphabeter(\*STDIN); 
   }

      
   if($output_arg){
      open (my $ofh, '>', $output_arg) 
         || die "Err: not a valid outfile for $output_arg";
      foreach(@$keys){
         print $ofh "$table->{$_}\n";
         print STDOUT $_ . ": $table->{$_}\n";
      }
   }else{
      foreach(@$keys){
         print STDOUT $_ . ": $table->{$_}\n";
         #print STDERR $_ . ": $table->{$_}\n";
      }
   }
}

main() if not caller();

1;
