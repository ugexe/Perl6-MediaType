use v6;
use Test;
plan 1;
my $DEBUG = 1;
use MediaType;

subtest {
    # 13 test cases
    my %valid = %(
        'image/svg+xml'=> %(
            type-name     => 'image',
            subtype-name  => 'svg',
            suffix        => 'xml'
        ),
        'application/vnd.oasis.opendocument.text'=> %(
            type-name => 'application',
            facet     => 'vnd',
            tree      => 'vnd.oasis.opendocument.',
            subtype-name  => 'text'
        ),
        'text/plain; charset=utf-8'=> %(
            type-name     => 'text',
            subtype-name  => 'plain',
            params        => [
                'charset' => 'utf-8'
            ]
        ),
        'video/mp4; codecs="avc1.640028"' => %(
            type-name     => 'video',
            subtype-name  => 'mp4',
            params        => [
                'codecs' => 'avc1.640028'
            ]
        )
    );

    for %valid.kv -> $content-type, %expected {
        my $mt = parse($content-type);
        for $mt.kv -> $k, $v {
            say "\n\n-------\nitem: {$k}\nExpecting: {%valid{$content-type}.hash.{$k}}\n--------" if $DEBUG;
            say "Got: {$v.Str}" if $DEBUG;
            is $v.Str, %valid{$content-type}.hash.{$k}, $content-type;
            say "-------\nend {$k}\n--------" if $DEBUG;    
        }
    }
}, 'Basic string parsing';

done();