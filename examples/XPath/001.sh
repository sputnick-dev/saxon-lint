#!/bin/bash

./saxon-lint.pl --output-separator="," --xpath '/a//b/text()' examples/XPath/001.xml
