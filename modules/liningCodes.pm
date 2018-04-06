package liningCodes;
use strict;
use warnings;

our %lineSymbols = (
 "."  => ". B",			# Begin Line
 ".." => ".. E",			# End Line
 "+"  => "_ CLS",		# Close Figure
 "-"  => "SC BC",		# Begin Curve
 "!"  => "PT EC",		# End Curve
 "@"  => "/ OC",		# Point On Curve
);

1;
