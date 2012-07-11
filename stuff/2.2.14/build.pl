#!/usr/bin/perl

use strict;
use warnings;

use Data::Dump 'dump';
use Template::Alloy;
use Text::Wrap;
use XML::Simple;

my $command = XMLin(
  './commands.xml',
  ForceArray => [qw( arg )],
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

# login and logout aren't represented in the above files, so let's fake it!
push @lines, '', '# Session commands', 'login=;15', 'logout=;15';

my $section = '-';
my ( %section, %parm );

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

    $section =~ s/\W//g;

    next;

  } elsif ( $section ne '-' && $line =~ /^([^#]+)=.*;(\d+)$/ ) {

    my ( $cmd, $level ) = ( $1, $2 );

    if ( exists $command->{ $cmd } ) {

      $command->{ $cmd }{ description } =~ s/^\s*(.*?)\s*$/$1/;

      $command->{ $cmd }{ section } = $section;
      $command->{ $cmd }{ level   } = $level;

      push @{ $section{ $section } }, $cmd;

      # Some cleanup XMLin can't do
      my ( $request, $response );

      my $work = $command->{ $cmd }{ request };

      for my $parm ( keys %$work ) {

        my $required = lc( $work->{ $parm }{ required } ) eq 'true'  ? 'required'
                     : lc( $work->{ $parm }{ required } ) eq 'false' ? 'optional'
                     :     $work->{ $parm }{ required };

        my $description = exists $work->{ $parm }{ description }
                        ? $work->{ $parm }{ description }
                        : 'no description';

        $description =~ s/^\s*(.*?)\s*$/$1/;

        $request->{ $required }{ $parm } = $description;
        $parm{ $parm }->{ $description }++;

      }

      $work = $command->{ $cmd }{ response };

      for my $parm ( keys %$work ) {

        my $description = exists $work->{ $parm }{ description }
                        ? $work->{ $parm }{ description }
                        : 'no description';

        $description =~ s/^\s*(.*?)\s*$/$1/;

        $response->{ $parm } = $description;
        $parm{ $parm }->{ $description }++;

      }

      $command->{ $cmd }{ request } = $request;
      $command->{ $cmd }{ response } = $response;

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

if ( 0 ) {

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
  print "$_\n" for sort keys %section;

}

my $template = Template::Alloy->new( INCLUDE_PATH => [ '.' ] );

# Build the exports array string.
$Text::Wrap::columns = 78;
my $exports = wrap( '  ', '  ', sort keys %$command );

# Build the groups hash reference.
my @groups;

for my $g ( sort keys %section ) {

  ( my $g2 = $g ) =~ s/\W//g;
  my $commands = join ' ', sort @{ $section{ $g } };
  my $group = "  $g2 => [qw( $commands )],";

  if ( length $group > 79 ) {

    $commands = wrap( '    ', '    ', $commands );
    $group = "  $g2 => [qw(\n\n$commands\n\n  )],";

  }

  push @groups, $group;

}

my $groups = join "\n\n", @groups;

my $swap = {

  cmd_dump => ( dump $command ),
  command  => $command,
  exports  => $exports,
  groups   => $groups,
  parm     => \%parm,
  section  => \%section,

};

# Generate the pod file
$template->process( 'API_pod.tt', $swap, \my $pod )
  or die "Unable to process pod: ", $template->error;

open my $POD, '>', './API.pod'
  or die "Unable to open API.pod: $!\n";

print $POD $pod;

# Generate the pm file
$template->process( 'API_pm.tt', $swap, \my $pm )
  or die "Unable to process: ", $template->error;

open my $PM, '>', './API.pm'
  or die "Unable to open API.pm: $!\n";

print $PM $pm;

mkdir 't' if ! -e 't';

for my $section ( keys %section ) {

  my $method;
  $method->{ $_ } = $command->{ $_ }
    for @{ $section{ $section } };

  my $swap = {
    section     => $section,
    method_dump => ( dump $method ),
 };

  open my $T, '>', "./t/200-$section.t"
    or die "Unable to open ./t/200-$section.t: $!\n";

  # Generate the test file
  $template->process( '200_section-test.t.tt', $swap, \my $t )
    or die "Unable to process: ", $template->error;

  print $T $t;

}
