#!/usr/bin/perl
# Doffy, 2019.08.25
# Run $ARGV[0] command, split output by $ARGV[1] character and send to Zabbix the first part of line as key,
#	and second part of lines as it's value
#
# Input parameters:
# $ARGV[0]: the command to run ( like: "apcaccess status 127.0.0.1:3551" )
# $ARGV[1]: the splitter character/string ( like: ":" or ": ")
# $ARGV[2]: the Zabbix server name and other parameters but without "-k" and "-o" ( like: after -z the "zabbix.mydomain.hu" )
# $ARGV[3]: the key name prefix (if needed) (like: "apcupsd.")
# $ARGV[4]: the key name postfix (if needed) (like: ".capacity")
# testing: "./dfy_split.pl "apcaccess status 127.0.0.1:3551" ": " localhost apcupsd."

use strict;
use warnings;
use Net::Domain qw(hostfqdn);
 
my $in_command=$ARGV[0];
my $in_splitter=$ARGV[1];
my $in_zabbix_srv=$ARGV[2];
my $in_key_prefix=$ARGV[3];
my $in_key_postfix=$ARGV[4];
my @cmd_output;
my @fields;
my $zbx_send="zabbix_sender" ;
my $send_cmd;
my $myhost=hostfqdn();

eval { @cmd_output=`$in_command`; } or do { exit 1; };

foreach ( @cmd_output ) {
  eval {
    chomp($_);
    @fields = split $in_splitter, $_;
    if (not defined $fields[0]) { $fields[0]=""; }
    if (not defined $fields[1]) { $fields[1]=""; }
    if (not defined $in_key_prefix) { $in_key_prefix=""; }
    if (not defined $in_key_postfix) { $in_key_postfix=""; }
    $fields[0] =~ s/^\s+|\s+$//g;
    $fields[1] =~ s/^\s+|\s+$//g;
    if ($fields[0] ne "") {
      $fields[0] =~ tr/ /_/;
      $send_cmd="$zbx_send -z $in_zabbix_srv -s $myhost -k \"$in_key_prefix$fields[0]$in_key_postfix\" -o '$fields[1]'";
      `$send_cmd`;
      print "$send_cmd\n";
    }
    1;
  } or do { print "hiba?"; exit 1; };
}
print "0\n";
exit 0;
