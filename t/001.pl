#!/usr/bin/perl

# to run the tests, you need an *Unix like shell and :
# $ prove t/001.pl

use utf8;
use strict; use warnings;

use Unicode::Normalize;
use charnames ':full';

use Test::More tests => 10;

like(qx(./examples/XPath/get_free_links.sh), qr!http://!, 'match http links');
like(qx(./examples/XPath/001.sh), qr!1,2,3!, 'match');
like(qx(./examples/XPath/002.sh), qr!1\n2\n3!s, 'match');
like(qx(./examples/XQuery/billboard.com/to_HTML_table.sh), qr!Check file!, 'match');
like(qx(cat examples/XQuery/billboard.com/to_HTML_table.html), qr!\s+<td>Hoodie Allen Featuring!, 'match');
my $x = qx(./examples/XQuery/billboard.com/simple_text_parsing.sh);
like($x, qr!\[100\] All About It!, 'match');
unlike($x, qr/xml\s+version/, 'not match');
like(qx(examples/XQuery/FLWOR/books.sh), qr!\s+<title>Hui</title>!, 'match');
like(qx(examples/XSLT/ex_01.sh), qr!\s+<target>num1,num2,num3</target>!, 'match');
like(qx(./examples/XQuery/simple/variable_interpolation.sh), qr/Hello\s+World!/, 'match');
