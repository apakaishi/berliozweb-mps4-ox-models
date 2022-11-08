<?xml version="1.0" encoding="utf-8"?>
<!--
  This is a transformation Json document to XML

  @author Adriano Akaishi
  @date 14/09/2022
  @copyright Allette Systems Pty Ltd
-->

<xsl:stylesheet
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        xmlns:fn="http://www.w3.org/2005/xpath-functions"
        exclude-result-prefixes="xs fn" version="3.0">

    <xsl:output indent="yes" omit-xml-declaration="yes" />

    <xsl:variable name="base" select="replace(replace(base-uri(),'file:', 'file://'), 'files/list-files.xml', '')" />
    <xsl:variable name="folder-xml" select="concat($base,'/xml/')" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" />

    <xsl:template match="files">
        <xsl:for-each select="file">
           <xsl:variable name="path" select="concat($base,@short-path)" />
           <xsl:variable name="filename" select="substring-before(tokenize(@short-path,'/')[last()],'.json')" />
           <xsl:variable name="array-data">
                <data>
                    <xsl:value-of select="unparsed-text($path)" />
                </data>
            </xsl:variable>
            <xsl:result-document href="{concat($folder-xml,$filename,'.xml')}">
                <xsl:copy-of select="json-to-xml($array-data/data)" />
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
