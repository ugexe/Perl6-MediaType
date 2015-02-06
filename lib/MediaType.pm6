module MediaType;
use IETF::RFC_Grammar::MediaType;

# TODO: use Blob ?
constant UTF_32_BE = Buf[uint32].new(0x00FE, 0x00FF);   # ISO-8859-1: ␀␀þÿ (␀ = ASCII null)
constant UTF_32_LE = Buf[uint32].new(0xFF, 0xFE);       # ISO-8859-1: ÿþ␀␀
constant UTF_16_BE = Buf[uint16].new(0xFE, 0xFF);       # ISO-8859-1: þÿ
constant UTF_16_LE = Buf[uint16].new(0xFF, 0xFE);       # ISO-8859-1: ÿþ
constant UTF_8     = Buf[uint8].new(0xEF, 0xBB, 0xBF);  # ISO-8859-1: ï»¿

sub parse(Str $content-type) is export {
    IETF::RFC_Grammar::MediaType.parse($content-type);
}

sub sniff(Buf $data = $?FILE.IO.slurp(:bin).subbuf(0,512)) is export {
    # first, try to run 'parse' to extract
    # Also treat these as unknown: 
    # unknown/unknown", "application/unknown", or "*/*

    # xml is always utf-8 unless state

    # bom should be ignored if the charset is given elsewhere

    return check-bom($data)
}

sub meta_from_html(Str $markup) is export {
    if $markup ~~ / '<' \s* meta \s* [<-[\>]> .]*? 'charset=' <q=[\'\"]>? $<charset>=<[a..z A..Z 0..9 \- \_ \.]>+ $<q>? .*? '>' / {
        return $<charset>;
    }
}

sub check-bom($d) {
    CATCH { when X::OutOfRange {  } }

    if $d.subbuf(0, 2)    eqv UTF_16_BE {       # ISO-8859-1: þÿ
        return 'utf-16be';
    }
    elsif $d.subbuf(0, 2) eqv UTF_16_LE {       # ISO-8859-1: ÿþ
        return 'utf-16le';
    }
    elsif $d.subbuf(0, 3) eqv UTF_8 { # ISO-8859-1: ï»¿
        # not required by utf-8
        return 'utf-8-strict';
    }
}