use strict;
use warnings;

use lib 'C:\git-repos\surveyprocess\modules';

use commentLists;
use flagCodes;
use mainCodes;
use liningCodes;
use noLineList;
# Some Vars
my $fullCode="";
my $fullComment="";
my $lineCode="";
my $liningSymbol="";
my $IDOTlineSymbol="";
my $ACADlineSymbol="";
$figname="";
$curPtNum="";
$lastPtNum="";
$lastFigname="";
%activeStrings=();
$lastWasString=0;
$comment=""; #lv added
$Icode=""; #lv added (Process01)
$hold = "";
$noLineCounter=1;


# ==============================================================================================
#                                   Start of Main Program
# ==============================================================================================
#                                   Syntax - process ARGV
# @ARGV is a special array containing the items listed after the command on the command line
# Test to make sure that a filename was listed after the command 'checkin'
if ($#ARGV<0) {
	print q{
==============================================================================
|                                                                            |
|                     Process script requires file name                      |
|                                                                            |
|                        Syntax:  process filename                           |
|                                                                            |
==============================================================================

};
	exit;
}
# $ARGV[0] is the first item following the command - in our case the filename to be processed
$filename=$ARGV[0];
	# print OUT "filename with extension	= $filename\n";
# This next line removes the extension (normally .txt) from the entered filename
$filename =~ s/\.[^.]*$//;
	# print OUT "filename without extension	= $filename\n";
# This opens the file for reading
open(IN,$ARGV[0]);
# This opens the file for writing
open(OUT,">${filename}_all.cor");
# begin the loop - read in the lines one by one and evaluate to the end
while (<IN>) {
	@in = split(/,/, substr(uc, 0, -1), 5); # the substr forces text to be uppercase
	# the split creates:
		# $in[0] = point number
		# $in[1] = northing
		# $in[2] = easting
		# $in[3] = elevation
		# $in[4] = fieldCode (3 Letter Code-Line Number-Line Code-Comments)
###############


	my @codeCommentSplit = split(/\s+/,$in[4],2); # this separates the fullCode from the fullComment
		# using the first whitespace as the separator.
		# print OUT "codeCommentSplit[0] 	= $codeCommentSplit[0]\n";
		# print OUT "codeCommentSplit[1] 	= $codeCommentSplit[1]\n";
	$fullCode = $codeCommentSplit[0];
		# print OUT "fullCode		= $fullCode\n";
	$fullComment = $codeCommentSplit[1];
		# print OUT "fullComment		= $fullComment\n";
	my @fullCodeSplit = ($fullCode =~ /(\w+)*(\W+)/); # this separates the 3 character MPSCode and
		# line number from the line coding symbol liningSymbol;
		# \w is alpha or numeric - \W is non alpha or numeric
		# print OUT "fullCodeSplit[0]	= $fullCodeSplit[0]\n";
		# print OUT "fullCodeSplit[1]	= $fullCodeSplit[1]\n";
	$lineCode = $fullCodeSplit[0];
		# print OUT "lineCode		= $lineCode\n";
	$liningSymbol = $fullCodeSplit[1];
		# print OUT "liningSymbol		= $liningSymbol\n";
	if ($liningSymbol) { # This checks for a lining symbol
		my $combinedLineSymbol = ($liningCodes::lineSymbols{$liningSymbol});
		 print OUT "combinedLineSymbol		= $combinedLineSymbol\n";
		my @separateLineSymbol = split(/\s+/,$combinedLineSymbol,2); # this separates
		# the IDOTlineSymbol from the ACADlineSymbol 
		 print OUT "separateLineSymbol[0]	= $separateLineSymbol[0]\n";
		 print OUT "separateLineSymbol[1]	= $separateLineSymbol[1]\n";
		$IDOTlineSymbol = $separateLineSymbol[0];
		 print OUT "IDOTlineSymbol		= $IDOTlineSymbol\n";
		$ACADlineSymbol = $separateLineSymbol[1];
		 print OUT "ACADlineSymbol		= $ACADlineSymbol\n";
		} else {
		$IDOTlineSymbol = "";
		 print OUT "IDOTlineSymbol		= $IDOTlineSymbol\n";
		$ACADlineSymbol = "";
		 print OUT "ACADlineSymbol		= $ACADlineSymbol\n";
#			# print OUT "liningSymbol		= This lining symbol \"$liningSymbol\" is ILLEGAL!!!!\n";
#		}
#	} else {
#		$lineCode = $fullCode;
#		$liningSymbol = "";
#	}
#		# print OUT "lineCode		= $lineCode\n";
#		# print OUT "liningSymbol		= $liningSymbol\n";
	my @lineNumberSplit = ($lineCode =~ /(\w\w\w)(\d*)/); # this separates the MPScode from the line number
		# print OUT "lineNumberSplit[0]	= $lineNumberSplit[0]\n";
		# print OUT "lineNumberSplit[1]	= $lineNumberSplit[1]\n";
	$MPScode = $lineNumberSplit[0];
		# print OUT "MPScode			= $MPScode\n";
	$lineNumber = $lineNumberSplit[1];
		# print OUT "lineNumber		= $lineNumber\n";



		######33333333333333333333

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
# if (length($fsplit[1])>0) {##############lv
#  $fsplit[1]="\;$fsplit[1]"; ########lv - adds the semi-colon before the Comment
# }
 $Icode=$pointCodes{$csplit[0]}; ## if the three letter code matches any of the codes

##############Test Section
##print OUT1 "alksdf;alkdj   $pointCodes{$csplit[0]}\n";
#print OUT1 "\n\n\n\in[0] point number      = $in[0]\n";
#print OUT1 "in[4] full code & comment      = $in[4]\n";
#print OUT1 "fsplit[0] full code no comment = $fsplit[0]\n";
#print OUT1 "fsplit[1] comment              = $fsplit[1]\n";
#print OUT1 "ssplit[0] code and line no.    = $ssplit[0]\n";
#print OUT1 "ssplit[1] line code            = $ssplit[1]\n";
#print OUT1 "tok[0] line code               = $tok[0]\n";
#print OUT1 "tok[1] code, line no., comment = $tok[1]\n";
#print OUT1 "csplit[0] alpha code           = $csplit[0]\n";
#print OUT1 "csplit[1] line number          = $csplit[1]\n";
##print OUT1 "hold                           = $hold\n";
##print OUT1 "c linecode                     = $c\n";
#print OUT1 "Icode idot code, line no.      = $Icode\n\n";
        #####################
        #Material type prefix
        if  (exists ($typePrefix{$csplit[0]})) {
          $prefix = $typePrefix{$csplit[0]};
          $csplit[1] = "$prefix$csplit[1]";
 }
# ########################################
# #NoLine fix
# if  (exists ($noLine{$csplit[0]})) {
#          $csplit[1] = $noLineCounter;
#          $noLineCounter = $noLineCounter + 1;
# }
 ########################################Begin sorting and printing
 #################################################
 if  (exists ($bridgeCodes{$csplit[0]}))
   {
   if ($c = $idotcommands{$tok[0]})
     {
     print OUT2 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1] $c $fsplit[1]\n";
     print OUT1 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1] $c $fsplit[1]\n";
     }
   else
     {
     print OUT2 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1] $fsplit[1]\n";
     print OUT1 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1] $fsplit[1]\n";
     }
   }
 elsif (exists ($symbolCodes{$Icode}))  # Check against symbolCodes list for cells
   {
   if ($c = $idotcommands{$tok[0]})
     {
     print OUT4 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1] $c $fsplit[1]\n";
     print OUT1 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1] $c $fsplit[1]\n";
     }
   else
     {
     print OUT4 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1] $fsplit[1]\n";
     print OUT1 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1] $fsplit[1]\n";
     }
   }
 elsif (exists ($lineCodes{$Icode}))
   {
   if ($c = $idotcommands{$tok[0]})
     {
     print OUT3 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1] $c $fsplit[1]\n";
     print OUT1 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1] $c $fsplit[1]\n";
     }
   else
     {
     print OUT3 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1] $fsplit[1]\n";
     print OUT1 "$in[0],$in[1],$in[2],$in[3],$Icode$csplit[1] $fsplit[1]\n";
     }
   }





####################### TEST SECTION
#print OUT5 "in[0] point number             = $in[0]\n";
#print OUT5 "in[1] northing                 = $in[1]\n";
#print OUT5 "in[2] easting                  = $in[2]\n";
#print OUT5 "in[3] elevation                = $in[3]\n";
#print OUT5 "in[4] full code & comment      = $in[4]\n";
#print OUT5 "fsplit[0] full code no comment = $fsplit[0]\n";
#print OUT5 "fsplit[1] comment              = $fsplit[1]\n";
#print OUT5 "ssplit[0] code and line no.    = $ssplit[0]\n";
#print OUT5 "ssplit[1] line code            = $ssplit[1]\n";
#print OUT5 "tok[0] line code               = $tok[0]\n";
#print OUT5 "tok[1] code, line no., comment = $tok[1]\n";
#print OUT5 "csplit[0] alpha code           = $csplit[0]\n";
#print OUT5 "csplit[1] line number          = $csplit[1]\n";
#print OUT1 "hold                           = $hold\n";
#print OUT5 "c linecode                     = $c\n";
#print OUT5 "Icode idot code, line no.      = $Icode\n\n\n\n\n";


 #prepare for next loop
 $lastFigname=$figname;
 $lastPtNum=$in[0];
 $figname="";
 $comment="";  #### added lv
 $Icode="";
 $prefix="";


 $fsplit[0]="";
 $fsplit[1]="";
 $ssplit[0]="";
 $ssplit[1]="";
 $tok[0]="";
 $tok[1]="";
 $csplit[0]="";
 $csplit[1]="";


}
close(IN);
close(OUT1);
close(OUT2);
close(OUT3);
close(OUT4);
close(OUT5);
close(OUT6);
