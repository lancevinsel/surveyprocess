use strict;
use warnings;

use lib 'C:\git-repos\surveyprocess\modules';

use commentLists;
use flagCodes;
use mainCodes;
use liningCodes;
use miscCodes;

# Some Variables
my $illegalCodeCount=0;
my $illegalLiningSymbolCount=0;
my $controlPointCount=0;
my $IDOTtext="";
my $lastPtNum="";
my %activeStrings=();
my $curIsString=0;
my $lastWasString=0;
my $finalComment="";
my $globalcomment="";
my $aflag = "XXXalphaXXX";
my $codeFlag = ".-|-??? What Code Is This, eh ???-|-.";
my $_nextAutogenPtNua=0;
my $multiCodeDelimiter="";
my $textComment="";
my $numericComment="";
my $fullComment="";
my $liningSymbol="";
my $lineNumber=0;
my $MPScode="";
my $lineCode="";
my $fullCode="";
my $filename="";
my @in="";
my $possibleMiscCode="";
my $C2="";
my $mComment="";
my $mcomment="";
my $C3="";
my $C4="";
my $linecode="";
my $checkInCode="";
my $commentFlag="";
my $commentText="";
my $requiredComments="";
# 
# 
# Start of Main Program
# 
#
# Test to make sure that a filename was listed after the command 'checkin'
if ($#ARGV<0) {
	die "\nHey you forgot the file name, Jeez! \n\nSyntax:\ncheckin <input file name>\n";
}
# @ARGV is a special array containing the items listed after the command on the command line
# $ARGV[0] is the first item following the command - in our case the filename to be processed
$filename=$ARGV[0];
	# print OUT "filename with extension	= $filename\n";
# This next line removes the extension (normally .txt) from the entered filename
$filename =~ s/\.[^.]*$//;
	# print OUT "filename without extension	= $filename\n";
# This opens the file for reading
open(IN,$ARGV[0]);
# This open the output file for writing
open(OUT,">${filename}.csv");
# eliminate specific warnings - this is needed to prevent error messages in this code 
{
	no warnings 'uninitialized';
	no warnings 'once';
# begin the loop - read in the lines one by one and evaluate to the end
while (<IN>) {
	@in = split(/,/, substr(uc, 0, -1), 5); # forces text to be uppercase
# 
# FUTURE FEATURE?
# need to parse the fullComment for:
# multiCodeDelimiter
# 
# print OUT "\n";
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
		if ($liningCodes::lineSymbols{$liningSymbol}) {
			# print OUT "liningSymbol		= This lining symbol \"$liningSymbol\" is OK\n";
		} else {
			$illegalLiningSymbolCount++;
			# print OUT "liningSymbol		= This lining symbol \"$liningSymbol\" is ILLEGAL!!!!\n";
		}
	} else {
		$lineCode = $fullCode;
		$liningSymbol = "";
	}
		# print OUT "lineCode		= $lineCode\n";
		# print OUT "liningSymbol		= $liningSymbol\n";
	my @lineNumberSplit = ($lineCode =~ /(\w\w\w)(\d*)/); # this separates the MPScode from the line number
		# print OUT "lineNumberSplit[0]	= $lineNumberSplit[0]\n";
		# print OUT "lineNumberSplit[1]	= $lineNumberSplit[1]\n";
	$MPScode = $lineNumberSplit[0];
		# print OUT "MPScode			= $MPScode\n";
	$lineNumber = $lineNumberSplit[1];
		# print OUT "lineNumber		= $lineNumber\n";
	if ($mainCodes::legalCodes{$MPScode}) {
		#print OUT "MPScode check		= $MPScode is a legal code\n";
	} else {
		$illegalCodeCount++;
		$commentFlag = $codeFlag;
		#print OUT "MPScode check		= $MPScode is an ILLEGAL CODE!!!!! DAMN!!\n";
	}
	my @fullCommentSplit = (split(/\s+/,$fullComment,2)); # This separates the full code by the first
		# whitespace
		# print OUT "fullCommentSplit[0]	= $fullCommentSplit[0]\n";
		# print OUT "fullCommentSplit[1]	= $fullCommentSplit[1]\n";
	$numericComment = $fullCommentSplit[0];
		# print OUT "numericComment		= $numericComment\n";
	$textComment = $fullCommentSplit[1];
		# print OUT "textComment		= $textComment\n";
	if ($numericComment =~ /\d{3}/)  { # This checks if the numericCode is in fact numeric 
		$IDOTtext = $miscCodes::IDOTmiscCodes{$numericComment};  # If it is numeric it checks it against the 
		# IDOT misc code and then replaces the number with the IDOT text.
		# print OUT "IDOTtext		= $IDOTtext\n";
		if ($IDOTtext) {
			$fullComment = "$IDOTtext $textComment";
		# print OUT "fullComment w/IDOT IDOTtext	= $fullComment\n";
		}
	}
	if ($flagCodes::controlFlags{$numericComment}) { # This checks for control flags and issues the error messages
		$commentFlag = "$commentFlag $flagCodes::controlFlags{$numericComment}";
		$controlPointCount++;
		# print OUT "commentFlag		= $commentFlag\n";
		} else {
		# print OUT "commentFlag		= This is not a control check or resection point\n";
	}
	if ($commentLists::addedComments{$MPScode}) { # This checks for comments that are required by the code
		$commentText = $commentLists::addedComments{$MPScode};
		# print OUT "commentText-		= $commentText\n";
		} else {
		# print OUT "commentText-		= There are no added comments for this code\n";
	}
	$finalComment = join " ", $commentText, $fullComment, $commentFlag;
	# print OUT "finalComment		= $finalComment\n";
	$checkInCode = "$lineCode$liningSymbol $finalComment";
	# print OUT "checkInCode		= $checkInCode\n";
	$checkInCode =~ s/  / /g;
	$checkInCode =~ s/  / /g;
########################### Print Section

 print OUT "$in[0],$in[1],$in[2],$in[3],$checkInCode\n";

 #prepare for next loop
 $finalComment="";  #### added lv
 $globalcomment="";  #### added lv to make comment $fullComment available to processpoint()
 $lineCode="";
 $fullCode="";
 $liningSymbol="";
 $fullComment="";
 $MPScode="";
 $lineNumber="";
 $possibleMiscCode="";
 $IDOTtext="";
 $fullComment="";
 $C2="";
 $mComment="";
 $C3="";
 $C4="";
 $linecode="";
 $checkInCode="";
 $commentFlag="";
 $commentText="";
}
}
if ($illegalCodeCount > 0) {
	print "\nThere are $illegalCodeCount illegal point codes in this file\n";
	print OUT "\nThere are $illegalCodeCount illegal point codes in this file\n";
}
if ($illegalLiningSymbolCount > 0) {
	print "\nThere are $illegalLiningSymbolCount illegal lining symbols in this file\n";
	print OUT "\nThere are $illegalLiningSymbolCount illegal lining symbols in this file\n";
}
if ($controlPointCount > 0) {
	print "\nThere are $controlPointCount control-point-checks or resection positions in this file\n";
	print OUT "\nThere are $controlPointCount control-point-checks or resection positions in this file\n";
}
if ($illegalCodeCount < 1 && $illegalLiningSymbolCount < 1 && $controlPointCount < 1) {
	print "\nCheckin found no errors in this file. Good job!\n";
}
print "\n";
close(IN);
close(OUT);

