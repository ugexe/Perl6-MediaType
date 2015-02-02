use v6;
use Test;
plan 9;
use MediaType;

# XXX: TODO
# 1.) '.' is used in name: "Wordperfect5.1" and may need to be handled correctly
# 2.) test for sub matches like facet, individual branches


# 1) basic tests on valid/invalid strings
subtest {
    my $ok-str   = 'text/html';
    my $nok-str1 = 'abcd-efgh';
    my $nok-str2 = '/abcd.efgh';
    my $nok-str3 = 'text/.fakex-subtype';

    my ($ok-str-result, $nok-str1-result, $nok-str2-result, $nok-str3-result);
    lives_ok { $ok-str-result   = parse($ok-str)   }
    lives_ok { $nok-str1-result = parse($nok-str1) }
    lives_ok { $nok-str2-result = parse($nok-str2) }
    lives_ok { $nok-str3-result = parse($nok-str3) }

    subtest {
        ok $ok-str-result ~~ Match;
        is $ok-str-result, 'text/html';
        is $ok-str-result.<type>, 'text';
        is $ok-str-result.<subtype>, 'html';
    }, 'valid string: basic match';

    subtest {
        nok $nok-str1-result ~~ Match;
        nok $nok-str1-result;
        nok $nok-str1-result.<type>;
        nok $nok-str1-result.<subtype>;
    }, 'invalid string-1: basic no-match';

    subtest {
        nok $nok-str2-result ~~ Match;
        nok $nok-str2-result;
        nok $nok-str2-result.<type>;
        nok $nok-str2-result.<subtype>;
    }, 'invalid string-2: basic no-match';

    subtest {
        nok $nok-str3-result ~~ Match;
        nok $nok-str3-result;
        nok $nok-str3-result.<type>;
        nok $nok-str3-result.<subtype>;
    }, 'invalid string-3: basic no-match';

}, 'Basic go/no-go tests';


# 2) test `x-` tree vendor with multi-branches (deprecated, but still in use)
{
    my $str = 'example/x-deprecated.branch1.branch2.rn-realaudio';
    subtest {
        my $parsed = parse($str);

        is $parsed.<type>, 'example',      
            'type: example';

        is $parsed.<subtype>,'rn-realaudio', 
            'subtype: rn-realaudio';

        is $parsed.<tree>, 'x-deprecated.branch1.branch2.',
            'tree: x-deprecated.branch1.branch2.';

        nok $parsed.<suffix>, 'no suffix';
    }, $str;
}


# 3) test basic type/subtype with suffix and tree
{
    my $str = 'text/vnd.abc+xml; charset=utf-8';
    subtest {
        my $parsed = parse($str);

        is $parsed.<type>, 'text',      
            'type: text';

        is $parsed.<tree>, 'vnd.',
            'tree: vnd.';

        is $parsed.<subtype>,'abc', 
            'subtype: abc';

        is $parsed.<suffix>, 'xml', 
            'suffix: xml';
    }, $str;
}


# 4) test basic type/subtype with suffix and no tree
{
    my $str = 'image/svg+xml';
    subtest {
        my $parsed = parse($str);

        is $parsed.<type>, 'image',      
            'type: image';

        is $parsed.<subtype>,'svg', 
            'subtype: svg';

        is $parsed.<suffix>, 'xml', 
            'suffix: xml';

        nok $parsed.<tree>, 'no tree';
    }, $str;
}


# 5) test basic type/subtype with multi-branch tree
{
    my $str = 'application/vnd.oasis.opendocument.text';
    subtest {
        my $parsed = parse($str);

        is $parsed.<type>, 'application',      
            'type: application';

        is $parsed.<tree>, 'vnd.oasis.opendocument.', 
            'tree: vnd.oasis.opendocument.';

        is $parsed.<subtype>,'text', 
            'subtype: text';

        nok $parsed.<suffix>, 'no suffix';
    }, $str;
}


# 6) test x- tree with no branches
{
    my $str = 'example/x-deprecated';
    subtest {
        my $parsed = parse($str);

        is $parsed.<type>, 'example',      
            'type: example';

        is $parsed.<tree>, 'x-',
            'tree: x-';

        is $parsed.<subtype>,'deprecated', 
            'subtype: deprecated';

        nok $parsed.<suffix>, 'no suffix';
    }, $str;
}


# 7) test x- tree with no branches and dashes in subtype name
{
    my $str = 'application/x-font-woff';
    subtest {
        my $parsed = parse($str);

        is $parsed.<type>, 'application',      
            'type: application';

        is $parsed.<tree>, 'x-',
            'tree: x-';

        is $parsed.<subtype>,'font-woff', 
            'subtype: font-woff';

        nok $parsed.<suffix>, 'no suffix';
    }, $str;
}


# 8) test x. tree with no branches and dashes in subtype name
{
    my $str = 'application/x.font-woff';
    subtest {
        my $parsed = parse($str);

        is $parsed.<type>, 'application',      
            'type: application';

        is $parsed.<tree>, 'x.',
            'tree: x.';

        is $parsed.<subtype>,'font-woff', 
            'subtype: font-woff';

        nok $parsed.<suffix>, 'no suffix';
    }, $str;
}


# 9) test with params (params not parsed out yet)
{
    my $str = 'video/mp4 codecs="avc1.640028"';
    subtest {
        my $parsed = parse($str);

        is $parsed.<type>, 'video',      
            'type: video';

        is $parsed.<subtype>,'mp4', 
            'subtype: mp4';

        nok $parsed.<tree>,   'no tree';
        nok $parsed.<suffix>, 'no suffix';
    }, $str;
}


done();