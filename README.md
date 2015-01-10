# saxon-lint
This [Saxon-HE](http://sourceforge.net/projects/saxon) wrapper script is aimed to query XML with command line in a shell like [XMLStarlet](http://xmlstar.sourceforge.net/) or [xmllint](http://xmlsoft.org/xmllint.html), but with the ability to use **XPath 3.0**/**XQuery 3.0** using Michael Kay's Saxon Java library. (Other command-line tools use XPath 1.0).

As far as you have the prerequisites, this project is **cross-platform** (Linux, MacOsX & *BSD, Windows... ).

The default output display each result nodes on a separate newline, this is suitable for shell scripting to split results in an array (by example). This feature is missing with `xmllint`.

### Main features

 - XPath 3.0/ XQuery 3.0
 - XML parsing via files
 - (X)HTML parsing via HTTP, HTTPS or files, even with broken RealLife©®™ HTML

### Install prerequisites
 - java (openjdk...)
 - bash
 - perl

And Perl modules :

  - `XML::LibXML` :`libxml-libxml-perl` debian package
  - `LWP::UserAgent` & `Net::SSLeay` (if HTTPS is needed) : `libwww-perl libnet-ssleay-perl` debian packages

### Install:

```sh
$ git clone https://github.com/sputnick-dev/saxon-lint.git
$ cd saxon-lint
$ chmod +x saxon-lint
$ ./saxon-lint --help
```

### Usage:

```
Usage:
    test.pl <opts> <file(s)>
    Parse the XML files and output the result of the parsing
    --help,                     this help
    --html,                     use the HTML parser
    --output-separator,         set default separator to character ("\n", ","...)
    --xpath,                    XPath expression
    --query,                    XQuery expression

```

### Trick:
To be able to run the command without dot-slash : `./saxon-lint`, you need to modify the PATH variable. For windows, check http://www.computerhope.com/issues/ch000549.htm    
For Unix Likes, modify `~/.bashrc` by searching `PATH=` and put `PATH=$PATH:/PATH/TO/saxon-lint_DIRECTORY`, then `source ~/.bashrc`

### Licensing:

This program is under the same licence as Saxon-HE.
