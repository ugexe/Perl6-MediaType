use v6;
use Test;
plan 13;

use MediaType;

my %valid = %(
    'image/svg+xml'=> %(
        type-name => 'image',
        sub-type  => 'svg',
        suffix    => 'xml'
    ),
    'application/vnd.oasis.opendocument.text'=> %(
        type-name => 'application',
        facet     => 'vnd',
        producer  => 'oasis.opendocument',
        sub-type  => 'text'
    ),
    'text/plain; charset=utf-8'=> %(
        type-name => 'text',
        sub-type  => 'plain',
        params    => [
            'charset' => 'utf-8'
        ]
    ),
    'video/mp4; codecs="avc1.640028"' => %(
        type-name => 'video',
        sub-type  => 'mp4',
        params    => [
            'codecs' => 'avc1.640028'
        ]
    )
);

for %valid.kv -> $content-type, %expected {
    my $mt = parse($content-type);
    for %expected.kv -> $key, $value {
        is $mt{$key}, $value, $content-type;
    }
}

done();