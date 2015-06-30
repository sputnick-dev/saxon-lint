#!/bin/bash

cd examples/XPath
../../saxon-lint.pl --output-separator="," --xpath '/a//b/text()' 001.xml
