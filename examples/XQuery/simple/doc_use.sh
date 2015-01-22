#!/bin/bash

cp ./examples/XQuery/FLWOR/books.xml /tmp/__books.xml
./saxon-lint.pl --indent --xquery examples/XQuery/simple/doc_use.xquery
rm -f /tmp/__books.xml
