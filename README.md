# saxon-lint
This program is aimed to query XML/(X)HTML files via command line such as [XMLStarlet](http://xmlstar.sourceforge.net/) or [xmllint](http://xmlsoft.org/xmllint.html), but with the ability to use **XPath 3.0**/**XQuery 3.0**/**XSLT 2.0** (Other command-line tools are stuck with [libxml2](http://xmlsoft.org/) (apart [xidel](http://www.videlibri.de/xidel.html)) and XPath 1.0/XSLT 1.0).

As far as you have the prerequisites, this project is **cross-platform** (Linux, MacOsX/*BSD, Windows... ).

The default XPath output displays each result nodes on a separate newline, this is suitable for shell scripting to split results in an array (by example). This feature is missing with `xmllint`.

### Main features

 - XML parsing via files (and `STDIN`)
 - XPath 3.0/XQuery 3.0/XSLT 2.0 using Michael Kay's [Saxon-HE](http://sourceforge.net/projects/saxon) Java library
 - (X)HTML parsing via HTTP, HTTPS or files, even with broken RealLife©®™ HTML using John Cowan's [TagSoup](http://home.ccil.org/~cowan/XML/tagsoup/) Java library

### Install prerequisites
 - java (openjdk...)
 - perl
 - libxml2
 - git (or use the .zip)

And Perl modules :

  - `XML::LibXML` :`libxml-libxml-perl` debian package
  - `LWP::UserAgent` & `LWP::protocol::https` (if HTTPS is needed) : `libwww-perl  liblwp-protocol-https-perl` debian packages

With one command for Debian and derivatives :

     apt-get update && apt-get install openjdk-7-jre perl libxml2 libxml2-dev \
        libxml-libxml-perl libwww-perl liblwp-protocol-https-perl
### Install:

```sh
$ git clone https://github.com/sputnick-dev/saxon-lint.git
$ cd saxon-lint*
$ chmod +x saxon-lint.pl
$ ./saxon-lint.pl --help
```

### Usage:

```
Usage:
    saxon-lint.pl <opts> <file(s)>
    Parse the XML files and output the result of the parsing
    --help -h,                  this help
    --xpath,                    XPath expression
    --xquery,                   Xquery expression or file
    --html,                     use the HTML parser
    --xslt,                     use XSL transformation
    --output-separator,         set output separator to character ("\n", ","...)
    --indent,                   indent the output
    --no-pi,                    remove Processing Instruction (<?xml ...>)
    --saxon-opt,                Saxon extra argument
    --verbose -v,               verbose mode

```

### Examples:

```sh
saxon-lint.pl --xpath '//key[text()="String"]/following-sibling::string[1]' file.xml
saxon-lint.pl --xquery 'for $r in 1 to count(/table/tr) return /title' file.xml
saxon-lint.pl --indent --xquery file.xquery
curl -Ls 'http://domain.tld/file.xml' | saxon-lint.pl --xpath '//key[1]' -
saxon-lint.pl --xslt file.xsl file.xml
saxon-lint.pl --xquery file.xquery --saxon-opt -t --saxon-opt '!indent=yes'
saxon-lint.pl --html --xpath 'string-join(//a/@href, "\r\n")' http://x.y/z.html
```

Get shortened URL via tinyurl:
```sh
saxon-lint --html --xpath '//div[@class="indent"][1]/b/text()' \
    'http://tinyurl.com/create.php?url=http://google.com'
```

To set the `string-join()` character (like the latest snippet) for Unix likes, hit <kbd>ctrl</kbd>+<kbd>v</kbd> and <kbd>ENTER</kbd>.
For Windows, just type `"\r\n"`.

Check [others examples](https://github.com/sputnick-dev/saxon-lint/tree/master/examples).    

For `--saxon-opt`, check [Saxon documentation](http://www.saxonica.com/documentation/#!configuration/config-features)

### Tricks:
To be able to run the command without dot-slash : `./saxon-lint`, you need to modify the PATH variable. For windows, check http://www.computerhope.com/issues/ch000549.htm
For Unix Likes, modify `~/.bashrc` by searching `PATH=` and put `PATH=$PATH:/PATH/TO/saxon-lint_DIRECTORY`, then `source ~/.bashrc`

If you want to enable `bash-completion`, you have to install this program and move
`usr_share_bash-completion_completions_saxon-lint`
to `/usr/share/bash-completion/completions/saxon-lint` (or similar).

### TroobleShooting:
Tested platforms :
 - GNU/Linux (Archlinux, Ubuntu 12.04) the most tested
 - FreeBSD 10.1
 - Windows XP (with or without Cygwin)

Thanks to report any bug [here](https://github.com/sputnick-dev/saxon-lint/issues/new).

### Licensing:

This program is under the same licence as Saxon-HE.
