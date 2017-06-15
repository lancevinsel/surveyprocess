use strict;
use warnings;

# Some Global Vars
$figname="";
$curPtNum="";
$lastPtNum="";
$lastFigname="";
%activeStrings=();
$curIsString=0;
$lastWasString=0;
$comment="";
$globalcomment="";
undef @ssplit;
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
 @in = split(/,/, substr(uc, 0, -1), 5); #note: forces text to be uppercase
 my @fsplit = split(/\s+/,$in[4],2); #added lv - this separates the code from the comments
     #using the first? whitespace as the separator so $fplit[0] is the full code and $fsplit[1] = the comment
        my @ssplit = ($fsplit[0] =~ /(\w+)*(\W+)/);
#    print OUT "ssplit[0] = $ssplit[0]\n";
#    print OUT "ssplit[1] = $ssplit[1]\n";
    if ($ssplit[1]) {
 } else {
  $ssplit[0] = $fsplit[0];
  $ssplit[1] = "";
 }
# print OUT "ssplit[0] = $ssplit[0]\n";
# print OUT "ssplit[1] = $ssplit[1]\n";
    #added lv - this separates the 3 letter and
    # line number from the line coding symbol; \w is alpha
    # or numeric - \W is non alpha or numeric
    # $ssplit[0] is the code and line number; ssplit[1] is the line code
 $tok[0] = $ssplit[1]; #added lv - this is the line code
 $tok[1] = "$ssplit[0] $fsplit[1]"; #added lv - this is the code and the comment, no line code
 # @tok = split(/\s+/, $in[4], 2);
 my @csplit = ($ssplit[0] =~ /(\w\w\w)(\d*)/);


########################test for comment
# if (length($fsplit[1])>0) {##############lv  test for comment
#  $fsplit[1]="\;$fsplit[1]";########lv
#  $globalcomment = $fsplit[1]; #### added lv to make comment $fsplit[1] available to processpoint()
# }
##### 1.A. cHANGES TO fIELD cOMMENT idot MISC CODES
# if ($fsplit[1] =~ /\d[3]/)  {
 if ($fsplit[1] =~ /\d\d\d/)  {
#  print OUT "fsplit[1] = $fsplit[1]\n";
#  print OUT "var1 = $&\n";
  $possibleMiscCode = $&;
  $description = $IDOTmiscCodes{$possibleMiscCode};
#  print OUT "possibleMiscCode = $possibleMiscCode\n";
#  print OUT "description = $description\n";
 }
 if ($description) {
  $fieldComment = $fsplit[1];
#  print OUT "fieldcomment1 = $fieldComment\n";
  $fieldComment =~ s/$possibleMiscCode/$description/;
#  print OUT "fieldcomment2 = $fieldComment\n";
 } else {
  $fieldComment = $fsplit[1];
#  print OUT "fieldcomment3 = $fieldComment\n";
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
 if ($ssplit[1] =~ /\.\./) {   #END LINE
#  print OUT "a;lskdjfl\n";
#  print OUT "ssplit[1] = $ssplit[1]\n";
  $linecode = ")";
 }
 if ($ssplit[1] =~ /^\.$/) { #BEGIN LINE
  $linecode = "(";
 }
 if ($ssplit[1] =~ /-/) { #PC or PT (substitiute for OC);Graef Curve 20110610
  $linecode = "%";
 }
 if ($ssplit[1] =~ /@/) { #END LINE
  $linecode = ")";
 }
 #if ($ssplit[1] =~ /-/) { #PC CURVE
 # $linecode = "-";
 #}
 if ($ssplit[1] =~ /\+/) { #CLOSE FIGURE
  $linecode = "+";
 }
 $comment = " $mcomment $fieldComment $commentFlag";
 $checkInCode = "$ssplit[0]$linecode$comment";
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
# print OUT "fsplit[0] full code no comment = $fsplit[0]\n";
# print OUT "fsplit[1] comment              = $fsplit[1]\n";
# print OUT "ssplit[0] code and line no.    = $ssplit[0]\n";
# print OUT "ssplit[1] line code            = $ssplit[1]\n";
# print OUT "tok[0] line code               = $tok[0]\n";
# print OUT "tok[1] code, line no., comment = $tok[1]\n";
# print OUT "csplit[0] code                 = $csplit[0]\n";
# print OUT "csplit[1] line number          = $csplit[1]\n";
# print OUT "possibleMiscCode               = $possibleMiscCode\n";
# print OUT "description                    = $description\n";
# print OUT "field comment                  = $fieldComment\n";
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
 $globalcomment="";  #### added lv to make comment $fsplit[1] available to processpoint()
 $ssplit[0]="";
 $fsplit[0]="";
 $ssplit[1]="";
 $fsplit[1]="";
 $csplit[0]="";
 $csplit[1]="";
 $possibleMiscCode="";
 $description="";
 $fieldComment="";
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
