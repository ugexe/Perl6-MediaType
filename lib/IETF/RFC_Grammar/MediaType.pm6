use v6;
#use Grammar::Debugger;
# RFC: https://tools.ietf.org/html/rfc6838

grammar IETF::RFC_Grammar::MediaType {
    token TOP {
        ^ <type> '/' <tree>? <subtype> ['+' <suffix>]? .* $
        #<type-name>? '/' <tree>? <subtype-name>? [<suffix>]? \s* <parameters>?
    }

    token type {
        <restricted-name>
    }
    token subtype {
        <restricted-name> 
    }

    token tree {
        <facet> <branches>? <before <subtype>>
    }
    proto token facet {*}
    token facet:sym<vnd.> {
        <sym>
    }
    token facet:sym<prs.> {
        <sym>
    }
    token facet:sym<x.> {
        <sym>
    }
    token branches {
        [<branch> '.']+
    }
    token branch {
        <restricted-name>
    }

    token suffix {
        <alnum>+
    }

    token parameters {
        [\; \s* <param-name> '=' [<param-value>+ %% \' | <param-value>+ %% \" | <param-value>+]  ]*
    }
    token param-name {
        <alnum>+ <after [\s\"\;]+>
    }
    token param-value {
        <-[\s\"\;]>+
    }


    token restricted-name {
        <alnum>
        <restricted-chars> ** 0..127
    }
    token restricted-chars {
        <+alnum +[!#$&^_-]> # <-[\.\+]> not explicitly needed
    }
}


# for only allowing registered types
grammar IETF::RFC_Grammar::MediaType::StrictType is IETF::RFC_Grammar::MediaType {
    proto token type {*}
    token type:sym<application> { <sym> }
    token type:sym<audio>       { <sym> }
    token type:sym<example>     { <sym> }
    token type:sym<image>       { <sym> }
    token type:sym<message>     { <sym> }
    token type:sym<model>       { <sym> }
    token type:sym<multipart>   { <sym> }
    token type:sym<text>        { <sym> }
    token type:sym<video>       { <sym> }
}