module MediaType;
use IETF::RFC_Grammar::MediaType;

sub parse(Str $content-type) is export {
    IETF::RFC_Grammar::MediaType.parse($content-type);
}

sub sniff(Blob $data) is export {
    # first, try to run 'parse' to extract
    # Also treat these as unknown: 
    # unknown/unknown", "application/unknown", or "*/*

    # xml is always utf-8 unless state

    # bom should be ignored if the charset is given elsewhere

    # HTTP precedence
    # The HTML5 specification was recently changed to say that the byte-order mark 
    # should override any encoding declaration in the HTTP header when detecting the 
    # encoding of an HTML page. This can be very useful when the author of the page 
    # cannot control the character encoding setting of the server, or is unaware of 
    # its effect, and the server is declaring pages to be in an encoding other than 
    # UTF-8. If the BOM has a higher precedence than the HTTP headers, the page should 
    # be correctly identified as UTF-8. 

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