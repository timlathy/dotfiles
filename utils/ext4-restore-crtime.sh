#!/bin/bash

# Based on https://unix.stackexchange.com/a/591388, with a modification
# to significantly reduce running time by batching debugfs commands.

dsk_src=/dev/sdc4 # source disk with original timestamps
mnt_src=/mnt/sdc4 # source disk mounted at this path
dsk_dst=/dev/sda4 # destination disk
directory=user/Documents # the leading slash _must_ be omitted

cmdstat=$(pwd)/cmdstat
cmdstatout=$(pwd)/cmdstatout
cmdwrite=$(pwd)/cmdwrite
cmdwriteout=$(pwd)/cmdwriteout

rm -i $cmdstat $cmdstatout $cmdwrite $cmdwriteout

cd $mnt_src || exit 1

find "$directory" -depth | while read name; do
    echo "stat \"/$name\"" >> $cmdstat
done

debugfs -w $dsk_src -f $cmdstat > $cmdstatout

cat $cmdstatout | perl > $cmdwrite <(cat <<'EOF'
use strict;
use warnings;
my %crtimes;
my $curr_file;
while (<>) {
	if (/debugfs: stat "(.+)"$/) { $curr_file = $1; }
	if (/crtime: 0x(\w+):(\w+)/) {
		die "ERROR: no file for crtime at line $.\n" if !defined($curr_file);
		die "ERROR: file already read for crtime at line $.\n" if exists($crtimes{$curr_file});
		$crtimes{$curr_file} = [$1, $2];
		print qq(set_inode_field "$curr_file" crtime_lo 0x$1\n);
		print qq(set_inode_field "$curr_file" crtime_hi 0x$2\n);
	}
}
EOF
)

debugfs -w $dsk_dst -f $cmdwrite | tee $cmdwriteout
