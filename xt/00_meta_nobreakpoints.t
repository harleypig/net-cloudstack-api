## no critic qw( ErrorHandling::RequireCheckingReturnValueOfEval )
## no critic qw( Lax::RequireExplicitPackage::ExceptForPragmata )
## no critic qw( Modules::RequireExplicitPackage )
## no critic qw( OTRS::ProhibitRequire )
## no critic qw( TestingAndDebugging::RequireUseStrict  )

use Test::Most;
use File::Find::Rule;

eval { require Test::NoBreakpoints };

if ( $@ ) {
  my $msg = 'Test::NoBreakpoints required to check for soft breakpoints.';
  plan skip_all => $msg;
}

my @binfiles = File::Find::Rule->file()->in( qw( bin ) );
my @files = File::Find::Rule->file()->name( '[^\.]+', '*.p[ml]', '*.t' )->in( qw( lib t ) );

plan tests => scalar @binfiles + scalar @files;

Test::NoBreakpoints::no_breakpoints_ok( $_, "No breakpoints found in $_" ) for @binfiles, @files;
