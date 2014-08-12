#!/usr/bin/perl
use Getopt::Long;
use Data::Dumper;


#################### open folder contains all input files#################
my $USAGE = "\nUSAGE: fastq_read_length.pl 
                                   -seqdir directory_with_fastq_files
                                   ";
my $options = {};
GetOptions($options, "-seqdir=s"); #, "-out=s" 
die $USAGE unless defined ($options->{seqdir});

############################# Main #############################
my $seqdir = $options->{seqdir};
opendir (DIR, $seqdir) or die "Couldn't open $seqdir: $!\n";

my $command;
while (defined(my $seqfile = readdir(DIR))) {
    next if !($seqfile =~ m/\.fastq/);
    if ($seqfile =~ /\.gz$/) {
	open(SEQ1, "gunzip -c $seqdir$seqfile |") || die "can't open pipe to $seqfile";
	}
	else {
	open(SEQ1, "< $seqdir$seqfile") || die "can't open $seqfile";
	}
	while (<SEQ1>) {
		chomp;
		next if m/@/;
		$tag = $_;
		$len = length($tag);
		print "$len\t$seqfile\n";
		last;
	}

}
