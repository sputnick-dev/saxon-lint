#!/bin/bash

./saxon-lint.pl --output-separator="," --xpath '/a//b/text()' examples/XPath/string-join_xml.xml
