## no critic qw( ErrorHandling::RequireCheckingReturnValueOfEval )
## no critic qw( Lax::RequireExplicitPackage::ExceptForPragmata )
## no critic qw( Modules::RequireExplicitPackage )
## no critic qw( OTRS::ProhibitRequire )
## no critic qw( TestingAndDebugging::RequireUseStrict  )

use Test::Most tests => 4;

eval { require Test::Cmd };

if ( $@ ) {
  my $msg = 'Test::Cmd required to criticize code.';
  plan skip_all => $msg;
}

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
