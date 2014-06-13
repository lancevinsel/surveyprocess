######################
########################
%pointCodes = (  # Utility code-> IDOT Code           
 	"T" => "286", # Telephone                      
	"E" => "285", # Electric                       
	"V" => "288", # TV                             
	"F" => "289", # Fiber Optic                    
	"G" => "688", # Gas                            
	"W" => "689", # Water                          
	"N" => "960", # Sanitary                       
	"M" => "962", # Storm                          
	"H" => "919", # Test Hole                      
	"S" => "224", # Fiber Optic Traffic Signal     
);                                                     
%utilityCode = (
	"T" => "TELE", # Telephone                      
	"E" => "ELEC", # Electric                       
	"V" => "TV", # TV                             
	"F" => "FIBER", # Fiber Optic                    
	"G" => "GAS", # Gas                            
	"W" => "WATER", # Water                          
	"N" => "SAN", # Sanitary                       
	"M" => "STORM", # Storm                          
	"H" => "TH", # Test Hole                      
	"S" => "TRAF", # Fiber Optic Traffic Signal  
);


####################################### Start of Main Program
if ($#ARGV<0) {
	die "Syntax:\nperl fbk.pl <input file name> <start ptnum for new pts>\n";
}
$fname=$ARGV[0];
$fname =~ s/\.[^.]*$//;
open(IN,$ARGV[0]);
open(OUT1,">${fname}_cardno.cor");
open(OUT2,">${fname}_idot.txt");

@data = <>;

my @AOA = map { chomp; [split /,/]; } @data; 


$i=0;                                          
foreach my $AOAArray (@AOA)
{ 
  	my @firstsplit = split(/\s+/,$AOA[$i][4],2); #added lv - this separates the Codes from the Comments
		#using the first whitespace as the separator so:
		#$firstsplit[0] = code
		#$firstsplit[1] = the Comment
		$firstsplit[1]=uc($firstsplit[1]); 
#		print "pointnumber = $AOA[$i][0]\n";
#		print "firstsplit[0] code = $firstsplit[0]\n";  
#		print "firstsplit[1] comment = $firstsplit[1]\n"; 
	my @secondsplit = split(/\./,$firstsplit[0],2); #added lv - this separates the code using
		#a period as a delimiter		
		#$secondsplit[0] = the Utility Code and line number
		#$secondsplit[1] = the flag number
		$secondsplit[1] = int ($secondsplit[1]); 
#		print "secondsplit[0] utility code & line no = $secondsplit[0]\n"; 
#		print "secondsplit[1] flag no = $secondsplit[1]\n"; 
	my @thirdsplit = ($secondsplit[0] =~ /(\w)(\d*)/);  		
		#$thirdsplit[0] = utility code
		#$thirdsplit[1] = line number
#		print "thirdsplit[0] utility code = $thirdsplit[0]\n";
#		print "thirdsplit[1] line number = $thirdsplit[1]\n"; 
		$thirdsplit[0] = uc($thirdsplit[0]);
		$thirdsplit[1] = int($thirdsplit[1]); 
#		print "thirdsplit[0] utility code = $thirdsplit[0]\n";     		
		if ($thirdsplit[0] eq "X")
		{	
			my @IDOTsplit = ($AOA[$i][4] =~ /(\w)(.*)/);
			$AOA[$i][8] = $IDOTsplit[1];
			$AOA[$i][5] = $IDOTsplit[0];
			$AOA[$i][6] = $AOA[$i][0];
		}
		else
		{	
#			push @{$AOA[$i]}, "$thirdsplit[0]", "$thirdsplit[1]", "$secondsplit[1]","$firstsplit[1]",; 
			$AOA[$i][5] = $thirdsplit[0];
#			print "AOA[5] utility code = $AOA[$i][5]\n";
			$AOA[$i][6] = $thirdsplit[1];
#			print "AOA[6] line number = $AOA[$i][6]\n"; 
			$AOA[$i][7] = $secondsplit[1];
#			print "AOA[7] flag no = $AOA[$i][7]\n";
			$AOA[$i][8] = $firstsplit[1];
#			print "AOA[8] comment = $AOA[$i][8]\n";  

                }       
  	$j=0;                                                 
  	foreach my $AOACell (@$AOAArray)                         
  	{                                                     
    		$j++;                                      
  	}
  	$i++;                                     
} 
            
@sorted = sort
	{
                $a->[5] cmp $b->[5] ||
                $a->[6] <=> $b->[6] ||
                $a->[7] <=> $b->[7] ;
	}
	@AOA; 
                   

######################################################################
$i=0;
$lastCode="";                                          
foreach my $sortedArray (@sorted)
{ 
	$sorted[$i][5] = uc($sorted[$i][5]);
  	if ($sorted[$i][5] eq "X")
  	{
  		print OUT2 "$sorted[$i][0],$sorted[$i][1],$sorted[$i][2],$sorted[$i][3],$sorted[$i][8]\n"; 
	}
	else
	{
		if ("$sorted[$i][5]$sorted[$i][6]" eq $lastCode)
		{
                	$lineCode = "";
        	}
        	else
        	{
        		$lineCode = "L";
        	}
                $utility = ($utilityCode{$sorted[$i][5]});
                $numberCode = ($pointCodes{$sorted[$i][5]});
#               print "$sorted[$i][5]\n";
                if ($sorted[$i][5] eq "H")
                {
                $sorted[$i][6] = "";
                $lineCode = "";	
                }
                if ($sorted[$i][8] eq "")
                {
                	$comment = ";$utility$sorted[$i][6]_$sorted[$i][7]";
                	print OUT1 "$sorted[$i][0],$sorted[$i][1],$sorted[$i][2],$sorted[$i][3],$numberCode$sorted[$i][5]$sorted[$i][6]$comment,$lineCode\n";
                }
                else
                { 	$comment = ";$utility$sorted[$i][6]_$sorted[$i][7] $sorted[$i][8]";
	                print OUT1 "$sorted[$i][0],$sorted[$i][1],$sorted[$i][2],$sorted[$i][3],$numberCode$sorted[$i][5]$sorted[$i][6]$comment,$lineCode\n"; 
              	}
	$lastCode= "$sorted[$i][5]$sorted[$i][6]";
	}
	$i++; 
}
 

close(IN);
close(OUT1);
close(OUT2);
