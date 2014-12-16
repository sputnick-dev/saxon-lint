This [Saxon-HE](http://sourceforge.net/projects/saxon) wrapper script is aimed to query XML files with command line in a shell like [XMLStarlet](http://xmlstar.sourceforge.net/) or [xmllint](http://xmlsoft.org/xmllint.html), but with the ability to use **XPath 3.0** and others fresh rich features.

The default output display each result nodes on a separate newline, this is suitable for shell scripting to split results in an array (by example). This feature is a lack for `xmllint`

### Install for Windows + Cygwin:

    $ curl -k 'https://raw.githubusercontent.com/sputnick-dev/saxon-lint/master/saxon-lint' > saxon-lint
    $ chmod +x saxon-lint
    $ wget http://sourceforge.net/projects/saxon/files/Saxon-HE/9.6/SaxonHE9-6-0-1J.zip

 - unzip `SaxonHE9-6-0-1J.zip` to `C:\`
 - edit the file `saxon-lint`, you have to replace `saxon9hePATH=XXX by saxon9hePATH='C:/SaxonHE9-6-0-1J'`

### Install for Linux/Unix*likes:

    $ curl -k 'https://raw.githubusercontent.com/sputnick-dev/saxon-lint/master/saxon-lint' > saxon-lint
    $ chmod +x saxon-lint
    $ wget http://sourceforge.net/projects/saxon/files/Saxon-HE/9.6/SaxonHE9-6-0-1J.zip
    $ unzip SaxonHE9-6-0-1J.zip -d /PATH/WHERE/YOU/WANT/THE/Saxon/LIBS
    $ $EDITOR saxon-lint # you have to replace saxon9hePATH=XXX by 
        saxon9hePATH=/PATH/WHERE/YOU/WANT/THE/Saxon/LIBS

### Note:
To be able to run the command without dot-slash `./saxon-lint`, you need to modify the PATH variable. For windows, check http://www.computerhope.com/issues/ch000549.htm    
For Unix Likes, modify `~/.bashrc` by searching `PATH=` and put `PATH=$PATH:/PATH/TO/saxon-lint_DIRECTORY`    


Mac Os X is not already tested. With this OS, you have to install `java` too, it's not installed by default.    
Thanks to report any successfull install to gilles `<DOT> quenot <AT> sputnick <DOT> fr`, and any issue [here](https://github.com/sputnick-dev/saxon-lint/issues/new)

### Usage:

    Usage:
        saxon-lint <Query> [<file> | <files*>]

    Examples:
        saxon-lint '//key[text()="VersionString"]/following-sibling::string[1]' file.xml
        saxon-lint 'for $r in 1 to count(/table/tr) return /title' file2.xml
        curl -s 'http://domain.tld/file.xml' | saxon-lint '//key[1]'
