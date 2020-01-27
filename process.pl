use strict;
use warnings;

use lib 'C:\git-repos\surveyprocess\modules';
use Getopt::Long qw(GetOptions);

use commentLists;
use flagCodes;
use mainCodes;
use liningCodes;
use noLineList;
use typePrefixList;
# Some Vars
my @in="";
my $fullCode="";
my $fullComment="";
my $lineCode="";
my $liningSymbol="";
my $IDOTlineSymbol="";
my $ACADlineSymbol="";
my $filename="";
my $civil3d="";
my $openroads="";
my $MPScode="";
my $lineNumber="";
my $noLineCounter=1;

# ==============================================================================================
#                                   Start of Main Program
# ==============================================================================================
# @ARGV is a special array containing the items listed after the command on the command line
# Test to make sure that a filename was listed after the command 'checkin'
if ($#ARGV<0) {
	print q{
==============================================================================
|                                                                            |
|                     Process script requires file name                      |
|                                                                            |
|                    Syntax:  process filename -c (or -o)                    |
|                                                                            |
==============================================================================

};
	exit;
}
# Test for the output program flag and assign a value to either $civil3d or $openroads
GetOptions(
	'c' => \$civil3d,
	'o' => \$openroads,
);
if ($civil3d eq "" && $openroads eq ""){
	print q{
==============================================================================
|                                                                            |
|             Hey - The process script now requires a -c or a -o             |
|              The -c is for Civil3d and the -o is for Openroad              |
|                                                                            |
|                        Syntax:  process filename -c                        |
|                                     or                                     |
|                        Syntax:  process filename -o                        |
|                                                                            |
==============================================================================

};
	exit;
}
# $ARGV[0] is the first item following the command - in our case the filename to be processed
$filename=$ARGV[0];
# This next line removes the extension (normally .txt) from the entered filename
$filename =~ s/\.[^.]*$//;
# This opens the file for reading
open(IN,$ARGV[0]) or die "Can't open '$ARGV[0]' : $!";
# This opens the file for writing
if ($openroads eq "1") {
	open(OUT1,">${filename}_ORoads.cor");
	}
if ($civil3d eq "1") {
	open(OUT2,">${filename}_C3d.cor");
	}
# begin the loop - read in the lines one by one and evaluate to the end
# eliminate specific warnings - this is needed to prevent error messages in this code
	# print OUT "Civil3d is selected		= $civil3d\n";
	# print OUT "Openroads is selected		= $openroads\n";
	# print OUT "filename with extension		= $ARGV[0]\n";
	# print OUT "filename without extension	= $filename\n";
{
	no warnings 'uninitialized';
	no warnings 'once';
while (<IN>) {
	@in = split(/,/, substr(uc, 0, -1), 5); # the substr forces text to be uppercase
	# the split creates:
		# $in[0] = point number
		# $in[1] = northing
		# $in[2] = easting
		# $in[3] = elevation
		# $in[4] = fieldCode (3 Letter Code-Line Number-Line Code-Comments)
###############
# print OUT "\n";
		# print OUT "fieldCode		= @in\n";
	my @codeCommentSplit = split(/\s+/,$in[4],2); # this separates the fullCode from the fullComment
		# using the first whitespace as the separator.
		# print OUT "codeCommentSplit[0] 	= $codeCommentSplit[0]\n";
		# print OUT "codeCommentSplit[1] 	= $codeCommentSplit[1]\n";
	$fullCode = $codeCommentSplit[0];
		# print OUT "fullCode		= $fullCode\n";
	$fullComment = $codeCommentSplit[1];
		# print OUT1 "fullComment		= $fullComment TEST\n";
		#my @fullCodeSplit = ($fullCode =~ /(\w+)*(\W+)/); # this separates the 3 character MPSCode and
	my @fullCodeSplit = ($fullCode =~ /([a-zA-Z0-9]+)*(\W+)/); # this separates the 3 character MPSCode and
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
		# print OUT "combinedLineSymbol	= $combinedLineSymbol\n";
		my @separateLineSymbol = split(/\s+/,$combinedLineSymbol,2); # this separates
		# the IDOTlineSymbol from the ACADlineSymbol
		# print OUT "separateLineSymbol[0]	= $separateLineSymbol[0]\n";
		# print OUT "separateLineSymbol[1]	= $separateLineSymbol[1]\n";
		$IDOTlineSymbol = $separateLineSymbol[0];
			# print OUT "IDOTlineSymbol		= $IDOTlineSymbol\n";
		$ACADlineSymbol = $separateLineSymbol[1];
		#  print OUT "ACADlineSymbol		= $ACADlineSymbol\n";
	} else {
		$lineCode = $fullCode;
		#  print OUT "lineCode		= $lineCode\n";
		$IDOTlineSymbol = "";
			# print OUT "IDOTlineSymbol		= $IDOTlineSymbol\n";
		$ACADlineSymbol = "";
		#  print OUT "ACADlineSymbol		= $ACADlineSymbol\n";
	}
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

# Material type prefix
#	if ($openroads eq "1") {
		if ($typePrefixList::typePrefix{$MPScode}) {
			my $prefix = $typePrefixList::typePrefix{$MPScode};
				#   	print OUT "prefix			= $prefix\n";
			$lineNumber = "$prefix$lineNumber";
		# 	print OUT "lineNumber		= $lineNumber\n";
		}
#	}
# fix IDOT smd creating lines on non-line items
	if ($openroads eq "1") {
		if ($noLineList::noLine{$MPScode}) {
			# print OUT "lineNumber before noline add	= $lineNumber\n";
			# print OUT "noLineCounter		= $noLineCounter\n";
		$lineNumber = $noLineCounter;
			# print OUT "lineNumber after noline add	= $lineNumber\n";
		$noLineCounter = $noLineCounter + 1;
			# print OUT "noLineCounter is now		= $noLineCounter\n";
		}
	}
# get the IDOT and Civil3d codes for the MPScode as created in the field
	my $combinedCode = ($mainCodes::legalCodes{$MPScode});
		# print OUT "combinedCode	= $combinedCode\n";
	my @separateCode = split(/\s+/,$combinedCode,2); # this separates
	# the IDOTlineSymbol from the ACADlineSymbol
	#  print OUT "separateCode[0]	= $separateCode[0]\n";
	#  print OUT "separateCode[1]	= $separateCode[1]\n";
	my $idotCode = $separateCode[0];
	#  print OUT "idotCode		= $idotCode\n";
	my $civil3dCode = $separateCode[1];
	#  print OUT "civil3dCode		= $civil3dCode\n";
# Printing Section
	if ($openroads eq "1") {
		if ($fullComment) {
			$fullComment="--$fullComment";
		}
		print OUT1 "$in[0],$in[1],$in[2],$in[3],$IDOTlineSymbol$idotCode$lineNumber $fullComment\n";
		}
	if ($civil3d eq "1") {
		if ($fullComment) {
#			$fullComment=";$fullComment";
			$fullComment="$fullComment";
		}
		if ($liningSymbol) {
			print OUT2 "$in[0],$in[1],$in[2],$in[3],$civil3dCode$lineNumber $ACADlineSymbol/$fullComment\n";
		} else {
			print OUT2 "$in[0],$in[1],$in[2],$in[3],$civil3dCode$lineNumber /$fullComment\n";
		}
	}

# prepare for next loop
my @in="";
my $fullCode="";
my $fullComment="";
my $lineCode="";
my $liningSymbol="";
my $IDOTlineSymbol="";
my $ACADlineSymbol="";
my $civil3d="";
my $openroads="";
my $MPScode="";
my $lineNumber="";
}
close(IN);
if ($openroads eq "1") {
	close(OUT1);
}
if ($civil3d eq "1") {
	close(OUT2);
}
}
