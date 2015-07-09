## no critic qw( ErrorHandling::RequireCheckingReturnValueOfEval )
## no critic qw( Lax::RequireExplicitPackage::ExceptForPragmata )
## no critic qw( Modules::RequireExplicitPackage )
## no critic qw( OTRS::ProhibitRequire )
## no critic qw( TestingAndDebugging::RequireUseStrict  )

use Test::Most;
use File::Find::Rule;

eval { require Test::Perl::Critic };

if ( $@ ) {
  my $msg = 'Test::Perl::Critic required to criticize code.';
  plan( skip_all => $msg );
}

my @binfiles = File::Find::Rule->file()->in( qw( bin ) );
my @files = File::Find::Rule->file()->name( '[^\.]+', '*.p[ml]', '*.t' )->in( qw( lib t ) );

plan tests => scalar @binfiles + scalar @files;

my $rcfile = '.perlcriticrc';
Test::Perl::Critic->import( -profile => $rcfile );

TODO: {

  local $TODO = 'Need to fix these as time permits.';

  critic_ok( $_, "PerlCritic test for $_" ) for @binfiles, @files;

}
