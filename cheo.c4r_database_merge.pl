#!/usr/bin/perl

#merge the database from all samples

open(IN,$ARGV[0]);
$fname="seen_in_c4r_counts.txt";
open($fh,'>',$fname);
$fname1="seen_in_c4r_samples.txt";
open($fh1,'>',$fname1);

%seen_in_c4r_counts;
%seen_in_c4r_samples;

while(<IN>)
{
    chomp;
    @ar = split("\t",$_);
    $variant_id = $ar[0];
    $sample = $ar[1];
    $seen_in_c4r_counts{$variant_id}++;
    if (exists($seen_in_c4r_samples{$variant_id}))
    {
	$t = $seen_in_c4r_samples{$variant_id};
	$seen_in_c4r_samples{$variant_id} = $sample.",".$t;
    }
    else
    {
	$seen_in_c4r_samples{$variant_id} = $sample;
    }
}

close(IN);

print $fh "superindex\tcounts\n";
foreach $key (keys(%seen_in_c4r_counts))
{
    print $fh $key."\t".$seen_in_c4r_counts{$key}."\n";
}


print $fh1 "superindex;samples\n";
for $key (keys(%seen_in_c4r_samples))
{
    print $fh1 $key.";".$seen_in_c4r_samples{$key}."\n";
}

close $fh;
close $fh1;
