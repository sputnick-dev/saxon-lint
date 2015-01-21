#!/bin/bash

page=0
saxon-lint --no-pi --html --xquery '
    for $a in //article/header
         let $chart    := $a/span[1]/text()
         let $song     := normalize-space($a/h1/text())
         let $artist   := $a/p[@class="chart_info"]/a/text()
         let $link     := string($a/p[@class="chart_info"]/a/@href)
    return
         concat(
             "[", $chart, "] ", $song, " - ", $artist,
             " : http://www.billboard.com", $link
         )
' "http://www.billboard.com/charts/billboard-200?page=$page"
