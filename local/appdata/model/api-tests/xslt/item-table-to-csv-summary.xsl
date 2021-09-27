<?xml version="1.0" encoding="UTF-8"?>
<!--
   (C) Allette Systems 2021  Any use for PBS allowed
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

  <xsl:output method="text" encoding="UTF-8"/>

  <xsl:template match="/csv">

    <xsl:text>General&#x0D;</xsl:text>
    <xsl:text>Generic Drugs,Items,Brands&#x0D;</xsl:text>

    <xsl:value-of select="count(distinct-values(item/@PBS_CODE))" /> <xsl:text>,</xsl:text>
    <xsl:value-of select="count(item)" /> <xsl:text>,</xsl:text>
    <xsl:value-of select="count(distinct-values(item/@BRAND_NAME))" /> <xsl:text>&#x0D;&#x0D;&#x0D;</xsl:text>

    <xsl:text>Programs&#x0D;</xsl:text>
    <xsl:text>Drug Types,Drugs,Items,Brands</xsl:text>

    <xsl:for-each-group select="item" group-by="@PROGRAM_CODE">
      <xsl:text>&#x0D;</xsl:text>
      <xsl:value-of select="current-grouping-key()" /> <xsl:text>,</xsl:text>
      <xsl:value-of select="count(distinct-values(current-group()/@PBS_CODE))" /> <xsl:text>,</xsl:text>
      <xsl:value-of select="count(current-group())" /> <xsl:text>,</xsl:text>
      <xsl:value-of select="count(distinct-values(current-group()/@BRAND_NAME))" />
    </xsl:for-each-group>

  </xsl:template>

</xsl:stylesheet>