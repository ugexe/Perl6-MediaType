use v6;

grammar IETF::RFC_Grammar::RFC2045 {
    token TOP {
        ^ <type> '/' <tree>? <subtype> ['+' <suffix>]? [';' \s* <parameter>]* $
    }


    token type { [:i <restricted-name>] }

    # optional: tree
    token tree             { <facet> <facet-sep> [<branch> '.']* }
    proto token facet      {*}
    token facet:sym<vnd>   { <after <!alnum>> <sym> <before '.'>         }
    token facet:sym<prs>   { <after <!alnum>> <sym> <before '.'>         }
    token facet:sym<x>     { <after <!alnum>> <sym> <before ['.' | '-']> } # '.' should go in
    token facet:sym<X>     { <after <!alnum>> <sym> <before ['.' | '-']> } # RFC6838 only
    proto token facet-sep  {*} # try to make 'token tree' less ugly with 'x-'
    token facet-sep:sym<-> { <after x> <sym> <before [<branch> | <subtype>]> }
    token facet-sep:sym<.> { <sym> <before [<branch> | <subtype>]>           }
    token branch           { <restricted-name> <before '.'> } 

    token subtype { [:i <restricted-name>] }

    # optional: suffix
    token suffix { <after [<subtype> '+']> <alnum>+ }

    token parameter {
        <attribute> <attribute-concat>? '=' \s* <values> \s*
    }

    token attribute { <restricted-name>  }
    token attribute-concat { [\* \d+ \*?] }
    token values { 
        $<quote>=[\' | \"]? 
        <value> [',' \s* <value>]* 
        [<!after \\> $<quote>]? 
    }
    token value  { <+alnum +[\.\-\s] -[,]>+ }

    # valid characters
    token restricted-name  { <+alnum -[\-\_]> <restricted-chars> ** 0..127 }
    token restricted-chars { <+alnum +[!#$&^_-] -[\.\+]>                   }
}


grammar IETF::RFC_Grammar::RFC6838 is IETF::RFC_Grammar::RFC2045 {

}
# for only allowing registered types
#grammar IETF::RFC_Grammar::MediaType::Type::Strict is IETF::RFC_Grammar::MediaType {
#    proto token type {*}
#    token type:sym<application/> { <sym> }
#    token type:sym<audio/>       { <sym> }
#    token type:sym<example/>     { <sym> }
#    token type:sym<image/>       { <sym> }
#    token type:sym<message/>     { <sym> }
#    token type:sym<model/>       { <sym> }
#    token type:sym<multipart/>   { <sym> }
#    token type:sym<text/>        { <sym> }
#    token type:sym<video/>       { <sym> }
#}