module MediaType;
use IETF::RFC_Grammar::MediaType;

sub parse(Str $content-type) is export {
    IETF::RFC_Grammar::MediaType.parse($content-type);
}
