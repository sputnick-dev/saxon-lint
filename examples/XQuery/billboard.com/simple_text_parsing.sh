#!/bin/bash

saxon-lint --no-pi --html --xquery '
    for $a in //article[@id]
         let $chart    := $a//span[@class="this-week"]/text()
         let $artist   := normalize-space($a//div[@class="row-title"]/h3/a/text())
         let $song     := normalize-space($a//h2/text())
         let $link     := string($a//div[@class="row-title"]/h3/a/@href)
    return
        concat(
             "[", $chart, "] ", $song, " - ", $artist,
             " : ", $link
         )
' examples/XQuery/billboard.com/input.html
