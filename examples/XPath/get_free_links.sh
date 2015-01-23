#!/bin/bash

urls=( 'https://google.com' 'http://free.fr' 'https://twitter.com/' )
./saxon-lint.pl --html --xpath 'string-join(//a/@href, "")' "${urls[RANDOM % 3]}"

