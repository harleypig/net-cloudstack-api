## no critic qw( ErrorHandling::RequireCheckingReturnValueOfEval )
## no critic qw( Lax::RequireExplicitPackage::ExceptForPragmata )
## no critic qw( Modules::RequireExplicitPackage )
## no critic qw( OTRS::ProhibitRequire )
## no critic qw( TestingAndDebugging::RequireUseStrict  )

use Test::Most;

eval { require Test::Synopsis };

if ( $@ ) {
  my $msg = 'Test::Synopsis required to check spelling.';
  plan skip_all => $msg;
}

TODO: {
  local $TODO = 'Add synopsis to documentation.';

  # XXX: Change this to explicitly checking each individual file.
  Test::Synopsis::all_synopsis_ok();
}
