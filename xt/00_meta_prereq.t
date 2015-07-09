## no critic qw( ErrorHandling::RequireCheckingReturnValueOfEval )
## no critic qw( Lax::RequireExplicitPackage::ExceptForPragmata )
## no critic qw( Modules::RequireExplicitPackage )
## no critic qw( OTRS::ProhibitRequire )
## no critic qw( TestingAndDebugging::RequireUseStrict  )

use Test::Most;

unless ( exists $ENV{TEST_PREREQ} ) {
  my $msg = 'Set TEST_PREREQ if you want to test with Test::Prereq';
  plan skip_all => $msg;
}

eval { require Test::Prereq::Build };

if ( $@ ) {
  my $msg = 'Test::Prereq::Build required to test prerequisites.';
  plan skip_all => $msg;
}

Test::Prereq::Build::prereq_ok();
