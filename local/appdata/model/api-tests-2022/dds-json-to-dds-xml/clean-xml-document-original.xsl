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
    <xsl:variable name="base-input" select="concat($base,'xml/')" />
    <xsl:variable name="folder-xml-cleaned" select="concat($base,'/xml-data/')" />

    <xsl:output method="xml" encoding="UTF-8" indent="yes" />

    <xsl:template match="files">
        <root>
            <xsl:for-each select="file">
                <xsl:variable name="filename-input" select="concat(substring-before(tokenize(@short-path,'/')[last()],'.json'),'.xml')" />
                <xsl:variable name="path" select="document(concat($base-input,$filename-input))" />
                <xsl:variable name="filename" select="substring-before(tokenize(@short-path,'/')[last()],'.json')" />
                <xsl:variable name="element-name" select="$filename" />

                <xsl:apply-templates select="$path" mode="full">
                    <xsl:with-param name="element-name" select="$element-name" />
                </xsl:apply-templates>
            </xsl:for-each>
        </root>
    </xsl:template>

    <xsl:template match="fn:array">
        <xsl:param name="element-name" />
        <root>
            <xsl:apply-templates select="*">
                <xsl:with-param name="element-name" select="$element-name" />
            </xsl:apply-templates>
        </root>
    </xsl:template>

    <xsl:template match="fn:array" mode="full">
        <xsl:param name="element-name" />
        <xsl:element name="{$element-name}">
            <xsl:apply-templates select="*" mode="full" />
        </xsl:element>
    </xsl:template>

    <xsl:template match="fn:map">
        <xsl:param name="element-name" />
        <xsl:element name="{$element-name}">
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>

    <xsl:template match="fn:map" mode="full">
        <element>
            <xsl:apply-templates />
        </element>
    </xsl:template>

    <xsl:template match="fn:number|fn:string">
      <xsl:element name="{@key}">
         <xsl:value-of select="." />
      </xsl:element>
    </xsl:template>

    <xsl:template match="fn:null">
       <xsl:element name="{@key}">
          <xsl:value-of select="." />
       </xsl:element>
    </xsl:template>

    <xsl:template match="text()" />

</xsl:stylesheet>
