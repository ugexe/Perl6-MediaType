use v6;
#use Grammar::Debugger;
# RFC: https://tools.ietf.org/html/rfc6838

grammar IETF::RFC_Grammar::MediaType {
    token TOP {
        ^ <type-name> '/' <tree>? <subtype-name> <suffix>? .* $
        #<type-name>? '/' <tree>? <subtype-name>? [<suffix>]? \s* <parameters>?
    }

    token type-name {
        <restricted-name>
    }

    token tree {
        <facet> <producer>+ <before <subtype-name>>
    }
    token facet {
        <restricted-name> '.' # [<after '/'> && <before '.'>]
    }
    token producer {
        <restricted-name> '.' # [<after '.'> && <before '.'>]
    }

    token subtype-name {
        <restricted-name> 
    }

    token suffix {
        '+' <alnum>+
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
        <restricted-name-chars> ** 0..126
    }
    token restricted-name-first {
        <alnum>
    }
    token restricted-name-chars {
        <alnum>
        # <[ <alnum>+[!#$&-^_]-[+.] ]>
    }
}