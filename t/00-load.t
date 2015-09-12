use v6;
use Test;
plan 1;

subtest {
    lives-ok { use IETF::RFC_Grammar::RFC2045 };
    lives-ok { use IETF::RFC_Grammar::RFC6838 };
    lives-ok { use MediaType };
}, "Sanity tests";
