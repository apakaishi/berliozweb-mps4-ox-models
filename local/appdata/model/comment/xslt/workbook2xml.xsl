<?xml version="1.0"?>
<xsl:transform version="2.0"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               exclude-result-prefixes="#all">

  <xsl:output indent="yes" method="xml" encoding="utf-8" />

  <xsl:variable name="headers" select="//worksheet/row[@position = 1]/col/string()" />

  <xsl:template match="/">
    <xsl:apply-templates select="*" />
  </xsl:template>

  <xsl:template match="workbook">
    <publishes>
      <xsl:apply-templates select="worksheet/row" />
    </publishes>
  </xsl:template>

  <xsl:template match="row[@position != 1]">
    <xsl:element name="publish">
      <xsl:for-each select="col">
        <xsl:variable name="pos" select="position()"/>
        <xsl:attribute name="{$headers[$pos]}" select="."/>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*" />

</xsl:transform>