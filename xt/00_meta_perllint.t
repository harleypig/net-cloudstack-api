## no critic qw( ErrorHandling::RequireCheckingReturnValueOfEval )
## no critic qw( Lax::RequireExplicitPackage::ExceptForPragmata )
## no critic qw( Modules::RequireExplicitPackage )
## no critic qw( OTRS::ProhibitRequire )
## no critic qw( TestingAndDebugging::RequireUseStrict  )

use Test::Most;

unless ( exists $ENV{TEST_PERLLINT} ) {
  my $msg = 'Set TEST_PERLLINT if you want to test with Perl::Lint';
  plan skip_all => $msg;
}

eval { require Test::Perl::Lint };

if ( $@ ) {
  my $msg = 'Test::Perl::Lint required to check code.';
  plan skip_all => $msg;
}

Test::Perl::Lint::all_policies_ok( { targets => [qw( bin lib )], } );
