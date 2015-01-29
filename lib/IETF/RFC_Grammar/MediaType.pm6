use v6;

# RFC: https://tools.ietf.org/html/rfc6838

grammar IETF::RFC_Grammar::MediaType {
    token TOP {
        ^ <type-name> '/' <tree>? <subtype-name> [<suffix>]? \s* <params>? $
    };

    token type-name {
        <restricted-name>
    };
    token subtype-name {
        <restricted-name> <after [<tree>.]>
    };

    token tree {
        <facet> [.<producer>]*
    };
    token facet {
        <restricted-name-chars>+ [<after '/'> && <before '.'>]
    };
    token producer {
        <restricted-name-chars>+ <before [.<subtype-name>]>
    };

    token suffix {
        <alnum>+ <after <subtype-name> '+'>
    };


    token parameters {
        [\; \s* <param-name> '=' \"? <param-value>]*
    };
    token param-name {
        ^^ <alnum>+ <after [\s\"\;]+>
    };
    token param-value {
        <-[\s\"\;]>+
    };


    token restricted-name {
        <restricted-name-first>
        <restricted-name-chars> ** 0..126
    };
    token restricted-name-first {
        ^^ <alnum>
    };
    token restricted-name-chars {
        <alnum>+
        # <[ <alnum>+[!#$&-^_]-[+.] ]>
    };
}