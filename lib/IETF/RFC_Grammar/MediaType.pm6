use v6;
# use Grammar::Debugger;
# RFC: https://tools.ietf.org/html/rfc6838

grammar IETF::RFC_Grammar::MediaType {
    token TOP {
        ^ <type-name> '/' <tree>? <subtype-name> <suffix>? .* $
        #<type-name>? '/' <tree>? <subtype-name>? [<suffix>]? \s* <parameters>?
    }

    token type-name {
        <restricted-name>
    }
    token subtype-name {
        <restricted-name> 
    }

    # token tree {
    #     vnd.oasis.opendocument.text
    #     vnd     | oasis | opendocument  | text
    #     <facet>   [<producer>+ % '.']     ['.' <subtype-name>]
    # }
    token tree {
        <facet> '.' [<producer> '.']+
    }
    proto token facet {*}
    token facet:sym<vnd> {
        <sym>
    }
    token facet:sym<prs> {
        <sym>
    }
    token facet:sym<x> {
        # x can be followed by either '.' or '-'
        <sym>
    }
    token producer {
        <restricted-name> #'.' # [<after '.'> && <before '.'>]
    }

    token suffix {
        <alnum>+ <after '+'>
    }

    token parameters {
        [\; \s* <param-name> '=' \"? <param-value>]*
    }
    token param-name {
        ^^ <alnum>+ <after [\s\"\;]+>
    }
    token param-value {
        <-[\s\"\;]>+
    }


    token restricted-name {
        <restricted-name-first>
        <restricted-name-chars> # 0..127
    }
    token restricted-name-first {
        <alnum>
    }
    token restricted-name-chars {
        <alnum>+
        # <[ <alnum>+[!#$&-^_]-[+.] ]>
    }
}