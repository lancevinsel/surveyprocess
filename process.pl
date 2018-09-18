#!/bin/perl
#-------------------------------
# Some Global Vars
$lastweld="";
$lastjoint="";
$lasttext1="";
$lastdist="";
$lastbend="";
$jointtext1="";
$jointtext2="";
$disttext1="";
$bendtext1="";

# ====================================================================================================
#                                             Start of Main Program
# ====================================================================================================
#                                             Syntax - process ARG1
if ($#ARGV<0)
  {
    print q{
===================================================================================
|                                                                                 |
|                         Process script requires file name                       |
|                                                                                 |
|                            Syntax:  process filename                            |
|                                                                                 |
===================================================================================
  };
    exit;
  }
$filename=$ARGV[0];
$filename =~ s/\.[^.]*$//;
open(IN,$ARGV[0]);
open(OUT1,">${filename}.csv");
while (<IN>) {
    @in = split(/,/, substr(uc, 0, -1), 5); #note: the substr forces text to be uppercase; the split creates:
    $code    = $in[0];
    $station = $in[1];
    $text1   = $in[2];
    $text2   = $in[3];
    if ($code eq "WLD") {
        $lastbend="";
        if ($lastjoint) {
            $jointstation = (($station+$lastweld)/2);
            print OUT1 "JNT,$jointstation,$jointtext1,$jointtext2\n";
        }
        if ($lastdist) {
            $diststation = (($station+$lastweld)/2);
            print OUT1 "DST,$diststation,$disttext1,\n";
       }
       print OUT1 "WLD,$station,$text1,\n";
       $lastweld=$station;
    }
    if ($code eq "BND") {
        $bendtext1=$text1
        if ($lastbend) {
            $legstation = (($station+$lastbend)/2);
            print OUT1 "LEG,$legstation,,\n";
            print OUT1 "BND,$station,$bendtext1,\n;
            $lastbend=$station;
        } else {
            $legstation = (($station+$lastweld)/2);
            print OUT1 "LEG,$legstation,,\n";
            print OUT1 "BND,$station,$bendtext1,\n;
            $lastbend=$station;
        }
    }




##############Test Section
#print OUT1 "alksdf;alkdj   $pointCodes{$csplit[0]}\n";
#print OUT5 "\n\n\n\in[0] point number      = $in[0]\n";
#print OUT5 "in[4] full code & comment      = $in[4]\n";
#print OUT5 "fsplit[0] full code no comment = $fsplit[0]\n";
#print OUT5 "fsplit[1] comment              = $fsplit[1]\n";
#print OUT5 "ssplit[0] code and line no.    = $ssplit[0]\n";
#print OUT5 "ssplit[1] line code            = $ssplit[1]\n";
#print OUT5 "tok[0] line code               = $tok[0]\n";
#print OUT5 "tok[1] code, line no., comment = $tok[1]\n";
#print OUT5 "csplit[0] alpha code           = $csplit[0]\n";
#print OUT5 "csplit[1] line number          = $csplit[1]\n";
#print OUT5 "hold                           = $hold\n";
#print OUT5 "c linecode                     = $c\n";
#print OUT5 "Icode idot code, line no.      = $Icode\n\n";
 if  (exists ($bridgeCodes{$csplit[0]}))
   {
   if ($c = $idotcommands{$tok[0]})
     {
     print OUT2 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1]$fsplit[1],$c\n";
     print OUT1 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1]$fsplit[1],$c\n";
     }
   else
     {
     print OUT2 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1]$fsplit[1],\n";
     print OUT1 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1]$fsplit[1],\n";
     }
   }
 elsif (exists ($symbolCodes{$Icode}))  # Check against symbolCodes list for cells
   {
   if ($c = $idotcommands{$tok[0]})
     {
     print OUT4 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1]$fsplit[1],$c\n";
     print OUT1 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1]$fsplit[1],$c\n";
     }
   else
     {
     print OUT4 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1]$fsplit[1],\n";
     print OUT1 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1]$fsplit[1],\n";
     }
   }
 elsif (exists ($lineCodes{$Icode}))
   {
   if ($c = $idotcommands{$tok[0]})
     {
     print OUT3 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1]$fsplit[1],$c\n";
     print OUT1 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1]$fsplit[1],$c\n";
     }
   else
     {
     print OUT3 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1]$fsplit[1],\n";
     print OUT1 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1]$fsplit[1],\n";
     }
   }





####################### TEST SECTION
#print OUT5 "in[0] point number             = $in[0]\n";
#print OUT5 "Icode idot code, line no.      = $Icode\n\n\n\n\n";


 #prepare for next loop
 $jointstation="";
}
close(IN);
close(OUT1);
