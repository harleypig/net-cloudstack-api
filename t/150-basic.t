
use Test::Most tests => 1;
#use Test::NoWarnings;

eval "use Net::CloudStack::API; 1" or BAIL_OUT $@;
eval "use Net::CloudStack::API 'listVirtualMachines'; 1" or BAIL_OUT $@;
eval "use Net::CloudStack::API ':all'; 1" or BAIL_OUT $@;

# Need to do
# eval "use Net::CloudStack::API 'badmethod'" ...
# eval "use Net::CloudStack::API ':badgroup'" ...

ok( 1, 'yay' );
