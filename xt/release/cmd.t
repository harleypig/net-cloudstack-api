## no critic qw( ErrorHandling::RequireCheckingReturnValueOfEval )
## no critic qw( Lax::RequireExplicitPackage::ExceptForPragmata )
## no critic qw( Modules::RequireExplicitPackage )
## no critic qw( OTRS::ProhibitRequire )
## no critic qw( TestingAndDebugging::RequireUseStrict  )

BEGIN {

  use Test::Most;

  plan skip_all => 'these tests are for release candidate testing'
    unless $ENV{RELEASE_TESTING};

}

eval { require Test::Cmd };

plan skip_all => 'Test::Cmd required for these tests'
  if $@;

plan tests => 4;

Test::Cmd->import();

my $lsout = q!bin
brokkr.conf
lib
t!;

my $test = Test::Cmd->new( prog => 'ls', workdir => q{.} );

SKIP: {
  ## no critic qw( ValuesAndExpressions::ProhibitMagicNumbers )
  skip 'could not create test object', 4 unless defined $test;

  isa_ok( $test, 'Test::Cmd', 'created Test::Cmd object' );

  $test->run( chdir => $test->curdir );
  ok( $? == 0, 'ls ran ok' );

  is( $test->stdout, $lsout, 'ls output matched' );
  is( $test->stderr, '',     'ls had no errors' );
}
