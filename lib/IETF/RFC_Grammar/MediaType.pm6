use v6;
 # use Grammar::Debugger;
# RFC: https://tools.ietf.org/html/rfc6838

grammar IETF::RFC_Grammar::MediaType {
    token TOP {
        ^ <type> '/' <tree>? <subtype> ['+' <suffix>]? .* $ 
    }

    # main type
    token type {
        <restricted-name>
    }

    # optional: tree
    token tree {
        [<facet> <.facet-sep>] [<branch> '.']*
    }
    proto token facet {*}
    token facet:sym<vnd> {
        <sym> <before '.'>
    }
    token facet:sym<prs> {
        <sym> <before '.'>
    }
    token facet:sym<x> {
        <sym> [<before '.'> || <before '-'>]
    }
    token  facet-sep {
        [['-' <after x>] || '.']
    }
    token branch {
        <restricted-name> #<before [[<branch> '.'] || <.subtype>]>
    }

    # subtype
    token subtype {
        <restricted-name> 
    }

    # optional: suffix
    token suffix {
        <alnum>+ <after [<subtype> '+']>
    }

    # optional: parameters
    #token parameters {
        #[\; \s* <param-name> '=' [<param-value>+ %% \' | <param-value>+ %% \" | <param-value>+]  ]*
    #}
    token param-name {
        <alnum>+ <after [\s\"\;]+>
    }
    token param-value {
        <-[\s\"\;]>+
    }

    # valid characters
    token restricted-name {
        <alnum>
        <restricted-chars> ** 0..127
    }
    token restricted-chars {
        # '.' is used in name: "Wordperfect5.1" and may need to be handled correctly
        <+alnum +[!#$&^_-] -[\.\+]>
    }
}


# for only allowing registered types
grammar IETF::RFC_Grammar::MediaType::StrictType is IETF::RFC_Grammar::MediaType {
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