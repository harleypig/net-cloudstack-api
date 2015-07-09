## no critic qw( ErrorHandling::RequireCheckingReturnValueOfEval )
## no critic qw( Lax::RequireExplicitPackage::ExceptForPragmata )
## no critic qw( Modules::RequireExplicitPackage )
## no critic qw( OTRS::ProhibitRequire )
## no critic qw( TestingAndDebugging::RequireUseStrict  )

use Test::Most;
use File::Find::Rule;

eval { require Test::EOL };

if ( $@ ) {
  my $msg = 'Test::EOL required to criticize code.';
  plan skip_all => $msg;
}

my @binfiles = File::Find::Rule->file()->in( qw( bin ) );
my @files = File::Find::Rule->file()->name( '[^\.]+', '*.p[ml]', '*.t' )->in( qw( lib t ) );

plan tests => scalar @binfiles + scalar @files;

Test::EOL::eol_unix_ok( $_, "Line endings ok for $_", { trailing_whitespace => 1 } ) for @binfiles, @files;
