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

eval { Test::Spelling };

plan skip_all => 'Test::Spelling required for these tests'
  if $@;

use Pod::Wordlist;

set_spell_cmd( 'aspell list' );
add_stopwords( <DATA> );
all_pod_files_spelling_ok( qw( bin lib  ) );

__DATA__
LICENCE
MERCHANTABILITY
Alan
Young
harleypig
lib
Net
CloudStack
API
