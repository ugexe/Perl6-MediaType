use v6;
use Test;
plan 5;
use MediaType;

# html 5 style
{
    my $html = q{<html><head> <meta charset='utf-8'> </head><body><b> hello </body></html>};
    is meta_from_html($html), "utf-8";
}

# html 4 style (uppercase charset)
{
    my $html = q{<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">};
    is meta_from_html($html), "UTF-8";
}

# html 4 style (lowercase charset)
{
    my $html = q{<meta http-equiv="Content-Type" content="text/html; charset=utf-8">};
    is meta_from_html($html), "utf-8";
}

# bogus tag
{
    my $html = q{<meta http-equiv="Content-Type" content="text/html; > charset=utf-8">};
    nok meta_from_html($html);
}

{
    is sniff(), 'utf-8-strict';
}

done();
