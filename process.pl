#!/bin/perl
#
use strict;
use warnings;
#-------------------------------
# Some Global Vars
my $bendtext2="";
my $diststation="";
my $disttext2="";
my $jointstation="";
my $jointtext1="";
my $jointtext2="";
my $lastbend="";
my $lastdist="";
my $lastjoint="";
my $lastweld="";
my $legstation="";
#
# ====================================================================================================
#                                             Start of Main Program
# ====================================================================================================
#                                             Syntax - process ARG1
if ($#ARGV<0) {
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
my $filename=$ARGV[0];
$filename =~ s/\.[^.]*$//;
open(IN,$ARGV[0]);
open(OUT1,">${filename}.csv");
while (<IN>) {
	my @in = split(/,/, substr(uc, 0, -1), 5); #note: the substr forces text to be uppercase; the split creates:
	my $code    = $in[0];
	my $station = $in[1];
	my $text1   = $in[2];
	my $text2   = $in[3];
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
		$disttext2=$text2;
#                    print OUT1 "IF DST disttext2                         $disttext2\n";
	}
	if ($code eq "WLD") {
		if ($lastbend) {
			$legstation = (($station+$lastbend)/2);
			print OUT1 "LEG,$legstation,,,0\n";
			if ($lastjoint) {
				$jointstation = (($station+$lastweld)/2);
				if ($disttext2 > 25) {
					print OUT1 "JN2,$jointstation,$jointtext1,$jointtext2,0\n";
				} else {
					print OUT1 "JN3,$jointstation,$jointtext1,$jointtext2,0\n";
				}
			}
			if ($lastdist) {
				$diststation = (($station+$lastweld)/2);
				if ($disttext2 > 25) {
					print OUT1 "DST,$diststation,,$disttext2,0\n";
				} else {
					print OUT1 "DS2,$diststation,,$disttext2,0\n";
				}
			}
		} else {
			if ($lastjoint) {
				$jointstation = (($station+$lastweld)/2);
				if ($disttext2 > 25) {
					print OUT1 "JNT,$jointstation,$jointtext1,$jointtext2,0\n";
				} else {
					print OUT1 "JN3,$jointstation,$jointtext1,$jointtext2,0\n";
				}
			}
			if ($lastdist) {
				$diststation = (($station+$lastweld)/2);
				if ($disttext2 > 25) {
				print OUT1 "DST,$diststation,,$disttext2,0\n";
				} else {
				print OUT1 "DS2,$diststation,,$disttext2,0\n";
				}
			}
		}
		$lastjoint=$text1;
		$lastdist=$text1;
		$lastbend="";
		print OUT1 "WLD,$station,$text1,,0\n";
		$lastweld=$station;
	}
	if ($code eq "BND") {
		$bendtext2=$text2;
		if ($lastbend) {
			$legstation = (($station+$lastbend)/2);
			print OUT1 "LEG,$legstation,,,0\n";
			print OUT1 "BND,$station,,$bendtext2,0\n";
		} else {
			$legstation = (($station+$lastweld)/2);
			print OUT1 "LEG,$legstation,,,0\n";
			print OUT1 "BND,$station,,$bendtext2,0\n";
		}
		$lastbend=$station;
	}
#-------------------Test Area    
# print OUT1 "Status code                                          $code\n";
# print OUT1 "Status station                                       $station\n";
# print OUT1 "Status text1                                         $text1\n";
# print OUT1 "Status text2                                         $text2\n";
# print OUT1 "Status bendtext2                                     $bendtext2\n";
# print OUT1 "Status diststation                                   $diststation\n";
# print OUT1 "Status disttext2                                     $disttext2\n";
# print OUT1 "Status jointstation                                  $jointstation\n";
# print OUT1 "Status jointtext1                                    $jointtext1\n";
# print OUT1 "Status jointtext2                                    $jointtext2\n";
# print OUT1 "Status lastbend                                      $lastbend\n";
# print OUT1 "Status lastdist                                      $lastdist\n";
# print OUT1 "Status lastjoint                                     $lastjoint\n";
# print OUT1 "Status lastweld                                      $lastweld\n";
# print OUT1 "Status legstation                                    $legstation\n";

#-----------------prepare for next loop
	$jointstation="";
}
close(IN);
close(OUT1);
