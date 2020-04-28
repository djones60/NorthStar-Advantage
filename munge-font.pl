#! /usr/bin/perl

use strict;
use warnings;

while (<>) {
    chomp;
    my ($val) = (/^[0-9a-f]{6} ([0-9a-f]{2})$/);
    last if not defined $val;
    $val = hex $val;
    my $char = 32+int($.-1)/7;
    my $row = ($.-1) % 7;
    my $safechar = chr($char);
    $safechar =~ s/([^!#-^(-\][-~])/\\$1/gsm;
    $safechar = "\'$safechar\'";
    if ($row==0) {
        my $flaginfo = "";
        if (($val & 0xc0) == 0x80) {
            $flaginfo = " descender1";
        } elsif (($val & 0xc0) == 0xc0) {
            $flaginfo = " descender2";
        }
        printf "char_%02x:                        ; \%4s\%s\n",
          $char, $safechar, $flaginfo;
    }
    printf "        db \%08bb            ;\%04x \%02x\n",
      $val, 0x560+$., $val;
    if ($row==6) {
        print "\n";
    }
}
