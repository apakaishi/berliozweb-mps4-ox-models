<?xml version="1.0" encoding="UTF-8"?>
<!--
   (C) Allette Systems 2021  Any use for PBS allowed
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

<!--  <xsl:output method="text" encoding="UTF-8"/>-->
  <xsl:output method="xml" encoding="UTF-8" indent="yes" />

  <xsl:param name="new-api-file-name"/>

  <xsl:template match="/csv">
    <report>
      <xsl:apply-templates select="." mode="summary">
        <xsl:with-param name="prefix" select="'xml-v3'"/>
      </xsl:apply-templates>
<!--      <xsl:variable name="new-api-file-uri" select="resolve-uri($new-api-file-name)"/>-->
      <xsl:variable name="new-api-file-uri" select="resolve-uri($new-api-file-name, base-uri())"/>

      <xsl:message>Base URI: <xsl:value-of select="base-uri()"/> </xsl:message>
      <xsl:message>API Path: <xsl:value-of select="$new-api-file-uri"/> </xsl:message>
      <xsl:variable name="new-api-file" select="document($new-api-file-uri)"/>
      <xsl:message>Has CSV: <xsl:value-of select="count($new-api-file/csv)"/> </xsl:message>
      <xsl:message>Children: <xsl:value-of select="count($new-api-file/*)"/> </xsl:message>
      <xsl:apply-templates select="$new-api-file/csv" mode="summary">
        <xsl:with-param name="prefix" select="'new-api'"/>
      </xsl:apply-templates>
    </report>
  </xsl:template>

  <xsl:template match="/csv" mode="summary">
    <xsl:param name="prefix" as="xs:string"/>
    <xsl:element name="{concat($prefix, '-general')}">
<!--      <general>-->
      <row generic-drugs="{count(distinct-values(item/@PBS_CODE))}" items="{count(item)}" brands="{count(distinct-values(item/@BRAND_NAME))}"/>
<!--      </general>-->
    </xsl:element>

    <xsl:element name="{concat($prefix, '-programs')}">
<!--      <programs>-->
      <xsl:for-each-group select="item" group-by="@PROGRAM_CODE">
        <row drug-types="{current-grouping-key()}"
             drugs="{count(distinct-values(current-group()/@PBS_CODE))}"
             items="{count(current-group())}"
             brands="{count(distinct-values(current-group()/@BRAND_NAME))}"/>

      </xsl:for-each-group>
<!--      </programs>-->
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>