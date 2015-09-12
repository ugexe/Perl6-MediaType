use v6;
use Test;
plan 2;
use MediaType;


subtest {
    my $html;
    
    $html = q{<html><head> <meta charset='utf-8'> </head><body><b> hello </body></html>};
    is meta_from_html($html), "utf-8", "HTML 5 style";

    $html = q{<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">};
    is meta_from_html($html), "UTF-8", 'Old skool HTML style inside content attribute';

    $html = q{<meta http-equiv="Content-Type" content="text/html; charset='utf-8'">};
    is meta_from_html($html), "utf-8", 'Quoted charset inside content attribute';

    $html = q{<meta http-equiv="Content-Type" content="text/html; > charset=utf-8">};
    nok meta_from_html($html), "bogus html tag";
}, '<meta> charset';


subtest {
    my $bom-test-dir = "{$?FILE.IO.dirname}/encoded-files/bom";

    my $utf8-file = "{$bom-test-dir}/utf-8".IO;
    my Blob $utf8 = $utf8-file.slurp(:bin, :enc("Unicode")).subbuf(0,512);
    is sniff($utf8), 'utf-8', 'utf8';

    my $utf16le-file = "{$bom-test-dir}/utf-16-le".IO;
    my Blob $utf16le = $utf16le-file.slurp(:bin, :enc("Unicode")).subbuf(0,512);
    is sniff($utf16le), 'utf-16-le', 'utf-16-le';

    my $utf16be-file = "{$bom-test-dir}/utf-16-be".IO;
    my Blob $utf16be = $utf16be-file.slurp(:bin, :enc("Unicode")).subbuf(0,512);
    is sniff($utf16be), 'utf-16-be', 'utf-16-be';

    my $utf7-file = "{$bom-test-dir}/utf-7".IO;
    my Blob $utf7 = $utf7-file.slurp(:bin, :enc("Unicode")).subbuf(0,512);
    is sniff($utf7), 'utf-7', 'utf-7';

    my $gb18030-file = "{$bom-test-dir}/gb-18030".IO;
    my Blob $gb18030 = $gb18030-file.slurp(:bin).subbuf(0,512);
    todo("Figure out how to read file as Buf[uint16] not Buf[uint8]");
    is sniff($gb18030), 'gb-18030', 'gb-18030';

}, 'Byte Order Mark';
