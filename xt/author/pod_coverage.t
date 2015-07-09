## no critic qw( ErrorHandling::RequireCheckingReturnValueOfEval )
## no critic qw( Lax::RequireExplicitPackage::ExceptForPragmata )
## no critic qw( Modules::RequireExplicitPackage )
## no critic qw( OTRS::ProhibitRequire )
## no critic qw( TestingAndDebugging::RequireUseStrict  )

BEGIN {

  use Test::Most

  plan skip_all => 'these tests are for testing by the author'
    unless $ENV{AUTHOR_TESTING};

}

eval { require Test::Pod::Coverage };

plan skip_all => 'Test::Pod::Coverage required for these tests'
  if $@;

Test::Pod::Coverage->import;

my @packages = qw( Net::CloudStack::API );

plan tests => scalar @packages;

TODO: {

  local $TODO = 'Pod Coverage';

  #Test::Pod::Coverage::all_pod_coverage_ok({ coverage_class => 'Pod::Coverage::TrustPod' });
  #all_pod_coverage_ok({ coverage_class => 'Pod::Coverage::TrustPod' });

  pod_coverage_ok( $_, "$_ is covered" ) for @packages;

}
