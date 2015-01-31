use v6;
use Test;
plan 13;
my $DEBUG = 0;
use MediaType;

# commented out missing functionalty tests
my %valid = %(
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
    'application/x.oasis.opendocument.text' => %(
        type    => 'application',
        # facet   => 'x',
        tree    => 'x.oasis.opendocument.',
        subtype => 'text'
    ),
    'text/plain; charset=utf-8' => %(
        type    => 'text',
        subtype => 'plain',
        # params  => [
        #     'charset' => 'utf-8'
        # ]
    ),
    'video/mp4; codecs="avc1.640028"' => %(
        type    => 'video',
        subtype => 'mp4',
        # params  => [
        #     'codecs' => 'avc1.640028'
        # ]
    )
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