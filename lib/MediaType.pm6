module MediaType;
use IETF::RFC_Grammar::RFC2045;


sub parse(Str $content-type) is export {
    IETF::RFC_Grammar::RFC2045.parse($content-type);
}


sub sniff(Blob $data) is export {
    return check-bom($data);
}

sub meta_from_html(Str $markup) is export {
    if $markup ~~ / '<' \s* meta \s* [<-[\>]> .]*? 'charset=' <q=[\'\"]>? $<charset>=<[a..z A..Z 0..9 \- \_ \.]>+ $<q>? .*? '>' / {
        return $<charset>;
    }
}

sub check-bom(Blob $data) {
    given $data.subbuf(0,4).decode('latin-1') {
        when /^ 'ÿþ␀␀'  / { return 'utf-32-le'     } # no test
        when /^ '␀␀þÿ'  / { return 'utf-32-be'     } # no test
        when /^ 'þÿ'   / { return 'utf-16-be'     }
        when /^ 'ÿþ'   / { return 'utf-16-le'     }
        when /^ 'ï»¿'  / { return 'utf-8'         }
        when /^ '÷dL'  / { return 'utf-1'         } # no test
        when /^ 'Ýsfs' / { return 'utf-ebcdic'    } # no test
        when /^ '␎þÿ'   / { return 'scsu'          } # no test
        when /^ 'ûî('  / { return 'bocu-1'        } # no test
        when /^ '„1•3' / { return 'gb-18030'      } # test marked :todo
        when /^ '+/v' <[89/+]> / { return 'utf-7' }

        default { return False }
    }
}
