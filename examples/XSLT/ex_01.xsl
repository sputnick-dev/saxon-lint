<?xml version="1.0"?>

<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="/">
        <products>
            <product>
                <id>1</id>
                <other>y</other>
                <notarget>x</notarget>
                <target><xsl:value-of select="string-join(//target/text(), ',')" /></target>
            </product>
        </products>
    </xsl:template>
</xsl:stylesheet> 
