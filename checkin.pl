use strict;
use warnings;

# Some Global Vars
$figname="";
$lastPtNum="";
$lastFigname="";
%activeStrings=();
$curIsString=0;
$lastWasString=0;
$comment="";
$globalcomment="";
undef @fullCodeSplit;
$cflag = "XXXcontrolXXX";
$aflag = "XXXalphaXXX";
$oflag = "XXXoutlierXXX";

# --------------------
sub generateNextPtNum {
	return $_nextAutogenPtNum++;
}
#------------------- Start of Main Program
if ($#ARGV<0) {
	die "Syntax:\nperl fbk.pl <input file name> <start ptnum for new pts>\n";
}
$filename=$ARGV[0];
$filename =~ s/\.[^.]*$//;
open(IN,$ARGV[0]);
open(OUT,">${filename}.csv");
if ($#ARGV>0) {
	$_nextAutogenPtNum=$ARGV[1];
}
else {
	$_nextAutogenPtNum=100000;
}
while (<IN>) {
	$curIsString=0;
	@in = split(/,/, substr(uc, 0, -1), 5); # forces text to be uppercase
	my @codeCommentSplit = split(/\s+/,$in[4],2); # this separates the fullCode from the fullComment
		# using the first whitespace as the separator.
		# print OUT "codeCommentSplit[0] 	= $codeCommentSplit[0]\n";
		# print OUT "codeCommentSplit[1] 	= $codeCommentSplit[1]\n";
	$fullCode = $codeCommentSplit[0];
		# print OUT "fullCode			= $fullCode\n";
	$fullComment = $codeCommentSplit[1];
		# print OUT "fullComment		= $fullComment\n";
	my @fullCodeSplit = ($fullCode =~ /(\w+)*(\W+)/); # this separates the 3 character MPSCode and
		# line number from the line coding symbol liningSymbol;
		# \w is alpha or numeric - \W is non alpha or numeric
		# print OUT "fullCodeSplit[0]		= $fullCodeSplit[0]\n";
		# print OUT "fullCodeSplit[1]		= $fullCodeSplit[1]\n";
	$lineCode = $fullCodeSplit[0];
		# print OUT "lineCode			= $lineCode\n";
	$liningSymbol = $fullCodeSplit[1];
		# print OUT "liningSymbol		= $liningSymbol\n";
	if ($liningSymbol) {
	} else {
		$lineCode = $fullCode;
		$liningSymbol = "";
	}
		# print OUT "lineCode			= $lineCode\n";
		# print OUT "liningSymbol		= $liningSymbol\n";
	my @lineNumberSplit = ($lineCode =~ /(\w\w\w)(\d*)/);
		# print OUT "lineNumberSplit[0]		= $lineNumberSplit[0]\n";
		# print OUT "lineNumberSplit[1]		= $lineNumberSplit[1]\n";
	$MPScode = lineNumberSplit[0];
		# print OUT "MPScode			= $MPScode\n";
	$lineNumber = lineNumberSplit[1];
		# print OUT "lineNumber			= $lineNumber\n";

########################test for comment
# if (length($fullComment)>0) {##############lv  test for comment
#  $fullComment="\;$fullComment";########lv
#  $globalcomment = $fullComment; #### added lv to make comment $fullComment available to processpoint()
# }
##### 1.A. cHANGES TO fIELD cOMMENT idot MISC CODES
# if ($fullComment =~ /\d[3]/)  {
 if ($fullComment =~ /\d\d\d/)  {
#  print OUT "fullComment = $fullComment\n";
#  print OUT "var1 = $&\n";
  $possibleMiscCode = $&;
  $description = $IDOTmiscCodes{$possibleMiscCode};
#  print OUT "possibleMiscCode = $possibleMiscCode\n";
#  print OUT "description = $description\n";
 }
 if ($description) {
  $fullComment = $fullComment;
#  print OUT "fullComment1 = $fullComment\n";
  $fullComment =~ s/$possibleMiscCode/$description/;
#  print OUT "fullComment2 = $fullComment\n";
 } else {
  $fullComment = $fullComment;
#  print OUT "fullComment3 = $fullComment\n";
 }
#####1.B sEARCH FOR DELETEABLE CODES
 if ($in[4] =~ /RANDOM|CKH|CKV/) {
  $commentFlag = $cflag;
 }
####2 SEARCH FOR REQUIRED COMMENTS
 $commentText = $requiredComments{$MPScode};
# if ($CommentText) {
  #print OUT "MPScode = $MPScode\n";
  #print OUT "variblec2 = $commentText\n";
  $mcomment = $commentText;
# }

####3.A. sEARCH FOR ALPHA POINT NUMBERS
# if ($in[0] =~ /[^0-9]/) {
##  $commentFlag = $aflag;
# }

#### 3.B. sEARCH FOR OUTLIERS
 $C3 = $legalCodes{$MPScode};
# print OUT "varibleC3 = $C3\n";
 unless ($C3) {
  $commentFlag = $oflag;
 }


#### 4 lINECODEl
 if ($liningSymbol =~ /\.\./) {   #END LINE
#  print OUT "a;lskdjfl\n";
#  print OUT "liningSymbol = $liningSymbol\n";
  $linecode = ")";
 }
 if ($liningSymbol =~ /^\.$/) { #BEGIN LINE
  $linecode = "(";
 }
 if ($liningSymbol =~ /-/) { #PC or PT (substitiute for OC);Graef Curve 20110610
  $linecode = "%";
 }
 if ($liningSymbol =~ /@/) { #END LINE
  $linecode = ")";
 }
 #if ($liningSymbol =~ /-/) { #PC CURVE
 # $linecode = "-";
 #}
 if ($liningSymbol =~ /\+/) { #CLOSE FIGURE
  $linecode = "+";
 }
 $comment = " $mcomment $fullComment $commentFlag";
 $checkInCode = "$lineCode$linecode$comment";
 $checkInCode =~ s/  / /g;
 $checkInCode =~ s/  / /g;

########################### Print Section

 print OUT "$in[0],$in[1],$in[2],$in[3],$checkInCode\n";

####################### TEST SECTION
# print OUT "in[0] point number             = $in[0]\n";
# print OUT "in[1] northing                 = $in[1]\n";
# print OUT "in[2] easting                  = $in[2]\n";
# print OUT "in[3] elevation                = $in[3]\n";
# print OUT "in[4] full code & comment      = $in[4]\n";
# print OUT "fullCode full code no comment = $fullCode\n";
# print OUT "fullComment comment              = $fullComment\n";
# print OUT "fullCodeSplit[0] code and line no.    = $lineCode\n";
# print OUT "liningSymbol line code            = $liningSymbol\n";
# print OUT "MPScode code                 = $MPScode\n";
# print OUT "lineNumber line number          = $lineNumber\n";
# print OUT "possibleMiscCode               = $possibleMiscCode\n";
# print OUT "description                    = $description\n";
# print OUT "field comment                  = $fullComment\n";
# print OUT "C1                             = $C1\n";
# print OUT "commentFlag                    = $commentFlag\n";
# print OUT "cFlag  control                 = $cflag\n";
# print OUT "aFlag  alpha                   = $aflag\n";
# print OUT "oFlag  outlier                 = $oflag\n";
# print OUT "C2                             = $C2\n";
# print OUT "mComment                       = $mComment\n";
# print OUT "C3                             = $C3\n";
# print OUT "C4                             = $C4\n";
# print OUT "linecode                       = $linecode\n";
# print OUT "comment                        = $comment\n";
# print OUT "checkInCode                    = $checkInCode\n\n";


 #prepare for next loop
 if ($curIsString) {
  $activeStrings{$figname}=1; #make sure the list contains an entry for this string
 }
 $lastWasString=$curIsString;
 $lastFigname=$figname;
 $lastPtNum=$in[0];
 $figname="";
 $comment="";  #### added lv
 $globalcomment="";  #### added lv to make comment $fullComment available to processpoint()
 $lineCode="";
 $fullCode="";
 $liningSymbol="";
 $fullComment="";
 $MPScode="";
 $lineNumber="";
 $possibleMiscCode="";
 $description="";
 $fullComment="";
 $C2="";
 $mComment="";
 $C3="";
 $C4="";
 $linecode="";
 $comment="";
 $checkInCode="";
 $commentFlag="";
 $commentText="";
}
close(IN);
close(OUT);
