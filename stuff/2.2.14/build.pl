#!/usr/bin/perl
## no critic qw( Modules::ProhibitExcessMainComplexity )
## no critic qw( ValuesAndExpressions::ProhibitAccessOfPrivateData )
## no critic qw( References::ProhibitDoubleSigils Variables::ProhibitPackageVars )

use 5.006;
use strict;
use warnings;

use Carp;
use Data::Dump 'dump';
use Template::Alloy;
use Text::Wrap;
use XML::Simple;

use constant LINE_WIDTH => 78;

if ( ! -e 't' ) {

  croak "Unable to 'mkdir t': $!" unless mkdir 't';

}

my $command = XMLin(
  './commands.xml',
  ForceArray => [qw( arg )],
  GroupTags  => { request => 'arg', response => 'arg', },
);

$command = $command->{ command };

my @lines = do {

  croak "Unable to open commands.properties: $!"
      unless open my $FH, '<', './commands.properties';

  <$FH>;

};

push @lines, do {

  croak "Unable to open commands-ext.properties: $!"
    unless open my $FH, '<', './commands-ext.properties';

  <$FH>;

};

chomp @lines;

# login and logout aren't represented in the above files, so let's fake it!
push @lines, '', '# Session commands', 'login=;15', 'logout=;15';

my $section = q{-};
my ( %section, %parm );

for my $line ( @lines ) {

  if ( $line =~ /^\s*$/ ) { ## no critic qw( ControlStructures::ProhibitCascadingIfElse )

    $section = q{-};
    next;

  } elsif ( $section eq q{-} && $line =~ /^#+\s*(.*?)\s+command.*$/ ) {

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

  } elsif ( $section ne q{-} && $line =~ /^([^#]+)=.*;(\d+)$/ ) {

    my ( $cmd, $level ) = ( $1, $2 );

    if ( exists $command->{ $cmd } ) {

      $command->{ $cmd }{ description } =~ s/^\s*(.*?)\s*$/$1/;

      $command->{ $cmd }{ section } = $section;
      $command->{ $cmd }{ level }   = $level;

      push @{ $section{ $section } }, $cmd;

      # Some cleanup XMLin can't do
      my ( $request, $response );

      my $work = $command->{ $cmd }{ request };

      for my $parm ( keys %$work ) {

        my $required
            = lc( $work->{ $parm }{ required } ) eq 'true'  ? 'required'
            : lc( $work->{ $parm }{ required } ) eq 'false' ? 'optional'
            :                                                 $work->{ $parm }{ required };

        my $description
            = exists $work->{ $parm }{ description }
            ? $work->{ $parm }{ description }
            : 'no description';

        $description =~ s/^\s*(.*?)\s*$/$1/;

        $request->{ $required }{ $parm } = $description;
        #$parm{ $parm }->{ $description }++;
        ++$parm{ $parm }{ $description };

      } ## end for my $parm ( keys...)

      $work = $command->{ $cmd }{ response };

      for my $parm ( keys %$work ) {

        my $description
            = exists $work->{ $parm }{ description }
            ? $work->{ $parm }{ description }
            : 'no description';

        $description =~ s/^\s*(.*?)\s*$/$1/;

        $response->{ $parm } = $description;
        #$parm{ $parm }->{ $description }++;
        ++$parm{ $parm }{ $description };

      }

      $command->{ $cmd }{ request }  = $request;
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
} ## end for my $line ( @lines)

if ( 0 ) {

  my %check;

  my @expected = qw( description isAsync level request response section );

  for my $c ( keys %$command ) {

    my @k = keys %{ $command->{ $c } };
    $check{ $_ }++ for @k;

    ## no critic qw( Bangs::ProhibitVagueNames )
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

} ## end if ( 0 )

my $template = Template::Alloy->new( INCLUDE_PATH => [q{.}] );

# Build the exports array string.
$Text::Wrap::columns = LINE_WIDTH;
my $exports = wrap( '  ', '  ', sort keys %$command );

# Build the groups hash reference.
my @groups;

for my $g ( sort keys %section ) {

  ( my $g2 = $g ) =~ s/\W//g; ## no critic qw( Bangs::ProhibitNumberedNames )
  my $commands = join ' ', sort @{ $section{ $g } };
  my $group = "  $g2 => [qw( $commands )],";

  if ( length $group > LINE_WIDTH ) {

    $commands = wrap( '    ', '    ', $commands );
    $group = "  $g2 => [qw(\n\n$commands\n\n  )],";

  }

  push @groups, $group;

}

my $groups = join "\n\n", @groups;

# Satisfy perlcritic: ValuesAndExpressions::ProhibitInterpolationOfLiterals
my $cmd_dump = dump $command;
$cmd_dump =~ s/'/\\'/g;
$cmd_dump =~ s/"/'/g;

my $api_swap = {

  cmd_dump => $cmd_dump,
  command  => $command,
  exports  => $exports,
  groups   => $groups,
  parm     => \%parm,
  section  => \%section,

};

# Generate the pm file
croak( 'Unable to process: ', $template->error )
  unless $template->process( 'API_pm.tt', $api_swap, \my $pm );

croak( "Unable to open API.pm: $!" )
  unless open my $PM, '>', './API.pm';

print $PM $pm;

for my $section ( keys %section ) {

  my $method;
  $method->{ $_ } = $command->{ $_ } for @{ $section{ $section } };

  my $section_swap = { section => $section, method_dump => ( dump $method ), };

  croak "Unable to open ./t/200-$section.t: $!"
    unless open my $T, '>', "./t/200-$section.t";

  # Generate the test file
  croak( 'Unable to process: ', $template->error )
      unless $template->process( '200_section-test.t.tt', $section_swap, \my $t );

  print $T $t;

}
