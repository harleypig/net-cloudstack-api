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

eval { require Test::Version };

plan skip_all => 'Test::Version required for these tests'
  if $@;

my @imports = qw( version_all_ok );

my $params = {
  is_strict   => 0,
  has_version => 1,
  multiple    => 0,

};

push @imports, $params
  if version->parse( $Test::Version::VERSION ) >= version->parse( '1.002' );

Test::Version->import( @imports );

version_all_ok;
done_testing;
