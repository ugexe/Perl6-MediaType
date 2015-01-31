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
        <facet> '.' [<branch> '.']+ <before <subtype>>
    }
    proto token facet {*}
    token facet:sym<vnd> {
        <sym> <before '.'>
    }
    token facet:sym<prs> {
        <sym> <before '.'>
    }
    token facet:sym<x> {
        # x can be followed by either '.' or '-'
        <sym> <before ['.' | '-']>
    }
    token branch {
        <restricted-name>
    }

    token suffix {
        <alnum>+
    }

    token parameters {
        [\; \s* <param-name> '=' \"? <param-value>]*
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