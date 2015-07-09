package Net::CloudStack::API;

# ABSTRACT: Basic request and response handling for calls to a CloudStack service.

## no critic qw( ValuesAndExpressions::RestrictLongStrings ClassHierarchies::ProhibitAutoloading )
## no critic qw( ValuesAndExpressions::ProhibitAccessOfPrivateData )

=head1 DESCRIPTION

This module handles parameter checking for the various calls available from a cloudstack service.

Probably should include some explanatory text here about how this file is generated.

=head1 SYNOPSIS

  use Net::CloudStack::API;
  my $cs = Net::CloudStack::API->new;
  $cs->api( 'see Net::CloudStack docs for setup details' );
  print $cs->listVolumes;

  use Net::CloudStack::API 'listVolumes';
  Net::CloudStack::API::api( 'see Net::CloudStack docs for setup details' );
  print listVolume();

  use Net::CloudStack::API ':Volume';
  Net::CloudStack::API::api( 'see Net::CloudStack docs for setup details' );
  print listVolumes();

=head1 METHODS

##############################################################################

#{
#  # Setup exports
#
#  my ( $exports, $groups, @all );
#
#  for my $cmd ( keys %$command ) { ## no critic qw( References::ProhibitDoubleSigils )
#
#    $exports->{ $cmd } = \&_generate_method;
#    push @{ $groups->{ $command->{ $cmd }{ section } } }, $cmd;
#    push @all, $cmd;
#
#  }
#
#  $groups->{ all } = \@all;
#
#  my $config = {
#
#    exports => $exports,
#    groups  => $groups,
#
#  };
#
#  Sub::Exporter::setup_exporter( $config );
#
###############################################################################
#  # Setup OO interface
#
#  # handle either a list of elements or a hashref
#
#  sub new { ## no critic qw( Subroutines::RequireArgUnpacking )
#    return bless {}, ref $_[0] || $_[0];
#  }
#
#  our $AUTOLOAD;
#
#  sub AUTOLOAD { ## no critic qw( Subroutines::RequireArgUnpacking )
#
#    my $self = $_[0];
#
#    ( my $method = $AUTOLOAD ) =~ s/^.*:://;
#
#    croak "unknown method $method"
#        unless exists $command->{ $method };
#
#    no strict 'refs'; ## no critic qw( TestingAndDebugging::ProhibitNoStrict )
#    *$AUTOLOAD = $self->_generate_method( $method ); ## no critic qw( References::ProhibitDoubleSigils )
#
#    goto &$AUTOLOAD; ## no critic qw( References::ProhibitDoubleSigils )
#
#  }
#
#  sub DESTROY { }
#
###############################################################################
#  # Utility methods
#
#  sub _generate_method {
#
#    my ( undef, $cmd ) = @_;
#
#    croak "Unknown method: $cmd"
#        unless exists $command->{ $cmd };
#
#    # FIXME: allow caller to pass in their own validation structures.
#    # FIXME: more robust handling of at least the obvious data types.
#    my %validate;
#
#    # Only build this part of the hash once ...
#    $validate{ spec }{ $_ } = { type => SCALAR } for keys %{ $command->{ $cmd }{ request }{ required } };
#    $validate{ spec }{ $_ } = { type => SCALAR, optional => 1 } for keys %{ $command->{ $cmd }{ request }{ optional } };
#
#    return sub {
#
#      my $self = '';
#      $self = shift
#          if blessed $_[0];
#
#      $validate{ params } = \@_;
#
#      my %arg;
#      %arg = validate_with( %validate )
#          if keys %{ $validate{ spec } };
#
#      my @proc = $cmd;
#
#      if ( keys %arg ) {
#
#        push @proc, join q{&}, map { "$_=$arg{$_}" } keys %arg;
#
#      }
#
#      my $api = blessed $self ? $self->api : api();
#
#      $api->proc( @proc );
#
#      return $api->send_request eq 'yes' ? $api->response : $api->url;
#
#    };
#  } ## end sub _generate_method
#
#  {  # Hide api stuff
#
#    my $api;
#
#    sub api { ## no critic qw( Subroutines::RequireArgUnpacking )
#
#      if ( ! @_ || ( @_ == 1 && blessed $_[0] eq __PACKAGE__ ) ) {
#
#        croak 'api not setup correctly'
#            unless defined $api && blessed $api eq 'Net::CloudStack';
#
#        return $api;
#
#      }
#
#      my $args
#          = ( $_[0] eq __PACKAGE__ || blessed $_[0] eq __PACKAGE__ )
#          ? $_[1]
#          : $_[0];
#
#      croak 'args must be a hashref'
#          if ref $args && ref $args ne 'HASH';
#
#      $api = Net::CloudStack->new( $args )
#          if ! defined $api || blessed $api ne 'Net::CloudStack';
#
#      return $api
#          unless ref $args;
#
#      $api->$_( $args->{ $_ } ) for keys %$args; ## no critic qw( References::ProhibitDoubleSigils )
#
#      return $api;
#
#    } ## end sub api
#  }  # End hiding api stuff
#
#}  # End general hiding

1;
