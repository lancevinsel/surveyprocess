#!/bin/perl
%pointCodes = (  # ABC -> 123
 #"XXX" => "XXX",
 "ACU" => "282", # Air Conditioning Unit
 "AEM" => "930", # AG Electric Main
 #"AGE" => "674", # Shoulder Aggregate Edge
 "B62" => "516", # Curb B6-24 Top Back - depreciated
 "B6B" => "509", # Curb B6-12 Top Back - depreciated
 "B6F" => "510" # Curb B6-12 Flowline #deleted v6 # added back v15 - depreciated
 );

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
            $jointstation = (($station+$lastweld)/2)
            print OUT1 "JNT,$jointstation,$jointtext1,$jointtext2\n";
        }
        if ($lastdist) {
            $diststation = (($station+$lastweld)/2)
            print OUT1 "DST,$diststation,$disttext1,\n";
       }
       print OUT1 "WLD,$station,$text1,\n";
    }




 my @fsplit = split(/\s+/,$in[4],2); #added lv - this separates the Codes from the Comments
   #using the first whitespace as the separator so:
   #$fsplit[0] = 3 Letter Code-Line Number-Line Code
   #$fsplit[1] = the Comment
 my @ssplit = ($fsplit[0] =~ /(\w+)*(\W*)/); #added lv - this separtes the 3 Letter Code and
   # line number from the line coding symbol
   # \w is alpha or numeric - \W is non alpha or numeric:
   # $ssplit[0] = the 3 Letter Code and Line Number
   # $ssplit[1] = the Line Code
 $tok[0] = $ssplit[1]; #added lv:
   # $tok[0} = the Line Code
 $tok[1] = "$ssplit[0] $fsplit[1]"; #added lv:
   # $tok[1] = the code and the comment, no line code
 my @csplit = ($ssplit[0] =~ /(\w\w\w)(\d*)/); # this is for QAQC
   # $csplit[0] = 3 letter code
   # $csplit[1] = line number
 if (length($fsplit[1])>0) {##############lv
  $fsplit[1]="\;$fsplit[1]"; ########lv - adds the semi-colon before the Comment
 }
 $Icode=$pointCodes{$csplit[0]}; ## if the three letter code matches any of the codes

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
        #####################
        #Material type prefix
        if  (exists ($typePrefix{$csplit[0]})) {
          $prefix = $typePrefix{$csplit[0]};
          $csplit[1] = "$prefix$csplit[1]";
 }
 ########################################
 #NoLine fix
 if  (exists ($noLine{$csplit[0]})) {
          $csplit[1] = $noLineCounter;
          $noLineCounter = $noLineCounter + 1;
 }
 ########################################Begin sorting and printing
 #################################################
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
