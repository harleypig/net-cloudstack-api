## no critic qw( ErrorHandling::RequireCheckingReturnValueOfEval )
## no critic qw( Lax::RequireExplicitPackage::ExceptForPragmata )
## no critic qw( Modules::RequireExplicitPackage )
## no critic qw( OTRS::ProhibitRequire )
## no critic qw( TestingAndDebugging::RequireUseStrict  )

BEGIN {

  use Test::Most

  #plan skip_all => 'these tests are for testing by the author' 
  plan skip_all => 'This is not working, fix when you have time'
    unless $ENV{AUTHOR_TESTING};

}

eval { require Test::ConsistentVersion };

plan skip_all => 'Test::ConsistentVersion required for these tests'
  if $@;

# XXX: Change this to explicitly checking each individual file.
Test::ConsistentVersion::check_consistent_versions();
