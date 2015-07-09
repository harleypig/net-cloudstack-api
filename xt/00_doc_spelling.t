## no critic qw( ErrorHandling::RequireCheckingReturnValueOfEval )
## no critic qw( Lax::RequireExplicitPackage::ExceptForPragmata )
## no critic qw( Modules::RequireExplicitPackage )
## no critic qw( OTRS::ProhibitRequire )
## no critic qw( TestingAndDebugging::RequireUseStrict  )

use Test::Most;

eval { require Test::Spelling };

if ( $@ ) {
  my $msg = 'Test::Spelling required to check spelling.';
  plan skip_all => $msg;
}

# XXX: Change this to explicitly checking each individual file.
Test::Spelling::all_pod_files_spelling_ok();
