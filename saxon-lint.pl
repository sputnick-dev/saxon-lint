#!/usr/bin/perl

# Gilles Quenot <gilles.quenot@sputnick.fr>

use strict; use warnings;
use FindBin '$RealBin';
use XML::LibXML;
use Getopt::Long;
use autodie;

use utf8;
use open qw/:std :utf8/;

my $htmlparser = 'lib/tagsoup-1.2.jar';
my $xmlparser = 'lib/saxon9he.jar';
my $queryclass = 'net.sf.saxon.Query';
my $htmlclass = 'org.ccil.cowan.tagsoup.Parser';
my $transformclass = 'net.sf.saxon.Transform';

my $help = my $html = my $indent = my $res = my $xslt = my $nopi = 0;
my $oDel = "\n"; # default output-separator
my $mainclass = my $xpath = my $query = my $xquery = my $verbose = '';
my @extra = ();
GetOptions (
    "h|help"                => \$help,     # flag
    "html"                  => \$html,     # flag
    "xslt=s"                => \$xslt,     # string
    "output-separator=s"    => \$oDel,     # string
    "xpath=s"               => \$xpath,    # string
    "xquery=s"              => \$xquery,   # string
    "indent"                => \$indent,   # flag
    "no-pi"                 => \$nopi,     # flag
    "saxon-opt=s"           => \@extra,    # array
    "v|verbose"             => \$verbose,  # flag
) or die("Error in command line arguments\n");

my $sep = $^O =~ /(?:MSWin|cygwin)/i ? ";" : ":";
my $classpath = $html ? "$RealBin/$htmlparser${sep}$RealBin/$xmlparser" : "$RealBin/$xmlparser";

$indent = $indent ? 'yes' : 'no';

if ($nopi == 0) {
    $nopi = 1 if $html and not length $xquery;
}
$verbose = $verbose ? 'set -x' : 'set +x';

if ($xslt) {
    $mainclass = $transformclass;
    $query = $xslt;
}
else {
    $mainclass = $queryclass;
}

$query = $xpath unless length $query;

# Base command
my $basecmd = qq#java -cp "$classpath" "$mainclass" !encoding=utf-8 !indent=$indent -quit:on !item-separator='$oDel'#;

# Add all Saxon extra opts
$basecmd .= qq@ $_@ for @extra;

help(0) if $help == 1;

if (not $xslt and not length $xquery and not length $xpath) {
    warn "Missing mandatory --xpath --xslt or --xquery argument\n\n";
    help(1);
}

if (length $xquery) {
    { # $xquery can be a file or a string and -s complains when it's a string with multi-lines
        no warnings;

        if (-s $xquery) {
            $basecmd .= qq! '-q:$xquery'!
        }
        else{
            $query = $xquery;
            if ($html) {
                $basecmd .= qq# '-qs:declare default element namespace "http://www.w3.org/1999/xhtml";$query'#;
            }
            else {
                $basecmd .= qq! '-qs:$query'!;
            }
        }
    }
}

if (length $xquery and not @ARGV) {
    execute($basecmd, undef, undef, undef, $nopi, undef);
}

foreach my $input (@ARGV) {
    my $https = 0;

    if ($input =~ m!^https://!) {
        $input = GET_https($input);
        $https = 1;
    }

    my $cmd = $basecmd;
    $cmd .= qq# -s:$input#;

    if ($html and not length $xquery) {
        $cmd .= qq# -x:$htmlclass '-qs:declare default element namespace "http://www.w3.org/1999/xhtml";$query'#;
    }
    elsif ($html and length $xquery) {
        $cmd .= qq# -x:$htmlclass#;
    }
    elsif ($xslt) {
        $cmd .= qq/ '-xsl:$query'/;
    }
    elsif (not length $xquery) {
        $cmd .= qq/ '-qs:$query'/;
    }

    execute($cmd, $html, $https, $input, $nopi, $xpath);
}

sub help {
    my $error = shift;

    print STDERR <<EOF;
Usage:
    $0 <opts> <file(s)>
    Parse the XML files and output the result of the parsing
    --help -h,                  this help
    --xpath,                    XPath expression
    --xquery,                   Xquery expression or file
    --html,                     use the HTML parser
    --xslt,                     use XSL transformation
    --output-separator,         set default separator to character ("\\n", ","...)
    --indent,                   indent the output
    --no-pi,                    remove Processing Instruction (<?xml ...>)
    --saxon-opt,                Saxon extra argument
    --verbose -v,               verbose mode
EOF
   exit $error;
}

# Call the Java command-line with built command
sub execute {
    my ($cmd, $html, $https, $input, $nopi, $xpath) = @_;

    #print $cmd , "\n";
    my $xml = qx(
        $verbose
        $cmd
    );
    $res = $?;

    remove_PI(\$xml) if $nopi or (defined $xpath and length $xpath > 1);
    remove_NS(\$xpath, \$xml) if $html;

    print $xml;

    if ($https) {
        chomp $input;
        unlink $input;
    }

    print "\n";

    #exit ($res > 0) ? 1 : 0;
}

sub remove_PI {
    my $xml = shift;

    # can't find a better way to do this with XML::LibXML
    $$xml =~ s/^\<\?xml\s*version=.\d+\.\d+.\s*encoding=.[^"]+.\?\>//i;
    $$xml =~ s/(^|\n)[\n\s]*/$1/g;

    return;
}

sub remove_NS {
    my ($xpath, $xml) = @_;

    if (length $$xpath and $$xpath ne "/") {
        my $parser = XML::LibXML->new();
        my $doc = $parser->parse_balanced_chunk($xml);

        # remove namespaces for the whole document
        for my $el ($doc->findnodes('//*')) {
            if ($el->getNamespaces){
                replace_without_ns($el);
            }
        }
        return $doc->toString();
    }
    else {
        return $$xml;
    }
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
    my $path;

    require LWP::UserAgent;
    use File::Temp;
    my $ua = LWP::UserAgent->new;
    my $req = HTTP::Request->new(GET => $arg);
    my $res = $ua->request($req);
    die 'HTTPS error: ' . $res->status_line . "\n" unless $res->is_success;

    my $fh = File::Temp->new();
    $fh->unlink_on_destroy(0);
    print $fh $res->content;
	
    my $filename = $fh->filename;

    if ($^O =~/cygwin/i) {
        $path = qx(cygpath -m "/cygdrive/c/cygwin$filename");
    }
    else {
        $path = $filename;
    }

    return $path;
}
