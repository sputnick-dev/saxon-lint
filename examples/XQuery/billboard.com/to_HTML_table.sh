#!/bin/bash

# Check http://tinyurl.com/p5853wo

if ./saxon-lint.pl --indent --html --xquery examples/XQuery/billboard.com/to_HTML_table.xquery examples/XQuery/billboard.com/input.html > examples/XQuery/billboard.com/to_HTML_table.html; then
    echo "Check file://$PWD/examples/XQuery/billboard.com/to_HTML_table.html"
else
    echo >&2 "ERROR"
    exit 1
fi
