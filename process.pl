#!/bin/perl
#-------------------------------
# Some Global Vars
$bendtext1="";
$diststation="";
$disttext1="";
$jointstation="";
$jointtext1="";
$jointtext2="";
$lastbend="";
$lastdist="";
$lastjoint="";
$lasttext1="";
$lastweld="";
$legstation="";

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
#                    print OUT1 "READ code is                             $code\n";
#                    print OUT1 "READ station is                          $station\n";
#                    print OUT1 "READ text1 is                            $text1\n";
#                    print OUT1 "READ text2 is                            $text2\n";

    if ($code eq "JNT") {
        $jointtext1=$text1;
#                    print OUT1 "IF JNT jointtext1                         $jointtext1\n";
        $jointtext2=$text2;
#                    print OUT1 "IF JNT jointtext2                         $jointtext2\n";
    }
    if ($code eq "DST") {
        $disttext1=$text1;
#                    print OUT1 "IF DST disttext1                         $disttext1\n";
    }
    if ($code eq "WLD") {
	if ($lastbend) {
            $legstation = (($station+$lastbend)/2);
                    print OUT1 "LEG,$legstation,,\n";
	}
        $lastbend="";
#                    print OUT1 "IF WLD lastbend                         $lastbend\n";
#                    print OUT1 "IF WLD lastjoint                        $lastjoint\n";
        if ($lastjoint) {
            $jointstation = (($station+$lastweld)/2);
#                    print OUT1 "IF WLD jointstation                     $jointstation\n";
            print OUT1 "JNT,$jointstation,$jointtext1,$jointtext2\n";
        }
	$lastjoint=$text1;
        if ($lastdist) {
            $diststation = (($station+$lastweld)/2);
            print OUT1 "DST,$diststation,$disttext1,\n";
       }
       $lastdist=$text1;
       print OUT1 "WLD,$station,$text1,\n";
       $lastweld=$station;
    }
    if ($code eq "BND") {
        $bendtext1=$text1;
        if ($lastbend) {
            $legstation = (($station+$lastbend)/2);
            print OUT1 "LEG,$legstation,,\n";
            print OUT1 "BND,$station,$bendtext1,\n";
        } else {
            $legstation = (($station+$lastweld)/2);
            print OUT1 "LEG,$legstation,,\n";
            print OUT1 "BND,$station,$bendtext1,\n";
        }
        $lastbend=$station;
    }
    #-------------------Test Area    
    # print OUT1 "Status code                                          $code\n";
    # print OUT1 "Status station                                       $station\n";
    # print OUT1 "Status text1                                         $text1\n";
    # print OUT1 "Status text2                                         $text2\n";
    # print OUT1 "Status bendtext1                                     $bendtext1\n";
    # print OUT1 "Status diststation                                   $diststation\n";
    # print OUT1 "Status disttext1                                     $disttext1\n";
    # print OUT1 "Status jointstation                                  $jointstation\n";
    # print OUT1 "Status jointtext1                                    $jointtext1\n";
    # print OUT1 "Status jointtext2                                    $jointtext2\n";
    # print OUT1 "Status lastbend                                      $lastbend\n";
    # print OUT1 "Status lastdist                                      $lastdist\n";
    # print OUT1 "Status lastjoint                                     $lastjoint\n";
    # print OUT1 "Status lasttext1                                     $lasttext1\n";
    # print OUT1 "Status lastweld                                      $lastweld\n";
    # print OUT1 "Status legstation                                    $legstation\n";

#-----------------prepare for next loop
 $jointstation="";
}
close(IN);
close(OUT1);
