#!/bin/bash

# check http://htmlpreview.github.io/?https://raw.githubusercontent.com/sputnick-dev/saxon-lint/master/examples/XQuery/billboard.com/to_HTML_table.html

./saxon-lint.pl --indent --html --xquery examples/XQuery/billboard.com/to_HTML_table.xquery http://www.billboard.com/charts/billboard-200 | tee examples/XQuery/billboard.com/to_HTML_table.html
