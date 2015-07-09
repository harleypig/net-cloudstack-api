## no critic qw( ErrorHandling::RequireCheckingReturnValueOfEval )
## no critic qw( Lax::RequireExplicitPackage::ExceptForPragmata )
## no critic qw( Modules::RequireExplicitPackage )
## no critic qw( OTRS::ProhibitRequire )
## no critic qw( TestingAndDebugging::RequireUseStrict  )

use Test::Most;
use File::Find::Rule;

eval { require Test::Compile };

if ( $@ ) {
  my $msg = 'Test::Compile required to criticize code.';
  plan skip_all => $msg;
}

my @binfiles = File::Find::Rule->file()->in( qw( bin ) );
my @plfiles  = File::Find::Rule->file()->name( '*.pl', '*.t' )->in( qw( lib t ) );
my @pmfiles  = File::Find::Rule->file()->name( '*.pm' )->in( qw( lib t ) );

plan tests => scalar @binfiles + scalar @plfiles + scalar @pmfiles;

Test::Compile::pl_file_ok( $_, "$_ compiles" ) for @binfiles, @plfiles;
Test::Compile::pm_file_ok( $_, "$_ compiles" ) for @pmfiles;
