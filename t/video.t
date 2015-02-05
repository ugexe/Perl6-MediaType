use v6;
use Test;
plan 4;
use MediaType;

# https://tools.ietf.org/html/rfc6381

# 1)
{
    my $str = 'video/mp4; codecs="avc1.640028"';
    subtest {
        my $parsed = parse($str);

        is $parsed.<type>, 'video';
        is $parsed.<subtype>,'mp4';

        nok $parsed.<tree>;
        nok $parsed.<suffix>;
    }, $str;
}


# 2)
{
    my $str = Q{video/3gpp2; codecs="sevc, s263"};
    subtest {
        my $parsed = parse($str);

        is $parsed.<type>, 'video';
        is $parsed.<subtype>,'3gpp2';
        is $parsed.<params>.elems, 1;
        is $parsed.<params>.[0].<param-name>, 'codecs';
        is $parsed.<params>.[0].<param-values>.<param-value>.[0], 'sevc';
        is $parsed.<params>.[0].<param-values>.<param-value>.[1], 's263';

        nok $parsed.<tree>;
        nok $parsed.<suffix>;
    }, $str;
}


# 3)
{
    my $str = Q{video/3gpp2; codecs=mp4v.20.9};
    subtest {
        my $parsed = parse($str);

        is $parsed.<type>, 'video';
        is $parsed.<subtype>,'3gpp2';
        is $parsed.<params>.elems, 1;
        is $parsed.<params>.[0].<param-name>, 'codecs';
        is $parsed.<params>.[0].<param-values>.<param-value>.[0], 'mp4v.20.9';

        nok $parsed.<tree>;
        nok $parsed.<suffix>;
    }, $str;
}


# 4)
{
    my $str = Q{video/3gpp2; codecs="mp4v.20.9, mp4a.E1"};
    subtest {
        my $parsed = parse($str);

        is $parsed.<type>, 'video';
        is $parsed.<subtype>,'3gpp2';
        is $parsed.<params>.elems, 1;
        is $parsed.<params>.[0].<param-name>, 'codecs';
        is $parsed.<params>.[0].<param-values>.<param-value>.[0], 'mp4v.20.9';
        is $parsed.<params>.[0].<param-values>.<param-value>.[1], 'mp4a.E1';
        nok $parsed.<tree>;
        nok $parsed.<suffix>;
    }, $str;
}


done();
