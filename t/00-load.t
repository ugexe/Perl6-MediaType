use v6;
use Test;
plan 1;

subtest {
    lives_ok { use IETF::RFC_Grammar::RFC2045 };
    lives_ok { use IETF::RFC_Grammar::RFC6838 };
    lives_ok { use MediaType };
}, "Sanity tests";

done();
