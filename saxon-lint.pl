#!/usr/bin/perl

# Gilles Quenot <gilles.quenot@sputnick.fr>

use strict; use warnings;
use XML::LibXML;
use Getopt::Long;

use utf8;
binmode $_, ":utf8" for qw/STDOUT STDIN STDERR/;

my $sep = $^O =~ /MSWin/i ? ";" : ":";
my $classpath = "$0/../lib/tagsoup-1.2.jar${sep}$0/../lib/saxon9he.jar";
my $queryclass = 'net.sf.saxon.Query';
my $htmlclass = 'org.ccil.cowan.tagsoup.Parser';

my $help = my $html = 0;
my $oDel = "\n";
my $xpath = '';
my $indent = 0;

GetOptions (
    "html"                  => \$html,     # flag
    "help"                  => \$help,     # flag
    "output-separator=s"    => \$oDel,     # string
    "xpath=s"               => \$xpath,    # string
    "query=s"               => \$xpath,    # string
    "indent"                => \$indent,   # flag
) or die("Error in command line arguments\n");

$indent = $indent ? 'yes' : 'no';

unless (length $xpath) {
    warn "Missing mandatory --xpath or --query argument\n\n";
    help(1);
}
help($help) if $help == 1;
help(0) unless @ARGV;

foreach my $input (@ARGV) {
    $html = 1 if $input =~ m!^https?://!;
    my $https = 0;
    if ($input =~ m!^https://!) {
        $input = GET_https($input) if $input =~ m!^https://!;
        $https = 1;
    }
    if ($html) {
        my $xml = qx(
        bash <<EOF
        java -cp '$classpath' $queryclass -x:$htmlclass -s:'$input' \Q-qs:declare default element namespace "http://www.w3.org/1999/xhtml";$xpath\E -quit:on !item-separator=\$'$oDel' !indent=$indent
EOF
);
        # can't find a better way to do this with XML::LibXML
        $xml =~ s/^\<\?xml\s*version=.\d+\.\d+.\s*encoding=.[^"]+.\?\>//;
        $xml =~ s/(^|\n)[\n\s]*/$1/g;
        my $parser = XML::LibXML->new();
        my $doc = $parser->parse_balanced_chunk($xml);

        # remove namespaces for the whole document
        for my $el ($doc->findnodes('//*')) {
            if ($el->getNamespaces){
                replace_without_ns($el);
            }
        }
        print $doc->toString();
        unlink $input if $https;
    }
    # XML
    else {
        my $xml = qx(
        bash<<EOF
            java -cp "$classpath" "$queryclass" -s:"$input" \Q-qs:$xpath\E -quit:on !item-separator=\$'$oDel' !encoding=utf-8 !indent=$indent
EOF
        );
        # can't find a better way to do this with XML::LibXML
        $xml =~ s/^\<\?xml\s*version=.\d+\.\d+.\s*encoding=.[^"]+.\?\>//;
        $xml =~ s/(^|\n)[\n\s]*/$1/g;
        print $xml;
    }
}

sub help {
    my $error = shift;

    print STDERR <<EOF;
Usage:
    $0 <opts> <file(s)>
    Parse the XML files and output the result of the parsing
    --help,                     this help
    --xpath,                    XPath expression
    --query,                    XQuery expression
    --html,                     use the HTML parser
    --output-separator,         set default separator to character ("\\n", ","...)
    --indent,                   indent the output
EOF
   exit $error if $error; 
}

# http://stackoverflow.com/questions/17756926/remove-xml-namespaces-with-xmllibxml
# Replaces the given element with an identical one without the namespace
# also does this with attributes
sub replace_without_ns {
    my ($el) = @_;
    # new element has same name, minus namespace
    my $new = XML::LibXML::Element->new( $el->localname );
    #copy attributes (minus namespace namespace)
    for my $att($el->attributes) {
        if($att->nodeName !~ /xmlns(?::|$)/){
            $new->setAttribute($att->localname, $att->value);
        }
    }
    #move children
    for my $child($el->childNodes){
        $new->appendChild($child);
    }

    $el->parentNode->insertAfter($new, $el);
    $el->unbindNode;

    return;
}

sub GET_https {
    my $arg = shift;

    require LWP::UserAgent;
    use File::Temp;
    my $ua = LWP::UserAgent->new;
    my $req = HTTP::Request->new(GET => $arg);
    my $res = $ua->request($req);
    die 'HTTPS error: ' . $res->status_line . "\n" unless $res->is_success;

    my $fh = File::Temp->new();
    $fh->unlink_on_destroy(0);
    print $fh $res->content;

    return $fh->filename;
}
