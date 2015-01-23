#!/bin/bash

./saxon-lint.pl --xpath 'declare default element namespace "http://www.tei-c.org/ns/1.0";//name/text()' examples/XPath/hamlet.xml
