#!/usr/bin/perl -w

use strict;
use warnings;

while (<>) {
	my $mis=0;	
#	if (/\tX0:i:(\d+)/)
#	{
#		my $best=$1;
#	}
#	if (/\tX1:i:(\d+)/)
#	{
#		my $sub=$1;
#	}
	if (/\tNM:i:(\d+)/)
	{
		$mis=$1;
	}

	if (/\tXA:Z:(\S+)/) {
		my $l = $1;
		my @t = split("\t");
		my $split_length = scalar(@t)-2;
		my @name = split("#",$t[0]);
		if (scalar(@name)!=5)
		{
			next;
		}

		if (abs(abs($name[1])-abs($t[3]))<20000)
		{
			print (join("\t",@t[0..10],"NM:i:$mis","best"),"\n");
		}
		while ($l =~ /([^,;]+),([-+]\d+),([^,]+),(\d+);/g) {
			if (abs(abs($name[1])-abs($2))>20000)
			{
				next;
			}
			my $mchr = ($t[6] eq $1)? '=' : $t[6]; # FIXME: TLEN/ISIZE is not calculated!
			my $flag = ($mis eq $4) ? "best" : "suboptimal";			
			print(join("\t", $t[0], 0x100|($t[1]&0x6e9)|($2<0?0x10:0), $1, $2, 0, $3, @t[6..7], 0, @t[9..10], "NM:i:$4", $flag),"\n");
		}
	} else { 		
		my @t = split("\t");
		my $split_length = scalar(@t);

		if ($t[0] =~ /^@/)
		{
			print;
		}else
		{
			my @name = split("#",$t[0]);
			if (scalar(@name)!=5)
			{
				next;
			}
			if (abs(abs($name[1])-abs($t[3]))>20000)
			{
				next;
			}			
			my $final = $t[10];
			$final =~ s/^\s+//;
			$final =~ s/\s+$//;			
			print (join("\t",@t[0..9],$final,"NM:i:$mis","best"),"\n"); 
		}
	}
}
