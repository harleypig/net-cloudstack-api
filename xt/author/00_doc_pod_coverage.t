## no critic qw( ErrorHandling::RequireCheckingReturnValueOfEval )
## no critic qw( Lax::RequireExplicitPackage::ExceptForPragmata )
## no critic qw( Modules::RequireExplicitPackage )
## no critic qw( OTRS::ProhibitRequire )
## no critic qw( TestingAndDebugging::RequireUseStrict  )

use Test::Most;

eval { require Test::Pod::Coverage };

if ( $@ ) {
  my $msg = 'Test::Pod::Coverage required to test pod coverage.';
  plan skip_all => $msg;
}

Test::Pod::Coverage->import;

my @packages = qw( Brokkr Brokkr::Options Brokkr::Server );

plan tests => scalar @packages;

TODO: {

  local $TODO = 'Pod Coverage';

  #Test::Pod::Coverage::all_pod_coverage_ok({ coverage_class => 'Pod::Coverage::TrustPod' });
  #all_pod_coverage_ok({ coverage_class => 'Pod::Coverage::TrustPod' });

  pod_coverage_ok( $_, "$_ is covered" ) for @packages;

}
