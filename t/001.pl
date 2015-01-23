#!/usr/bin/perl

# to run the tests, you need an *Unix like shell and '$ prove t/001.pl'

use utf8;
use strict; use warnings;

use Test::More tests => 20;

require_ok('XML::LibXML');
require_ok('Getopt::Long');
require_ok('File::Basename');
require_ok('autodie');
require_ok('File::Temp');
require_ok('LWP::UserAgent');

like(qx(./examples/XPath/get_free_links.sh), qr!http://!, 'match http links');
like(qx(./examples/XPath/001.sh), qr!1,2,3!, 'simple xpath concatenation');
like(qx(./examples/XPath/002.sh), qr!1\n2\n3!s, 'simple xpath query on multi-lines');
like(qx(./examples/XQuery/billboard.com/to_HTML_table.sh), qr!Check file!, 'xquery to create a table');
like(qx(cat examples/XQuery/billboard.com/to_HTML_table.html), qr!\R\s+<td>Hoodie Allen Featuring!, 'test a node in generated HTML');
my $x = qx(./examples/XQuery/billboard.com/simple_text_parsing.sh);
like($x, qr!\[100\] All About It!, 'simple_text_parsing found [100]');
unlike($x, qr/xml\s+version/, 'not matching PI');
like(qx(examples/XQuery/FLWOR/books.sh), qr!\s+<title>Hui</title>!, 'FLWOR books query match a node');
like(qx(examples/XSLT/ex_01.sh), qr!\R\s+<target>num1,num2,num3</target>!, 'xslt concatenation');
like(qx(./examples/XQuery/simple/variable_interpolation.sh), qr/Hello\s+World!/, 'xquery variable interpolation');
like(qx(examples/XQuery/simple/doc_use.sh), qr!\R<title>Zetaz</title>!, 'using fn:doc()');
like(qx(examples/XQuery/simple/inline-XQyery.sh), qr!\R5!, 'inline xquery');
like(qx(examples/XQuery/simple/test_to_see_if_a_word_is_in_a_list.sh), qr#\R\s+<title>Test of is a word on a list</title>#, 'test to see if a word is in a list');
ok(&{ sub{ return scalar grep { /(?:Wulfman|Parod|Terrell|XXX)/ } split "\n", qx(examples/XPath/hamlet.sh); } }() == 3, "using a default NS with --xpath for hamlet.xml");
