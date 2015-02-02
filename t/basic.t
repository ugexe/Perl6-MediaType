use v6;
use Test;
plan 18;
my $DEBUG = 0;
use MediaType;

# commented out missing functionalty tests
my %valid = %(
    'example/x-deprecated.branch1.branch2.rn-realaudio' => %(
        type    => 'example',
        # facet   => 'x',
        tree    => 'x-deprecated.branch1.branch2.',
        subtype => 'rn-realaudio'
    ),    
    'image/svg+xml' => %(
        type    => 'image',
        subtype => 'svg',
        suffix  => 'xml'
    ),
    'application/vnd.oasis.opendocument.text' => %(
        type    => 'application',
        # facet   => 'vnd',
        tree    => 'vnd.oasis.opendocument.',
        subtype => 'text'
    ),    
    'example/x-deprecated' => %(
        type    => 'example',
        # facet   => 'x',
        subtype => 'x-deprecated'
    ),
    'text/vnd.abc+xml; charset=utf-8' => %(
        type    => 'text',
        subtype => 'abc',
        tree    => 'vnd.',
        suffix  => 'xml',
        # params  => [
        #     'charset' => 'utf-8'
        # ]
    ),
    'text/plain; charset=utf-8' => %(
        type    => 'text',
        subtype => 'plain',
        # params  => [
        #     'charset' => 'utf-8'
        # ]
    ),
    'video/mp4 codecs="avc1.640028"' => %(
        type    => 'video',
        subtype => 'mp4',
        # params  => [
        #     'codecs' => 'avc1.640028'
        # ]
    ),
    'application/x-font-woff' => %(
        type    => 'application',
        subtype => 'x-font-woff',
    ),

);

for %valid.kv -> $content-type, %expected {
    my $mt = parse($content-type) or fail "fail";
    for $mt.kv -> $k, $v {
        if $DEBUG {
            say "\n\n-------\nitem: {$k}\nExpecting: {%valid{$content-type}.hash.{$k}}\n--------";
            say "Got: {$v.Str}";
            say "-------\nend {$k}\n--------";
        }

        is $v.Str, %valid{$content-type}.{$k}, $content-type;
    }
}


done();