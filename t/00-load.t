use v6;
use Test;
plan 1;

subtest {
    lives_ok { use IETF::RFC_Grammar::MediaType };
    lives_ok { use MediaType };
}, "Sanity tests";

done();
