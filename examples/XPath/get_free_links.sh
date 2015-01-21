#!/bin/bash

./saxon-lint.pl --html --xpath 'string-join(//a/@href, "")' https://free.fr

