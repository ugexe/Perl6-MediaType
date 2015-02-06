use v6;
# RFC: https://tools.ietf.org/html/rfc6838

grammar IETF::RFC_Grammar::MediaType {
    token TOP {
        ^ <type> '/' <tree>? <subtype> ['+' <suffix>]? [';' <params>]* $
    }

    # main type
    token type { <restricted-name> }

    # optional: tree
    token tree             { <facet> <facet-sep> [<branch> '.']* }
    proto token facet      {*}
    token facet:sym<vnd>   { <after <!alnum>> <sym> <before '.'>         }
    token facet:sym<prs>   { <after <!alnum>> <sym> <before '.'>         }
    token facet:sym<x>     { <after <!alnum>> <sym> <before ['.' | '-']> }
    proto token facet-sep  {*} # try to make 'token tree' less ugly with 'x-'
    token facet-sep:sym<-> { <after x> <sym> <before [<branch> | <subtype>]> }
    token facet-sep:sym<.> { <sym> <before [<branch> | <subtype>]>           }
    token branch           { <restricted-name> <before '.'> } 

    # subtype
    token subtype { <restricted-name> }

    # optional: suffix
    token suffix { <after [<subtype> '+']> <alnum>+ }

    # todo: https://tools.ietf.org/html/rfc2231
    token params {
        \s* <param-name> \s* <param-sep> \s* <param-values> \s*
    }

    token param-name   { <restricted-name> }
    token param-values { 
        $<quote>=[\' | \"]? 
        <param-value> [',' \s* <param-value>]* 
        [<!after \\> $<quote>]? 
    }
    token param-value  { <+alnum +[\.\-\s] -[,]> + }
    token param-sep    { [\* \d \*?]? '=' }

    # valid characters
    token restricted-name  { <+alnum -[\-\_]> <restricted-chars> ** 0..127 }
    token restricted-chars { <+alnum +[!#$&^_-] -[\.\+]>                   }
}


# for only allowing registered types
grammar IETF::RFC_Grammar::MediaType::Type::Strict is IETF::RFC_Grammar::MediaType {
    proto token type {*}
    token type:sym<application/> { <sym> }
    token type:sym<audio/>       { <sym> }
    token type:sym<example/>     { <sym> }
    token type:sym<image/>       { <sym> }
    token type:sym<message/>     { <sym> }
    token type:sym<model/>       { <sym> }
    token type:sym<multipart/>   { <sym> }
    token type:sym<text/>        { <sym> }
    token type:sym<video/>       { <sym> }
}