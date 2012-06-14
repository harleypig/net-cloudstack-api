#!/usr/bin/perl

use strict;
use warnings;

use XML::Simple;

my $command = XMLin(
  './commands.xml',
  GroupTags => {
    request => 'arg',
    response => 'arg',
  },
);

$command = $command->{ command };

my @lines = do {

  open my $FH, '<', './commands.properties'
    or die "Unable to open commands.properties: $!\n";

  <$FH>;

};

push @lines, do {

  open my $FH, '<', './commands-ext.properties'
    or die "Unable to open commands-ext.properties: $!\n";

  <$FH>;

};

chomp @lines;

my $section = '-';
my @sections;

for my $line ( @lines ) {

  if ( $line =~ /^\s*$/ ) {

    $section = '-';
    next;

  } elsif ( $section eq '-' && $line =~ /^#+\s*(.*?)\s+command.*$/ ) {

    ( $section = $1 ) =~ s/(\w+)/\u\L$1/g;

    # Special Handling
    $section =~ s/\biso\b/ISO/i;
    $section =~ s/\bloadbalancer\b/Load Balancer/i;
    $section =~ s/\bnat\b/NAT/i;
    $section =~ s/\bnetapp\b/NetApp/i;
    $section =~ s/\bos\b/OS/i;
    $section =~ s/\bssh\b/SSH/i;
    $section =~ s/\bvlan\b/VLAN/i;
    $section =~ s/\bvm\b/VM/i;
    $section =~ s/\bvpn\b/VPN/i;

    push @sections, $section;
    next;

  } elsif ( $section ne '-' && $line =~ /^([^#]+)=.*;(\d+)$/ ) {

    my ( $cmd, $level ) = ( $1, $2 );

    if ( exists $command->{ $cmd } ) {

      $command->{ $cmd }{ section } = $section;
      $command->{ $cmd }{ level   } = $level;

    } else {

      warn "No matching command for $cmd ($line)\n";

    }

    next;

  } elsif ( $line =~ /^#/ ) {

    next;

  } else {

    warn "Unhandled situation for $line\n";

  }
}

my %check;

my @expected = qw( description isAsync level request response section );

for my $c ( keys %$command ) {

  my @k = keys %{ $command->{ $c } };
  $check{ $_ }++ for @k;

  my %tmp;
  $tmp{ $_ }++ for @expected;
  $tmp{ $_ }++ for @k;

  for my $t ( keys %tmp ) {

    next if $tmp{ $t } == 2;
    warn "$c is missing $t\n";

  }
}

print "$_ = $check{ $_ }\n" for keys %check;
print "$_\n" for sort @sections;
