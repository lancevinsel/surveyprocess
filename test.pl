use lib 'C:\git-repos\surveyprocess\lists';

use miscCodes;

foreach my $name (keys %miscCodes::IDOTmiscCodes) {
	print "$name => $miscCodes::IDOTmiscCodes{$name}\n";
}
