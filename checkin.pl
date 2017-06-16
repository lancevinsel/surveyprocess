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
undef @pointCodeSplit;
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
		#using the first whitespace as the separator.
		#    print OUT "codeCommentSplit[0] =		$codeCommentSplit[0]\n";
		#    print OUT "codeCommentSplit[1] =		$codeCommentSplit[1]\n";
	$fullCode    = $codeCommentSplit[0];
		#    print OUT "fullCode =		$fullCode\n";
	$fullComment = $codeCommentSplit[1];
		#    print OUT "fullComment =		$fullComment\n";
	my @pointCodeSplit = ($fullCode =~ /(\w+)*(\W+)/);
		#    print OUT "pointCodeSplit[0] = $pointCodeSplit[0]\n";
		#    print OUT "pointCodeSplit[1] = $pointCodeSplit[1]\n";
	if ($pointCodeSplit[1]) {
	} else {
		$pointCodeSplit[0] = $codeCommentSplit[0];
		$pointCodeSplit[1] = "";
	}
		# print OUT "pointCodeSplit[0] = $pointCodeSplit[0]\n";
		# print OUT "pointCodeSplit[1] = $pointCodeSplit[1]\n";
    #added lv - this separates the 3 letter and
    # line number from the line coding symbol; \w is alpha
    # or numeric - \W is non alpha or numeric
    # $pointCodeSplit[0] is the code and line number; pointCodeSplit[1] is the line code
 $tok[0] = $pointCodeSplit[1]; #added lv - this is the line code
 $tok[1] = "$pointCodeSplit[0] $codeCommentSplit[1]"; #added lv - this is the code and the comment, no line code
 # @tok = split(/\s+/, $in[4], 2);
 my @csplit = ($pointCodeSplit[0] =~ /(\w\w\w)(\d*)/);


########################test for comment
# if (length($codeCommentSplit[1])>0) {##############lv  test for comment
#  $codeCommentSplit[1]="\;$codeCommentSplit[1]";########lv
#  $globalcomment = $codeCommentSplit[1]; #### added lv to make comment $codeCommentSplit[1] available to processpoint()
# }
##### 1.A. cHANGES TO fIELD cOMMENT idot MISC CODES
# if ($codeCommentSplit[1] =~ /\d[3]/)  {
 if ($codeCommentSplit[1] =~ /\d\d\d/)  {
#  print OUT "codeCommentSplit[1] = $codeCommentSplit[1]\n";
#  print OUT "var1 = $&\n";
  $possibleMiscCode = $&;
  $description = $IDOTmiscCodes{$possibleMiscCode};
#  print OUT "possibleMiscCode = $possibleMiscCode\n";
#  print OUT "description = $description\n";
 }
 if ($description) {
  $fullComment = $codeCommentSplit[1];
#  print OUT "fullComment1 = $fullComment\n";
  $fullComment =~ s/$possibleMiscCode/$description/;
#  print OUT "fullComment2 = $fullComment\n";
 } else {
  $fullComment = $codeCommentSplit[1];
#  print OUT "fullComment3 = $fullComment\n";
 }
#####1.B sEARCH FOR DELETEABLE CODES
 if ($in[4] =~ /RANDOM|CKH|CKV/) {
  $commentFlag = $cflag;
 }
####2 SEARCH FOR REQUIRED COMMENTS
 $commentText = $requiredComments{$csplit[0]};
# if ($CommentText) {
  #print OUT "csplit[0] = $csplit[0]\n";
  #print OUT "variblec2 = $commentText\n";
  $mcomment = $commentText;
# }

####3.A. sEARCH FOR ALPHA POINT NUMBERS
# if ($in[0] =~ /[^0-9]/) {
##  $commentFlag = $aflag;
# }

#### 3.B. sEARCH FOR OUTLIERS
 $C3 = $legalCodes{$csplit[0]};
# print OUT "varibleC3 = $C3\n";
 unless ($C3) {
  $commentFlag = $oflag;
 }


#### 4 lINECODEl
 if ($pointCodeSplit[1] =~ /\.\./) {   #END LINE
#  print OUT "a;lskdjfl\n";
#  print OUT "pointCodeSplit[1] = $pointCodeSplit[1]\n";
  $linecode = ")";
 }
 if ($pointCodeSplit[1] =~ /^\.$/) { #BEGIN LINE
  $linecode = "(";
 }
 if ($pointCodeSplit[1] =~ /-/) { #PC or PT (substitiute for OC);Graef Curve 20110610
  $linecode = "%";
 }
 if ($pointCodeSplit[1] =~ /@/) { #END LINE
  $linecode = ")";
 }
 #if ($pointCodeSplit[1] =~ /-/) { #PC CURVE
 # $linecode = "-";
 #}
 if ($pointCodeSplit[1] =~ /\+/) { #CLOSE FIGURE
  $linecode = "+";
 }
 $comment = " $mcomment $fullComment $commentFlag";
 $checkInCode = "$pointCodeSplit[0]$linecode$comment";
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
# print OUT "codeCommentSplit[0] full code no comment = $codeCommentSplit[0]\n";
# print OUT "codeCommentSplit[1] comment              = $codeCommentSplit[1]\n";
# print OUT "pointCodeSplit[0] code and line no.    = $pointCodeSplit[0]\n";
# print OUT "pointCodeSplit[1] line code            = $pointCodeSplit[1]\n";
# print OUT "tok[0] line code               = $tok[0]\n";
# print OUT "tok[1] code, line no., comment = $tok[1]\n";
# print OUT "csplit[0] code                 = $csplit[0]\n";
# print OUT "csplit[1] line number          = $csplit[1]\n";
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
 $globalcomment="";  #### added lv to make comment $codeCommentSplit[1] available to processpoint()
 $pointCodeSplit[0]="";
 $codeCommentSplit[0]="";
 $pointCodeSplit[1]="";
 $codeCommentSplit[1]="";
 $csplit[0]="";
 $csplit[1]="";
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
