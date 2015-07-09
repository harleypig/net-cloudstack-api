## no critic qw( ErrorHandling::RequireCheckingReturnValueOfEval )
## no critic qw( Lax::RequireExplicitPackage::ExceptForPragmata )
## no critic qw( Modules::RequireExplicitPackage )
## no critic qw( OTRS::ProhibitRequire )
## no critic qw( TestingAndDebugging::RequireUseStrict  )

use Test::Most;
use File::Find::Rule;

eval { require Test::Vars };

if ( $@ ) {
  my $msg = 'Test::Vars required to criticize code.';
  plan skip_all => $msg;
}

my @files = File::Find::Rule->file()->name( '*.pm' )->in( qw( lib t ) );

plan tests => scalar @files;

my %ignore = ( ignore_vars => [qw( $signal_int $signal_hup )] );

Test::Vars::vars_ok( $_, %ignore ) for @files;
