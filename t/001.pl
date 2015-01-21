#!/usr/bin/perl

# to run the tests, you need an *Unix like shell and :
# $ prove t/001.pl

use utf8;
use strict; use warnings;

use Unicode::Normalize;
use charnames ':full';

use Test::More tests => 7;

like(qx(./examples/XPath/get_free_links.sh), qr!http://!, 'match http links');
like(qx(./examples/XPath/001.sh), qr!1,2,3!, 'match 1,2,3');
like(qx(./examples/XQuery/billboard.com/to_HTML_table.sh), qr!Check file!);
like(qx(cat examples/XQuery/billboard.com/to_HTML_table.html), qr!\s+<td>Hoodie Allen Featuring!);
like(qx(./examples/XQuery/billboard.com/simple_text_parsing.sh), qr!\[100\] All About It!);
like(qx(examples/XQuery/FLWOR/books.sh), qr!\s+<title>Hui</title>!);
like(qx(examples/XSLT/ex_01.sh), qr!\s+<target>num1,num2,num3</target>!);
