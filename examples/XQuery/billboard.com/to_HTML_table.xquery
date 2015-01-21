(:
    Based on http://www.xmlplease.com/xquery-xhtml

    Usage:

        $ saxon-lint --html --xquery examples/billboard.com_to_HTML_table.xquery http://www.billboard.com/charts/billboard-200
:)

declare namespace saxon="http://saxon.sf.net/";
declare option saxon:output "method=xml";
declare option saxon:output "doctype-public=-//W3C//DTD XHTML 1.0 Strict//EN";
declare option saxon:output "doctype-system=http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd";
declare option saxon:output "omit-xml-declaration=no";
declare option saxon:output "indent=yes";

<html xml:lang="en" xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <style type="text/css">
      body{{font-family: Verdana, Arial, Helvetica, sans-serif}}
      table, th, td{{border: 1px solid gray; border-collapse:collapse}}
      .alt1{{background-color:mistyrose}}
      .alt2{{background-color:azure}}
      .th{{background-color:silver}}
    </style>
    <title>Using XQuery</title>
  </head>
  <body>
    <h1>saxon-lint XQuery demo</h1>
    <table cellspacing="0" cellpadding="5">
      <tr class="th">
        <th>#</th>
        <th>artist</th>
        <th>song</th>
        <th>link</th>
      </tr>
      {
        for $a at $b in //article[@id]
             let $chart    := $a//span[@class="this-week"]/text()
             let $artist   := normalize-space($a//div[@class="row-title"]/h3/a/text())
             let $song     := normalize-space($a//h2/text())
             let $link     := string($a//div[@class="row-title"]/h3/a/@href)
        return
        <tr class="{if ($b mod 2 = 0) then "alt1" else "alt2"}">
        <td>{$chart}</td>
        <td>{$artist}</td>
        <td>{$song}</td>
        <td><a href="{$link}">{$link}</a></td>
      </tr>}
    </table>
  </body>
</html>
