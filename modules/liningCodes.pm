package liningCodes;
use strict;
use warnings;

our %lineSymbols = (
 "."  => "B B",			# Begin Line
 ".." => "E E",			# End Line
 "+"  => "C CLS",		# Close Figure
 "-"  => "PC BC",		# Begin Curve
 "!"  => "PT EC",		# End Curve
 "@"  => "OC OC",		# Point On Curve
);

1;
