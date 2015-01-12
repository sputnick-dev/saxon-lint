# saxon-lint
This program is aimed to query XML/HTML files with command line in a shell like [XMLStarlet](http://xmlstar.sourceforge.net/) or [xmllint](http://xmlsoft.org/xmllint.html), but with the ability to use **XPath 3.0**/**XQuery 3.0** (Other command-line tools use XPath 1.0).

As far as you have the prerequisites, this project is **cross-platform** (Linux, MacOsX/*BSD, Windows... ).

The default output display each result nodes on a separate newline, this is suitable for shell scripting to split results in an array (by example). This feature is missing with `xmllint`.

### Main features

 - XPath 3.0/ XQuery 3.0 using Michael Kay's [Saxon-HE](http://sourceforge.net/projects/saxon) Java library
 - XML parsing via files
 - (X)HTML parsing via HTTP, HTTPS or files, even with broken RealLife©®™ HTML using John Cowan's [TagSoup](http://home.ccil.org/~cowan/XML/tagsoup/) Java library

### Install prerequisites
 - java (openjdk...)
 - bash
 - perl

And Perl modules :

  - `XML::LibXML` :`libxml-libxml-perl` debian package
  - `LWP::UserAgent`, `LWP::protocol::https` & `Net::SSLeay` (if HTTPS is needed) : `libwww-perl libnet-ssleay-perl liblwp-protocol-https-perl` debian packages

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
    --help,                     this help
    --html,                     use the HTML parser
    --output-separator,         set default separator to character ("\n", ","...)
    --xpath,                    XPath expression
    --query,                    XQuery expression

```

### Examples:

```sh
saxon-lint.pl --xpath '//key[text()="String"]/following-sibling::string[1]' file.xml
saxon-lint.pl --xpath 'for $r in 1 to count(/table/tr) return /title' file.xml
curl -Ls 'http://domain.tld/file.xml' | saxon-lint.pl  --xpath '//key[1]' -
```

### Tricks:
To be able to run the command without dot-slash : `./saxon-lint`, you need to modify the PATH variable. For windows, check http://www.computerhope.com/issues/ch000549.htm    
For Unix Likes, modify `~/.bashrc` by searching `PATH=` and put `PATH=$PATH:/PATH/TO/saxon-lint_DIRECTORY`, then `source ~/.bashrc`

If you want to enable `bash-completion`, you have to install this program and move    
`usr_share_bash-completion_completions_saxon-lint`    
to `/usr/share/bash-completion/completions/saxon-lint` (or similar).

### TroobleShooting:
Tested platforms :
 - Linux (Archlinux)
 - Windows XP (with or without Cygwin)
 - FreeBSD 10.1

Thanks to report any bug [here](https://github.com/sputnick-dev/saxon-lint/issues/new).

### Licensing:

This program is under the same licence as Saxon-HE.
