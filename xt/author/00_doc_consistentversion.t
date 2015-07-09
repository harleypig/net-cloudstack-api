## no critic qw( ErrorHandling::RequireCheckingReturnValueOfEval )
## no critic qw( Lax::RequireExplicitPackage::ExceptForPragmata )
## no critic qw( Modules::RequireExplicitPackage )
## no critic qw( OTRS::ProhibitRequire )
## no critic qw( TestingAndDebugging::RequireUseStrict  )

use Test::Most;

plan skip_all => 'This is not working, fix when you have time.';

eval { require Test::ConsistentVersion };

if ( $@ ) {
  my $msg = 'Test::ConsistentVersion required to criticize code.';
  plan skip_all => $msg;
}

# XXX: Change this to explicitly checking each individual file.
Test::ConsistentVersion::check_consistent_versions();
