## no critic qw( ErrorHandling::RequireCheckingReturnValueOfEval )
## no critic qw( Lax::RequireExplicitPackage::ExceptForPragmata )
## no critic qw( Modules::RequireExplicitPackage )
## no critic qw( OTRS::ProhibitRequire )
## no critic qw( TestingAndDebugging::RequireUseStrict  )

use Test::Most;

eval { require Test::Pod };

if ( $@ ) {
  my $msg = 'Test::Pod required to criticize code.';
  plan skip_all => $msg;
}

# XXX: Change this to explicitly checking each individual file.
Test::Pod::all_pod_files_ok();
